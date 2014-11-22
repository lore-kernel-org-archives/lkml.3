Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaKVOpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:45:41 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53713
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbaKVOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:44:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,437,1413237600"; 
   d="scan'208";a="90017239"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] solos-pci: fix error return code
Date: Sat, 22 Nov 2014 15:39:17 +0100
Message-Id: <1416667159-9808-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
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
 drivers/atm/solos-pci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 7652e8d..21b0bc6 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -1225,11 +1225,13 @@ static int fpga_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	card->config_regs = pci_iomap(dev, 0, CONFIG_RAM_SIZE);
 	if (!card->config_regs) {
 		dev_warn(&dev->dev, "Failed to ioremap config registers\n");
+		err = -ENOMEM;
 		goto out_release_regions;
 	}
 	card->buffers = pci_iomap(dev, 1, DATA_RAM_SIZE);
 	if (!card->buffers) {
 		dev_warn(&dev->dev, "Failed to ioremap data buffers\n");
+		err = -ENOMEM;
 		goto out_unmap_config;
 	}
 

