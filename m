Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbaELTIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:08:18 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:42286 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbaELTIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:08:17 -0400
Date: Mon, 12 May 2014 21:08:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] i915: Add module option to support VGA arbiter on HD
 devices
Message-ID: <20140512190812.GH25056@phenom.ffwll.local>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Dave Airlie <airlied@redhat.com>
References: <20140509201655.2849.97478.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140509201655.2849.97478.stgit@bling.home>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:20:41PM -0600, Alex Williamson wrote:
> Commit 81b5c7bc found that the current VGA arbiter support in i915
> only works for ancient GMCH-based IGD devices and attempted to update
> support for newer HD devices.  Unfortunately newer devices cannot
> completely opt-out of VGA arbitration like the old devices could.
> The VGA I/O space cannot be disabled internally.  The only way to
> route VGA I/O elsewhere is by disabling I/O at the device PCI command
> register.  This means that with commit 81b5c7bc and multiple VGA
> adapters, the VGA arbiter will report that multiple VGA devices are
> participating in arbitration, Xorg will notice this and disable DRI.
> Therefore, 81b5c7bc was reverted because DRI is more important than
> being correct.
> 
> There is however an actual need for i915 to correctly participate in
> VGA arbitration; VGA device assignment.  If we want to use VFIO to
> assign a VGA device to a virtual machine, we need to be able to
> access the VGA resources of that device.  By adding an i915 module
> option we can allow i915 to continue with its charade by default, but
> also allow an easy path for users who require working VGA arbitration.
> Hopefully Xorg can someday be taught to behave better with multiple
> VGA devices.
> 
> This also rolls in reverted commit 6e1b4fda, which corrected an
> ordering issue with 81b5c7bc by delaying the disabling of VGA memory
> until after vgacon->fbcon handoff.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@redhat.com>
> ---
> 
> This should be a nop with the default module setting, so if there's
> any opportunity to get this into v3.15, it would be appreciated.

I really don't like module options to work around bugs elsewhere. It means
the 5 users who know about a given bug are now happen, and the 3
bazillion without enough clue/savy/time still suffer from problems.

My goal is to actually add a bit of support to the core kernel's module
option parsing code so that most of the options we have can spit warnings
into dmesg and taint the kernel.

Can't we fix this in any other way?
-Daniel

> 
>  drivers/gpu/drm/i915/i915_dma.c      |   22 +++++++++++++++++++---
>  drivers/gpu/drm/i915/i915_drv.h      |    1 +
>  drivers/gpu/drm/i915/i915_params.c   |    5 +++++
>  drivers/gpu/drm/i915/intel_display.c |   30 ++++++++++++++++++++++++++++++
>  drivers/gpu/drm/i915/intel_drv.h     |    2 ++
>  include/linux/vgaarb.h               |    7 +++++++
>  6 files changed, 64 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 96177ee..c0d0c03 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1306,10 +1306,20 @@ static int i915_load_modeset_init(struct drm_device *dev)
>  	 * If we are a secondary display controller (!PCI_DISPLAY_CLASS_VGA),
>  	 * then we do not take part in VGA arbitration and the
>  	 * vga_client_register() fails with -ENODEV.
> +	 *
> +	 * NB.  The set_decode callback here actually only works on GMCH
> +	 * devices, on newer HD devices we can only disable VGA MMIO space.
> +	 * Disabling VGA I/O space requires disabling I/O in the PCI command
> +	 * register.  Nonetheless, we like to pretend that we participate in
> +	 * VGA arbitration and can dynamically disable VGA I/O space because
> +	 * this makes X happy, even though it's a complete lie.
>  	 */
> -	ret = vga_client_register(dev->pdev, dev, NULL, i915_vga_set_decode);
> -	if (ret && ret != -ENODEV)
> -		goto out;
> +	if (!i915.enable_hd_vgaarb || !HAS_PCH_SPLIT(dev)) {
> +		ret = vga_client_register(dev->pdev, dev, NULL,
> +					  i915_vga_set_decode);
> +		if (ret && ret != -ENODEV)
> +			goto out;
> +	}
>  
>  	intel_register_dsm_handler();
>  
> @@ -1369,6 +1379,12 @@ static int i915_load_modeset_init(struct drm_device *dev)
>  	 */
>  	intel_fbdev_initial_config(dev);
>  
> +	/*
> +	 * Must do this after fbcon init so that
> +	 * vgacon_save_screen() works during the handover.
> +	 */
> +	i915_disable_vga_mem(dev);
> +
>  	/* Only enable hotplug handling once the fbdev is fully set up. */
>  	dev_priv->enable_hotplug_processing = true;
>  
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index ec82f6b..f3908f6 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -2080,6 +2080,7 @@ struct i915_params {
>  	bool prefault_disable;
>  	bool reset;
>  	bool disable_display;
> +	bool enable_hd_vgaarb;
>  };
>  extern struct i915_params i915 __read_mostly;
>  
> diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
> index d1d7980..64d96c6 100644
> --- a/drivers/gpu/drm/i915/i915_params.c
> +++ b/drivers/gpu/drm/i915/i915_params.c
> @@ -47,6 +47,7 @@ struct i915_params i915 __read_mostly = {
>  	.invert_brightness = 0,
>  	.disable_display = 0,
>  	.enable_cmd_parser = 0,
> +	.enable_hd_vgaarb = false,
>  };
>  
>  module_param_named(modeset, i915.modeset, int, 0400);
> @@ -152,3 +153,7 @@ MODULE_PARM_DESC(disable_display, "Disable display (default: false)");
>  module_param_named(enable_cmd_parser, i915.enable_cmd_parser, int, 0600);
>  MODULE_PARM_DESC(enable_cmd_parser,
>  		 "Enable command parsing (1=enabled, 0=disabled [default])");
> +
> +module_param_named(enable_hd_vgaarb, i915.enable_hd_vgaarb, bool, 0444);
> +MODULE_PARM_DESC(enable_hd_vgaarb,
> +	"Enable support for VGA arbitration on Intel HD IGD. (default: false)");
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 69bcc42..2cd35ba 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -11284,6 +11284,33 @@ static void i915_disable_vga(struct drm_device *dev)
>  	POSTING_READ(vga_reg);
>  }
>  
> +static void i915_enable_vga_mem(struct drm_device *dev)
> +{
> +	/* Enable VGA memory on Intel HD */
> +	if (i915.enable_hd_vgaarb && HAS_PCH_SPLIT(dev)) {
> +		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
> +		outb(inb(VGA_MSR_READ) | VGA_MSR_MEM_EN, VGA_MSR_WRITE);
> +		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
> +						   VGA_RSRC_LEGACY_MEM |
> +						   VGA_RSRC_NORMAL_IO |
> +						   VGA_RSRC_NORMAL_MEM);
> +		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
> +	}
> +}
> +
> +void i915_disable_vga_mem(struct drm_device *dev)
> +{
> +	/* Disable VGA memory on Intel HD */
> +	if (i915.enable_hd_vgaarb && HAS_PCH_SPLIT(dev)) {
> +		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
> +		outb(inb(VGA_MSR_READ) & ~VGA_MSR_MEM_EN, VGA_MSR_WRITE);
> +		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
> +						   VGA_RSRC_NORMAL_IO |
> +						   VGA_RSRC_NORMAL_MEM);
> +		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
> +	}
> +}
> +
>  void intel_modeset_init_hw(struct drm_device *dev)
>  {
>  	intel_prepare_ddi(dev);
> @@ -11594,6 +11621,7 @@ void i915_redisable_vga_power_on(struct drm_device *dev)
>  	if (!(I915_READ(vga_reg) & VGA_DISP_DISABLE)) {
>  		DRM_DEBUG_KMS("Something enabled VGA plane, disabling it\n");
>  		i915_disable_vga(dev);
> +		i915_disable_vga_mem(dev);
>  	}
>  }
>  
> @@ -11848,6 +11876,8 @@ void intel_modeset_cleanup(struct drm_device *dev)
>  
>  	intel_disable_fbc(dev);
>  
> +	i915_enable_vga_mem(dev);
> +
>  	intel_disable_gt_powersave(dev);
>  
>  	ironlake_teardown_rc6(dev);
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
> index 328b1a7..fbe5d360 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -934,4 +934,6 @@ int intel_sprite_get_colorkey(struct drm_device *dev, void *data,
>  /* intel_tv.c */
>  void intel_tv_init(struct drm_device *dev);
>  
> +extern void i915_disable_vga_mem(struct drm_device *dev);
> +
>  #endif /* __INTEL_DRV_H__ */
> diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
> index 2c02f3a..80cf817 100644
> --- a/include/linux/vgaarb.h
> +++ b/include/linux/vgaarb.h
> @@ -65,8 +65,15 @@ struct pci_dev;
>   *     out of the arbitration process (and can be safe to take
>   *     interrupts at any time.
>   */
> +#if defined(CONFIG_VGA_ARB)
>  extern void vga_set_legacy_decoding(struct pci_dev *pdev,
>  				    unsigned int decodes);
> +#else
> +static inline void vga_set_legacy_decoding(struct pci_dev *pdev,
> +					   unsigned int decodes)
> +{
> +}
> +#endif
>  
>  /**
>   *     vga_get         - acquire & locks VGA resources
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
