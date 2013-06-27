Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3F0AmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:42:15 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37739 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3F0Al4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:41:56 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        lllllinux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 3/3] mm/slab: Fix /proc/slabinfo unwriteable for slab
Date: Thu, 27 Jun 2013 08:41:40 +0800
Message-Id: <1372293700-15916-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062700-8878-0000-0000-000007B4D636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slab have some tunables like limit, batchcount, and sharedfactor can be
tuned through function slabinfo_write. Commit (b7454ad3: mm/sl[au]b: Move
slabinfo processing to slab_common.c) uncorrectly change /proc/slabinfo
unwriteable for slab, this patch fix it by revert to original mode.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab_common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 4ee4325..d41ff76 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -631,10 +631,20 @@ static const struct file_operations proc_slabinfo_operations = {
 	.release	= seq_release,
 };
 
+#ifdef CONFIG_SLAB
+static int __init slab_proc_init(void)
+{
+	proc_create("slabinfo", S_IWUSR | S_IRUSR, NULL, &proc_slabinfo_operations);
+	return 0;
+}
+#endif
+#ifdef CONFIG_SLUB
 static int __init slab_proc_init(void)
 {
 	proc_create("slabinfo", S_IRUSR, NULL, &proc_slabinfo_operations);
 	return 0;
 }
+#endif
+
 module_init(slab_proc_init);
 #endif /* CONFIG_SLABINFO */
-- 
1.8.1.2

