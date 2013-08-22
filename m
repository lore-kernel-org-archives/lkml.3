Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3HVQDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:03:49 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54074 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752512Ab3HVQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:03:47 -0400
Message-ID: <52163660.8000700@semaphore.gr>
Date: Thu, 22 Aug 2013 19:03:44 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org >> LKML" <linux-kernel@vger.kernel.org>
Subject: Re: oops during boot with CONFIG_SND_DYNAMIC_MINORS not set
References: <52153451.10601@semaphore.gr> <s5hppt6jgv4.wl%tiwai@suse.de>
In-Reply-To: <s5hppt6jgv4.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 10:59 AM, Takashi Iwai wrote:
> At Thu, 22 Aug 2013 00:42:41 +0300,
> Stratos Karafotis wrote:
>>
>> Hi,
>>
>> I get the following oops during boot when build with CONFIG_SND_DYNAMIC_MINORS
>> not set (3.11-rc6).
>> The issue is vanished building the kernel with CONFIG_SND_DYNAMIC_MINORS=y
>> as suggested in printk message.
>>
>> Regards,
>> Stratos
>>
>>
> 
> Could you check the patch below?
> Thanks!
> 
> 
> Takashi
> 
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Fix NULL dereference with CONFIG_SND_DYNAMIC_MINORS=n
> 
> Without the dynamic minor assignment, HDMI codec may have less PCM
> instances than the number of pins, which eventually leads to Oops.
> 
> Reported-by: Stratos Karafotis <stratosk@semaphore.gr>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>   sound/pci/hda/patch_hdmi.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
> index 030ca86..e2cb92b 100644
> --- a/sound/pci/hda/patch_hdmi.c
> +++ b/sound/pci/hda/patch_hdmi.c
> @@ -1781,6 +1781,9 @@ static int generic_hdmi_build_controls(struct hda_codec *codec)
>   		struct snd_pcm_chmap *chmap;
>   		struct snd_kcontrol *kctl;
>   		int i;
> +
> +		if (pin_idx >= codec->num_pcms)
> +			break;
>   		err = snd_pcm_add_chmap_ctls(codec->pcm_info[pin_idx].pcm,
>   					     SNDRV_PCM_STREAM_PLAYBACK,
>   					     NULL, 0, pin_idx, &chmap);
> 

Hi,

Unfortunately, still the same problem after applying your patch.

Regards,
Stratos


[   12.828335] Oops: 0000 [#1] SMP 
[   12.829237] Modules linked in: snd_hda_codec_hdmi arc4 rt2800pci eeprom_93cx6 rt2x00pci iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support rt2800lib crc_ccitt eeepc_wmi rt2x00mmio rt2x00lib asus_wmi mac80211 sparse_keymap cfg80211 rfkill r8169 snd_hda_intel(+) snd_hda_codec snd_hwdep snd_seq snd_seq_device mii snd_pcm snd_page_alloc snd_timer snd soundcore i2c_i801 i2c_core lpc_ich mfd_core serio_raw pcspkr uinput binfmt_misc usb_storage video wmi
[   12.833282] CPU: 2 PID: 405 Comm: systemd-udevd Not tainted 3.11.0-rc6+ #5
[   12.834299] Hardware name: ASUSTeK COMPUTER INC. CM6870/CM6870, BIOS 0606 08/27/2012
[   12.835334] task: ffff880212d45d40 ti: ffff880210bd6000 task.ti: ffff880210bd6000
[   12.836411] RIP: 0010:[<ffffffffa00ae992>]  [<ffffffffa00ae992>] snd_pcm_add_chmap_ctls+0xd2/0x160 [snd_pcm]
[   12.837505] RSP: 0018:ffff880210bd7968  EFLAGS: 00010246
[   12.838596] RAX: ffffffffa00b451e RBX: ffff880212348500 RCX: 0000000000000000
[   12.839721] RDX: ffffffffa00b4533 RSI: ffff880212348500 RDI: ffff880210bd7980
[   12.840831] RBP: ffff880210bd79f8 R08: 0000000000000000 R09: ffff880216003b00
[   12.841944] R10: 0000000000000000 R11: ffff8802103210c0 R12: 0000000000000000
[   12.843073] R13: ffff880210bd7a10 R14: 0000000000000000 R15: ffff880210bd7980
[   12.844218] FS:  00007f902eec6880(0000) GS:ffff88021ec80000(0000) knlGS:0000000000000000
[   12.845403] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.846566] CR2: 0000000000000018 CR3: 000000021054f000 CR4: 00000000001407e0
[   12.847737] Stack:
[   12.848892]  0000000000000000 000000000c334000 0000000000000000 0000000000000003
[   12.850086]  0000000000000000 ffffffffa00b451e 1000001100000000 0000000000000000
[   12.851275]  ffffffffa00aca80 ffffffffa00aecd0 0000000000000000 ffffffffa00adb30
[   12.852465] Call Trace:
[   12.853646]  [<ffffffffa00aca80>] ? snd_pcm_hw_rule_msbits+0x50/0x50 [snd_pcm]
[   12.854852]  [<ffffffffa00aecd0>] ? snd_pcm_hw_rule_ratdens+0x2b0/0x2b0 [snd_pcm]
[   12.856062]  [<ffffffffa00adb30>] ? snd_pcm_hw_param_last+0x240/0x240 [snd_pcm]
[   12.857298]  [<ffffffffa02a27fd>] generic_hdmi_build_controls+0x15d/0x200 [snd_hda_codec_hdmi]
[   12.858524]  [<ffffffffa02a1827>] ? generic_hdmi_init+0xb7/0xd0 [snd_hda_codec_hdmi]
[   12.859757]  [<ffffffffa00ee812>] snd_hda_codec_build_controls+0x1c2/0x220 [snd_hda_codec]
[   12.861003]  [<ffffffffa00e9255>] ? snd_hda_codec_configure+0x295/0x450 [snd_hda_codec]
[   12.862264]  [<ffffffffa00ee898>] snd_hda_build_controls+0x28/0x80 [snd_hda_codec]
[   12.863523]  [<ffffffffa0084bed>] azx_probe_continue+0x84d/0xcc0 [snd_hda_intel]
[   12.864744]  [<ffffffffa0084060>] ? perf_trace_azx_pcm_trigger+0xe0/0xe0 [snd_hda_intel]
[   12.865979]  [<ffffffffa0082ee0>] ? azx_resume+0x130/0x130 [snd_hda_intel]
[   12.867205]  [<ffffffffa0083c20>] ? azx_pcm_prepare+0x5f0/0x5f0 [snd_hda_intel]
[   12.868433]  [<ffffffffa00828f0>] ? azx_runtime_suspend+0x40/0x40 [snd_hda_intel]
[   12.869658]  [<ffffffffa0081800>] ? azx_remove+0x30/0x30 [snd_hda_intel]
[   12.870883]  [<ffffffffa00854bf>] azx_probe+0x3bf/0x7e0 [snd_hda_intel]
[   12.872131]  [<ffffffff8130b3ee>] local_pci_probe+0x3e/0x70
[   12.873347]  [<ffffffff8130c6d1>] pci_device_probe+0x121/0x130
[   12.874584]  [<ffffffff813bf3c7>] driver_probe_device+0x87/0x390
[   12.875803]  [<ffffffff813bf7a3>] __driver_attach+0x93/0xa0
[   12.877016]  [<ffffffff813bf710>] ? __device_attach+0x40/0x40
[   12.878227]  [<ffffffff813bd303>] bus_for_each_dev+0x63/0xa0
[   12.879421]  [<ffffffff813bee1e>] driver_attach+0x1e/0x20
[   12.880593]  [<ffffffff813be9b8>] bus_add_driver+0x1e8/0x2a0
[   12.881780]  [<ffffffffa0091169>] ? ftrace_define_fields_azx_get_position+0xcd/0xcd [snd_hda_intel]
[   12.882956]  [<ffffffff813bfdc4>] driver_register+0x74/0x150
[   12.884164]  [<ffffffffa0091169>] ? ftrace_define_fields_azx_get_position+0xcd/0xcd [snd_hda_intel]
[   12.885349]  [<ffffffff8130b27b>] __pci_register_driver+0x4b/0x50
[   12.886499]  [<ffffffffa0091187>] azx_driver_init+0x1e/0xe97 [snd_hda_intel]
[   12.887630]  [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
[   12.888731]  [<ffffffff8103f183>] ? set_memory_nx+0x43/0x50
[   12.889819]  [<ffffffff810b9f3d>] load_module+0x1b9d/0x2640
[   12.890895]  [<ffffffff810b6270>] ? store_uevent+0x40/0x40
[   12.891951]  [<ffffffff810bab56>] SyS_finit_module+0x86/0xb0
[   12.892984]  [<ffffffff81621782>] system_call_fastpath+0x16/0x1b
[   12.894003] Code: ff 48 89 de 4c 89 ff 48 89 43 18 8b 85 7c ff ff ff 89 43 20 48 c7 c0 1e 45 0b a0 4c 89 45 d0 48 0f 45 c2 49 c1 e2 07 48 89 45 98 <41> 8b 44 24 18 4f 8d 34 14 89 45 8c 41 8b 86 c8 00 00 00 89 45 
[   12.896336] RIP  [<ffffffffa00ae992>] snd_pcm_add_chmap_ctls+0xd2/0x160 [snd_pcm]
[   12.897444]  RSP <ffff880210bd7968>
[   12.898533] CR2: 0000000000000018
[   12.899624] ---[ end trace c645a5da0439ceeb ]---

