Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab3CMSGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:06:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55724 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933024Ab3CMSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:06:08 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, Nathan Zimmer <nzimmer@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] dgrp: staging: cleanup sparse warnings
Date: Wed, 13 Mar 2013 13:05:59 -0500
Message-Id: <1363197959-22685-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361480226-13965-1-git-send-email-nzimmer@sgi.com>
References: <1361480226-13965-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cleanup patch to remove sparse warnings caused by my other patch
"procfs: Improve Scaling in proc" since now proc_fops is protected by the rcu.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: devel@driverdev.osuosl.org 
Cc: linux-kernel@vger.kernel.org

---
 drivers/staging/dgrp/dgrp_dpa_ops.c   | 2 +-
 drivers/staging/dgrp/dgrp_mon_ops.c   | 2 +-
 drivers/staging/dgrp/dgrp_net_ops.c   | 2 +-
 drivers/staging/dgrp/dgrp_ports_ops.c | 2 +-
 drivers/staging/dgrp/dgrp_specproc.c  | 6 ++++--
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_dpa_ops.c b/drivers/staging/dgrp/dgrp_dpa_ops.c
index 021cca4..67fb3d6 100644
--- a/drivers/staging/dgrp/dgrp_dpa_ops.c
+++ b/drivers/staging/dgrp/dgrp_dpa_ops.c
@@ -116,7 +116,7 @@ void dgrp_register_dpa_hook(struct proc_dir_entry *de)
 	struct nd_struct *node = de->data;
 
 	de->proc_iops = &dpa_inode_ops;
-	de->proc_fops = &dpa_ops;
+	rcu_assign_pointer(de->proc_fops, &dpa_ops);
 
 	node->nd_dpa_de = de;
 	spin_lock_init(&node->nd_dpa_lock);
diff --git a/drivers/staging/dgrp/dgrp_mon_ops.c b/drivers/staging/dgrp/dgrp_mon_ops.c
index 4792d05..b484fcc 100644
--- a/drivers/staging/dgrp/dgrp_mon_ops.c
+++ b/drivers/staging/dgrp/dgrp_mon_ops.c
@@ -66,7 +66,7 @@ void dgrp_register_mon_hook(struct proc_dir_entry *de)
 	struct nd_struct *node = de->data;
 
 	de->proc_iops = &mon_inode_ops;
-	de->proc_fops = &mon_ops;
+	rcu_assign_pointer(de->proc_fops, &mon_ops);
 	node->nd_mon_de = de;
 	sema_init(&node->nd_mon_semaphore, 1);
 }
diff --git a/drivers/staging/dgrp/dgrp_net_ops.c b/drivers/staging/dgrp/dgrp_net_ops.c
index 2d1bbfd..7392578 100644
--- a/drivers/staging/dgrp/dgrp_net_ops.c
+++ b/drivers/staging/dgrp/dgrp_net_ops.c
@@ -90,7 +90,7 @@ void dgrp_register_net_hook(struct proc_dir_entry *de)
 	struct nd_struct *node = de->data;
 
 	de->proc_iops = &net_inode_ops;
-	de->proc_fops = &net_ops;
+	rcu_assign_pointer(de->proc_fops, &net_ops);
 	node->nd_net_de = de;
 	sema_init(&node->nd_net_semaphore, 1);
 	node->nd_state = NS_CLOSED;
diff --git a/drivers/staging/dgrp/dgrp_ports_ops.c b/drivers/staging/dgrp/dgrp_ports_ops.c
index cd1fc20..f93dc1f 100644
--- a/drivers/staging/dgrp/dgrp_ports_ops.c
+++ b/drivers/staging/dgrp/dgrp_ports_ops.c
@@ -65,7 +65,7 @@ void dgrp_register_ports_hook(struct proc_dir_entry *de)
 	struct nd_struct *node = de->data;
 
 	de->proc_iops = &ports_inode_ops;
-	de->proc_fops = &ports_ops;
+	rcu_assign_pointer(de->proc_fops, &ports_ops);
 	node->nd_ports_de = de;
 }
 
diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index c214078..51b2153 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -268,9 +268,11 @@ static void register_proc_table(struct dgrp_proc_entry *table,
 			if (!table->child) {
 				de->proc_iops = &proc_inode_ops;
 				if (table->proc_file_ops)
-					de->proc_fops = table->proc_file_ops;
+					rcu_assign_pointer(de->proc_fops,
+							table->proc_file_ops);
 				else
-					de->proc_fops = &dgrp_proc_file_ops;
+					rcu_assign_pointer(de->proc_fops,
+							 &dgrp_proc_file_ops);
 			}
 		}
 		table->de = de;
-- 
1.8.1.2

