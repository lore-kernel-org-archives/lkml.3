Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaCEJd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:33:27 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64968 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaCEJdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:33:23 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] Taint the kernel for unsafe module options
Date: Wed,  5 Mar 2014 10:33:14 +0100
Message-Id: <1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users just love to set random piles of options since surely enabling
all the experimental stuff helps. Later on we get bug reports because
it all fell apart.

Even more fun when it's labelled a regression when some change only
just made the feature possible (e.g. stolen memory fixes suddenly
making fbc possible).

Make it clear that users are playing with fire here. In drm/i915 all
these options follow the same pattern of using -1 as the per-machine
default, and any other value being used for force the parameter.

Adding a pile of cc's to solicit input and figure out whether this
would be generally useful - this quick rfc is just for drm/i915.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org
References: https://bugzilla.kernel.org/show_bug.cgi?id=71391
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_params.c | 49 ++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
index 3b482585c5ae..9cb89adeabcd 100644
--- a/drivers/gpu/drm/i915/i915_params.c
+++ b/drivers/gpu/drm/i915/i915_params.c
@@ -50,7 +50,46 @@ struct i915_params i915 __read_mostly = {
 	.disable_display = 0,
 };
 
-module_param_named(modeset, i915.modeset, int, 0400);
+int param_set_unsafe_int(const char *val, const struct kernel_param *kp)
+{
+	long l;
+	int ret;
+
+	ret = kstrtol(val, 0, &l);
+	if (ret < 0 || ((int)l != l))
+		return ret < 0 ? ret : -EINVAL;
+
+	/* Taint if userspace overrides the kernel defaults. */
+	if (l != -1) {
+		printk(KERN_WARNING "Setting dangerous option %s to non-default value!\n",
+		       kp->name);
+		add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+	}
+
+	*((int *)kp->arg) = l;
+	return 0;
+}
+
+struct kernel_param_ops param_ops_unsafe_int = {
+	.set = param_set_unsafe_int,
+	.get = param_get_int,
+};
+/**
+ * module_param_unsafe_int_named - integer module param which taints the kernel
+ * @name: a valid C identifier which is the parameter name.
+ * @value: the actual lvalue to alter.
+ * @perm: visibility in sysfs.
+ *
+ * This is a special integer module parameter. The default is assumed to be -1,
+ * if any other values are set this will taint the kernel. Useful for debug and
+ * other dangerous options which users really shouldn't set normally.
+ */
+#define module_param_unsafe_int_named(name, value, perm)		\
+	param_check_int(name, &(value));				\
+	module_param_cb(name, &param_ops_unsafe_int, &value, perm);	\
+	__MODULE_PARM_TYPE(name, "int")
+
+module_param_unsafe_int_named(modeset, i915.modeset, 0400);
 MODULE_PARM_DESC(modeset,
 	"Use kernel modesetting [KMS] (0=DRM_I915_KMS from .config, "
 	"1=on, -1=force vga console preference [default])");
@@ -64,12 +103,12 @@ module_param_named(powersave, i915.powersave, int, 0600);
 MODULE_PARM_DESC(powersave,
 	"Enable powersavings, fbc, downclocking, etc. (default: true)");
 
-module_param_named(semaphores, i915.semaphores, int, 0400);
+module_param_unsafe_int_named(semaphores, i915.semaphores, 0400);
 MODULE_PARM_DESC(semaphores,
 	"Use semaphores for inter-ring sync "
 	"(default: -1 (use per-chip defaults))");
 
-module_param_named(enable_rc6, i915.enable_rc6, int, 0400);
+module_param_unsafe_int_named(enable_rc6, i915.enable_rc6, 0400);
 MODULE_PARM_DESC(enable_rc6,
 	"Enable power-saving render C-state 6. "
 	"Different stages can be selected via bitmask values "
@@ -77,7 +116,7 @@ MODULE_PARM_DESC(enable_rc6,
 	"For example, 3 would enable rc6 and deep rc6, and 7 would enable everything. "
 	"default: -1 (use per-chip default)");
 
-module_param_named(enable_fbc, i915.enable_fbc, int, 0600);
+module_param_unsafe_int_named(enable_fbc, i915.enable_fbc, 0600);
 MODULE_PARM_DESC(enable_fbc,
 	"Enable frame buffer compression for power savings "
 	"(default: -1 (use per-chip default))");
@@ -111,7 +150,7 @@ MODULE_PARM_DESC(enable_hangcheck,
 	"WARNING: Disabling this can cause system wide hangs. "
 	"(default: true)");
 
-module_param_named(enable_ppgtt, i915.enable_ppgtt, int, 0400);
+module_param_unsafe_int_named(enable_ppgtt, i915.enable_ppgtt, 0400);
 MODULE_PARM_DESC(enable_ppgtt,
 	"Override PPGTT usage. "
 	"(-1=auto [default], 0=disabled, 1=aliasing, 2=full)");
-- 
1.8.5.2

