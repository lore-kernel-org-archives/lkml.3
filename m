Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3IHQAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:00:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3IHP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:47 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=itgFbhsqU78A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1w0UDUdmRhAA:10 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=KfcAlyQ9hwRfQHvsVqoA:9 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151447.241176823@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:14:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 09/19] gpu: i915: allow the user not to do the wbinvd
References: <20130908151355.362583092@goodmis.org>
Content-Disposition: inline; filename=0009-gpu-i915-allow-the-user-not-to-do-the-wbinvd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The wbinvd() renders the system with i915 unusable on RT. Using this
expensive instruction avoids GPU trouble according to
   https://bugs.freedesktop.org/show_bug.cgi?id=62191

As a workaround for RT it is recommended to pin each GPU related process
to the same CPU and then disable this instruction via the module
paramter.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpu/drm/i915/i915_gem.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 18da42c..a3f72cb 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -36,6 +36,7 @@
 #include <linux/swap.h>
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
+#include <linux/module.h>
 
 static __must_check int i915_gem_object_flush_gpu_write_domain(struct drm_i915_gem_object *obj);
 static void i915_gem_object_flush_gtt_write_domain(struct drm_i915_gem_object *obj);
@@ -2525,6 +2526,10 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
+static bool do_wbinvd = true;
+module_param(do_wbinvd, bool, 0644);
+MODULE_PARM_DESC(do_wbinvd, "Do expensive synchronization. Say no after you pin each GPU process to the same CPU in order to lower the latency.");
+
 static void i915_gem_write_fence__ipi(void *data)
 {
 	wbinvd();
@@ -2548,8 +2553,16 @@ static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 	 * on each processor in order to manually flush all memory
 	 * transactions before updating the fence register.
 	 */
-	if (HAS_LLC(obj->base.dev))
-		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+	if (HAS_LLC(obj->base.dev)) {
+		if (do_wbinvd) {
+#ifdef CONFIG_PREEMPT_RT_FULL
+			pr_err_once("WARNING! The i915 invalidates all caches which increases the latency.");
+			pr_err_once("As a workaround use 'i915.do_wbinvd=no' and PIN each process doing ");
+			pr_err_once("any kind of GPU activity to the same CPU to avoid problems.");
+#endif
+			on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+		}
+	}
 	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
 
 	if (enable) {
-- 
1.7.10.4


