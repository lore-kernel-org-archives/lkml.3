Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3IKJIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:08:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3IKJIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:08:12 -0400
Date: Wed, 11 Sep 2013 12:06:49 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [117/251] radeon kms: do not flush uninitialized hotplug work
Message-ID: <20130911090648.GA2271@swordfish.minsk.epam.com>
References: <20130911042707.738353451@goodmis.org>
 <20130911042911.752089217@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911042911.752089217@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/11/13 00:29), Steven Rostedt wrote:
> 3.6.11.9-rc1 stable review patch.
> If anyone has any objections, please let me know.
>

Hello,
Steven, this patch makes r100_irq_process() unhappy and there
is additional fix on top of this patch.
upstream 27c505ca84e164ec66ad55dcf3f5befaac83f10a

I'll prepare a proper patch for stable.

	-ss

> ------------------
> 
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> [ Upstream commit a01c34f72e7cd2624570818f579b5ab464f93de2 ]
> 
> Fix a warning from lockdep caused by calling flush_work() for
> uninitialized hotplug work. Initialize hotplug_work, audio_work
> and reset_work upon successful radeon_irq_kms_init() completion
> and thus perform hotplug flush_work only when rdev->irq.installed
> is true.
> 
> [    4.790019] [drm] Loading CEDAR Microcode
> [    4.790943] r600_cp: Failed to load firmware "radeon/CEDAR_smc.bin"
> [    4.791152] [drm:evergreen_startup] *ERROR* Failed to load firmware!
> [    4.791330] radeon 0000:01:00.0: disabling GPU acceleration
> 
> [    4.792633] INFO: trying to register non-static key.
> [    4.792792] the code is fine but needs lockdep annotation.
> [    4.792953] turning off the locking correctness validator.
> 
> [    4.793114] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc0-dbg-10676-gfe56456-dirty #1816
> [    4.793314] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
> [    4.793507]  ffffffff821fd810 ffff8801530b9a18 ffffffff8160434e 0000000000000002
> [    4.794155]  ffff8801530b9ad8 ffffffff810b8404 ffff8801530b0798 ffff8801530b0000
> [    4.794789]  ffff8801530b9b00 0000000000000046 00000000000004c0 ffffffff00000000
> [    4.795418] Call Trace:
> [    4.795573]  [<ffffffff8160434e>] dump_stack+0x4e/0x82
> [    4.795731]  [<ffffffff810b8404>] __lock_acquire+0x1a64/0x1d30
> [    4.795893]  [<ffffffff814a87f0>] ? dev_vprintk_emit+0x50/0x60
> [    4.796034]  [<ffffffff810b8fb4>] lock_acquire+0xa4/0x200
> [    4.796216]  [<ffffffff8106cd75>] ? flush_work+0x5/0x280
> [    4.796375]  [<ffffffff8106cdad>] flush_work+0x3d/0x280
> [    4.796520]  [<ffffffff8106cd75>] ? flush_work+0x5/0x280
> [    4.796682]  [<ffffffff810b659d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
> [    4.796862]  [<ffffffff8131d775>] ? delay_tsc+0x95/0xf0
> [    4.797024]  [<ffffffff8141bb8b>] radeon_irq_kms_fini+0x2b/0x70
> [    4.797186]  [<ffffffff814557c9>] evergreen_init+0x2a9/0x2e0
> [    4.797347]  [<ffffffff813ebb1f>] radeon_device_init+0x5ef/0x700
> [    4.797511]  [<ffffffff81335bc7>] ? pci_find_capability+0x47/0x50
> [    4.797672]  [<ffffffff813edaed>] radeon_driver_load_kms+0x8d/0x150
> [    4.797843]  [<ffffffff813ce426>] drm_get_pci_dev+0x166/0x280
> [    4.798007]  [<ffffffff8116cff5>] ? kfree+0xf5/0x2e0
> [    4.798168]  [<ffffffff813ea298>] ? radeon_pci_probe+0x98/0xd0
> [    4.798329]  [<ffffffff813ea2aa>] radeon_pci_probe+0xaa/0xd0
> [    4.798489]  [<ffffffff81339404>] pci_device_probe+0x84/0xe0
> [    4.798644]  [<ffffffff814ac7d6>] driver_probe_device+0x76/0x240
> [    4.798805]  [<ffffffff814aca73>] __driver_attach+0x93/0xa0
> [    4.798948]  [<ffffffff814ac9e0>] ? __device_attach+0x40/0x40
> [    4.799126]  [<ffffffff814aa82b>] bus_for_each_dev+0x6b/0xb0
> [    4.799272]  [<ffffffff814ac2be>] driver_attach+0x1e/0x20
> [    4.799434]  [<ffffffff814abec0>] bus_add_driver+0x1f0/0x280
> [    4.799596]  [<ffffffff814ad0e4>] driver_register+0x74/0x150
> [    4.799758]  [<ffffffff8133923d>] __pci_register_driver+0x5d/0x60
> [    4.799936]  [<ffffffff81d16efc>] ? ttm_init+0x67/0x67
> [    4.800081]  [<ffffffff813ce655>] drm_pci_init+0x115/0x130
> [    4.800243]  [<ffffffff81d16efc>] ? ttm_init+0x67/0x67
> [    4.800405]  [<ffffffff81d16f98>] radeon_init+0x9c/0xba
> [    4.800586]  [<ffffffff810002ca>] do_one_initcall+0xfa/0x150
> [    4.800746]  [<ffffffff81073f60>] ? parse_args+0x120/0x330
> [    4.800909]  [<ffffffff81cdafae>] kernel_init_freeable+0x111/0x191
> [    4.801052]  [<ffffffff81cda87a>] ? do_early_param+0x88/0x88
> [    4.801233]  [<ffffffff815fb670>] ? rest_init+0x140/0x140
> [    4.801393]  [<ffffffff815fb67e>] kernel_init+0xe/0x180
> [    4.801556]  [<ffffffff8160dcac>] ret_from_fork+0x7c/0xb0
> [    4.801718]  [<ffffffff815fb670>] ? rest_init+0x140/0x140
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/gpu/drm/radeon/radeon_irq_kms.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_irq_kms.c b/drivers/gpu/drm/radeon/radeon_irq_kms.c
> index 443bd49..4bc6be5 100644
> --- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
> +++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
> @@ -243,9 +243,6 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
>  {
>  	int r = 0;
>  
> -	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
> -	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
> -
>  	spin_lock_init(&rdev->irq.lock);
>  	r = drm_vblank_init(rdev->ddev, rdev->num_crtc);
>  	if (r) {
> @@ -267,6 +264,10 @@ int radeon_irq_kms_init(struct radeon_device *rdev)
>  		rdev->irq.installed = false;
>  		return r;
>  	}
> +
> +	INIT_WORK(&rdev->hotplug_work, radeon_hotplug_work_func);
> +	INIT_WORK(&rdev->audio_work, r600_audio_update_hdmi);
> +
>  	DRM_INFO("radeon: irq initialized.\n");
>  	return 0;
>  }
> @@ -286,8 +287,8 @@ void radeon_irq_kms_fini(struct radeon_device *rdev)
>  		rdev->irq.installed = false;
>  		if (rdev->msi_enabled)
>  			pci_disable_msi(rdev->pdev);
> +		flush_work_sync(&rdev->hotplug_work);
>  	}
> -	flush_work_sync(&rdev->hotplug_work);
>  }
>  
>  /**
> -- 
> 1.7.10.4
> 
> 
