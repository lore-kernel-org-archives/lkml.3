Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3JNOvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:51:54 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53409 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3JNOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:50:25 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm-intel tree
Date: Mon, 14 Oct 2013 16:48:03 +0200
Message-Id: <1381762088-18880-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the drm-intel tree got conflicts in:

	drivers/gpu/drm/i915/i915_dma.c
	drivers/gpu/drm/i915/intel_dp.c
	drivers/gpu/drm/i915/intel_drv.h

caused by commits e1264eb (Revert "drm/i915: Delay disabling of VGA memory
until vgacon->fbcon handoff is done") and ce35255 (drm/i915: Fix unclaimed
register access due to delayed VGA memory disable).

I fixed them up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc drivers/gpu/drm/i915/i915_dma.c
index 24640dc,42cddc1..f240150
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@@ -1350,6 -1358,13 +1355,8 @@@ static int i915_load_modeset_init(struc
  	 */
  	intel_fbdev_initial_config(dev);
  
 -	/*
 -	 * Must do this after fbcon init so that
 -	 * vgacon_save_screen() works during the handover.
 -	 */
 -	i915_disable_vga_mem(dev);
+ 	intel_display_power_put(dev, POWER_DOMAIN_VGA);
+ 
  	/* Only enable hotplug handling once the fbdev is fully set up. */
  	dev_priv->enable_hotplug_processing = true;
  
diff --cc drivers/gpu/drm/i915/intel_display.c
index 1fdf49c,4a8a2e4..fbd028e
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -10237,8 -10388,37 +10384,10 @@@ static void i915_disable_vga(struct drm
  	POSTING_READ(vga_reg);
  }
  
 -static void i915_enable_vga_mem(struct drm_device *dev)
 -{
 -	/* Enable VGA memory on Intel HD */
 -	if (HAS_PCH_SPLIT(dev)) {
 -		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
 -		outb(inb(VGA_MSR_READ) | VGA_MSR_MEM_EN, VGA_MSR_WRITE);
 -		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
 -						   VGA_RSRC_LEGACY_MEM |
 -						   VGA_RSRC_NORMAL_IO |
 -						   VGA_RSRC_NORMAL_MEM);
 -		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
 -	}
 -}
 -
 -void i915_disable_vga_mem(struct drm_device *dev)
 -{
 -	/* Disable VGA memory on Intel HD */
 -	if (HAS_PCH_SPLIT(dev)) {
 -		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
 -		outb(inb(VGA_MSR_READ) & ~VGA_MSR_MEM_EN, VGA_MSR_WRITE);
 -		vga_set_legacy_decoding(dev->pdev, VGA_RSRC_LEGACY_IO |
 -						   VGA_RSRC_NORMAL_IO |
 -						   VGA_RSRC_NORMAL_MEM);
 -		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
 -	}
 -}
 -
  void intel_modeset_init_hw(struct drm_device *dev)
  {
+ 	struct drm_i915_private *dev_priv = dev->dev_private;
+ 
  	intel_prepare_ddi(dev);
  
  	intel_init_clock_gating(dev);
@@@ -10510,9 -10697,10 +10666,9 @@@ void i915_redisable_vga(struct drm_devi
  	    (I915_READ(HSW_PWR_WELL_DRIVER) & HSW_PWR_WELL_STATE_ENABLED) == 0)
  		return;
  
- 	if (I915_READ(vga_reg) != VGA_DISP_DISABLE) {
+ 	if (!(I915_READ(vga_reg) & VGA_DISP_DISABLE)) {
  		DRM_DEBUG_KMS("Something enabled VGA plane, disabling it\n");
  		i915_disable_vga(dev);
 -		i915_disable_vga_mem(dev);
  	}
  }
  
diff --cc drivers/gpu/drm/i915/intel_dp.c
index 98f3b64,bee09e1..c392ad2
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -1532,8 -1541,8 +1541,8 @@@ static void intel_edp_psr_setup(struct 
  	intel_edp_psr_write_vsc(intel_dp, &psr_vsc);
  
  	/* Avoid continuous PSR exit by masking memup and hpd */
- 	I915_WRITE(EDP_PSR_DEBUG_CTL, EDP_PSR_DEBUG_MASK_MEMUP |
+ 	I915_WRITE(EDP_PSR_DEBUG_CTL(dev), EDP_PSR_DEBUG_MASK_MEMUP |
 -		   EDP_PSR_DEBUG_MASK_HPD);
 +		   EDP_PSR_DEBUG_MASK_HPD | EDP_PSR_DEBUG_MASK_LPSP);
  
  	intel_dp->psr_setup_done = true;
  }
diff --cc drivers/gpu/drm/i915/intel_drv.h
index 39bfdb3,189257d..343f0fa
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@@ -714,116 -656,196 +656,197 @@@ void assert_fdi_rx_pll(struct drm_i915_
  		       enum pipe pipe, bool state);
  #define assert_fdi_rx_pll_enabled(d, p) assert_fdi_rx_pll(d, p, true)
  #define assert_fdi_rx_pll_disabled(d, p) assert_fdi_rx_pll(d, p, false)
- extern void assert_pipe(struct drm_i915_private *dev_priv, enum pipe pipe,
- 			bool state);
+ void assert_pipe(struct drm_i915_private *dev_priv, enum pipe pipe, bool state);
  #define assert_pipe_enabled(d, p) assert_pipe(d, p, true)
  #define assert_pipe_disabled(d, p) assert_pipe(d, p, false)
+ void intel_write_eld(struct drm_encoder *encoder,
+ 		     struct drm_display_mode *mode);
+ unsigned long intel_gen4_compute_page_offset(int *x, int *y,
+ 					     unsigned int tiling_mode,
+ 					     unsigned int bpp,
+ 					     unsigned int pitch);
+ void intel_display_handle_reset(struct drm_device *dev);
+ void hsw_enable_pc8_work(struct work_struct *__work);
+ void hsw_enable_package_c8(struct drm_i915_private *dev_priv);
+ void hsw_disable_package_c8(struct drm_i915_private *dev_priv);
+ void intel_dp_get_m_n(struct intel_crtc *crtc,
+ 		      struct intel_crtc_config *pipe_config);
+ int intel_dotclock_calculate(int link_freq, const struct intel_link_m_n *m_n);
+ void
+ ironlake_check_encoder_dotclock(const struct intel_crtc_config *pipe_config,
+ 				int dotclock);
+ bool intel_crtc_active(struct drm_crtc *crtc);
+ void i915_disable_vga_mem(struct drm_device *dev);
+ void hsw_enable_ips(struct intel_crtc *crtc);
+ void hsw_disable_ips(struct intel_crtc *crtc);
+ 
+ 
+ /* intel_dp.c */
+ void intel_dp_init(struct drm_device *dev, int output_reg, enum port port);
+ bool intel_dp_init_connector(struct intel_digital_port *intel_dig_port,
+ 			     struct intel_connector *intel_connector);
+ void intel_dp_start_link_train(struct intel_dp *intel_dp);
+ void intel_dp_complete_link_train(struct intel_dp *intel_dp);
+ void intel_dp_stop_link_train(struct intel_dp *intel_dp);
+ void intel_dp_sink_dpms(struct intel_dp *intel_dp, int mode);
+ void intel_dp_encoder_destroy(struct drm_encoder *encoder);
+ void intel_dp_check_link_status(struct intel_dp *intel_dp);
+ bool intel_dp_compute_config(struct intel_encoder *encoder,
+ 			     struct intel_crtc_config *pipe_config);
+ bool intel_dpd_is_edp(struct drm_device *dev);
+ void ironlake_edp_backlight_on(struct intel_dp *intel_dp);
+ void ironlake_edp_backlight_off(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_on(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_off(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync);
+ void intel_edp_psr_enable(struct intel_dp *intel_dp);
+ void intel_edp_psr_disable(struct intel_dp *intel_dp);
+ void intel_edp_psr_update(struct drm_device *dev);
+ 
+ 
+ /* intel_dsi.c */
+ bool intel_dsi_init(struct drm_device *dev);
+ 
  
- extern void intel_init_clock_gating(struct drm_device *dev);
- extern void intel_suspend_hw(struct drm_device *dev);
- extern void intel_write_eld(struct drm_encoder *encoder,
- 			    struct drm_display_mode *mode);
- extern void intel_prepare_ddi(struct drm_device *dev);
- extern void hsw_fdi_link_train(struct drm_crtc *crtc);
- extern void intel_ddi_init(struct drm_device *dev, enum port port);
- extern enum port intel_ddi_get_encoder_port(struct intel_encoder *intel_encoder);
- 
- /* For use by IVB LP watermark workaround in intel_sprite.c */
- extern void intel_update_watermarks(struct drm_crtc *crtc);
- extern void intel_update_sprite_watermarks(struct drm_plane *plane,
- 					   struct drm_crtc *crtc,
- 					   uint32_t sprite_width, int pixel_size,
- 					   bool enabled, bool scaled);
- 
- extern unsigned long intel_gen4_compute_page_offset(int *x, int *y,
- 						    unsigned int tiling_mode,
- 						    unsigned int bpp,
- 						    unsigned int pitch);
- 
- extern int intel_sprite_set_colorkey(struct drm_device *dev, void *data,
- 				     struct drm_file *file_priv);
- extern int intel_sprite_get_colorkey(struct drm_device *dev, void *data,
- 				     struct drm_file *file_priv);
- 
- /* Power-related functions, located in intel_pm.c */
- extern void intel_init_pm(struct drm_device *dev);
- /* FBC */
- extern bool intel_fbc_enabled(struct drm_device *dev);
- extern void intel_update_fbc(struct drm_device *dev);
- /* IPS */
- extern void intel_gpu_ips_init(struct drm_i915_private *dev_priv);
- extern void intel_gpu_ips_teardown(void);
- 
- /* Power well */
- extern int i915_init_power_well(struct drm_device *dev);
- extern void i915_remove_power_well(struct drm_device *dev);
- 
- extern bool intel_display_power_enabled(struct drm_device *dev,
- 					enum intel_display_power_domain domain);
- extern void intel_display_power_get(struct drm_device *dev,
- 				    enum intel_display_power_domain domain);
- extern void intel_display_power_put(struct drm_device *dev,
- 				    enum intel_display_power_domain domain);
- extern void intel_init_power_well(struct drm_device *dev);
- extern void intel_set_power_well(struct drm_device *dev, bool enable);
- extern void intel_resume_power_well(struct drm_device *dev);
- extern void intel_enable_gt_powersave(struct drm_device *dev);
- extern void intel_disable_gt_powersave(struct drm_device *dev);
- extern void ironlake_teardown_rc6(struct drm_device *dev);
+ /* intel_dvo.c */
+ void intel_dvo_init(struct drm_device *dev);
+ 
+ 
+ /* legacy fbdev emulation in intel_fbdev.c */
+ #ifdef CONFIG_DRM_I915_FBDEV
+ extern int intel_fbdev_init(struct drm_device *dev);
+ extern void intel_fbdev_initial_config(struct drm_device *dev);
+ extern void intel_fbdev_fini(struct drm_device *dev);
+ extern void intel_fbdev_set_suspend(struct drm_device *dev, int state);
+ extern void intel_fbdev_output_poll_changed(struct drm_device *dev);
+ extern void intel_fbdev_restore_mode(struct drm_device *dev);
+ #else
+ static inline int intel_fbdev_init(struct drm_device *dev)
+ {
+ 	return 0;
+ }
+ 
+ static inline void intel_fbdev_initial_config(struct drm_device *dev)
+ {
+ }
+ 
+ static inline void intel_fbdev_fini(struct drm_device *dev)
+ {
+ }
+ 
+ static inline void intel_fbdev_set_suspend(struct drm_device *dev, int state)
+ {
+ }
+ 
+ static inline void intel_fbdev_restore_mode(struct drm_device *dev)
+ {
+ }
+ #endif
+ 
+ /* intel_hdmi.c */
+ void intel_hdmi_init(struct drm_device *dev, int hdmi_reg, enum port port);
+ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
+ 			       struct intel_connector *intel_connector);
+ struct intel_hdmi *enc_to_intel_hdmi(struct drm_encoder *encoder);
+ bool intel_hdmi_compute_config(struct intel_encoder *encoder,
+ 			       struct intel_crtc_config *pipe_config);
+ 
+ 
+ /* intel_lvds.c */
+ void intel_lvds_init(struct drm_device *dev);
+ bool intel_is_dual_link_lvds(struct drm_device *dev);
+ 
+ 
+ /* intel_modes.c */
+ int intel_connector_update_modes(struct drm_connector *connector,
+ 				 struct edid *edid);
+ int intel_ddc_get_modes(struct drm_connector *c, struct i2c_adapter *adapter);
+ void intel_attach_force_audio_property(struct drm_connector *connector);
+ void intel_attach_broadcast_rgb_property(struct drm_connector *connector);
+ 
+ 
+ /* intel_overlay.c */
+ void intel_setup_overlay(struct drm_device *dev);
+ void intel_cleanup_overlay(struct drm_device *dev);
+ int intel_overlay_switch_off(struct intel_overlay *overlay);
+ int intel_overlay_put_image(struct drm_device *dev, void *data,
+ 			    struct drm_file *file_priv);
+ int intel_overlay_attrs(struct drm_device *dev, void *data,
+ 			struct drm_file *file_priv);
+ 
+ 
+ /* intel_panel.c */
+ int intel_panel_init(struct intel_panel *panel,
+ 		     struct drm_display_mode *fixed_mode);
+ void intel_panel_fini(struct intel_panel *panel);
+ void intel_fixed_panel_mode(const struct drm_display_mode *fixed_mode,
+ 			    struct drm_display_mode *adjusted_mode);
+ void intel_pch_panel_fitting(struct intel_crtc *crtc,
+ 			     struct intel_crtc_config *pipe_config,
+ 			     int fitting_mode);
+ void intel_gmch_panel_fitting(struct intel_crtc *crtc,
+ 			      struct intel_crtc_config *pipe_config,
+ 			      int fitting_mode);
+ void intel_panel_set_backlight(struct drm_device *dev, u32 level, u32 max);
+ int intel_panel_setup_backlight(struct drm_connector *connector);
+ void intel_panel_enable_backlight(struct drm_device *dev, enum pipe pipe);
+ void intel_panel_disable_backlight(struct drm_device *dev);
+ void intel_panel_destroy_backlight(struct drm_device *dev);
+ enum drm_connector_status intel_panel_detect(struct drm_device *dev);
+ 
+ 
+ /* intel_pm.c */
+ void intel_init_clock_gating(struct drm_device *dev);
+ void intel_suspend_hw(struct drm_device *dev);
+ void intel_update_watermarks(struct drm_crtc *crtc);
+ void intel_update_sprite_watermarks(struct drm_plane *plane,
+ 				    struct drm_crtc *crtc,
+ 				    uint32_t sprite_width, int pixel_size,
+ 				    bool enabled, bool scaled);
+ void intel_init_pm(struct drm_device *dev);
+ bool intel_fbc_enabled(struct drm_device *dev);
+ void intel_update_fbc(struct drm_device *dev);
+ void intel_gpu_ips_init(struct drm_i915_private *dev_priv);
+ void intel_gpu_ips_teardown(void);
+ int i915_init_power_well(struct drm_device *dev);
+ void i915_remove_power_well(struct drm_device *dev);
+ bool intel_display_power_enabled(struct drm_device *dev,
+ 				 enum intel_display_power_domain domain);
+ void intel_display_power_get(struct drm_device *dev,
+ 			     enum intel_display_power_domain domain);
+ void intel_display_power_put(struct drm_device *dev,
+ 			     enum intel_display_power_domain domain);
+ void intel_init_power_well(struct drm_device *dev);
+ void intel_set_power_well(struct drm_device *dev, bool enable);
+ void intel_enable_gt_powersave(struct drm_device *dev);
+ void intel_disable_gt_powersave(struct drm_device *dev);
+ void ironlake_teardown_rc6(struct drm_device *dev);
  void gen6_update_ring_freq(struct drm_device *dev);
+ void gen6_rps_idle(struct drm_i915_private *dev_priv);
+ void gen6_rps_boost(struct drm_i915_private *dev_priv);
+ void intel_aux_display_runtime_get(struct drm_i915_private *dev_priv);
+ void intel_aux_display_runtime_put(struct drm_i915_private *dev_priv);
  
- extern bool intel_ddi_get_hw_state(struct intel_encoder *encoder,
- 				   enum pipe *pipe);
- extern int intel_ddi_get_cdclk_freq(struct drm_i915_private *dev_priv);
- extern void intel_ddi_pll_init(struct drm_device *dev);
- extern void intel_ddi_enable_transcoder_func(struct drm_crtc *crtc);
- extern void intel_ddi_disable_transcoder_func(struct drm_i915_private *dev_priv,
- 					      enum transcoder cpu_transcoder);
- extern void intel_ddi_enable_pipe_clock(struct intel_crtc *intel_crtc);
- extern void intel_ddi_disable_pipe_clock(struct intel_crtc *intel_crtc);
- extern void intel_ddi_setup_hw_pll_state(struct drm_device *dev);
- extern bool intel_ddi_pll_mode_set(struct drm_crtc *crtc);
- extern void intel_ddi_put_crtc_pll(struct drm_crtc *crtc);
- extern void intel_ddi_set_pipe_settings(struct drm_crtc *crtc);
- extern void intel_ddi_prepare_link_retrain(struct drm_encoder *encoder);
- extern bool
- intel_ddi_connector_get_hw_state(struct intel_connector *intel_connector);
- extern void intel_ddi_fdi_disable(struct drm_crtc *crtc);
- 
- extern void intel_display_handle_reset(struct drm_device *dev);
- extern bool intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,
- 						  enum pipe pipe,
- 						  bool enable);
- extern bool intel_set_pch_fifo_underrun_reporting(struct drm_device *dev,
- 						 enum transcoder pch_transcoder,
- 						 bool enable);
- 
- extern void intel_edp_psr_enable(struct intel_dp *intel_dp);
- extern void intel_edp_psr_disable(struct intel_dp *intel_dp);
- extern void intel_edp_psr_update(struct drm_device *dev);
- extern void hsw_disable_lcpll(struct drm_i915_private *dev_priv,
- 			      bool switch_to_fclk, bool allow_power_down);
- extern void hsw_restore_lcpll(struct drm_i915_private *dev_priv);
- extern void ilk_enable_gt_irq(struct drm_i915_private *dev_priv, uint32_t mask);
- extern void ilk_disable_gt_irq(struct drm_i915_private *dev_priv,
- 			       uint32_t mask);
- extern void snb_enable_pm_irq(struct drm_i915_private *dev_priv, uint32_t mask);
- extern void snb_disable_pm_irq(struct drm_i915_private *dev_priv,
- 			       uint32_t mask);
- extern void hsw_enable_pc8_work(struct work_struct *__work);
- extern void hsw_enable_package_c8(struct drm_i915_private *dev_priv);
- extern void hsw_disable_package_c8(struct drm_i915_private *dev_priv);
- extern void hsw_pc8_disable_interrupts(struct drm_device *dev);
- extern void hsw_pc8_restore_interrupts(struct drm_device *dev);
- extern void intel_aux_display_runtime_get(struct drm_i915_private *dev_priv);
- extern void intel_aux_display_runtime_put(struct drm_i915_private *dev_priv);
- extern void intel_dp_get_m_n(struct intel_crtc *crtc,
- 			     struct intel_crtc_config *pipe_config);
- extern int intel_dotclock_calculate(int link_freq,
- 				    const struct intel_link_m_n *m_n);
- extern void ironlake_check_encoder_dotclock(const struct intel_crtc_config *pipe_config,
- 					    int dotclock);
  
- extern bool intel_crtc_active(struct drm_crtc *crtc);
+ /* intel_sdvo.c */
+ bool intel_sdvo_init(struct drm_device *dev, uint32_t sdvo_reg, bool is_sdvob);
+ 
+ 
+ /* intel_sprite.c */
+ int intel_plane_init(struct drm_device *dev, enum pipe pipe, int plane);
+ void intel_flush_primary_plane(struct drm_i915_private *dev_priv,
+ 			       enum plane plane);
+ void intel_plane_restore(struct drm_plane *plane);
+ void intel_plane_disable(struct drm_plane *plane);
+ int intel_sprite_set_colorkey(struct drm_device *dev, void *data,
+ 			      struct drm_file *file_priv);
+ int intel_sprite_get_colorkey(struct drm_device *dev, void *data,
+ 			      struct drm_file *file_priv);
+ 
++bool intel_crtc_active(struct drm_crtc *crtc);
+ 
+ /* intel_tv.c */
+ void intel_tv_init(struct drm_device *dev);
  
  #endif /* __INTEL_DRV_H__ */
