Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3APPCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:02:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38900 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3APPCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:02:32 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <horms@verge.net.au>, <magnus.damm@gmail.com>, <cbou@mail.ru>,
        <dwmw2@infradead.org>, <alexander.shishkin@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <leoli@freescale.com>,
        <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <stern@rowland.harvard.edu>, <kishon@ti.com>
Subject: [RFC PATCH 1/6] usb: otg: Add an API to bind the USB controller and PHY
Date: Wed, 16 Jan 2013 20:30:57 +0530
Message-ID: <1358348462-27693-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358348462-27693-1-git-send-email-kishon@ti.com>
References: <1358348462-27693-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New platforms are added which has multiple PHY's (of same type) and
which has multiple USB controllers. The binding information has to be
present in the PHY library (otg.c) in order for it to return the
appropriate PHY whenever the USB controller request for the PHY. So
added a new API to pass the binding information. This API should be
called by platform specific initialization code.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/otg/otg.c   |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/phy.h |   22 ++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index a30c041..492ba2f 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -18,6 +18,7 @@
 #include <linux/usb/otg.h>
 
 static LIST_HEAD(phy_list);
+static LIST_HEAD(phy_bind_list);
 static DEFINE_SPINLOCK(phy_lock);
 
 static struct usb_phy *__usb_find_phy(struct list_head *list,
@@ -201,6 +202,42 @@ void usb_remove_phy(struct usb_phy *x)
 }
 EXPORT_SYMBOL(usb_remove_phy);
 
+/**
+ * usb_bind_phy - bind the phy and the controller that uses the phy
+ * @dev_name: the device name of the device that will bind to the phy
+ * @index: index to specify the port number
+ * @phy_dev_name: the device name of the phy
+ *
+ * Fills the phy_bind structure with the dev_name and phy_dev_name. This will
+ * be used when the phy driver registers the phy and when the controller
+ * requests this phy.
+ *
+ * To be used by platform specific initialization code.
+ */
+struct usb_phy_bind __init *usb_bind_phy(const char *dev_name, u8 index,
+				const char *phy_dev_name)
+{
+	struct usb_phy_bind *phy_bind;
+	unsigned long flags;
+
+	phy_bind = kzalloc(sizeof(*phy_bind), GFP_KERNEL);
+	if (!phy_bind) {
+		pr_err("phy_bind(): No memory for phy_bind");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	phy_bind->dev_name = dev_name;
+	phy_bind->phy_dev_name = phy_dev_name;
+	phy_bind->index = index;
+
+	spin_lock_irqsave(&phy_lock, flags);
+	list_add_tail(&phy_bind->list, &phy_bind_list);
+	spin_unlock_irqrestore(&phy_lock, flags);
+
+	return phy_bind;
+}
+EXPORT_SYMBOL_GPL(usb_bind_phy);
+
 const char *otg_state_string(enum usb_otg_state state)
 {
 	switch (state) {
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index a29ae1e..fbeab1a 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -106,6 +106,21 @@ struct usb_phy {
 			enum usb_device_speed speed);
 };
 
+/**
+ * struct usb_phy_bind - represent the binding for the phy
+ * @dev_name: the device name of the device that will bind to the phy
+ * @phy_dev_name: the device name of the phy
+ * @index: used if a single controller uses multiple phys
+ * @phy: reference to the phy
+ * @list: to maintain a linked list of the binding information
+ */
+struct usb_phy_bind {
+	const char	*dev_name;
+	const char	*phy_dev_name;
+	u8		index;
+	struct usb_phy	*phy;
+	struct list_head list;
+};
 
 /* for board-specific init logic */
 extern int usb_add_phy(struct usb_phy *, enum usb_phy_type type);
@@ -151,6 +166,8 @@ extern struct usb_phy *devm_usb_get_phy(struct device *dev,
 	enum usb_phy_type type);
 extern void usb_put_phy(struct usb_phy *);
 extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
+extern struct usb_phy_bind *usb_bind_phy(const char *dev_name, u8 index,
+				const char *phy_dev_name);
 #else
 static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
 {
@@ -171,6 +188,11 @@ static inline void devm_usb_put_phy(struct device *dev, struct usb_phy *x)
 {
 }
 
+static inline struct usb_phy_bind *usb_bind_phy(const char *dev_name, u8 index,
+				const char *phy_dev_name)
+{
+	return NULL;
+}
 #endif
 
 static inline int
-- 
1.7.9.5

