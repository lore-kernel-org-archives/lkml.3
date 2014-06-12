Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbaFLNSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:18:00 -0400
Received: from purkki.adurom.net ([80.68.90.206]:43460 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554AbaFLNR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:17:56 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2014 09:17:56 EDT
From: Kalle Valo <kvalo@adurom.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: video: X sets brightness to zero after resume
Date: Thu, 12 Jun 2014 15:42:55 +0300
Message-ID: <871tuu1epc.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

after your commit 0e9f81d3b7c ("ACPI / video: Add systems that should
favour native backlight interface") I have had an regression that every
time after resume the display brightness has been set to zero and I need
to manually set it to non-zero to see something again.

Finally I started to investigate this more closely and it seems that X
sets it to zero for some reason. I added a WARN_ON() and few printks to
brightness_store() in drivers/video/backlight/backlight.c and this is
what I see during resume:

[   49.228221] ------------[ cut here ]------------
[   49.228229] WARNING: CPU: 1 PID: 1133 at
drivers/video/backlight/backlight.c:173 brightness_store+0x3c/0x120(
)
[   49.228230] Modules linked in: ctr ccm uvcvideo videobuf2_core
videodev videobuf2_vmalloc videobuf2_memops fu
se arc4 iwldvm sha256_generic kvm_intel kvm mac80211 snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_codec_gene
ric iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 snd_hda_intel
snd_hda_controller nf_nat_ipv4 nf_nat snd_hda_cod
ec nf_conntrack snd_hwdep snd_pcm_oss iwlwifi snd_mixer_oss snd_pcm
ip_tables x_tables thinkpad_acpi snd_seq_dum
my snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
cfg80211 snd_timer snd_seq_device snd bnep rfcomm bluetooth psmouse
soundcore nvram ehci_pci ehci_hcd rfkill wmi binfmt_misc ext4 jbd2
mbcache sd_mod fbcon tileblit font bitblit softcursor i915
drm_kms_helper drm cfbcopyarea i2c_algo_bit intel_gtt agpgart i2c_core
video xhci_hcd cfbimgblt cfbfillrect e1000e sdhci_pci sdhci ptp pps_core
mmc_core ahci libahci
[   49.228281] CPU: 1 PID: 1133 Comm: Xorg Tainted: G        W
3.15.0-rc7-wl-ath+ #259
[   49.228282] Hardware name: LENOVO 2324JB2/2324JB2, BIOS G2ET82WW
(2.02 ) 09/11/2012
[   49.228283]  0000000000000000 ffffffff817e4000 ffffffff814cbee3
0000000000000000
[   49.228285]  ffffffff810493bc ffff88020e2d1c98 ffff880213bc9f10
0000000000000002
[   49.228287]  ffff8800c5dfc198 ffff88020d7cbf50 ffffffff81290a1c
ffff88020e792800
[   49.228288] Call Trace:
[   49.228293]  [<ffffffff814cbee3>] ? dump_stack+0x41/0x51
[   49.228296]  [<ffffffff810493bc>] ? warn_slowpath_common+0x8c/0xc0
[   49.228298]  [<ffffffff81290a1c>] ? brightness_store+0x3c/0x120
[   49.228301]  [<ffffffff811d7242>] ? kernfs_fop_write+0x112/0x170
[   49.228304]  [<ffffffff8116791b>] ? vfs_write+0xcb/0x1f0
[   49.228306]  [<ffffffff81167e20>] ? SyS_write+0x50/0xb0
[   49.228308]  [<ffffffff814dd312>] ? system_call_fastpath+0x16/0x1b
[   49.228309] ---[ end trace a1f60d12df64bdbe ]---
[   49.228310] brightness=0
[   49.228310] set brightness to 0

And this is PID 1133:

root      1133  0.7  0.2 131504 20192 tty7     Ss+  15:16   0:00
/usr/bin/X :0 -auth /var/run/lightdm/root/:0 -nolisten tcp vt7
-novtswitch -background none

If I set video.use_native_backlight=0 in kernel command line the problem
goes away. Or if I revert your commit 0e9f81d3b7c the problem also goes
away. Any ideas?

My setup is:

Thinkpad X230
Ubuntu 12.04 64-bit
i3 window manager
xserver-xorg 1:7.6+12ubuntu2

-- 
Kalle Valo
