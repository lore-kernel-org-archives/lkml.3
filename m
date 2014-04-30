Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbaD3LeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:34:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780AbaD3Ld2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:33:28 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sergei.shtylyov@cogentembedded.com>, <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v3 1/4] mdio_bus: implement devm_mdiobus_alloc/devm_mdiobus_free
Date: Wed, 30 Apr 2014 15:23:33 +0300
Message-ID: <1398860616-6612-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
References: <1398860616-6612-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a resource managed devm_mdiobus_alloc[_size]()/devm_mdiobus_free()
to automatically clean up MDIO bus alocations made by MDIO drivers,
thus leading to simplified MDIO drivers code.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-and-tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 Documentation/driver-model/devres.txt |    5 +++
 drivers/net/phy/mdio_bus.c            |   67 +++++++++++++++++++++++++++++++++
 include/linux/phy.h                   |    7 ++++
 3 files changed, 79 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 4f7897e..c74e044 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -308,3 +308,8 @@ SLAVE DMA ENGINE
 
 SPI
   devm_spi_register_master()
+
+MDIO
+  devm_mdiobus_alloc()
+  devm_mdiobus_alloc_size()
+  devm_mdiobus_free()
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 76f54b3..68a9a38 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -69,6 +69,73 @@ struct mii_bus *mdiobus_alloc_size(size_t size)
 }
 EXPORT_SYMBOL(mdiobus_alloc_size);
 
+static void _devm_mdiobus_free(struct device *dev, void *res)
+{
+	mdiobus_free(*(struct mii_bus **)res);
+}
+
+static int devm_mdiobus_match(struct device *dev, void *res, void *data)
+{
+	struct mii_bus **r = res;
+
+	if (WARN_ON(!r || !*r))
+		return 0;
+
+	return *r == data;
+}
+
+/**
+ * devm_mdiobus_alloc_size - Resource-managed mdiobus_alloc_size()
+ * @dev:		Device to allocate mii_bus for
+ * @sizeof_priv:	Space to allocate for private structure.
+ *
+ * Managed mdiobus_alloc_size. mii_bus allocated with this function is
+ * automatically freed on driver detach.
+ *
+ * If an mii_bus allocated with this function needs to be freed separately,
+ * devm_mdiobus_free() must be used.
+ *
+ * RETURNS:
+ * Pointer to allocated mii_bus on success, NULL on failure.
+ */
+struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv)
+{
+	struct mii_bus **ptr, *bus;
+
+	ptr = devres_alloc(_devm_mdiobus_free, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return NULL;
+
+	/* use raw alloc_dr for kmalloc caller tracing */
+	bus = mdiobus_alloc_size(sizeof_priv);
+	if (bus) {
+		*ptr = bus;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return bus;
+}
+EXPORT_SYMBOL_GPL(devm_mdiobus_alloc);
+
+/**
+ * devm_mdiobus_free - Resource-managed mdiobus_free()
+ * @dev:		Device this mii_bus belongs to
+ * @bus:		the mii_bus associated with the device
+ *
+ * Free mii_bus allocated with devm_mdiobus_alloc_size().
+ */
+void devm_mdiobus_free(struct device *dev, struct mii_bus *bus)
+{
+	int rc;
+
+	rc = devres_release(dev, _devm_mdiobus_free,
+			    devm_mdiobus_match, bus);
+	WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_mdiobus_free);
+
 /**
  * mdiobus_release - mii_bus device release callback
  * @d: the target struct device that contains the mii_bus
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 24126c4..d7f5ef8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -195,6 +195,13 @@ static inline struct mii_bus *mdiobus_alloc(void)
 int mdiobus_register(struct mii_bus *bus);
 void mdiobus_unregister(struct mii_bus *bus);
 void mdiobus_free(struct mii_bus *bus);
+struct mii_bus *devm_mdiobus_alloc_size(struct device *dev, int sizeof_priv);
+static inline struct mii_bus *devm_mdiobus_alloc(struct device *dev)
+{
+	return devm_mdiobus_alloc_size(dev, 0);
+}
+
+void devm_mdiobus_free(struct device *dev, struct mii_bus *bus);
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
 int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
 int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
-- 
1.7.9.5

