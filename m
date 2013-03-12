Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920Ab3CLXFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:05:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3CLWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 055/100] drm/i915: enable irqs earlier when resuming
Date: Tue, 12 Mar 2013 15:31:40 -0700
Message-Id: <20130312223128.903478508@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 15239099d7a7a9ecdc1ccb5b187ae4cda5488ff9 upstream.

We need it to restore the ilk rc6 context, since the gpu wait no
requires interrupts. But in general having interrupts around should
help in code sanity, since more and more stuff is interrupt driven.

This regression has been introduced in

commit 3e9605018ab3e333d51cc90fccfde2031886763b
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Nov 27 16:22:54 2012 +0000

    drm/i915: Rearrange code to only have a single method for waiting upon the ring

Like in the driver load code we need to make sure that hotplug
interrupts don't cause havoc with our modeset state, hence block them
with the existing infrastructure. Again we ignore races where we might
loose hotplug interrupts ...

Note that the driver load part of the regression has already been
fixed in

commit 52d7ecedac3f96fb562cb482c139015372728638
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sat Dec 1 21:03:22 2012 +0100

    drm/i915: reorder setup sequence to have irqs for output setup

v2: Add a note to the commit message about which patch fixed the
driver load part of the regression. Stable kernels need to backport
both patches.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=54691
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Reported-and-Tested-by: Ilya Tumaykin <itumaykin@gmail.com>
Reviewed-by: Chris wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -486,6 +486,7 @@ static int i915_drm_freeze(struct drm_de
 		intel_modeset_disable(dev);
 
 		drm_irq_uninstall(dev);
+		dev_priv->enable_hotplug_processing = false;
 	}
 
 	i915_save_state(dev);
@@ -562,9 +563,19 @@ static int __i915_drm_thaw(struct drm_de
 		error = i915_gem_init_hw(dev);
 		mutex_unlock(&dev->struct_mutex);
 
+		/* We need working interrupts for modeset enabling ... */
+		drm_irq_install(dev);
+
 		intel_modeset_init_hw(dev);
 		intel_modeset_setup_hw_state(dev, false);
-		drm_irq_install(dev);
+
+		/*
+		 * ... but also need to make sure that hotplug processing
+		 * doesn't cause havoc. Like in the driver load code we don't
+		 * bother with the tiny race here where we might loose hotplug
+		 * notifications.
+		 * */
+		dev_priv->enable_hotplug_processing = true;
 	}
 
 	intel_opregion_init(dev);


