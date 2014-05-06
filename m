Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbaEFFGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:06:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:14230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343AbaEFFFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,994,1389772800"; 
   d="scan'208";a="534115927"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Liu ShuoX <shuox.liu@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 2/3] pstore: add seq_ops for norm zone
Date: Tue,  6 May 2014 13:03:45 +0800
Message-Id: <1399352628-13308-3-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
References: <1399352628-13308-1-git-send-email-shuox.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some developers want to output the pstore record trace flexible.
So add seq_ops into ramoops_zone in case users would make private output
format.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
 fs/pstore/inode.c              | 10 ++++++++--
 include/linux/pstore_ramoops.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index d463481..a9c9782 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -207,14 +207,20 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 static int pstore_file_open(struct inode *inode, struct file *file)
 {
 	struct pstore_private *ps = inode->i_private;
+	struct ramoops_context *cxt = ps->psi->data;
+	struct ramoops_zone    *zones = cxt ? cxt->zones : NULL;
 	struct seq_file *sf;
 	int err;
 	const struct seq_operations *sops = NULL;
 
 	if (ps->type == PSTORE_TYPE_FTRACE)
 		sops = &pstore_ftrace_seq_ops;
-	if (ps->type == PSTORE_TYPE_NORM)
-		sops = &pstore_seq_ops;
+	if (ps->type == PSTORE_TYPE_NORM && zones) {
+		if (zones[ps->id].seq_ops)
+			sops = zones[ps->id].seq_ops;
+		else
+			sops = &pstore_seq_ops;
+	}
 
 	err = seq_open(file, sops);
 	if (err < 0)
diff --git a/include/linux/pstore_ramoops.h b/include/linux/pstore_ramoops.h
index 28f47a9..b8da964 100644
--- a/include/linux/pstore_ramoops.h
+++ b/include/linux/pstore_ramoops.h
@@ -33,6 +33,7 @@ struct ramoops_zone {
 	int		item_size;
 	void (*print_record)(struct seq_file *s, void *record);
 	void *(*get_new_record)(struct persistent_ram_zone *prz);
+	const struct seq_operations *seq_ops;
 };
 
 /*
-- 
1.8.3.2

