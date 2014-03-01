Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCACRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:17:17 -0500
Received: from linuxhacker.ru ([217.76.32.60]:42573 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbaCACRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:17:12 -0500
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 03/17] lustre/llite: Do not send parent dir fid in getattr by fid
Date: Fri, 28 Feb 2014 21:16:32 -0500
Message-Id: <1393640206-20286-4-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
References: <1393640206-20286-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending getattr by fid in this case is pointless, as the parent
might havelong changed and we have no control over it, but it's
irrelevant anyway, since we already have the child fid.

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-on: http://review.whamcloud.com/7910
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3240
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dir.c  | 2 +-
 drivers/staging/lustre/lustre/llite/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index fd0dd20e..7fbc18e 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -362,7 +362,7 @@ struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
 		struct ptlrpc_request *request;
 		struct md_op_data *op_data;
 
-		op_data = ll_prep_md_op_data(NULL, dir, NULL, NULL, 0, 0,
+		op_data = ll_prep_md_op_data(NULL, dir, dir, NULL, 0, 0,
 		LUSTRE_OPC_ANY, NULL);
 		if (IS_ERR(op_data))
 			return (void *)op_data;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index c9ee574..36c54aa 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2891,7 +2891,7 @@ int __ll_inode_revalidate_it(struct dentry *dentry, struct lookup_intent *it,
 			oit.it_op = IT_LOOKUP;
 
 		/* Call getattr by fid, so do not provide name at all. */
-		op_data = ll_prep_md_op_data(NULL, dentry->d_parent->d_inode,
+		op_data = ll_prep_md_op_data(NULL, dentry->d_inode,
 					     dentry->d_inode, NULL, 0, 0,
 					     LUSTRE_OPC_ANY, NULL);
 		if (IS_ERR(op_data))
-- 
1.8.5.3

