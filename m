Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3GQX1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:27:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab3GQWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/145] PCI: Fix refcount issue in pci_create_root_bus() error recovery path
Date: Wed, 17 Jul 2013 15:45:47 -0700
Message-Id: <1374101277-7915-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 343df771e671d821478dd3ef525a0610b808dbf8 upstream.

After calling device_register(&bridge->dev), the bridge is reference-
counted, and it is illegal to call kfree() on it except in the release
function.

[bhelgaas: changelog, use put_device() after device_register() failure]
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[ luis: backported to 3.8:
  - adjusted context
  - removed error handling for pcibios_root_bridge_prepare invocation ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/probe.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6186f03..30db275 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1667,8 +1667,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
 	error = device_register(&bridge->dev);
-	if (error)
-		goto bridge_dev_reg_err;
+	if (error) {
+		put_device(&bridge->dev);
+		goto err_out;
+	}
 	b->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(b->bridge);
 	pci_set_bus_of_node(b);
@@ -1724,8 +1726,6 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 class_dev_reg_err:
 	put_device(&bridge->dev);
 	device_unregister(&bridge->dev);
-bridge_dev_reg_err:
-	kfree(bridge);
 err_out:
 	kfree(b);
 	return NULL;
-- 
1.8.1.2

