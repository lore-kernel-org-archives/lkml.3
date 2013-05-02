Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab3EBAmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:42:04 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:39795 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3EBAl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:41:59 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130502000206.GH15623@pd.tnic>
References: <20130502000206.GH15623@pd.tnic>
Date: Thu, 2 May 2013 02:41:58 +0200
X-Google-Sender-Auth: 6zyEb50UslqotpVCNKbTLnveELg
Message-ID: <CAKMK7uF=4spN_+BtwnXhWvNs4GjM1iXPCN6aTupPkykQqqnU2A@mail.gmail.com>
Subject: Re: WARNING: at drivers/gpu/drm/drm_crtc.c:82 drm_warn_on_modeset_not_all_locked+0x8d/0xc0()
From: Daniel Vetter <daniel@ffwll.ch>
To: Borislav Petkov <bp@alien8.de>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 2:02 AM, Borislav Petkov <bp@alien8.de> wrote:
> Hi,
>
> I'm seeing this when booting latest Linus tree + tip/master in kvm.
> Config is attached. Looks like it cannot find root fs and panics and
> calls the panic notifier which screams in drm_crtc.c because not all
> modeset locks are taken. Maybe bogus?

Locking in the drm panic notifiere is completely bogus (as in simply
does not exist). The only difference is that with the new locking
scheme in 3.9 we're now pretty obnixious about checking for these
kinds of things. Also, drm drivers love to sleep in the panic
handlers, too. It's somewhere on my giant list of things to fix in drm
land, but I'm not sure whether I'll get around to it in this life or
the next. Maybe we just need to shut up the WARN in case of a panic
...

Cheers, Daniel

> Anyway, just FYI:
>
> ...
> [   25.406627] md: Autodetecting RAID arrays.
> [   25.408078] md: Scanned 0 and added 0 devices.
> [   25.409665] md: autorun ...
> [   25.410916] md: ... autorun DONE.
> [   25.412501] VFS: Cannot open root device "sda1" or unknown-block(0,0): error -6
> [   25.414524] Please append a correct "root=" boot option; here are the available partitions:
> [   25.416719] 1f00            4096 mtdblock0  (driver?)
> [   25.445497] 1f01          131072 mtdblock1  (driver?)
> [   25.447975] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> [   25.449478] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.9.0-06610-g53332d7971f9 #1
> [   25.449478] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   25.449478]  0000000000008001 ffff88007c0f1db8 ffffffff825c3769 ffff88007c0f1e38
> [   25.449478]  ffffffff825be42e 3130663182d86a47 6631002000000010 ffff88007c0f1e48
> [   25.449478]  ffff88007c0f1de8 ffff88007c0f0031 ffff88007c0f1e60 0000000000000000
> [   25.449478] Call Trace:
> [   25.449478]  [<ffffffff825c3769>] dump_stack+0x27/0x30
> [   25.449478]  [<ffffffff825be42e>] panic+0x10f/0x2a3
> [   25.449478]  [<ffffffff8367fc72>] mount_block_root+0x2b5/0x3ad
> [   25.449478]  [<ffffffff8367fdd6>] mount_root+0x6c/0x77
> [   25.449478]  [<ffffffff8367ffaf>] prepare_namespace+0x1ce/0x210
> [   25.449478]  [<ffffffff8367f865>] kernel_init_freeable+0x2fd/0x31b
> [   25.449478]  [<ffffffff8367e948>] ? loglevel+0x46/0x46
> [   25.449478]  [<ffffffff825a9ac0>] ? rest_init+0x1f0/0x1f0
> [   25.449478]  [<ffffffff825a9ad6>] kernel_init+0x16/0x1a0
> [   25.449478]  [<ffffffff825e611c>] ret_from_fork+0x7c/0xb0
> [   25.449478]  [<ffffffff825a9ac0>] ? rest_init+0x1f0/0x1f0
> [   25.449478] drm_kms_helper: panic occurred, switching back to text console
> [   25.449478] ------------[ cut here ]------------
> [   25.449478] WARNING: at drivers/gpu/drm/drm_crtc.c:82 drm_warn_on_modeset_not_all_locked+0x8d/0xc0()
> [   25.449478] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.9.0-06610-g53332d7971f9 #1
> [   25.449478] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   25.449478]  0000000000000009 ffff88007c0f1c38 ffffffff825c3769 ffff88007c0f1c78
> [   25.449478]  ffffffff81080303 0000000000000001 ffff880079dbef60 ffff88007ba7ab28
> [   25.449478]  ffff88007ba7a290 0000000000000000 ffffffff831c3ad0 ffff88007c0f1c88
> [   25.449478] Call Trace:
> [   25.449478]  [<ffffffff825c3769>] dump_stack+0x27/0x30
> [   25.449478]  [<ffffffff81080303>] warn_slowpath_common+0x93/0xd0
> [   25.449478]  [<ffffffff8108046a>] warn_slowpath_null+0x2a/0x40
> [   25.449478]  [<ffffffff816e841d>] drm_warn_on_modeset_not_all_locked+0x8d/0xc0
> [   25.449478]  [<ffffffff816cb6a6>] drm_fb_helper_restore_fbdev_mode+0x26/0xa0
> [   25.449478]  [<ffffffff816cb7b2>] drm_fb_helper_panic+0x92/0xf0
> [   25.449478]  [<ffffffff810c875e>] notifier_call_chain+0x9e/0x250
> [   25.449478]  [<ffffffff810c8b49>] __atomic_notifier_call_chain+0xa9/0x1c0
> [   25.449478]  [<ffffffff810c8aa5>] ? __atomic_notifier_call_chain+0x5/0x1c0
> [   25.449478]  [<ffffffff810c8c7e>] atomic_notifier_call_chain+0x1e/0x30
> [   25.449478]  [<ffffffff825be46a>] panic+0x14b/0x2a3
> [   25.449478]  [<ffffffff8367fc72>] mount_block_root+0x2b5/0x3ad
> [   25.449478]  [<ffffffff8367fdd6>] mount_root+0x6c/0x77
> [   25.449478]  [<ffffffff8367ffaf>] prepare_namespace+0x1ce/0x210
> [   25.449478]  [<ffffffff8367f865>] kernel_init_freeable+0x2fd/0x31b
> [   25.449478]  [<ffffffff8367e948>] ? loglevel+0x46/0x46
> [   25.449478]  [<ffffffff825a9ac0>] ? rest_init+0x1f0/0x1f0
> [   25.449478]  [<ffffffff825a9ad6>] kernel_init+0x16/0x1a0
> [   25.449478]  [<ffffffff825e611c>] ret_from_fork+0x7c/0xb0
> [   25.449478]  [<ffffffff825a9ac0>] ? rest_init+0x1f0/0x1f0
> [   25.449478] ---[ end trace be42dd504bbfe2a8 ]---
> [   25.449478] ------------[ cut here ]------------
> [   25.449478] WARNING: at drivers/gpu/drm/drm_crtc.c:84 drm_warn_on_modeset_not_all_locked+0xa8/0xc0()
> [   25.449478] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.9.0-06610-g53332d7971f9 #1
> [   25.449478] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   25.449478]  0000000000000009 ffff88007c0f1c38 ffffffff825c3769 ffff88007c0f1c78
> [   25.449478]  ffffffff81080303 0000000000000001 ffff88007ba7ab20 ffff88007ba7ab28
> [   25.449478]  ffff88007ba7a290 0000000000000000 ffffffff831c3ad0 ffff88007c0f1c88
> [   25.449478] Call Trace:
> [   25.449478]  [<ffffffff825c3769>] dump_stack+0x27/0x30
> [   25.449478]  [<ffffffff81080303>] warn_slowpath_common+0x93/0xd0
> [   25.449478]  [<ffffffff8108046a>] warn_slowpath_null+0x2a/0x40
> [   25.449478]  [<ffffffff816e8438>] drm_warn_on_modeset_not_all_locked+0xa8/0xc0
> [   25.449478]  [<ffffffff816cb6a6>] drm_fb_helper_restore_fbdev_mode+0x26/0xa0
> [   25.449478]  [<ffffffff816cb7b2>] drm_fb_helper_panic+0x92/0xf0
> [   25.449478]  [<ffffffff810c875e>] notifier_call_chain+0x9e/0x250
> [   25.449478]  [<ffffffff810c8b49>] __atomic_notifier_call_chain+0xa9/0x1c0
> [   25.449478]  [<ffffffff810c8aa5>] ? __atomic_notifier_call_chain+0x5/0x1c0
> [   25.449478]  [<ffffffff810c8c7e>] atomic_notifier_call_chain+0x1e/0x30
> [   25.449478]  [<ffffffff825be46a>] panic+0x14b/0x2a3
> [   25.449478]  [<ffffffff8367fc72>] mount_block_root+0x2b5/0x3ad
> [   25.449478]  [<ffffffff8367fdd6>] mount_root+0x6c/0x77
> [   25.449478]  [<ffffffff8367ffaf>] prepare_namespace+0x1ce/0x210
> [   25.449478]  [<ffffffff8367f865>] kernel_init_freeable+0x2fd/0x31b
> [   25.449478]  [<ffffffff8367e948>] ? loglevel+0x46/0x46
> [   25.449478]  [<ffffffff825a9ac0>] ? rest_init+0x1f0/0x1f0
> [   25.449478]  [<ffffffff825a9ad6>] kernel_init+0x16/0x1a0
> [   25.449478]  [<ffffffff825e611c>] ret_from_fork+0x7c/0xb0
> [   25.449478]  [<ffffffff825a9ac0>] ? rest_init+0x1f0/0x1f0
> [   25.449478] ---[ end trace be42dd504bbfe2a9 ]---
> [EOF]
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
