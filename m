Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbbAPXdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:33:41 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64671 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbAPXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:30 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4/8] driver-core: enable drivers to opt-out of async probe
Date: Fri, 16 Jan 2015 15:33:13 -0800
Message-Id: <1421451197-19723-5-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <mcgrof@suse.com>

Some drivers do not work well when their probes are run asynchronously.
Usually it is because driver bug or not optimal driver organization.
Until they are all fixed properly let's allow them opt out of
asynchronous probing.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/base/dd.c      | 14 ++++++++++----
 include/linux/device.h | 15 +++++++++------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index b3ec0aa..1308e08 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -404,13 +404,19 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 
 bool driver_allows_async_probing(struct device_driver *drv)
 {
-	if (drv->probe_type == PROBE_PREFER_ASYNCHRONOUS)
+	switch (drv->probe_type) {
+	case PROBE_PREFER_ASYNCHRONOUS:
 		return true;
 
-	if (drv->owner && drv->owner->async_probe_requested)
-		return true;
+	case PROBE_FORCE_SYNCHRONOUS:
+		return false;
+
+	default:
+		if (drv->owner && drv->owner->async_probe_requested)
+			return true;
 
-	return false;
+		return false;
+	}
 }
 
 struct device_attach_data {
diff --git a/include/linux/device.h b/include/linux/device.h
index ae5a165..a17e46f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -200,19 +200,21 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
   *	respective probe routines. This tells the core what to
   *	expect and prefer.
   *
-  * @PROBE_DEFAULT_STRATEGY: Drivers expect their probe routines
-  *	to run synchronously with driver and device registration
-  *	(with the exception of -EPROBE_DEFER handling - re-probing
-  *	always ends up being done asynchronously) unless user
-  *	explicitly requested asynchronous probing via module
-  *	parameter.
+  * @PROBE_DEFAULT_STRATEGY: Used by drivers that are normally probed
+  *	synchronously, but work just as fine when probed asynchronously
+  *	when user requests it via module parameter.
   * @PROBE_PREFER_ASYNCHRONOUS: Drivers for "slow" devices which
   *	probing order is not essential for booting the system may
   *	opt into executing their probes asynchronously.
+  * @PROBE_FORCE_SYNCHRONOUS: Use this to annotate drivers that need
+  *	their probe routines to run synchronously with driver and
+  *	device registration (with the exception of -EPROBE_DEFER
+  *	handling - re-probing always ends up being done asynchronously).
   */
 enum probe_type {
 	PROBE_DEFAULT_STRATEGY,
 	PROBE_PREFER_ASYNCHRONOUS,
+	PROBE_FORCE_SYNCHRONOUS,
 };
 
 /**
@@ -222,6 +224,7 @@ enum probe_type {
  * @owner:	The module owner.
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @probe_type: type of probe to use
  * @of_match_table: The open firmware table.
  * @acpi_match_table: The ACPI match table.
  * @probe:	Called to query the existence of a specific device,
-- 
2.2.0.rc0.207.ga3a616c

