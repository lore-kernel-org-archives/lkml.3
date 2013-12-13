Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3LMWup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:50:45 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60025 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3LMW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:10 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 004/115] ion: Add reserve function to ion
Date: Fri, 13 Dec 2013 14:23:38 -0800
Message-Id: <1386973529-4884-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Rather than requiring each platform call memblock_remove or reserve
from the board file, add this to ion

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 17 +++++++++++++++++
 drivers/staging/android/ion/ion.h | 11 +++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index bca8d9e..004c0d4 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/list.h>
+#include <linux/memblock.h>
 #include <linux/miscdevice.h>
 #include <linux/export.h>
 #include <linux/mm.h>
@@ -1185,3 +1186,19 @@ void ion_device_destroy(struct ion_device *dev)
 	/* XXX need to free the heaps and clients ? */
 	kfree(dev);
 }
+
+void __init ion_reserve(struct ion_platform_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < data->nr; i++) {
+		if (data->heaps[i].size == 0)
+			continue;
+		ret = memblock_reserve(data->heaps[i].base,
+				       data->heaps[i].size);
+		if (ret)
+			pr_err("memblock reserve of %x@%lx failed\n",
+			       data->heaps[i].size,
+			       data->heaps[i].base);
+	}
+}
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 87f6a45..4e012b8 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -87,6 +87,17 @@ struct ion_platform_data {
 };
 
 /**
+ * ion_reserve() - reserve memory for ion heaps if applicable
+ * @data:	platform data specifying starting physical address and
+ *		size
+ *
+ * Calls memblock reserve to set aside memory for heaps that are
+ * located at specific memory addresses or of specfic sizes not
+ * managed by the kernel
+ */
+void ion_reserve(struct ion_platform_data *data);
+
+/**
  * ion_client_create() -  allocate a client and returns it
  * @dev:	the global ion device
  * @heap_mask:	mask of heaps this client can allocate from
-- 
1.8.3.2

