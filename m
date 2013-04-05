Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663Ab3DET2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 15:28:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57932 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422631Ab3DET2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 15:28:20 -0400
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] nfc: Standardize logging style
Date: Fri,  5 Apr 2013 12:27:39 -0700
Message-Id: <d25e045d7b686272035452a8d458e1bfac6b416c.1365189658.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <1365180413.2075.5.camel@joe-AO722>
References: <1365180413.2075.5.camel@joe-AO722>
In-Reply-To: <cover.1365189658.git.joe@perches.com>
References: <cover.1365189658.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standardized styles to minimize coding defects.

Always use nfc_<level> where feasible.
Add \n to formats where appropriate.
Tyop "it it" correction.
Add #define pr_fmt where appropriate.
Remove function tracing logging messages.
Remove OOM messages.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/nfc/microread/i2c.c       | 32 +++++++++++---------------------
 drivers/nfc/microread/mei.c       | 20 +++++---------------
 drivers/nfc/microread/microread.c |  7 ++++---
 drivers/nfc/nfcwilink.c           |  2 +-
 drivers/nfc/pn533.c               |  7 +++----
 drivers/nfc/pn544/i2c.c           | 38 +++++++++++++++-----------------------
 drivers/nfc/pn544/pn544.c         | 13 +++++++------
 7 files changed, 46 insertions(+), 73 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 1010894..696e346 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -18,6 +18,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
@@ -95,12 +97,8 @@ static int check_crc(struct sk_buff *skb)
 		crc = crc ^ skb->data[i];
 
 	if (crc != skb->data[skb->len-1]) {
-		pr_err(MICROREAD_I2C_DRIVER_NAME
-		       ": CRC error 0x%x != 0x%x\n",
-		       crc, skb->data[skb->len-1]);
-
-		pr_info(DRIVER_DESC ": %s : BAD CRC\n", __func__);
-
+		pr_err("CRC error 0x%x != 0x%x\n", crc, skb->data[skb->len-1]);
+		pr_info("%s: BAD CRC\n", __func__);
 		return -EPERM;
 	}
 
@@ -160,18 +158,15 @@ static int microread_i2c_read(struct microread_i2c_phy *phy,
 	u8 tmp[MICROREAD_I2C_LLC_MAX_SIZE - 1];
 	struct i2c_client *client = phy->i2c_dev;
 
-	pr_debug("%s\n", __func__);
-
 	r = i2c_master_recv(client, &len, 1);
 	if (r != 1) {
-		dev_err(&client->dev, "cannot read len byte\n");
+		nfc_err(&client->dev, "cannot read len byte\n");
 		return -EREMOTEIO;
 	}
 
 	if ((len < MICROREAD_I2C_LLC_MIN_SIZE) ||
 	    (len > MICROREAD_I2C_LLC_MAX_SIZE)) {
-		dev_err(&client->dev, "invalid len byte\n");
-		pr_err("invalid len byte\n");
+		nfc_err(&client->dev, "invalid len byte\n");
 		r = -EBADMSG;
 		goto flush;
 	}
@@ -228,7 +223,6 @@ static irqreturn_t microread_i2c_irq_thread_fn(int irq, void *phy_id)
 	}
 
 	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "IRQ\n");
 
 	if (phy->hard_fault != 0)
 		return IRQ_HANDLED;
@@ -263,20 +257,18 @@ static int microread_i2c_probe(struct i2c_client *client,
 		dev_get_platdata(&client->dev);
 	int r;
 
-	dev_dbg(&client->dev, "client %p", client);
+	dev_dbg(&client->dev, "client %p\n", client);
 
 	if (!pdata) {
-		dev_err(&client->dev, "client %p: missing platform data",
+		nfc_err(&client->dev, "client %p: missing platform data\n",
 			client);
 		return -EINVAL;
 	}
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct microread_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		dev_err(&client->dev, "Can't allocate microread phy");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(client, phy);
 	phy->i2c_dev = client;
@@ -285,7 +277,7 @@ static int microread_i2c_probe(struct i2c_client *client,
 				 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 				 MICROREAD_I2C_DRIVER_NAME, phy);
 	if (r) {
-		dev_err(&client->dev, "Unable to register IRQ handler");
+		nfc_err(&client->dev, "Unable to register IRQ handler\n");
 		return r;
 	}
 
@@ -296,7 +288,7 @@ static int microread_i2c_probe(struct i2c_client *client,
 	if (r < 0)
 		goto err_irq;
 
-	dev_info(&client->dev, "Probed");
+	nfc_info(&client->dev, "Probed");
 
 	return 0;
 
@@ -310,8 +302,6 @@ static int microread_i2c_remove(struct i2c_client *client)
 {
 	struct microread_i2c_phy *phy = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
-
 	microread_remove(phy->hdev);
 
 	free_irq(client->irq, phy);
diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 13bde92..dbad24b 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -18,6 +18,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
@@ -77,8 +79,6 @@ static int microread_mei_enable(void *phy_id)
 {
 	struct microread_mei_phy *phy = phy_id;
 
-	pr_info(DRIVER_DESC ": %s\n", __func__);
-
 	phy->powered = 1;
 
 	return 0;
@@ -88,8 +88,6 @@ static void microread_mei_disable(void *phy_id)
 {
 	struct microread_mei_phy *phy = phy_id;
 
-	pr_info(DRIVER_DESC ": %s\n", __func__);
-
 	phy->powered = 0;
 }
 
@@ -155,20 +153,16 @@ static int microread_mei_probe(struct mei_device *device,
 	struct microread_mei_phy *phy;
 	int r;
 
-	pr_info("Probing NFC microread\n");
-
 	phy = kzalloc(sizeof(struct microread_mei_phy), GFP_KERNEL);
-	if (!phy) {
-		pr_err("Cannot allocate memory for microread mei phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	phy->device = device;
 	mei_set_clientdata(device, phy);
 
 	r = mei_register_event_cb(device, microread_event_cb, phy);
 	if (r) {
-		pr_err(MICROREAD_DRIVER_NAME ": event cb registration failed\n");
+		pr_err("event cb registration failed\n");
 		goto err_out;
 	}
 
@@ -190,8 +184,6 @@ static int microread_mei_remove(struct mei_device *device)
 {
 	struct microread_mei_phy *phy = mei_get_clientdata(device);
 
-	pr_info("Removing microread\n");
-
 	microread_remove(phy->hdev);
 
 	if (phy->powered)
@@ -223,11 +215,9 @@ static int microread_mei_init(void)
 {
 	int r;
 
-	pr_debug(DRIVER_DESC ": %s\n", __func__);
-
 	r = mei_driver_register(&microread_driver);
 	if (r) {
-		pr_err(MICROREAD_DRIVER_NAME ": driver registration failed\n");
+		pr_err("driver registration failed\n");
 		return r;
 	}
 
diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index 3420d83..2e24373 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -18,6 +18,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -546,7 +548,7 @@ exit:
 	kfree_skb(skb);
 
 	if (r)
-		pr_err("Failed to handle discovered target err=%d", r);
+		pr_err("Failed to handle discovered target err=%d\n", r);
 }
 
 static int microread_event_received(struct nfc_hci_dev *hdev, u8 gate,
@@ -656,7 +658,6 @@ int microread_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
 
 	info = kzalloc(sizeof(struct microread_info), GFP_KERNEL);
 	if (!info) {
-		pr_err("Cannot allocate memory for microread_info.\n");
 		r = -ENOMEM;
 		goto err_info_alloc;
 	}
@@ -688,7 +689,7 @@ int microread_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
 					     MICROREAD_CMD_TAILROOM,
 					     phy_payload);
 	if (!info->hdev) {
-		pr_err("Cannot allocate nfc hdev.\n");
+		pr_err("Cannot allocate nfc hdev\n");
 		r = -ENOMEM;
 		goto err_alloc_hdev;
 	}
diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index f58b390..9b259b1 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -173,7 +173,7 @@ static int nfcwilink_get_bts_file_name(struct nfcwilink *drv, char *file_name)
 	dev_dbg(&drv->pdev->dev, "wait_for_completion_timeout returned %ld\n",
 		comp_ret);
 	if (comp_ret == 0) {
-		dev_err(&drv->pdev->dev,
+		nfc_err(&drv->pdev->dev,
 			"timeout on wait_for_completion_timeout\n");
 		return -ETIMEDOUT;
 	}
diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 714b4ec..35a2753 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -554,7 +554,7 @@ static void pn533_recv_response(struct urb *urb)
 
 	if (!pn533_rx_frame_is_cmd_response(dev, in_frame)) {
 		nfc_err(&dev->interface->dev,
-			"It it not the response to the last command\n");
+			"It is not the response to the last command\n");
 		dev->wq_in_error = -EIO;
 		goto sched_wq;
 	}
@@ -1233,7 +1233,7 @@ static int pn533_target_found(struct pn533 *dev, u8 tg, u8 *tgdata,
 	struct nfc_target nfc_tgt;
 	int rc;
 
-	dev_dbg(&dev->interface->dev, "%s - modulation=%d\n",
+	dev_dbg(&dev->interface->dev, "%s: modulation=%d\n",
 		__func__, dev->poll_mod_curr);
 
 	if (tg != 1)
@@ -1723,8 +1723,7 @@ static int pn533_activate_target(struct nfc_dev *nfc_dev,
 	struct pn533 *dev = nfc_get_drvdata(nfc_dev);
 	int rc;
 
-	dev_dbg(&dev->interface->dev, "%s - protocol=%u\n",
-		__func__, protocol);
+	dev_dbg(&dev->interface->dev, "%s: protocol=%u\n", __func__, protocol);
 
 	if (dev->poll_mod_count) {
 		nfc_err(&dev->interface->dev,
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 8cf64c1..abc22e0 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -18,6 +18,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/crc-ccitt.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
@@ -85,8 +87,7 @@ static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 	char rset_cmd[] = { 0x05, 0xF9, 0x04, 0x00, 0xC3, 0xE5 };
 	int count = sizeof(rset_cmd);
 
-	pr_info(DRIVER_DESC ": %s\n", __func__);
-	dev_info(&phy->i2c_dev->dev, "Detecting nfc_en polarity\n");
+	nfc_info(&phy->i2c_dev->dev, "Detecting nfc_en polarity\n");
 
 	/* Disable fw download */
 	gpio_set_value(phy->gpio_fw, 0);
@@ -107,7 +108,7 @@ static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 			dev_dbg(&phy->i2c_dev->dev, "Sending reset cmd\n");
 			ret = i2c_master_send(phy->i2c_dev, rset_cmd, count);
 			if (ret == count) {
-				dev_info(&phy->i2c_dev->dev,
+				nfc_info(&phy->i2c_dev->dev,
 					 "nfc_en polarity : active %s\n",
 					 (polarity == 0 ? "low" : "high"));
 				goto out;
@@ -115,7 +116,7 @@ static void pn544_hci_i2c_platform_init(struct pn544_i2c_phy *phy)
 		}
 	}
 
-	dev_err(&phy->i2c_dev->dev,
+	nfc_err(&phy->i2c_dev->dev,
 		"Could not detect nfc_en polarity, fallback to active high\n");
 
 out:
@@ -126,8 +127,6 @@ static int pn544_hci_i2c_enable(void *phy_id)
 {
 	struct pn544_i2c_phy *phy = phy_id;
 
-	pr_info(DRIVER_DESC ": %s\n", __func__);
-
 	gpio_set_value(phy->gpio_fw, 0);
 	gpio_set_value(phy->gpio_en, phy->en_polarity);
 	usleep_range(10000, 15000);
@@ -141,8 +140,6 @@ static void pn544_hci_i2c_disable(void *phy_id)
 {
 	struct pn544_i2c_phy *phy = phy_id;
 
-	pr_info(DRIVER_DESC ": %s\n", __func__);
-
 	gpio_set_value(phy->gpio_fw, 0);
 	gpio_set_value(phy->gpio_en, !phy->en_polarity);
 	usleep_range(10000, 15000);
@@ -225,11 +222,9 @@ static int check_crc(u8 *buf, int buflen)
 	crc = ~crc;
 
 	if (buf[len - 2] != (crc & 0xff) || buf[len - 1] != (crc >> 8)) {
-		pr_err(PN544_HCI_I2C_DRIVER_NAME
-		       ": CRC error 0x%x != 0x%x 0x%x\n",
+		pr_err("CRC error 0x%x != 0x%x 0x%x\n",
 		       crc, buf[len - 1], buf[len - 2]);
-
-		pr_info(DRIVER_DESC ": %s : BAD CRC\n", __func__);
+		pr_info("%s: BAD CRC\n", __func__);
 		print_hex_dump(KERN_DEBUG, "crc: ", DUMP_PREFIX_NONE,
 			       16, 2, buf, buflen, false);
 		return -EPERM;
@@ -255,13 +250,13 @@ static int pn544_hci_i2c_read(struct pn544_i2c_phy *phy, struct sk_buff **skb)
 
 	r = i2c_master_recv(client, &len, 1);
 	if (r != 1) {
-		dev_err(&client->dev, "cannot read len byte\n");
+		nfc_err(&client->dev, "cannot read len byte\n");
 		return -EREMOTEIO;
 	}
 
 	if ((len < (PN544_HCI_I2C_LLC_MIN_SIZE - 1)) ||
 	    (len > (PN544_HCI_I2C_LLC_MAX_SIZE - 1))) {
-		dev_err(&client->dev, "invalid len byte\n");
+		nfc_err(&client->dev, "invalid len byte\n");
 		r = -EBADMSG;
 		goto flush;
 	}
@@ -372,35 +367,32 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 	dev_dbg(&client->dev, "IRQ: %d\n", client->irq);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		dev_err(&client->dev, "Need I2C_FUNC_I2C\n");
+		nfc_err(&client->dev, "Need I2C_FUNC_I2C\n");
 		return -ENODEV;
 	}
 
 	phy = devm_kzalloc(&client->dev, sizeof(struct pn544_i2c_phy),
 			   GFP_KERNEL);
-	if (!phy) {
-		dev_err(&client->dev,
-			"Cannot allocate memory for pn544 i2c phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	phy->i2c_dev = client;
 	i2c_set_clientdata(client, phy);
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL) {
-		dev_err(&client->dev, "No platform data\n");
+		nfc_err(&client->dev, "No platform data\n");
 		return -EINVAL;
 	}
 
 	if (pdata->request_resources == NULL) {
-		dev_err(&client->dev, "request_resources() missing\n");
+		nfc_err(&client->dev, "request_resources() missing\n");
 		return -EINVAL;
 	}
 
 	r = pdata->request_resources(client);
 	if (r) {
-		dev_err(&client->dev, "Cannot get platform resources\n");
+		nfc_err(&client->dev, "Cannot get platform resources\n");
 		return r;
 	}
 
@@ -414,7 +406,7 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
 				 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 				 PN544_HCI_I2C_DRIVER_NAME, phy);
 	if (r < 0) {
-		dev_err(&client->dev, "Unable to register IRQ handler\n");
+		nfc_err(&client->dev, "Unable to register IRQ handler\n");
 		goto err_rti;
 	}
 
diff --git a/drivers/nfc/pn544/pn544.c b/drivers/nfc/pn544/pn544.c
index 9c5f16e..a6c6b95 100644
--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -18,6 +18,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -395,7 +397,7 @@ static int pn544_hci_start_poll(struct nfc_hci_dev *hdev,
 	if ((im_protocols | tm_protocols) & NFC_PROTO_NFC_DEP_MASK) {
 		hdev->gb = nfc_get_local_general_bytes(hdev->ndev,
 							&hdev->gb_len);
-		pr_debug("generate local bytes %p", hdev->gb);
+		pr_debug("generate local bytes %p\n", hdev->gb);
 		if (hdev->gb == NULL || hdev->gb_len == 0) {
 			im_protocols &= ~NFC_PROTO_NFC_DEP_MASK;
 			tm_protocols &= ~NFC_PROTO_NFC_DEP_MASK;
@@ -692,7 +694,7 @@ static int pn544_hci_tm_send(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 static int pn544_hci_check_presence(struct nfc_hci_dev *hdev,
 				   struct nfc_target *target)
 {
-	pr_debug("supported protocol %d", target->supported_protocols);
+	pr_debug("supported protocol %d\b", target->supported_protocols);
 	if (target->supported_protocols & (NFC_PROTO_ISO14443_MASK |
 					NFC_PROTO_ISO14443_B_MASK)) {
 		return nfc_hci_send_cmd(hdev, target->hci_reader_gate,
@@ -732,7 +734,7 @@ static int pn544_hci_event_received(struct nfc_hci_dev *hdev, u8 gate, u8 event,
 	struct sk_buff *rgb_skb = NULL;
 	int r;
 
-	pr_debug("hci event %d", event);
+	pr_debug("hci event %d\n", event);
 	switch (event) {
 	case PN544_HCI_EVT_ACTIVATED:
 		if (gate == PN544_RF_READER_NFCIP1_INITIATOR_GATE) {
@@ -763,7 +765,7 @@ static int pn544_hci_event_received(struct nfc_hci_dev *hdev, u8 gate, u8 event,
 		}
 
 		if (skb->data[0] != 0) {
-			pr_debug("data0 %d", skb->data[0]);
+			pr_debug("data0 %d\n", skb->data[0]);
 			r = -EPROTO;
 			goto exit;
 		}
@@ -807,7 +809,6 @@ int pn544_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
 
 	info = kzalloc(sizeof(struct pn544_hci_info), GFP_KERNEL);
 	if (!info) {
-		pr_err("Cannot allocate memory for pn544_hci_info.\n");
 		r = -ENOMEM;
 		goto err_info_alloc;
 	}
@@ -841,7 +842,7 @@ int pn544_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
 					     phy_headroom + PN544_CMDS_HEADROOM,
 					     phy_tailroom, phy_payload);
 	if (!info->hdev) {
-		pr_err("Cannot allocate nfc hdev.\n");
+		pr_err("Cannot allocate nfc hdev\n");
 		r = -ENOMEM;
 		goto err_alloc_hdev;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

