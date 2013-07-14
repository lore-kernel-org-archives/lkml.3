Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3GNJlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 05:41:36 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3926 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3GNJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 05:41:34 -0400
Message-ID: <51E27239.2080109@xs4all.nl>
Date: Sun, 14 Jul 2013 11:41:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance
 detected!
References: <1139404719.20130516194142@eikelenboom.it> <201305171025.24166.hverkuil@xs4all.nl> <1756541549.20130517110450@eikelenboom.it> <201305171152.17746.hverkuil@xs4all.nl> <266016445.20130712225644@eikelenboom.it>
In-Reply-To: <266016445.20130712225644@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sander,

On 07/12/2013 10:56 PM, Sander Eikelenboom wrote:
> 
> Friday, May 17, 2013, 11:52:17 AM, you wrote:
> 
>> On Fri May 17 2013 11:04:50 Sander Eikelenboom wrote:
>>>
>>> Friday, May 17, 2013, 10:25:24 AM, you wrote:
>>>
>>>> On Thu May 16 2013 19:41:42 Sander Eikelenboom wrote:
>>>>> Hi Hans / Mauro,
>>>>>
>>>>> With 3.10.0-rc1 (including the cx25821 changes from Hans), I get the bug below which wasn't present with 3.9.
>>>
>>>> How do I reproduce this? I've tried to, but I can't make this happen.
>>>
>>>> Looking at the code I can't see how it could hit this bug anyway.
>>>
>>> I'm using "motion" to grab and process 6 from the video streams of the card i have (card with 8 inputs).
>>> It seems the cx25821 underwent quite some changes between 3.9 and 3.10.
> 
>> It did.
> 
>>> And in the past there have been some more locking issues around mmap and media devices, although they seem to appear as circular locking dependencies and with different devices.
>>>    - http://www.mail-archive.com/linux-media@vger.kernel.org/msg46217.html
>>>    - Under kvm: http://www.spinics.net/lists/linux-media/msg63322.html
> 
>> Neither of those are related to this issue.
> 
>>>
>>> - Perhaps that running in a VM could have to do with it ?
>>>    - The driver on 3.9 occasionaly gives this, probably latency related (but continues to work):
>>>      cx25821: cx25821_video_wakeup: 2 buffers handled (should be 1)
>>>
>>>      Could it be something double unlocking in that path ?
>>>
>>> - Is there any extra debugging i could enable that could pinpoint the issue ?
> 
>> Try this patch:
> 
>> diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
>> index b762c5b..8f8d0e0 100644
>> --- a/drivers/media/pci/cx25821/cx25821-core.c
>> +++ b/drivers/media/pci/cx25821/cx25821-core.c
>> @@ -1208,7 +1208,6 @@ void cx25821_free_buffer(struct videobuf_queue *q, struct cx25821_buffer *buf)
>>         struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
>>  
>>         BUG_ON(in_interrupt());
>> -       videobuf_waiton(q, &buf->vb, 0, 0);
>>         videobuf_dma_unmap(q->dev, dma);
>>         videobuf_dma_free(dma);
>>         btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
> 
>> I don't think the waiton is really needed for this driver.
> 
>> What really should happen is that videobuf is replaced by videobuf2 in this
>> driver, but that's a fair amount of work.
> 
> Hi Hans,
> 
> After being busy for quite some time, i do have some spare time now.
> 
> Since i'm still having trouble with this driver, is there a patch series for a similar driver
> that was converted to videobuf2 ?
> I don't know if it is entirely in my league, but i could give it a try when i have a example.

The changes done for usb/em28xx might come close. That said, the cx25821 is already in
decent shape to convert to vb2. At least the videobuf data structures are already in the
correct place (they are often stored in a per-filehandle struct, which is wrong).

include/media/videobuf2-core.h gives a reasonable overview of vb2. Like em28xx, you
should use the vb2 helper functions (vb2_fop_* and vb2_ioctl_*) which takes a lot
of the work off your hands.

Converting cx25821-alsa.c may be the most difficult part as it is using some videobuf
internal functions which probably won't translate to vb2 as is. I think videobuf is
being abused here, but I don't know off-hand what the correct approach will be with
vb2.

I would ignore the alsa part for the time being (also the audio/video-upstream code,
that's been disabled and without datasheets of the cx25821 I'm not sure it can be
resurrected).

If you can get cx25821-video.c to work with vb2, then we can take a look at the alsa
code.

Regards,

	Hans
