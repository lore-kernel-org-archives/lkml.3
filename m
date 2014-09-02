Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbaIBPcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:32:08 -0400
Received: from cernmx13.cern.ch ([188.184.36.46]:14547 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256AbaIBPcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:32:03 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH 2/3] ipack: save carrier owner to allow device to get it
Date: Tue, 2 Sep 2014 17:31:40 +0200
Message-ID: <1409671901-4009-3-git-send-email-federico.vaga@cern.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
References: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.193.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was not any kind of protection against carrier driver removal.
In this way, device driver can 'get' the carrier driver when it is
using it.

Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
---
 drivers/ipack/carriers/tpci200.c |    3 ++-
 drivers/ipack/ipack.c            |    4 +++-
 include/linux/ipack.h            |   24 +++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index de5e321..9b23843 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -572,7 +572,8 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	/* Register the carrier in the industry pack bus driver */
 	tpci200->info->ipack_bus = ipack_bus_register(&pdev->dev,
 						      TPCI200_NB_SLOT,
-						      &tpci200_bus_ops);
+						      &tpci200_bus_ops,
+						      THIS_MODULE);
 	if (!tpci200->info->ipack_bus) {
 		dev_err(&pdev->dev,
 			"error registering the carrier on ipack driver\n");
diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index d0016ba..c0e7b62 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -206,7 +206,8 @@ static struct bus_type ipack_bus_type = {
 };
 
 struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
-					    const struct ipack_bus_ops *ops)
+					    const struct ipack_bus_ops *ops,
+					    struct module *owner)
 {
 	int bus_nr;
 	struct ipack_bus_device *bus;
@@ -225,6 +226,7 @@ struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
 	bus->parent = parent;
 	bus->slots = slots;
 	bus->ops = ops;
+	bus->owner = owner;
 	return bus;
 }
 EXPORT_SYMBOL_GPL(ipack_bus_register);
diff --git a/include/linux/ipack.h b/include/linux/ipack.h
index 1888e06..8bddc3f 100644
--- a/include/linux/ipack.h
+++ b/include/linux/ipack.h
@@ -172,6 +172,7 @@ struct ipack_bus_ops {
  *	@ops: bus operations for the mezzanine drivers
  */
 struct ipack_bus_device {
+	struct module *owner;
 	struct device *parent;
 	int slots;
 	int bus_nr;
@@ -189,7 +190,8 @@ struct ipack_bus_device {
  * available bus device in ipack.
  */
 struct ipack_bus_device *ipack_bus_register(struct device *parent, int slots,
-					    const struct ipack_bus_ops *ops);
+					    const struct ipack_bus_ops *ops,
+					    struct module *owner);
 
 /**
  *	ipack_bus_unregister -- unregister an ipack bus
@@ -265,3 +267,23 @@ void ipack_put_device(struct ipack_device *dev);
 	 .format = (_format), \
 	 .vendor = (vend), \
 	 .device = (dev)
+
+/**
+ * ipack_get_carrier - it increase the carrier ref. counter of
+ *                     the carrier module
+ * @dev: mezzanine device which wants to get the carrier
+ */
+static inline int ipack_get_carrier(struct ipack_device *dev)
+{
+	return try_module_get(dev->bus->owner);
+}
+
+/**
+ * ipack_get_carrier - it decrease the carrier ref. counter of
+ *                     the carrier module
+ * @dev: mezzanine device which wants to get the carrier
+ */
+static inline void ipack_put_carrier(struct ipack_device *dev)
+{
+	module_put(dev->bus->owner);
+}
-- 
1.7.10.4

