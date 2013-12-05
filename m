Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab3LERmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:42:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3LERiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olav Haugan <ohaugan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 79/90] staging: zsmalloc: Ensure handle is never 0 on success
Date: Thu,  5 Dec 2013 17:36:01 +0000
Message-Id: <1386264972-5399-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted context to use 'hval' variable instead of 'handle'
    parameter in function() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 8ded9a0..0cebb76 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -230,7 +230,12 @@ static struct page *get_next_page(struct page *page)
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
@@ -241,19 +246,23 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
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
 static void obj_handle_to_location(void *handle, struct page **page,
 				unsigned long *obj_idx)
 {
 	unsigned long hval = (unsigned long)handle;
 
 	*page = pfn_to_page(hval >> OBJ_INDEX_BITS);
-	*obj_idx = hval & OBJ_INDEX_MASK;
+	*obj_idx = (hval & OBJ_INDEX_MASK) - 1;
 }
 
 static unsigned long obj_idx_to_offset(struct page *page,
-- 
1.8.3.2

