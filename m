Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaH2QHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:07:16 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58824 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:07:13 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, jbaron@akamai.com, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH 3/4] mm: Use __seq_open_private() instead of seq_open()
Date: Fri, 29 Aug 2014 17:06:39 +0100
Message-Id: <1409328400-18212-4-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
References: <1409328400-18212-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __seq_open_private() removes boilerplate code from slabstats_open()

The resultant code is shorter and easier to follow.

This patch does not change any functionality.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 mm/slab.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 19d9218..d67f319 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4339,19 +4339,15 @@ static const struct seq_operations slabstats_op = {
 
 static int slabstats_open(struct inode *inode, struct file *file)
 {
-	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	int ret = -ENOMEM;
-	if (n) {
-		ret = seq_open(file, &slabstats_op);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			*n = PAGE_SIZE / (2 * sizeof(unsigned long));
-			m->private = n;
-			n = NULL;
-		}
-		kfree(n);
-	}
-	return ret;
+	unsigned long *n;
+
+	n = __seq_open_private(file, &slabstats_op, PAGE_SIZE);
+	if (!n)
+		return -ENOMEM;
+
+	*n = PAGE_SIZE / (2 * sizeof(unsigned long));
+
+	return 0;
 }
 
 static const struct file_operations proc_slabstats_operations = {
-- 
1.7.10.4

