Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaIOTgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:36:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaIOTgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.16 130/158] RDMA/iwcm: Use a default listen backlog if needed
Date: Mon, 15 Sep 2014 12:26:09 -0700
Message-Id: <20140915192546.782704793@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/iwcm.c |   27 +++++++++++++++++++++++++++
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
@@ -425,6 +440,9 @@ int iw_cm_listen(struct iw_cm_id *cm_id,
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 
+	if (!backlog)
+		backlog = default_backlog;
+
 	ret = alloc_work_entries(cm_id_priv, backlog);
 	if (ret)
 		return ret;
@@ -1030,11 +1048,20 @@ static int __init iw_cm_init(void)
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
 


