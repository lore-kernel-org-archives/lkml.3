Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbbAWPNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:13:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbbAWPNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666508983"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 7/8] phy: helpers for USB ULPI PHY registering
Date: Fri, 23 Jan 2015 17:12:57 +0200
Message-Id: <1422025978-178336-8-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ULPI PHYs need to be bound to their controllers with a
lookup. This adds helpers that the ULPI drivers can use to
do both, the registration of the PHY and the lookup, at the
same time.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/ulpi_phy.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 drivers/phy/ulpi_phy.h

diff --git a/drivers/phy/ulpi_phy.h b/drivers/phy/ulpi_phy.h
new file mode 100644
index 0000000..ac49fb6
--- /dev/null
+++ b/drivers/phy/ulpi_phy.h
@@ -0,0 +1,31 @@
+#include <linux/phy/phy.h>
+
+/**
+ * Helper that registers PHY for a ULPI device and adds a lookup for binding it
+ * and it's controller, which is always the parent.
+ */
+static inline struct phy
+*ulpi_phy_create(struct ulpi *ulpi, struct phy_ops *ops)
+{
+	struct phy *phy;
+	int ret;
+
+	phy = phy_create(&ulpi->dev, NULL, ops);
+	if (IS_ERR(phy))
+		return phy;
+
+	ret = phy_create_lookup(phy, "usb2-phy", dev_name(ulpi->dev.parent));
+	if (ret) {
+		phy_destroy(phy);
+		return ERR_PTR(ret);
+	}
+
+	return phy;
+}
+
+/* Remove a PHY that was created with ulpi_phy_create() and it's lookup. */
+static inline void ulpi_phy_destroy(struct ulpi *ulpi, struct phy *phy)
+{
+	phy_remove_lookup(phy, "usb2-phy", dev_name(ulpi->dev.parent));
+	phy_destroy(phy);
+}
-- 
2.1.4

