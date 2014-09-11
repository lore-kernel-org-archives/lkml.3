Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaIKNEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:04:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbaIKNEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Steve Wise" <swise@opengridcomputing.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.41558588@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 054/131] RDMA/iwcm: Use a default listen backlog if needed
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 2f0304d21867476394cd51a54e97f7273d112261 upstream.

If the user creates a listening cm_id with backlog of 0 the IWCM ends
up not allowing any connection requests at all.  The correct behavior
is for the IWCM to pick a default value if the user backlog parameter
is zero.

Lustre from version 1.8.8 onward uses a backlog of 0, which breaks
iwarp support without this fix.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
[bwh: Backported to 3.2: use register_net_sysctl_table()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/core/iwcm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -46,6 +46,7 @@
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 
 #include <rdma/iw_cm.h>
 #include <rdma/ib_addr.h>
@@ -65,6 +66,20 @@ struct iwcm_work {
 	struct list_head free_list;
 };
 
+static unsigned int default_backlog = 256;
+
+static struct ctl_table_header *iwcm_ctl_table_hdr;
+static struct ctl_table iwcm_ctl_table[] = {
+	{
+		.procname	= "default_backlog",
+		.data		= &default_backlog,
+		.maxlen		= sizeof(default_backlog),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{ }
+};
+
 /*
  * The following services provide a mechanism for pre-allocating iwcm_work
  * elements.  The design pre-allocates them  based on the cm_id type:
@@ -419,6 +434,9 @@ int iw_cm_listen(struct iw_cm_id *cm_id,
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 
+	if (!backlog)
+		backlog = default_backlog;
+
 	ret = alloc_work_entries(cm_id_priv, backlog);
 	if (ret)
 		return ret;
@@ -1014,17 +1032,33 @@ int iw_cm_init_qp_attr(struct iw_cm_id *
 }
 EXPORT_SYMBOL(iw_cm_init_qp_attr);
 
+static struct ctl_path iwcm_ctl_path[] = {
+	{ .procname = "net" },
+	{ .procname = "iw_cm" },
+	{ }
+};
+
 static int __init iw_cm_init(void)
 {
 	iwcm_wq = create_singlethread_workqueue("iw_cm_wq");
 	if (!iwcm_wq)
 		return -ENOMEM;
 
+	iwcm_ctl_table_hdr = register_net_sysctl_table(&init_net,
+						       iwcm_ctl_path,
+						       iwcm_ctl_table);
+	if (!iwcm_ctl_table_hdr) {
+		pr_err("iw_cm: couldn't register sysctl paths\n");
+		destroy_workqueue(iwcm_wq);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 static void __exit iw_cm_cleanup(void)
 {
+	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
 }
 

