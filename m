Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaCaGb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 02:31:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:25799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaCaGby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 02:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,763,1389772800"; 
   d="scan'208";a="483775029"
Date: Mon, 31 Mar 2014 14:30:30 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-next@vger.kernel.org,
        Zhang Yanmin <yanmin.zhang@intel.com>, fengguang.wu@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v2 2/3] pstore: add seq_ops for norm zone
Message-ID: <20140331063029.GB2395@lskakaxi-intel>
References: <20140331110756.c4f9b2e9f9f4874e0d90da11@canb.auug.org.au>
 <20140331062708.GA2395@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140331062708.GA2395@lskakaxi-intel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

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
index 7c0a64b..9a5a224 100644
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

