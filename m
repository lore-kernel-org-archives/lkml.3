Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3KVRaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:30:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42873 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab3KVRat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:30:49 -0500
From: Olav Haugan <ohaugan@codeaurora.org>
To: gregkh@linuxfoundation.org
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org, Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH v3 1/1] staging: zsmalloc: Ensure handle is never 0 on success
Date: Fri, 22 Nov 2013 09:30:41 -0800
Message-Id: <1385141441-16446-2-git-send-email-ohaugan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1385141441-16446-1-git-send-email-ohaugan@codeaurora.org>
References: <1385141441-16446-1-git-send-email-ohaugan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zsmalloc encodes a handle using the pfn and an object
index. On hardware platforms with physical memory starting
at 0x0 the pfn can be 0. This causes the encoded handle to be
0 and is incorrectly interpreted as an allocation failure.

This issue affects all current and future SoCs with physical
memory starting at 0x0. All MSM8974 SoCs which includes
Google Nexus 5 devices are affected.

To prevent this false error we ensure that the encoded handle
will not be 0 when allocation succeeds.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 1a67537..3b950e5 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -430,7 +430,12 @@ static struct page *get_next_page(struct page *page)
 	return next;
 }
 
-/* Encode <page, obj_idx> as a single handle value */
+/*
+ * Encode <page, obj_idx> as a single handle value.
+ * On hardware platforms with physical memory starting at 0x0 the pfn
+ * could be 0 so we ensure that the handle will never be 0 by adjusting the
+ * encoded obj_idx value before encoding.
+ */
 static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
 {
 	unsigned long handle;
@@ -441,17 +446,21 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
 	}
 
 	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-	handle |= (obj_idx & OBJ_INDEX_MASK);
+	handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
 
 	return (void *)handle;
 }
 
-/* Decode <page, obj_idx> pair from the given object handle */
+/*
+ * Decode <page, obj_idx> pair from the given object handle. We adjust the
+ * decoded obj_idx back to its original value since it was adjusted in
+ * obj_location_to_handle().
+ */
 static void obj_handle_to_location(unsigned long handle, struct page **page,
 				unsigned long *obj_idx)
 {
 	*page = pfn_to_page(handle >> OBJ_INDEX_BITS);
-	*obj_idx = handle & OBJ_INDEX_MASK;
+	*obj_idx = (handle & OBJ_INDEX_MASK) - 1;
 }
 
 static unsigned long obj_idx_to_offset(struct page *page,
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

