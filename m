Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbbAZVyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:54:05 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:50978 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbbAZVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:54:03 -0500
From: Sergei Rogachev <rogachevsergei@gmail.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sergei Rogachev <rogachevsergei@gmail.com>
Subject: [PATCH 1/1] mm/page_ext: remove unnecessary stack_trace field
Date: Tue, 27 Jan 2015 00:52:12 +0300
Message-Id: <1422309132-28030-2-git-send-email-rogachevsergei@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422309132-28030-1-git-send-email-rogachevsergei@gmail.com>
References: <1422309132-28030-1-git-send-email-rogachevsergei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page owner uses the page_ext structure to keep meta-information
for every page in the system. The structure also contains a field
of type 'struct stack_trace', page owner uses this field during
invocation of the function save_stack_trace. It is easy to notice
that keeping a copy of this structure for every page in the system
is very inefficiently in terms of memory.

The patch removes this unnecessary field of page_ext and forces
page owner to use a stack_trace structure allocated on the stack.

Signed-off-by: Sergei Rogachev <rogachevsergei@gmail.com>
---
 include/linux/page_ext.h |  2 +-
 mm/page_owner.c          | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index d2a2c84..c42981c 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -40,7 +40,7 @@ struct page_ext {
 #ifdef CONFIG_PAGE_OWNER
 	unsigned int order;
 	gfp_t gfp_mask;
-	struct stack_trace trace;
+	unsigned int nr_entries;
 	unsigned long trace_entries[8];
 #endif
 };
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 9ab4a9b..f7f3318 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -60,19 +60,19 @@ void __reset_page_owner(struct page *page, unsigned int order)
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
 	struct page_ext *page_ext;
-	struct stack_trace *trace;
+	struct stack_trace trace;
 
 	page_ext = lookup_page_ext(page);
 
-	trace = &page_ext->trace;
-	trace->nr_entries = 0;
-	trace->max_entries = ARRAY_SIZE(page_ext->trace_entries);
-	trace->entries = &page_ext->trace_entries[0];
-	trace->skip = 3;
-	save_stack_trace(&page_ext->trace);
+	trace.nr_entries = 0;
+	trace.max_entries = ARRAY_SIZE(page_ext->trace_entries);
+	trace.entries = &page_ext->trace_entries[0];
+	trace.skip = 3;
+	save_stack_trace(&trace);
 
 	page_ext->order = order;
 	page_ext->gfp_mask = gfp_mask;
+	page_ext->nr_entries = trace.nr_entries;
 
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
@@ -83,6 +83,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 {
 	int ret;
 	int pageblock_mt, page_mt;
+	struct stack_trace trace;
 	char *kbuf;
 
 	kbuf = kmalloc(count, GFP_KERNEL);
@@ -121,8 +122,10 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 	if (ret >= count)
 		goto err;
 
-	ret += snprint_stack_trace(kbuf + ret, count - ret,
-					&page_ext->trace, 0);
+	trace.nr_entries = page_ext->nr_entries;
+	trace.entries = &page_ext->trace_entries[0];
+
+	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
 	if (ret >= count)
 		goto err;
 
-- 
1.9.1

