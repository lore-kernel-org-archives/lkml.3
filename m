Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaIZKOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:14:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbaIZJqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/142] RDMA/iwcm: Use a default listen backlog if needed
Date: Fri, 26 Sep 2014 11:45:08 +0200
Message-Id: <904c6df509830db3e20429523963084b355a3a49.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2f0304d21867476394cd51a54e97f7273d112261 upstream.

If the user creates a listening cm_id with backlog of 0 the IWCM ends
up not allowing any connection requests at all.  The correct behavior
is for the IWCM to pick a default value if the user backlog parameter
is zero.

Lustre from version 1.8.8 onward uses a backlog of 0, which breaks
iwarp support without this fix.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/core/iwcm.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index c47c2034ca71..4293e89bbbdd 100644
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
@@ -419,6 +434,9 @@ int iw_cm_listen(struct iw_cm_id *cm_id, int backlog)
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 
+	if (!backlog)
+		backlog = default_backlog;
+
 	ret = alloc_work_entries(cm_id_priv, backlog);
 	if (ret)
 		return ret;
@@ -1024,11 +1042,20 @@ static int __init iw_cm_init(void)
 	if (!iwcm_wq)
 		return -ENOMEM;
 
+	iwcm_ctl_table_hdr = register_net_sysctl(&init_net, "net/iw_cm",
+						 iwcm_ctl_table);
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
 
-- 
2.1.0

