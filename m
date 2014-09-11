Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaIKU4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:56:36 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44595 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaIKUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:55:06 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 07/10] zsmalloc: add obj_handle_is_free()
Date: Thu, 11 Sep 2014 16:53:58 -0400
Message-Id: <1410468841-320-8-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function obj_handle_is_free() which scans through the entire
singly-linked list of free objects inside the provided zspage to
determine if the provided object handle is free or not.  This is
required by zspage reclaiming, which needs to evict each object
that is currently in use by the zs_pool owner, but has no other
way to determine if an object is in use.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 3dc7dae..ab72390 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -605,6 +605,33 @@ static unsigned long obj_idx_to_offset(struct page *page,
 	return off + obj_idx * class_size;
 }
 
+static bool obj_handle_is_free(struct page *first_page,
+			struct size_class *class, unsigned long handle)
+{
+	unsigned long obj, idx, offset;
+	struct page *page;
+	struct link_free *link;
+
+	BUG_ON(!is_first_page(first_page));
+
+	obj = (unsigned long)first_page->freelist;
+
+	while (obj) {
+		if (obj == handle)
+			return true;
+
+		obj_handle_to_location(obj, &page, &idx);
+		offset = obj_idx_to_offset(page, idx, class->size);
+
+		link = (struct link_free *)kmap_atomic(page) +
+					offset / sizeof(*link);
+		obj = (unsigned long)link->next;
+		kunmap_atomic(link);
+	}
+
+	return false;
+}
+
 static void obj_free(unsigned long obj, struct page *page, unsigned long offset)
 {
 	struct page *first_page = get_first_page(page);
-- 
1.8.3.1

