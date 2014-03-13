Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaCMLv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:51:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:46958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbaCMLvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:51:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,646,1389772800"; 
   d="scan'208";a="497688277"
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, Liu ShuoX <shuox.liu@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 2/3] pstore: add seq_ops for norm zone
Date: Thu, 13 Mar 2014 19:47:39 +0800
Message-Id: <1394711263-11042-2-git-send-email-shuox.liu@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394711263-11042-1-git-send-email-shuox.liu@intel.com>
References: <1394711263-11042-1-git-send-email-shuox.liu@intel.com>
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
index 2b1962f..6e53e3d 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -207,14 +207,20 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 static int pstore_file_open(struct inode *inode, struct file *file)
 {
 	struct pstore_private *ps = inode->i_private;
+	struct ramoops_context *cxt = ps->psi->data;
+	struct ramoops_zone    *zones = cxt->zones;
 	struct seq_file *sf;
 	int err;
 	const struct seq_operations *sops = NULL;
 
 	if (ps->type == PSTORE_TYPE_FTRACE)
 		sops = &pstore_ftrace_seq_ops;
-	if (ps->type == PSTORE_TYPE_NORM)
-		sops = &pstore_seq_ops;
+	if (ps->type == PSTORE_TYPE_NORM) {
+		if (zones[ps->id].seq_ops)
+			sops = zones[ps->id].seq_ops;
+		else
+			sops = &pstore_seq_ops;
+	}
 
 	err = seq_open(file, sops);
 	if (err < 0)
diff --git a/include/linux/pstore_ramoops.h b/include/linux/pstore_ramoops.h
index 1f95dc8..d43f6dd 100644
--- a/include/linux/pstore_ramoops.h
+++ b/include/linux/pstore_ramoops.h
@@ -32,6 +32,7 @@ struct ramoops_zone {
 	struct persistent_ram_zone *prz;
 	int		item_size;
 	void (*print_record)(struct seq_file *s, void *record);
+	struct seq_operations *seq_ops;
 };
 
 /*
-- 
1.8.3.2

