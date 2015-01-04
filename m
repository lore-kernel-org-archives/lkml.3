Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbbADHP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:15:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:16528 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbbADHP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:15:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,694,1413270000"; 
   d="scan'208";a="646039962"
From: Feng Tang <feng.tang@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>
Cc: Colin Cross <ccross@android.com>, Heesub Shin <heesub.shin@samsung.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id function
Date: Sun,  4 Jan 2015 15:11:51 +0800
Message-Id: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is user case that user only knows the ion_handle idand
needs to get the physical addr and len. So add this wrapper to
meet this requirement.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/staging/android/ion/ion.c |   16 ++++++++++++++++
 drivers/staging/android/ion/ion.h |   14 ++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 296d347..3d378ef 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -577,6 +577,22 @@ int ion_phys(struct ion_client *client, struct ion_handle *handle,
 }
 EXPORT_SYMBOL(ion_phys);
 
+int ion_phys_get_by_id(struct ion_client *client, int id,
+	     ion_phys_addr_t *addr, size_t *len)
+{
+	struct ion_handle *handle;
+	int ret;
+
+	handle = ion_handle_get_by_id(client, id);
+	if (!handle)
+		return -EINVAL;
+
+	ret = ion_phys(client, handle, addr, len);
+	ion_handle_put(handle);
+	return ret;
+}
+EXPORT_SYMBOL(ion_phys_get_by_id);
+
 static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 {
 	void *vaddr;
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 443db84..9ef0f18 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -147,6 +147,20 @@ int ion_phys(struct ion_client *client, struct ion_handle *handle,
 	     ion_phys_addr_t *addr, size_t *len);
 
 /**
+ * ion_phys_get_by_id - returns the physical address and len of a handle
+ * @client:	the client
+ * @id:		id bound to ion_handle, which may be passed to user space
+ * @addr:	a pointer to put the address in
+ * @len:	a pointer to put the length in
+ *
+ * This function will first get ion_handle from the id, and then
+ * use upper ion_phys() to get the physical and len.
+ */
+
+int ion_phys_get_by_id(struct ion_client *client, int id,
+	     ion_phys_addr_t *addr, size_t *len);
+
+/**
  * ion_map_dma - return an sg_table describing a handle
  * @client:	the client
  * @handle:	the handle
-- 
1.7.9.5

