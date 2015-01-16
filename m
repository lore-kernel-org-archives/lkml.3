Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbbAPXdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:33:39 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:60048 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbbAPXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:28 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 3/8] driver-core: add driver module asynchronous probe support
Date: Fri, 16 Jan 2015 15:33:12 -0800
Message-Id: <1421451197-19723-4-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <mcgrof@suse.com>

Some init systems may wish to express the desire to have device drivers
run their probe() code asynchronously. This implements support for this
and allows userspace to request async probe as a preference through a
generic shared device driver module parameter, async_probe.

Implementation for async probe is supported through a module parameter
given that since synchronous probe has been prevalent for years some
userspace might exist which relies on the fact that the device driver
will probe synchronously and the assumption that devices it provides
will be immediately available after this.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/kernel-parameters.txt |  3 +++
 drivers/base/dd.c                   |  8 +++++++-
 include/linux/device.h              |  8 +++++---
 include/linux/module.h              |  2 ++
 kernel/module.c                     | 12 ++++++++++--
 5 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 176d4fe..af034a2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -928,6 +928,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Enable debug messages at boot time.  See
 			Documentation/dynamic-debug-howto.txt for details.
 
+	module.async_probe [KNL]
+			Enable asynchronous probe on this module.
+
 	early_ioremap_debug [KNL]
 			Enable debug messages in early_ioremap support. This
 			is useful for tracking down temporary early mappings
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f9f4831..b3ec0aa 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -404,7 +404,13 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 
 bool driver_allows_async_probing(struct device_driver *drv)
 {
-	return drv->probe_type == PROBE_PREFER_ASYNCHRONOUS;
+	if (drv->probe_type == PROBE_PREFER_ASYNCHRONOUS)
+		return true;
+
+	if (drv->owner && drv->owner->async_probe_requested)
+		return true;
+
+	return false;
 }
 
 struct device_attach_data {
diff --git a/include/linux/device.h b/include/linux/device.h
index 9ace4c0..ae5a165 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -200,16 +200,18 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
   *	respective probe routines. This tells the core what to
   *	expect and prefer.
   *
-  * @PROBE_SYNCHRONOUS: Default. Drivers expect their probe routines
+  * @PROBE_DEFAULT_STRATEGY: Drivers expect their probe routines
   *	to run synchronously with driver and device registration
   *	(with the exception of -EPROBE_DEFER handling - re-probing
-  *	always ends up being done asynchronously).
+  *	always ends up being done asynchronously) unless user
+  *	explicitly requested asynchronous probing via module
+  *	parameter.
   * @PROBE_PREFER_ASYNCHRONOUS: Drivers for "slow" devices which
   *	probing order is not essential for booting the system may
   *	opt into executing their probes asynchronously.
   */
 enum probe_type {
-	PROBE_SYNCHRONOUS,
+	PROBE_DEFAULT_STRATEGY,
 	PROBE_PREFER_ASYNCHRONOUS,
 };
 
diff --git a/include/linux/module.h b/include/linux/module.h
index ebfb0e1..2b70e71 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -257,6 +257,8 @@ struct module {
 	bool sig_ok;
 #endif
 
+	bool async_probe_requested;
+
 	/* symbols that will be GPL-only in the near future. */
 	const struct kernel_symbol *gpl_future_syms;
 	const unsigned long *gpl_future_crcs;
diff --git a/kernel/module.c b/kernel/module.c
index f5b28b6..80639fa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3042,7 +3042,7 @@ static int do_init_module(struct module *mod)
 	 *
 	 * http://thread.gmane.org/gmane.linux.kernel/1420814
 	 */
-	if (current->flags & PF_USED_ASYNC)
+	if (!mod->async_probe_requested && (current->flags & PF_USED_ASYNC))
 		async_synchronize_full();
 
 	mutex_lock(&module_mutex);
@@ -3181,8 +3181,16 @@ out:
 static int unknown_module_param_cb(char *param, char *val, const char *modname,
 				   void *arg)
 {
+	struct module *mod = arg;
+	int ret;
+
+	if (strcmp(param, "async_probe") == 0) {
+		mod->async_probe_requested = true;
+		return 0;
+	}
+
 	/* Check for magic 'dyndbg' arg */
-	int ret = ddebug_dyndbg_module_param_cb(param, val, modname);
+	ret = ddebug_dyndbg_module_param_cb(param, val, modname);
 	if (ret != 0)
 		pr_warn("%s: unknown parameter '%s' ignored\n", modname, param);
 	return 0;
-- 
2.2.0.rc0.207.ga3a616c

