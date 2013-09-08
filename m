Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab3IHTjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 15:39:47 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:32987 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3IHTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 15:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <522CAB88.4020907@mni.thm.de>
References: <522CAB88.4020907@mni.thm.de>
Date: Sun, 8 Sep 2013 15:39:46 -0400
X-Google-Sender-Auth: K3l-exsNyTsIlEgSDLZtzuLP4YY
Message-ID: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>
Subject: Re: 3.12rc1-pre Nouveau? oops
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        David Airlie <airlied@linux.ie>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 8, 2013 at 12:53 PM, Tobias Klausmann
<tobias.johannes.klausmann@mni.thm.de> wrote:
> Hi there,
> with the latest snapshot of linus tree, i see a stack trace and my system
> does not start X! Maybe someone finds this useful! (3.11 is working like a
> charm)

Looks like you have Optimus (intel + nvidia), and the backtrace has
runtime pm in it, which is something new Dave added for 3.12, adding
him in explicitly. The simplest explanation is that disp->init is
NULL. And it seems like there are no outputs from the earlier nouveau
init prints. I guess that the call to nouveau_display_resume from
nouveau_pmops_runtime_resume should be guarded by a if
(dev->mode_config.num_crtc) like it is everywhere else.

  -ilia

>
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<          (null)>]           (null)
> PGD 24eaa0067 PUD 24e7ac067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP
> Modules linked in: bnep snd_hda_codec_hdmi snd_hda_codec_realtek fuse
> x86_pkg_temp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec
> snd_hwdep kvm snd_pcm uvcvideo snd_seq videobuf2_core snd_timer
> crct10dif_pclmul crc32_pclmul arc4 crc32c_intel snd_seq_device
> ghash_clmulni_intel ath9k videodev snd sdhci_pci sdhci aesni_intel iTCO_wdt
> iTCO_vendor_support mac80211 ablk_helper acer_wmi ath9k_common ath3k
> ath9k_hw sr_mod lpc_ich cryptd mmc_core joydev btusb sg ath cfg80211 tg3
> acpi_cpufreq ptp pps_core ipheth cdrom videobuf2_vmalloc mfd_core
> sparse_keymap soundcore serio_raw bluetooth videobuf2_memops shpchp rfkill
> i2c_i801 pcspkr snd_page_alloc lrw gf128mul glue_helper aes_x86_64 microcode
> battery ac autofs4 nouveau i915 ttm drm_kms_helper drm xhci_hcd mxm_wmi
> i2c_algo_bit wmi video button processor thermal_sys scsi_dh_emc scsi_dh_alua
> scsi_dh_rdac scsi_dh_hp_sw scsi_dh
> CPU: 0 PID: 792 Comm: Xorg Not tainted 3.11.0-desktop+ #1
> Hardware name: Acer Aspire V3-571G/VA50_HC_CR, BIOS V1.13 10/09/2012
> task: ffff880253031040 ti: ffff880253256000 task.ti: ffff880253256000
> RIP: 0010:[<0000000000000000>]  [< (null)>]           (null)
> RSP: 0018:ffff8802532579a0  EFLAGS: 00010246
> RAX: ffff88024fabb000 RBX: ffff88024f3e2800 RCX: ffff88024eacf5c0
> RDX: ffff88024fabb000 RSI: ffff88024f7fe760 RDI: ffff88024f3e2800
> RBP: ffff88024ea2f480 R08: 0000000000000004 R09: 0000000000000000
> R10: ffff88025f1e1f80 R11: 000000000000000f R12: ffff88024f3e2800
> R13: ffff88024f3e2800 R14: 0000000000000004 R15: ffff880253257ab8
> FS:  00007fe73cdd8880(0000) GS:ffff88025f200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000025022c000 CR4: 00000000001407f0
> Stack:
>  ffffffffa021e4a2 ffff88024f234000 ffff88024f3e2800 ffff88024f3e2c38
>  0000000000000000 ffff88024f3e2800 ffffffffa021eda5 ffff88025401d000
>  ffff88024fabb000 ffff88025401d000 ffffffffa020e7cb ffff880253257ab8
> Call Trace:
>  [<ffffffffa021e4a2>] ? nouveau_display_init+0x42/0xd0 [nouveau]
>  [<ffffffffa021eda5>] ? nouveau_display_resume+0x15/0xa0 [nouveau]
>  [<ffffffffa020e7cb>] ? nouveau_pmops_runtime_resume+0x9b/0x100 [nouveau]
>  [<ffffffff812ac745>] ? pci_pm_runtime_resume+0x85/0xc0
>  [<ffffffff812ac6c0>] ? pci_restore_standard_config+0x30/0x30
>  [<ffffffff8137b6f6>] ? __rpm_callback+0x36/0x80
>  [<ffffffff8137b768>] ? rpm_callback+0x28/0x90
>  [<ffffffff8137c48d>] ? rpm_resume+0x39d/0x570
>  [<ffffffff81071483>] ? __wake_up+0x43/0x70
>  [<ffffffff8137c8f8>] ? __pm_runtime_resume+0x48/0x70
>  [<ffffffffa020e5a2>] ? nouveau_drm_open+0x42/0x1d0 [nouveau]
>  [<ffffffff811bb858>] ? ext4_da_write_end+0xa8/0x2b0
>  [<ffffffff811ef559>] ? jbd2_journal_stop+0x1d9/0x2c0
>  [<ffffffff8124a56f>] ? apparmor_capable+0x1f/0x90
>  [<ffffffffa00c5cab>] ? drm_open+0x28b/0x6e0 [drm]
>  [<ffffffffa00c6206>] ? drm_stub_open+0x106/0x1a0 [drm]
>  [<ffffffff81143bc0>] ? cdev_put+0x30/0x30
>  [<ffffffff81143c56>] ? chrdev_open+0x96/0x1d0
>  [<ffffffff81143bc0>] ? cdev_put+0x30/0x30
>  [<ffffffff8113d186>] ? do_dentry_open+0x216/0x2a0
>  [<ffffffff8113d238>] ? finish_open+0x28/0x40
>  [<ffffffff8114e5e9>] ? do_last+0x709/0xe70
>  [<ffffffff8114a9e8>] ? link_path_walk+0x68/0x860
>  [<ffffffff81124b24>] ? kmem_cache_alloc+0x1b4/0x1d0
>  [<ffffffff8114ee21>] ? path_openat+0xd1/0x660
>  [<ffffffff8114f755>] ? do_filp_open+0x45/0xb0
>  [<ffffffff8115bb65>] ? __alloc_fd+0xc5/0x120
>  [<ffffffff8113e5f0>] ? do_sys_open+0x140/0x230
>  [<ffffffff8156c5ed>] ? system_call_fastpath+0x1a/0x1f
> Code:  Bad RIP value.
> RIP  [<          (null)>]           (null)
>  RSP <ffff8802532579a0>
> CR2: 0000000000000000
> ---[ end trace b6ce5041151511a5 ]---
>
> Thanks,
> Tobias Klausmann
>
