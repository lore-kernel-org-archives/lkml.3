Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaJXGP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:15:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:17389 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbaJXGPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="619636737"
From: Kweh Hock Leong <hock.leong.kweh@intel.com>
To: Matt Fleming <matt.fleming@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>
Subject: [PATCH v1 1/3] firmware loader: Introduce new API - request_firmware_abort()
Date: Fri, 24 Oct 2014 14:18:20 +0800
Message-Id: <1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Besides aborting through user helper interface, a new API
request_firmware_abort() allows kernel driver module to abort the
request_firmware() / request_firmware_nowait() when they are no
longer needed. It is useful for cancelling an outstanding firmware
load if initiated from inside a module where that module is in the
process of being unloaded, since the unload function may not have
a handle to the struct firmware_buf.

Note for people who use request_firmware_nowait():
You are required to do your own synchronization after you call
request_firmware_abort() in order to continue unloading the
module. The example synchronization code shows below:

while (THIS_MODULE && module_refcount(THIS_MODULE))
	msleep(20);

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 drivers/base/firmware_class.c |   30 ++++++++++++++++++++++++++++++
 include/linux/firmware.h      |    4 ++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33..b2fe40b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1291,6 +1291,36 @@ request_firmware_nowait(
 }
 EXPORT_SYMBOL(request_firmware_nowait);
 
+/**
+ * request_firmware_abort - abort the waiting of firmware request
+ * @fw_name: name of firmware file
+ *
+ *	@fw_name is the same name string while calling to request_firmware()
+ *		or request_firmware_nowait().
+ **/
+int request_firmware_abort(const char *fw_name)
+{
+	struct firmware_buf *buf;
+	struct firmware_buf *entry;
+
+	spin_lock(&fw_cache.lock);
+	buf = __fw_lookup_buf(fw_name);
+	spin_unlock(&fw_cache.lock);
+	if (!buf)
+		return -ENOENT;
+
+	mutex_lock(&fw_lock);
+	list_for_each_entry(entry, &pending_fw_head, pending_list) {
+		if (entry == buf) {
+			__fw_load_abort(buf);
+			break;
+		}
+	}
+	mutex_unlock(&fw_lock);
+	return 0;
+}
+EXPORT_SYMBOL(request_firmware_abort);
+
 #ifdef CONFIG_PM_SLEEP
 static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
 
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5952933..ed90c8b 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -47,6 +47,7 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 
 void release_firmware(const struct firmware *fw);
+int request_firmware_abort(const char *fw_name);
 #else
 static inline int request_firmware(const struct firmware **fw,
 				   const char *name,
@@ -66,6 +67,9 @@ static inline void release_firmware(const struct firmware *fw)
 {
 }
 
+static inline int request_firmware_abort(const char *fw_name)
+{
+}
 #endif
 
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-- 
1.7.9.5

