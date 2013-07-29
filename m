Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3G2VE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:04:59 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:61767 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755284Ab3G2VE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:04:57 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Mon, 29 Jul 2013 22:04:29 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        daniel.vetter@ffwll.ch, airlied@redhat.com,
        Ben Widawsky <ben@bwidawsk.net>
Subject: Re: i915 debug spew during boot.
Message-ID: <20130729210429.GB27041@cantiga.alporthouse.com>
References: <20130729195431.GA3540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729195431.GA3540@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 03:54:31PM -0400, Dave Jones wrote:
> [    7.542156]  [<ffffffff81079973>] cancel_delayed_work_sync+0x13/0x20
> [    7.543020]  [<ffffffff814846ed>] intel_disable_gt_powersave+0x5d/0x420
> [    7.543915]  [<ffffffff81486409>] intel_gt_sanitize+0x49/0xb0
> [    7.544708]  [<ffffffff81435228>] i915_driver_load+0x608/0xe60

Whoops, we spotted that error and fixed it in the next tree, but forgot
to send a fix for stable as well.

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index b152068..0c17977 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1594,6 +1594,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	intel_detect_pch(dev);
 
 	intel_irq_init(dev);
+	intel_pm_init(dev);
 	intel_gt_sanitize(dev);
 	intel_gt_init(dev);
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index d2ee334..70c3549 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1583,6 +1583,7 @@ void i915_handle_error(struct drm_device *dev, bool wedged);
 
 extern void intel_irq_init(struct drm_device *dev);
 extern void intel_hpd_init(struct drm_device *dev);
+extern void intel_pm_init(struct drm_device *dev);
 extern void intel_gt_init(struct drm_device *dev);
 extern void intel_gt_sanitize(struct drm_device *dev);
 
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 51a2a60..1235d71 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5536,6 +5536,10 @@ void intel_gt_init(struct drm_device *dev)
 		dev_priv->gt.force_wake_get = __gen6_gt_force_wake_get;
 		dev_priv->gt.force_wake_put = __gen6_gt_force_wake_put;
 	}
+}
+
+void intel_pm_init(struct drm_device *dev)
+{
 	INIT_DELAYED_WORK(&dev_priv->rps.delayed_resume_work,
 			  intel_gen6_powersave_work);
 }

-- 
Chris Wilson, Intel Open Source Technology Centre
