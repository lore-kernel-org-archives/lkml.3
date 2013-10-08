Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3JHH6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:58:45 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42596 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3JHH6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:58:43 -0400
MIME-Version: 1.0
In-Reply-To: <5253B2BE.5090209@samsung.com>
References: <1380894598-11242-1-git-send-email-ricardo.ribalda@gmail.com> <5253B2BE.5090209@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 8 Oct 2013 09:58:23 +0200
Message-ID: <CAPybu_0-b2BfuTVd09B4dreFHCsYSg=SjjrDCHXKrqNGzFSX2w@mail.gmail.com>
Subject: Re: [PATCH] vb2: Allow STREAMOFF for io emulator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek

Thanks for your comments. I was just trying to find a way to stop
streaming while in read/write mode without having to close the
descriptor. I thought reusing streamoff was more clever than creating
a new ioctl.

Thanks!

On Tue, Oct 8, 2013 at 9:22 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 2013-10-04 15:49, Ricardo Ribalda Delgado wrote:
>>
>> A video device opened and streaming in io emulator mode can only stop
>> streamming if its file descriptor is closed.
>>
>> There are some parameters that can only be changed if the device is not
>> streaming. Also, the power consumption of a device streaming could be
>> different than one not streaming.
>>
>> With this patch a video device opened in io emulator can be stopped on
>> demand.
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
>
> Read/write-based io mode must not be mixed with ioctrl-based IO, so I really
> cannot accept this patch. Check V4L2 documentation for more details.
>
>
>> ---
>>   drivers/media/v4l2-core/videobuf2-core.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c
>> index 9fc4bab..097fba8 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1686,6 +1686,7 @@ int vb2_streamon(struct vb2_queue *q, enum
>> v4l2_buf_type type)
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_streamon);
>>   +static int __vb2_cleanup_fileio(struct vb2_queue *q);
>>     /**
>>    * vb2_streamoff - stop streaming
>> @@ -1704,11 +1705,6 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
>>    */
>>   int vb2_streamoff(struct vb2_queue *q, enum v4l2_buf_type type)
>>   {
>> -       if (q->fileio) {
>> -               dprintk(1, "streamoff: file io in progress\n");
>> -               return -EBUSY;
>> -       }
>> -
>>         if (type != q->type) {
>>                 dprintk(1, "streamoff: invalid stream type\n");
>>                 return -EINVAL;
>> @@ -1719,6 +1715,11 @@ int vb2_streamoff(struct vb2_queue *q, enum
>> v4l2_buf_type type)
>>                 return -EINVAL;
>>         }
>>   +     if (q->fileio) {
>> +               __vb2_cleanup_fileio(q);
>> +               return 0;
>> +       }
>> +
>>         /*
>>          * Cancel will pause streaming and remove all buffers from the
>> driver
>>          * and videobuf, effectively returning control over them to
>> userspace.
>
>
> Best regards
> --
> Marek Szyprowski
> Samsung R&D Institute Poland
>



-- 
Ricardo Ribalda
