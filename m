Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3GCAuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:50:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59717 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GCAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:50:17 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/5] mm/slab: Fix /proc/slabinfo unwriteable for slab
Date: Wed,  3 Jul 2013 08:49:51 +0800
Message-Id: <1372812593-7617-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070300-6102-0000-0000-000003CBB37F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab have some tunables like limit, batchcount, and sharedfactor can be
tuned through function slabinfo_write. Commit (b7454ad3: mm/sl[au]b: Move
slabinfo processing to slab_common.c) uncorrectly change /proc/slabinfo
unwriteable for slab, this patch fix it by revert to original mode.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab_common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d161b81..6a5deda 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -497,6 +497,13 @@ void __init create_kmalloc_caches(unsigned long flags)
 
 
 #ifdef CONFIG_SLABINFO
+
+#ifdef CONFIG_SLAB
+#define SLABINFO_RIGHTS (S_IWUSR | S_IRUSR)
+#else
+#define SLABINFO_RIGHTS S_IRUSR
+#endif
+
 void print_slabinfo_header(struct seq_file *m)
 {
 	/*
@@ -633,7 +640,8 @@ static const struct file_operations proc_slabinfo_operations = {
 
 static int __init slab_proc_init(void)
 {
-	proc_create("slabinfo", S_IRUSR, NULL, &proc_slabinfo_operations);
+	proc_create("slabinfo", SLABINFO_RIGHTS, NULL,
+						&proc_slabinfo_operations);
 	return 0;
 }
 module_init(slab_proc_init);
-- 
1.8.1.2

