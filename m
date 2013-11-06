Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab3KFAyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:54:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3KFAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:54:38 -0500
From: Olav Haugan <ohaugan@codeaurora.org>
To: gregkh@linuxfoundation.org
Cc: ngupta@vflare.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, minchan@kernel.org,
        linux-arm-msm@vger.kernel.org, Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Date: Tue,  5 Nov 2013 16:54:12 -0800
Message-Id: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zsmalloc encodes a handle using the page pfn and an object
index. On some hardware platforms the pfn could be 0 and this
causes the encoded handle to be 0 which is interpreted as an
allocation failure.

To prevent this false error we ensure that the encoded handle
will not be 0 when allocation succeeds.

Change-Id: Ifff930dcf254915b497aec5cb36f152a5e5365d6
Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 523b937..0e32c0f 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -441,7 +441,7 @@ static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
 	}
 
 	handle = page_to_pfn(page) << OBJ_INDEX_BITS;
-	handle |= (obj_idx & OBJ_INDEX_MASK);
+	handle |= ((obj_idx + 1) & OBJ_INDEX_MASK);
 
 	return (void *)handle;
 }
@@ -451,7 +451,7 @@ static void obj_handle_to_location(unsigned long handle, struct page **page,
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

