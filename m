Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab3EBQUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:20:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758155Ab3EBQUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:20:01 -0400
Message-ID: <5182922E.4060305@sgi.com>
Date: Thu, 02 May 2013 09:19:58 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Henningsson <david.henningsson@canonical.com>
CC: Stephen Warren <swarren@nvidia.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH]: x86_64, audio: Fix system panic when DMA > 40 bits
References: <1367435048-66137-1-git-send-email-travis@sgi.com> <518205A9.1050409@canonical.com> <51820968.7080303@sgi.com> <518223ED.3000509@canonical.com>
In-Reply-To: <518223ED.3000509@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/2/2013 1:29 AM, David Henningsson wrote:
> On 05/02/2013 08:36 AM, Mike Travis wrote:
>>
>>
>> On 5/1/2013 11:20 PM, David Henningsson wrote:
>>> On 05/01/2013 09:04 PM, Mike Travis wrote:
>>>> The audio driver mistakenly allows 64 bit addresses to be created for
>>>> the audio driver on Nvidia GPUs.  Unfortunately, the hardware normally
>>>> only supports up to 40 bits of DMA.  This can cause system panics as
>>>> well as misdirected data when the address is > 40 bits as the upper
>>>> part the address is truncated.
>>>
>>> Thanks for this patch. Stephen Warren, is this something you can
>>> confirm/deny, and do you know what range of hardware this actually
>>> applies to?
>>
>> The dma_mask can be read from the gpu device's pci entry.  I know it's
>> a stretch to try to link to that but past history has shown that it
>> ranges from 36 to 40 bits.
> 
> Ok, so the below patch is some kind of workaround, as we don't currently
> take the dma_mask into account correctly? Or put in another way, would
> it be possible/better to actually read the dma_mask and use that instead
> of just clamping at 32 bit?\

Yes, it would.  There is a strange scenario where if you request
a DMA32 address it must be on the lowest node (where the DMA32 area
is).  But if you are running on a cpuset that excludes Node 0's
memory, you'll get an error.  But I couldn't think of a workable
way to link the two (except that the PCI id is the same except
for the function #.)
>>>
>>>>
>>>> Signed-off-by: Mike Travis <travis@sgi.com>
>>>> Reviewed-by: Mike Habeck <habeck@sgi.com>
>>>> ---
>>>>    sound/pci/hda/hda_intel.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
>>>> index bcd40ee..45eb165 100644
>>>> --- a/sound/pci/hda/hda_intel.c
>>>> +++ b/sound/pci/hda/hda_intel.c
>>>> @@ -615,7 +615,7 @@ enum {
>>>>    /* quirks for Nvidia */
>>>>    #define AZX_DCAPS_PRESET_NVIDIA \
>>>>        (AZX_DCAPS_NVIDIA_SNOOP | AZX_DCAPS_RIRB_DELAY |
>>>> AZX_DCAPS_NO_MSI |\
>>>> -     AZX_DCAPS_ALIGN_BUFSIZE)
>>>> +     AZX_DCAPS_ALIGN_BUFSIZE | AZX_DCAPS_NO_64BIT)
>>>>
>>>>    #define AZX_DCAPS_PRESET_CTHDA \
>>>>        (AZX_DCAPS_NO_MSI | AZX_DCAPS_POSFIX_LPIB |
>>>> AZX_DCAPS_4K_BDLE_BOUNDARY)
>>>>
>>>
>>>
>>>
>>
> 
> 
> 
