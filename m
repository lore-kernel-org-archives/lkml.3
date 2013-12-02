Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab3LBU1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:27:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3LBTQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:16:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH 3.12 012/212] staging: zsmalloc: Ensure handle is never 0 on success
Date: Mon,  2 Dec 2013 11:13:23 -0800
Message-Id: <20131202191250.003870958@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olav Haugan <ohaugan@codeaurora.org>

commit 67296874eb1cc80317bf2a8fba22b494e21eb29b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zsmalloc/zsmalloc-main.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -430,7 +430,12 @@ static struct page *get_next_page(struct
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
@@ -441,17 +446,21 @@ static void *obj_location_to_handle(stru
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


