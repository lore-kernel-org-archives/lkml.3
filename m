Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3KHB7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:59:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33166 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3KHB73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:59:29 -0500
From: Olav Haugan <ohaugan@codeaurora.org>
To: gregkh@linuxfoundation.org
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org, Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH v2] staging: zsmalloc: Ensure handle is never 0 on success
Date: Thu,  7 Nov 2013 17:58:03 -0800
Message-Id: <1383875883-30597-1-git-send-email-ohaugan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zsmalloc encodes a handle using the pfn and an object
index. On hardware platforms with physical memory starting
at 0x0 the pfn can be 0. This causes the encoded handle to be
0 and is incorrectly interpreted as an allocation failure.

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

