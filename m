Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbbAPXee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:34:34 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33677 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbAPXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:38 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 8/8] driver-core: allow forcing async probing for modules and builtins
Date: Fri, 16 Jan 2015 15:33:17 -0800
Message-Id: <1421451197-19723-9-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <mcgrof@suse.com>

Folks wishing to test enabling async probe for all built-in drivers
and/or for all modules can enable
__DEBUG__kernel_force_builtin_async_probe or
__DEBUG__kernel_force_modules_async_probe kernel parameters.

Using either one will taint your kernel.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
[Dmitry: split off from another patch, split into 2 parameters, moved
over to core_param_unsafe()]
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/kernel-parameters.txt | 10 ++++++++++
 drivers/base/dd.c                   | 13 +++++++++----
 kernel/module.c                     |  7 +++++++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index af034a2..b09c4ac 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -931,6 +931,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	module.async_probe [KNL]
 			Enable asynchronous probe on this module.
 
+	__DEBUG__kernel_force_builtin_async_probe [KNL]
+			Enable asynchronous probe on all built-in drivers.
+			This is is testing parameter and using it will taint
+			your kernel.
+
+	__DEBUG__kernel_force_modules_async_probe [KNL]
+			Enable asynchronous probe on all modules. This is
+			is testing parameter and using it will taint your
+			kernel.
+
 	early_ioremap_debug [KNL]
 			Enable debug messages in early_ioremap support. This
 			is useful for tracking down temporary early mappings
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1308e08..4d00734 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/async.h>
@@ -402,6 +403,10 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 	return ret;
 }
 
+static bool force_builtin_async_probe;
+core_param_unsafe(__DEBUG__kernel_force_builtin_async_probe,
+		  force_builtin_async_probe, bool, 0644);
+
 bool driver_allows_async_probing(struct device_driver *drv)
 {
 	switch (drv->probe_type) {
@@ -412,10 +417,10 @@ bool driver_allows_async_probing(struct device_driver *drv)
 		return false;
 
 	default:
-		if (drv->owner && drv->owner->async_probe_requested)
-			return true;
-
-		return false;
+		if (drv->owner)
+			return drv->owner->async_probe_requested;
+		else
+			return force_builtin_async_probe;
 	}
 }
 
diff --git a/kernel/module.c b/kernel/module.c
index 80639fa..8d667ef 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3196,6 +3196,10 @@ static int unknown_module_param_cb(char *param, char *val, const char *modname,
 	return 0;
 }
 
+static bool force_modules_async_probe;
+core_param_unsafe(__DEBUG__kernel_force_modules_async_probe,
+		  force_modules_async_probe, bool, 0644);
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static int load_module(struct load_info *info, const char __user *uargs,
@@ -3290,6 +3294,9 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err)
 		goto ddebug_cleanup;
 
+	if (force_modules_async_probe)
+		mod->async_probe_requested = true;
+
 	/* Module is ready to execute: parsing args may do that. */
 	after_dashes = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
 				  -32768, 32767, NULL,
-- 
2.2.0.rc0.207.ga3a616c

