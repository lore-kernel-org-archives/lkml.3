Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3LNAfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:35:37 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:59011 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3LNAfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:35:36 -0500
MIME-Version: 1.0
In-Reply-To: <yw1xbo0kinkv.fsf@unicorn.mansr.com>
References: <1386960092-32475-1-git-send-email-chyyuu@gmail.com>
	<yw1xbo0kinkv.fsf@unicorn.mansr.com>
Date: Sat, 14 Dec 2013 08:35:35 +0800
Message-ID: <CAAdffVGbCO5cvrCg2Xu4SvZdgLUJNnWscjd_HXhCjsb2cKfVtw@mail.gmail.com>
Subject: Re: [PATCH] scsi: integer overflow in megadev_ioctl()
From: Yu Chen <chyyuu@gmail.com>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: linux-kernel@vger.kernel.org, Levente Kurusa <levex@linux.com>,
        xiaoqixue_1 <xiaoqixue_1@163.com>,
        =?GB2312?B?t7bOxMG8?= <fanwlexca@gmail.com>, megaraidlinux@lsi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that the simpler fix is to change the type of 'adapno' to u32,
which is the type of uioc.adapno to u32.


2013/12/14 Måns Rullgård <mans@mansr.com>:
> "Chen.Yu" <chyyuu@gmail.com> writes:
>
>> From: "Chen.Yu" <chyyuu@gmail.com>
>>
>> There is a potential integer overflow in megadev_ioctl() if
>> userspace passes in a large u32 variable uioc.adapno.
>> The int variable adapno would < 0, leading to an error
>> array access for hdb_soft_state[adapno], or an error
>> copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,..)
>>
>> Reported-by: Wenliang Fan <fanwlexca@gmail.com>
>> Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
>> Signed-off-by: Yu Chen <chyyuu@gmail.com>
>> Reviewed-by: Levente Kurusa <levex@linux.com>
>> ---
>>  drivers/scsi/megaraid.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
>> index 816db12..0b90c54 100644
>> --- a/drivers/scsi/megaraid.c
>> +++ b/drivers/scsi/megaraid.c
>> @@ -3099,7 +3099,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>>               /*
>>                * Which adapter
>>                */
>> -             if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
>> +             adapno = GETADAP(uioc.adapno);
>> +             if( adapno < 0 )
>> +                     return (-EINVAL);
>> +             if( adapno >= hba_count )
>>                       return (-ENODEV);
>
> This relies on implementation-defined behaviour when converting an
> unsigned integer to signed integer.  A simpler and more robust fix is to
> make the local variable 'adapno' unsigned.
>
> --
> Måns Rullgård
> mans@mansr.com



--
