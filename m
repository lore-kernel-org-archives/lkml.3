Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3GAL6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:58:17 -0400
Received: from relay.parallels.com ([195.214.232.42]:33974 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3GAL6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:58:14 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <criu@openvz.org>, <devel@openvz.org>,
        <xemul@parallels.com>, <khorenko@parallels.com>
Subject: [PATCH RFC 11/13] mm: PRAM: allow to free persistent memory from userspace
Date: Mon, 1 Jul 2013 15:57:46 +0400
Message-ID: <38f22df08b8843c989d24c22c19f4a42d09b182a.1372582756.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1372582754.git.vdavydov@parallels.com>
References: <cover.1372582754.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.24.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To free all space utilized for persistent memory, one can write 0 to
/sys/kernel/pram. This will destroy all PRAM nodes that are not
currently being read or written.
---
 mm/pram.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/mm/pram.c b/mm/pram.c
index 3ad769b..43ad85f 100644
--- a/mm/pram.c
+++ b/mm/pram.c
@@ -697,6 +697,32 @@ static void pram_truncate_node(struct pram_node *node)
 
 }
 
+/*
+ * Free all nodes that are not under operation.
+ */
+static void pram_truncate(void)
+{
+	struct page *page, *tmp;
+	struct pram_node *node;
+	LIST_HEAD(dispose);
+
+	mutex_lock(&pram_mutex);
+	list_for_each_entry_safe(page, tmp, &pram_nodes, lru) {
+		node = page_address(page);
+		if (!(node->flags & PRAM_ACCMODE_MASK))
+			list_move(&page->lru, &dispose);
+	}
+	mutex_unlock(&pram_mutex);
+
+	while (!list_empty(&dispose)) {
+		page = list_first_entry(&dispose, struct page, lru);
+		list_del(&page->lru);
+		node = page_address(page);
+		pram_truncate_node(node);
+		pram_free_page(node);
+	}
+}
+
 static void pram_stream_init(struct pram_stream *ps,
 			     struct pram_node *node, gfp_t gfp_mask)
 {
@@ -1189,8 +1215,19 @@ static ssize_t show_pram_sb_pfn(struct kobject *kobj,
 	return sprintf(buf, "%lx\n", pfn);
 }
 
+static ssize_t store_pram_sb_pfn(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	int val;
+
+	if (kstrtoint(buf, 0, &val) || val)
+		return -EINVAL;
+	pram_truncate();
+	return count;
+}
+
 static struct kobj_attribute pram_sb_pfn_attr =
-	__ATTR(pram, 0444, show_pram_sb_pfn, NULL);
+	__ATTR(pram, 0644, show_pram_sb_pfn, store_pram_sb_pfn);
 
 static struct attribute *pram_attrs[] = {
 	&pram_sb_pfn_attr.attr,
-- 
1.7.10.4

