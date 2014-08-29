Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaH2QHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:07:05 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58792 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:07:03 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, jbaron@akamai.com, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH 2/4] mm: Use seq_open_private() instead of seq_open()
Date: Fri, 29 Aug 2014 17:06:38 +0100
Message-Id: <1409328400-18212-3-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using seq_open_private() removes boilerplate code from vmalloc_open().

The resultant code is shorter and easier to follow.

However, please note that seq_open_private() call kzalloc() rather than
kmalloc() which may affect timing due to the memory initialisation overhead.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 mm/vmalloc.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bf233b2..0d6caee 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2647,21 +2647,11 @@ static const struct seq_operations vmalloc_op = {
 
 static int vmalloc_open(struct inode *inode, struct file *file)
 {
-	unsigned int *ptr = NULL;
-	int ret;
-
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
-		if (ptr == NULL)
-			return -ENOMEM;
-	}
-	ret = seq_open(file, &vmalloc_op);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = ptr;
-	} else
-		kfree(ptr);
-	return ret;
+	if (IS_ENABLED(CONFIG_NUMA))
+		return seq_open_private(file, &vmalloc_op,
+					nr_node_ids * sizeof(unsigned int));
+	else
+		return seq_open(file, &vmalloc_op);
 }
 
 static const struct file_operations proc_vmalloc_operations = {
-- 
1.7.10.4

