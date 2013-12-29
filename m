Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3L2Vy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:54:27 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61815 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab3L2Vv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:51:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832554"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/25] RDMA/nes: fix error return code
Date: Sun, 29 Dec 2013 23:47:37 +0100
Message-Id: <1388357260-4843-23-git-send-email-Julia.Lawall@lip6.fr>
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

 drivers/infiniband/hw/nes/nes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 4291410..353c7b0 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -675,8 +675,11 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	INIT_DELAYED_WORK(&nesdev->work, nes_recheck_link_status);
 
 	/* Initialize network devices */
-	if ((netdev = nes_netdev_init(nesdev, mmio_regs)) == NULL)
+	netdev = nes_netdev_init(nesdev, mmio_regs);
+	if (netdev == NULL) {
+		ret = -ENOMEM;
 		goto bail7;
+	}
 
 	/* Register network device */
 	ret = register_netdev(netdev);

