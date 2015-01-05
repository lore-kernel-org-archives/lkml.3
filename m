Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbbAERIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:08:01 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:42502 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbbAERH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:07:59 -0500
MIME-Version: 1.0
In-Reply-To: <1420279798-961-1-git-send-email-tiwai@suse.de>
References: <1420279798-961-1-git-send-email-tiwai@suse.de>
Date: Mon, 5 Jan 2015 12:07:52 -0500
Message-ID: <CADnq5_NU-nde7eBk_Ptpk6twk_aBrXZgLXxio3RiJUJ1D4ZzdQ@mail.gmail.com>
Subject: Re: [PATCH v2] drm/radeon: Fix kernel panic with HDMI w/o SAD
From: Alex Deucher <alexdeucher@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2015 at 5:09 AM, Takashi Iwai <tiwai@suse.de> wrote:
> A BUG_ON() call in dce3_2_afmt_write_sad_regs() is triggered when a
> HDMI monitor without audio is plugged:

I have a slightly different fix already queued up:
http://lists.freedesktop.org/archives/dri-devel/2014-December/073672.html

Alex

>
>  kernel BUG at ../drivers/gpu/drm/radeon/dce3_1_afmt.c:110!
>  invalid opcode: 0000 [#1] PREEMPT SMP
>  CPU: 2 PID: 967 Comm: Xorg Tainted: PO  3.16.7-7-desktop #1
>  Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
>  task: ffff8800cea86350 ti: ffff8800c1880000 task.ti: ffff8800c1880000
>  RIP: 0010:[<ffffffffa0126c50>] dce3_1_hdmi_setmode+0x570/0x5a0 [radeon]
>  Call Trace:
>   [<ffffffffa00a6936>] drm_crtc_helper_set_mode+0x346/0x520 [drm_kms_helper]
>   [<ffffffffa00a7678>] drm_crtc_helper_set_config+0x8a8/0xad0 [drm_kms_helper]
>   [<ffffffffa00ede3f>] radeon_crtc_set_config+0x3f/0x110 [radeon]
>   [<ffffffffa001edc1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
>   [<ffffffffa00a9a6b>] restore_fbdev_mode+0xab/0xd0 [drm_kms_helper]
>   [<ffffffffa00a9aae>] drm_fb_helper_restore_fbdev_mode_unlocked+0x1e/0x30 [drm_kms_helper]
>   [<ffffffffa00ab642>] drm_fb_helper_set_par+0x22/0x60 [drm_kms_helper]
>   [<ffffffffa00ab5cb>] drm_fb_helper_hotplug_event+0x8b/0xe0 [drm_kms_helper]
>   [<ffffffffa00ab65a>] drm_fb_helper_set_par+0x3a/0x60 [drm_kms_helper]
>   [<ffffffff813818ce>] fb_set_var+0x15e/0x3b0
>   [<ffffffff81378d0b>] fbcon_blank+0x1cb/0x2b0
>   [<ffffffff813f2a31>] do_unblank_screen+0xa1/0x1b0
>   [<ffffffff813e8fd3>] complete_change_console+0x53/0xe0
>   [<ffffffff813e9fa9>] vt_ioctl+0xf49/0x10d0
>   [<ffffffff813ddfdc>] tty_ioctl+0x26c/0xb70
>   [<ffffffff811cad17>] do_vfs_ioctl+0x2e7/0x4c0
>   [<ffffffff811caf71>] SyS_ioctl+0x81/0xa0
>   [<ffffffff81622a2d>] system_call_fastpath+0x1a/0x1f
>   [<00007f2fae8c6397>] 0x7f2fae8c6396
>
> Actually the BUG_ON() check is wrong, since sads may be NULL when
> sad_count is zero.  This patch removes the BUG_ON() and adds the
> proper NULL initialization of sads.
>
> Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=911356
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/gpu/drm/radeon/dce3_1_afmt.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
> index 2fe8cfc966d9..7ca23f45829e 100644
> --- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
> +++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
> @@ -72,7 +72,7 @@ static void dce3_2_afmt_write_sad_regs(struct drm_encoder *encoder)
>         struct radeon_device *rdev = encoder->dev->dev_private;
>         struct drm_connector *connector;
>         struct radeon_connector *radeon_connector = NULL;
> -       struct cea_sad *sads;
> +       struct cea_sad *sads = NULL;
>         int i, sad_count;
>
>         static const u16 eld_reg_to_type[][2] = {
> @@ -107,7 +107,6 @@ static void dce3_2_afmt_write_sad_regs(struct drm_encoder *encoder)
>                 DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
>                 return;
>         }
> -       BUG_ON(!sads);
>
>         for (i = 0; i < ARRAY_SIZE(eld_reg_to_type); i++) {
>                 u32 value = 0;
> --
> 2.2.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
