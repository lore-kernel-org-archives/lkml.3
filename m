Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3L2V7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:59:09 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61815 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab3L2Vvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832525"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Roland Dreier <roland@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/25] IB/mlx4: fix error return code
Date: Sun, 29 Dec 2013 23:47:20 +0100
Message-Id: <1388357260-4843-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/infiniband/hw/mlx4/sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index 97516eb..db2ea31 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -582,8 +582,10 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 	p->pkey_group.attrs =
 		alloc_group_attrs(show_port_pkey, store_port_pkey,
 				  dev->dev->caps.pkey_table_len[port_num]);
-	if (!p->pkey_group.attrs)
+	if (!p->pkey_group.attrs) {
+		ret = -ENOMEM;
 		goto err_alloc;
+	}
 
 	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
 	if (ret)
@@ -591,8 +593,10 @@ static int add_port(struct mlx4_ib_dev *dev, int port_num, int slave)
 
 	p->gid_group.name  = "gid_idx";
 	p->gid_group.attrs = alloc_group_attrs(show_port_gid_idx, NULL, 1);
-	if (!p->gid_group.attrs)
+	if (!p->gid_group.attrs) {
+		ret = -ENOMEM;
 		goto err_free_pkey;
+	}
 
 	ret = sysfs_create_group(&p->kobj, &p->gid_group);
 	if (ret)

