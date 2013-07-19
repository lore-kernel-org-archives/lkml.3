Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800Ab3GSF1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:27:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965761Ab3GSF1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 42/72] PCI: Fix refcount issue in pci_create_root_bus() error recovery path
Date: Thu, 18 Jul 2013 22:25:59 -0700
Message-Id: <20130719052602.742607405@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <liuj97@gmail.com>

commit 343df771e671d821478dd3ef525a0610b808dbf8 upstream.

After calling device_register(&bridge->dev), the bridge is reference-
counted, and it is illegal to call kfree() on it except in the release
function.

[bhelgaas: changelog, use put_device() after device_register() failure]
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1703,12 +1703,16 @@ struct pci_bus *pci_create_root_bus(stru
 	bridge->dev.release = pci_release_bus_bridge_dev;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
 	error = pcibios_root_bridge_prepare(bridge);
-	if (error)
-		goto bridge_dev_reg_err;
+	if (error) {
+		kfree(bridge);
+		goto err_out;
+	}
 
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
@@ -1764,8 +1768,6 @@ struct pci_bus *pci_create_root_bus(stru
 class_dev_reg_err:
 	put_device(&bridge->dev);
 	device_unregister(&bridge->dev);
-bridge_dev_reg_err:
-	kfree(bridge);
 err_out:
 	kfree(b);
 	return NULL;


