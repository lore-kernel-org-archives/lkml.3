Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3HVV4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:56:06 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:55154 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754385Ab3HVV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:56:04 -0400
Message-ID: <521688F1.1010303@semaphore.gr>
Date: Fri, 23 Aug 2013 00:56:01 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org >> LKML" <linux-kernel@vger.kernel.org>
Subject: Re: oops during boot with CONFIG_SND_DYNAMIC_MINORS not set
References: <52153451.10601@semaphore.gr> <s5hppt6jgv4.wl%tiwai@suse.de> <52163660.8000700@semaphore.gr> <s5hy57tifnf.wl%tiwai@suse.de>
In-Reply-To: <s5hy57tifnf.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 12:23 AM, Takashi Iwai wrote:
> At Thu, 22 Aug 2013 19:03:44 +0300,
> Stratos Karafotis wrote:
>>
>> On 08/22/2013 10:59 AM, Takashi Iwai wrote:
>>> At Thu, 22 Aug 2013 00:42:41 +0300,
>>> Stratos Karafotis wrote:
>>>>
>>>> Hi,
>>>>
>>>> I get the following oops during boot when build with CONFIG_SND_DYNAMIC_MINORS
>>>> not set (3.11-rc6).
>>>> The issue is vanished building the kernel with CONFIG_SND_DYNAMIC_MINORS=y
>>>> as suggested in printk message.
>>>>
>>>> Regards,
>>>> Stratos
>>>>
>>>>
>>>
>>> Could you check the patch below?
>>> Thanks!
>>>
>>>
>>> Takashi
>>>
>>> ---
>>> From: Takashi Iwai <tiwai@suse.de>
>>> Subject: [PATCH] ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n
>>>
>>> Without the dynamic minor assignment, HDMI codec may have less PCM
>>> instances than the number of pins, which eventually leads to Oops.
>>>
>>> Reported-by: Stratos Karafotis <stratosk@semaphore.gr>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> ---
>>>    sound/pci/hda/patch_hdmi.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
>>> index 030ca86..e2cb92b 100644
>>> --- a/sound/pci/hda/patch_hdmi.c
>>> +++ b/sound/pci/hda/patch_hdmi.c
>>> @@ -1781,6 +1781,9 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
>>>    		struct snd_pcm_chmap *chmap;
>>>    		struct snd_kcontrol *kctl;
>>>    		int i;
>>> +
>>> +		if (pin_idx >= codec->num_pcms)
>>> +			break;
>>>    		err = snd_pcm_add_chmap_ctls(codec->pcm_info[pin_idx].pcm,
>>>    					     SNDRV_PCM_STREAM_PLAYBACK,
>>>    					     NULL, 0, pin_idx, &chmap);
>>>
>>
>> Hi,
>>
>> Unfortunately, still the same problem after applying your patch.
> 
> Bah, it's a wrong one.  The patch below should work better.
> Sorry for inconvenience.

No problem! :)

Yes, no more oops with the latest patch.
Tested with CONFIG_SND_DYNAMIC_MINORS=y and n.

There is an error -16 now (please see below), but I guess it's normal(?)

Thanks,
Stratos


[   16.392453] ALSA sound/pci/hda/hda_codec.c:4506 Too many HDMI devices
[   16.392457] ALSA sound/pci/hda/hda_codec.c:4508 Consider building the kernel with CONFIG_SND_DYNAMIC_MINORS=y
[   16.392460] ALSA sound/pci/hda/hda_codec.c:4506 Too many HDMI devices
[   16.392461] ALSA sound/pci/hda/hda_codec.c:4508 Consider building the kernel with CONFIG_SND_DYNAMIC_MINORS=y
[   16.409640] ALSA sound/core/control.c:349 control 0:0:0:HDMI/DP Jack:0 is already present
[   16.410627] hda_codec: cannot build controls for #3 (error -16)
[   16.411683] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[   16.411844] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   16.411986] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[   19.682495] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[   21.367420] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   21.420191] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   21.847085] type=1305 audit(1377207061.920:3): audit_pid=534 old=0 auid=4294967295 ses=4294967295
 res=1
[   22.164707] alsactl[549]: segfault at 1 ip 00007f6c8ad58a7d sp 00007fff19912de0 error 4 in libc-2.17.so[7f6c8ad10000+1b6000]

