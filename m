Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3BDX67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:58:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:42175 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab3BDX65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:58:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="282754436"
Message-ID: <1360022332.2249.1.camel@rzhang1-mobl4>
Subject: Re: [Intel-gfx] [PATCH V2 3/3] i915: ignore lid open event when
 resuming
From: Zhang Rui <rui.zhang@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        rjw@sisk.pl, lenb@kernel.org
Date: Tue, 05 Feb 2013 07:58:52 +0800
In-Reply-To: <20130204152500.GF5843@phenom.ffwll.local>
References: <1359961811-978-1-git-send-email-rui.zhang@intel.com>
	 <1359961811-978-3-git-send-email-rui.zhang@intel.com>
	 <20130204152500.GF5843@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 16:25 +0100, Daniel Vetter wrote:
> On Mon, Feb 04, 2013 at 03:10:11PM +0800, Zhang Rui wrote:
> > i915 driver needs to do modeset when
> > 1. system resumes from sleep
> > 2. lid is opened
> > 
> > In PM_SUSPEND_MEM state, all the GPEs are cleared when system resumes,
> > thus it is the i915_resume code does the modeset rather than intel_lid_notify().
> > 
> > But in PM_SUSPEND_FREEZE state, this will be broken because
> > system is still responsive to the lid events.
> > 1. When we close the lid in Freeze state, intel_lid_notify() sets modeset_on_lid.
> > 2. When we reopen the lid, intel_lid_notify() will do a modeset,
> >    before the system is resumed.
> > here is the error log,
> > 
> > [92146.548074] WARNING: at drivers/gpu/drm/i915/intel_display.c:1028 intel_wait_for_pipe_off+0x184/0x190 [i915]()
> > [92146.548076] Hardware name: VGN-Z540N
> > [92146.548078] pipe_off wait timed out
> > [92146.548167] Modules linked in: hid_generic usbhid hid snd_hda_codec_realtek snd_hda_intel snd_hda_codec parport_pc snd_hwdep ppdev snd_pcm_oss i915 snd_mixer_oss snd_pcm arc4 iwldvm snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi fbcon tileblit font bitblit softcursor drm_kms_helper snd_rawmidi snd_seq_midi_event coretemp drm snd_seq kvm btusb bluetooth snd_timer iwlwifi pcmcia tpm_infineon i2c_algo_bit joydev snd_seq_device intel_agp cfg80211 snd intel_gtt yenta_socket pcmcia_rsrc sony_laptop agpgart microcode psmouse tpm_tis serio_raw mxm_wmi soundcore snd_page_alloc tpm acpi_cpufreq lpc_ich pcmcia_core tpm_bios mperf processor lp parport firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci thermal e1000e
> > [92146.548173] Pid: 4304, comm: kworker/0:0 Tainted: G        W    3.8.0-rc3-s0i3-v3-test+ #9
> > [92146.548175] Call Trace:
> > [92146.548189]  [<c10378e2>] warn_slowpath_common+0x72/0xa0
> > [92146.548227]  [<f86398b4>] ? intel_wait_for_pipe_off+0x184/0x190 [i915]
> > [92146.548263]  [<f86398b4>] ? intel_wait_for_pipe_off+0x184/0x190 [i915]
> > [92146.548270]  [<c10379b3>] warn_slowpath_fmt+0x33/0x40
> > [92146.548307]  [<f86398b4>] intel_wait_for_pipe_off+0x184/0x190 [i915]
> > [92146.548344]  [<f86399c2>] intel_disable_pipe+0x102/0x190 [i915]
> > [92146.548380]  [<f8639ea4>] ? intel_disable_plane+0x64/0x80 [i915]
> > [92146.548417]  [<f8639f7c>] i9xx_crtc_disable+0xbc/0x150 [i915]
> > [92146.548456]  [<f863ebee>] intel_crtc_update_dpms+0x5e/0x90 [i915]
> > [92146.548493]  [<f86437cf>] intel_modeset_setup_hw_state+0x42f/0x8f0 [i915]
> > [92146.548535]  [<f8645b0b>] intel_lid_notify+0x9b/0xc0 [i915]
> > [92146.548543]  [<c15610d3>] notifier_call_chain+0x43/0x60
> > [92146.548550]  [<c105d1e1>] __blocking_notifier_call_chain+0x41/0x80
> > [92146.548556]  [<c105d23f>] blocking_notifier_call_chain+0x1f/0x30
> > [92146.548563]  [<c131a684>] acpi_lid_send_state+0x78/0xa4
> > [92146.548569]  [<c131aa9e>] acpi_button_notify+0x3b/0xf1
> > [92146.548577]  [<c12df56a>] ? acpi_os_execute+0x17/0x19
> > [92146.548582]  [<c12e591a>] ? acpi_ec_sync_query+0xa5/0xbc
> > [92146.548589]  [<c12e2b82>] acpi_device_notify+0x16/0x18
> > [92146.548595]  [<c12f4904>] acpi_ev_notify_dispatch+0x38/0x4f
> > [92146.548600]  [<c12df0e8>] acpi_os_execute_deferred+0x20/0x2b
> > [92146.548607]  [<c1051208>] process_one_work+0x128/0x3f0
> > [92146.548613]  [<c1564f73>] ? common_interrupt+0x33/0x38
> > [92146.548618]  [<c104f8c0>] ? wake_up_worker+0x30/0x30
> > [92146.548624]  [<c12df0c8>] ? acpi_os_wait_events_complete+0x1e/0x1e
> > [92146.548629]  [<c10524f9>] worker_thread+0x119/0x3b0
> > [92146.548634]  [<c10523e0>] ? manage_workers+0x240/0x240
> > [92146.548640]  [<c1056e84>] kthread+0x94/0xa0
> > [92146.548647]  [<c1060000>] ? ftrace_raw_output_sched_stat_runtime+0x70/0xf0
> > [92146.548652]  [<c15649b7>] ret_from_kernel_thread+0x1b/0x28
> > [92146.548658]  [<c1056df0>] ? kthread_create_on_node+0xc0/0xc0
> > 
> > three different modeset flags are introduced in this patch
> > MODESET_ON_LID: do modeset on next lid open event
> > MODESET_DONE:  modeset already done
> > MODESET_ON_RESUME:  do modeset when system is resumed
> > 
> > In this way,
> > 1. when lid is closed, MODESET_ON_LID is set so that
> >    we'll do modeset on next lid open event.
> > 2. when lid is opened, MODESET_DONE is set
> >    so that duplicate lid open events will be ignored.
> > 3. when system suspends, MODESET_ON_RESUME is set.
> >    In this case, we will not do modeset on any lid events.
> > 
> > Plus, locking mechanism is also introduced to avoid racing.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> Looks nice, two tiny bikesheds below.
> 
Great, thanks for reviewing. Refreshed patch attached.

>From 0d597b4859535c79ed545160cf4af9e6b5970e3c Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Thu, 24 Jan 2013 13:27:22 +0800
Subject: [PATCH V3 3/3] i915: ignore lid open event when resuming

i915 driver needs to do modeset when
1. system resumes from sleep
2. lid is opened

In PM_SUSPEND_MEM state, all the GPEs are cleared when system resumes,
thus it is the i915_resume code does the modeset rather than intel_lid_notify().

But in PM_SUSPEND_FREEZE state, this will be broken because
system is still responsive to the lid events.
1. When we close the lid in Freeze state, intel_lid_notify() sets modeset_on_lid.
2. When we reopen the lid, intel_lid_notify() will do a modeset,
   before the system is resumed.
here is the error log,

[92146.548074] WARNING: at drivers/gpu/drm/i915/intel_display.c:1028 intel_wait_for_pipe_off+0x184/0x190 [i915]()
[92146.548076] Hardware name: VGN-Z540N
[92146.548078] pipe_off wait timed out
[92146.548167] Modules linked in: hid_generic usbhid hid snd_hda_codec_realtek snd_hda_intel snd_hda_codec parport_pc snd_hwdep ppdev snd_pcm_oss i915 snd_mixer_oss snd_pcm arc4 iwldvm snd_seq_dummy mac80211 snd_seq_oss snd_seq_midi fbcon tileblit font bitblit softcursor drm_kms_helper snd_rawmidi snd_seq_midi_event coretemp drm snd_seq kvm btusb bluetooth snd_timer iwlwifi pcmcia tpm_infineon i2c_algo_bit joydev snd_seq_device intel_agp cfg80211 snd intel_gtt yenta_socket pcmcia_rsrc sony_laptop agpgart microcode psmouse tpm_tis serio_raw mxm_wmi soundcore snd_page_alloc tpm acpi_cpufreq lpc_ich pcmcia_core tpm_bios mperf processor lp parport firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci thermal e1000e
[92146.548173] Pid: 4304, comm: kworker/0:0 Tainted: G        W    3.8.0-rc3-s0i3-v3-test+ #9
[92146.548175] Call Trace:
[92146.548189]  [<c10378e2>] warn_slowpath_common+0x72/0xa0
[92146.548227]  [<f86398b4>] ? intel_wait_for_pipe_off+0x184/0x190 [i915]
[92146.548263]  [<f86398b4>] ? intel_wait_for_pipe_off+0x184/0x190 [i915]
[92146.548270]  [<c10379b3>] warn_slowpath_fmt+0x33/0x40
[92146.548307]  [<f86398b4>] intel_wait_for_pipe_off+0x184/0x190 [i915]
[92146.548344]  [<f86399c2>] intel_disable_pipe+0x102/0x190 [i915]
[92146.548380]  [<f8639ea4>] ? intel_disable_plane+0x64/0x80 [i915]
[92146.548417]  [<f8639f7c>] i9xx_crtc_disable+0xbc/0x150 [i915]
[92146.548456]  [<f863ebee>] intel_crtc_update_dpms+0x5e/0x90 [i915]
[92146.548493]  [<f86437cf>] intel_modeset_setup_hw_state+0x42f/0x8f0 [i915]
[92146.548535]  [<f8645b0b>] intel_lid_notify+0x9b/0xc0 [i915]
[92146.548543]  [<c15610d3>] notifier_call_chain+0x43/0x60
[92146.548550]  [<c105d1e1>] __blocking_notifier_call_chain+0x41/0x80
[92146.548556]  [<c105d23f>] blocking_notifier_call_chain+0x1f/0x30
[92146.548563]  [<c131a684>] acpi_lid_send_state+0x78/0xa4
[92146.548569]  [<c131aa9e>] acpi_button_notify+0x3b/0xf1
[92146.548577]  [<c12df56a>] ? acpi_os_execute+0x17/0x19
[92146.548582]  [<c12e591a>] ? acpi_ec_sync_query+0xa5/0xbc
[92146.548589]  [<c12e2b82>] acpi_device_notify+0x16/0x18
[92146.548595]  [<c12f4904>] acpi_ev_notify_dispatch+0x38/0x4f
[92146.548600]  [<c12df0e8>] acpi_os_execute_deferred+0x20/0x2b
[92146.548607]  [<c1051208>] process_one_work+0x128/0x3f0
[92146.548613]  [<c1564f73>] ? common_interrupt+0x33/0x38
[92146.548618]  [<c104f8c0>] ? wake_up_worker+0x30/0x30
[92146.548624]  [<c12df0c8>] ? acpi_os_wait_events_complete+0x1e/0x1e
[92146.548629]  [<c10524f9>] worker_thread+0x119/0x3b0
[92146.548634]  [<c10523e0>] ? manage_workers+0x240/0x240
[92146.548640]  [<c1056e84>] kthread+0x94/0xa0
[92146.548647]  [<c1060000>] ? ftrace_raw_output_sched_stat_runtime+0x70/0xf0
[92146.548652]  [<c15649b7>] ret_from_kernel_thread+0x1b/0x28
[92146.548658]  [<c1056df0>] ? kthread_create_on_node+0xc0/0xc0

three different modeset flags are introduced in this patch
MODESET_ON_LID: do modeset on next lid open event
MODESET_DONE:  modeset already done
MODESET_ON_RESUME:  do modeset when system is resumed

In this way,
1. when lid is closed, MODESET_ON_LID is set so that
   we'll do modeset on next lid open event.
2. when lid is opened, MODESET_DONE is set
   so that duplicate lid open events will be ignored.
3. when system suspends, MODESET_ON_RESUME is set.
   In this case, we will not do modeset on any lid events.

Plus, locking mechanism is also introduced to avoid racing.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/gpu/drm/i915/i915_dma.c   |    1 +
 drivers/gpu/drm/i915/i915_drv.c   |   14 +++++++++-----
 drivers/gpu/drm/i915/i915_drv.h   |   11 +++++++++--
 drivers/gpu/drm/i915/intel_lvds.c |   33 ++++++++++++++++++++-------------
 4 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 99daa89..a5115d8 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1585,6 +1585,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	spin_lock_init(&dev_priv->dpio_lock);
 
 	mutex_init(&dev_priv->rps.hw_lock);
+	mutex_init(&dev_priv->modeset_restore_lock);
 
 	if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
 		dev_priv->num_pipe = 3;
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 1172658..68c6048 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -468,6 +468,12 @@ static int i915_drm_freeze(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	/* ignore lid events during suspend */
+	mutex_lock(&dev_priv->modeset_restore_lock);
+	dev_priv->modeset_restore = MODESET_SUSPENDED;
+	mutex_unlock(&dev_priv->modeset_restore_lock);
+
+
 	drm_kms_helper_poll_disable(dev);
 
 	pci_save_state(dev->pdev);
@@ -492,9 +498,6 @@ static int i915_drm_freeze(struct drm_device *dev)
 
 	intel_opregion_fini(dev);
 
-	/* Modeset on resume, not lid events */
-	dev_priv->modeset_on_lid = 0;
-
 	console_lock();
 	intel_fbdev_set_suspend(dev, 1);
 	console_unlock();
@@ -569,8 +572,6 @@ static int __i915_drm_thaw(struct drm_device *dev)
 
 	intel_opregion_init(dev);
 
-	dev_priv->modeset_on_lid = 0;
-
 	/*
 	 * The console lock can be pretty contented on resume due
 	 * to all the printk activity.  Try to keep it out of the hot
@@ -583,6 +584,9 @@ static int __i915_drm_thaw(struct drm_device *dev)
 		schedule_work(&dev_priv->console_resume_work);
 	}
 
+	mutex_lock(&dev_priv->modeset_restore_lock);
+	dev_priv->modeset_restore = MODESET_DONE;
+	mutex_unlock(&dev_priv->modeset_restore_lock);
 	return error;
 }
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 12ab3bd..0fddad01 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -620,6 +620,12 @@ struct intel_l3_parity {
 	struct work_struct error_work;
 };
 
+enum modeset_restore {
+	MODESET_ON_LID_OPEN,
+	MODESET_DONE,
+	MODESET_SUSPENDED,
+};
+
 typedef struct drm_i915_private {
 	struct drm_device *dev;
 
@@ -750,9 +756,10 @@ typedef struct drm_i915_private {
 
 	unsigned long quirks;
 
-	/* Register state */
-	bool modeset_on_lid;
+	enum modeset_restore modeset_restore; 
+	struct mutex modeset_restore_lock;
 
+	/* Register state */
 	struct {
 		/** Bridge to intel-gtt-ko */
 		struct intel_gtt *gtt;
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 17aee74..2f55e9c 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -492,13 +492,14 @@ static const struct dmi_system_id intel_no_modeset_on_lid[] = {
 };
 
 /*
- * Lid events. Note the use of 'modeset_on_lid':
- *  - we set it on lid close, and reset it on open
+ * Lid events. Note the use of 'modeset':
+ *  - we set it to MODESET_ON_LID on lid close,
+ *    and set it to MODESET_DONE on open
  *  - we use it as a "only once" bit (ie we ignore
- *    duplicate events where it was already properly
- *    set/reset)
- *  - the suspend/resume paths will also set it to
- *    zero, since they restore the mode ("lid open").
+ *    duplicate events where it was already properly set)
+ *  - the suspend/resume paths will set it to
+ *    MODESET_ON_RESUME and ignore the lid open event,
+ *    because they restore the mode ("lid open").
  */
 static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
 			    void *unused)
@@ -512,6 +513,9 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
 	if (dev->switch_power_state != DRM_SWITCH_POWER_ON)
 		return NOTIFY_OK;
 
+	mutex_lock(&dev_priv->modeset_restore_lock);
+	if (dev_priv->modeset_restore == MODESET_SUSPENDED)
+		goto exit;
 	/*
 	 * check and update the status of LVDS connector after receiving
 	 * the LID nofication event.
@@ -520,21 +524,24 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
 
 	/* Don't force modeset on machines where it causes a GPU lockup */
 	if (dmi_check_system(intel_no_modeset_on_lid))
-		return NOTIFY_OK;
+		goto exit;
 	if (!acpi_lid_open()) {
-		dev_priv->modeset_on_lid = 1;
-		return NOTIFY_OK;
+		/* do modeset on next lid open event */
+		dev_priv->modeset_restore = MODESET_ON_LID_OPEN;
+		goto exit;
 	}
 
-	if (!dev_priv->modeset_on_lid)
-		return NOTIFY_OK;
-
-	dev_priv->modeset_on_lid = 0;
+	if (dev_priv->modeset_restore == MODESET_DONE)
+		goto exit;
 
 	mutex_lock(&dev->mode_config.mutex);
 	intel_modeset_setup_hw_state(dev, true);
 	mutex_unlock(&dev->mode_config.mutex);
 
+	dev_priv->modeset_restore = MODESET_DONE;
+
+exit:
+	mutex_unlock(&dev_priv->modeset_restore_lock);
 	return NOTIFY_OK;
 }
 
-- 
1.7.9.5



