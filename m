Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaGAGcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:32:31 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:44337 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaGAGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:32:28 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH] staging: gdm72xx: clean up endianness conversions
Date: Mon, 30 Jun 2014 23:32:27 -0700
Message-Id: <1404196347-28460-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the endianness conversions in the gdm72xx driver:
- Directly use the generic byte-reordering macros for endianness
  conversion instead of some custom-defined macros.
- Convert values on the constant side instead of the variable side when
  appropriate.
- Add endianness annotations.

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_qos.c   |  4 +--
 drivers/staging/gdm72xx/gdm_sdio.c  |  5 +--
 drivers/staging/gdm72xx/gdm_usb.c   | 12 +++----
 drivers/staging/gdm72xx/gdm_wimax.c | 64 +++++++++++++++++++------------------
 drivers/staging/gdm72xx/gdm_wimax.h | 10 ------
 drivers/staging/gdm72xx/hci.h       |  6 ++--
 drivers/staging/gdm72xx/usb_boot.c  | 10 +++---
 7 files changed, 49 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index b08c8e1..af24c57 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -24,8 +24,6 @@
 #include "hci.h"
 #include "gdm_qos.h"
 
-#define B2H(x)	__be16_to_cpu(x)
-
 #define MAX_FREE_LIST_CNT		32
 static struct {
 	struct list_head head;
@@ -266,7 +264,7 @@ int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev)
 
 	tcph = (struct tcphdr *)iph + iph->ihl*4;
 
-	if (B2H(ethh->h_proto) == ETH_P_IP) {
+	if (ethh->h_proto == cpu_to_be16(ETH_P_IP)) {
 		if (qcb->qos_list_cnt && !qos_free_list.cnt) {
 			entry = alloc_qos_entry();
 			entry->skb = skb;
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 9d2de6f..a903173 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -275,8 +275,9 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
 	aggr_len = pos;
 
 	hci = (struct hci_s *)(tx->sdu_buf + TYPE_A_HEADER_SIZE);
-	hci->cmd_evt = H2B(WIMAX_TX_SDU_AGGR);
-	hci->length = H2B(aggr_len - TYPE_A_HEADER_SIZE - HCI_HEADER_SIZE);
+	hci->cmd_evt = cpu_to_be16(WIMAX_TX_SDU_AGGR);
+	hci->length = cpu_to_be16(aggr_len - TYPE_A_HEADER_SIZE -
+				  HCI_HEADER_SIZE);
 
 	spin_unlock_irqrestore(&tx->lock, flags);
 
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 971976c..5a6b86a 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -36,10 +36,6 @@ MODULE_DEVICE_TABLE(usb, id_table);
 
 #define GDM7205_PADDING		256
 
-#define H2B(x)		__cpu_to_be16(x)
-#define B2H(x)		__be16_to_cpu(x)
-#define DB2H(x)		__be32_to_cpu(x)
-
 #define DOWNLOAD_CONF_VALUE	0x21
 
 #ifdef CONFIG_WIMAX_GDM72XX_K_MODE
@@ -541,9 +537,9 @@ static int gdm_usb_probe(struct usb_interface *intf,
 	bConfigurationValue = usbdev->actconfig->desc.bConfigurationValue;
 
 	/*USB description is set up with Little-Endian*/
-	idVendor = L2H(usbdev->descriptor.idVendor);
-	idProduct = L2H(usbdev->descriptor.idProduct);
-	bcdDevice = L2H(usbdev->descriptor.bcdDevice);
+	idVendor = le16_to_cpu(usbdev->descriptor.idVendor);
+	idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
+	bcdDevice = le16_to_cpu(usbdev->descriptor.bcdDevice);
 
 	dev_info(&intf->dev, "Found GDM USB VID = 0x%04x PID = 0x%04x...\n",
 		 idVendor, idProduct);
@@ -626,7 +622,7 @@ static void gdm_usb_disconnect(struct usb_interface *intf)
 	phy_dev = usb_get_intfdata(intf);
 
 	/*USB description is set up with Little-Endian*/
-	idProduct = L2H(usbdev->descriptor.idProduct);
+	idProduct = le16_to_cpu(usbdev->descriptor.idProduct);
 
 	if (idProduct != EMERGENCY_PID &&
 	    bConfigurationValue != DOWNLOAD_CONF_VALUE &&
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 4148013..cc3e80a 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -166,6 +166,7 @@ static void dump_eth_packet(struct net_device *dev, const char *title,
 static inline int gdm_wimax_header(struct sk_buff **pskb)
 {
 	u16 buf[HCI_HEADER_SIZE / sizeof(u16)];
+	struct hci_s *hci = (struct hci_s *)buf;
 	struct sk_buff *skb = *pskb;
 
 	if (unlikely(skb_headroom(skb) < HCI_HEADER_SIZE)) {
@@ -181,8 +182,8 @@ static inline int gdm_wimax_header(struct sk_buff **pskb)
 	}
 
 	skb_push(skb, HCI_HEADER_SIZE);
-	buf[0] = H2B(WIMAX_TX_SDU);
-	buf[1] = H2B(skb->len - HCI_HEADER_SIZE);
+	hci->cmd_evt = cpu_to_be16(WIMAX_TX_SDU);
+	hci->length = cpu_to_be16(skb->len - HCI_HEADER_SIZE);
 	memcpy(skb->data, buf, HCI_HEADER_SIZE);
 
 	*pskb = skb;
@@ -409,7 +410,7 @@ static int gdm_wimax_set_config(struct net_device *dev, struct ifmap *map)
 static void __gdm_wimax_set_mac_addr(struct net_device *dev, char *mac_addr)
 {
 	u16 hci_pkt_buf[32 / sizeof(u16)];
-	u8 *pkt = (u8 *)&hci_pkt_buf[0];
+	struct hci_s *hci = (struct hci_s *)hci_pkt_buf;
 	struct nic *nic = netdev_priv(dev);
 
 	/* Since dev is registered as a ethernet device,
@@ -420,13 +421,13 @@ static void __gdm_wimax_set_mac_addr(struct net_device *dev, char *mac_addr)
 	/* Let lower layer know of this change by sending
 	 * SetInformation(MAC Address)
 	 */
-	hci_pkt_buf[0] = H2B(WIMAX_SET_INFO);	/* cmd_evt */
-	hci_pkt_buf[1] = H2B(8);			/* size */
-	pkt[4] = 0; /* T */
-	pkt[5] = 6; /* L */
-	memcpy(pkt + 6, mac_addr, dev->addr_len); /* V */
+	hci->cmd_evt = cpu_to_be16(WIMAX_SET_INFO);
+	hci->length = cpu_to_be16(8);
+	hci->data[0] = 0; /* T */
+	hci->data[1] = 6; /* L */
+	memcpy(&hci->data[2], mac_addr, dev->addr_len); /* V */
 
-	gdm_wimax_send(nic, pkt, HCI_HEADER_SIZE + 8);
+	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE + 8);
 }
 
 /* A driver function */
@@ -608,6 +609,7 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	struct hci_s *hci = (struct hci_s *)buf;
 	u16 len = 0;
 	u32 val = 0;
+	__be32 val_be32;
 
 	#define BIT_MULTI_CS	0
 	#define BIT_WIMAX		1
@@ -616,9 +618,9 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 
 	/* GetInformation mac address */
 	len = 0;
-	hci->cmd_evt = H2B(WIMAX_GET_INFO);
+	hci->cmd_evt = cpu_to_be16(WIMAX_GET_INFO);
 	hci->data[len++] = TLV_T(T_MAC_ADDRESS);
-	hci->length = H2B(len);
+	hci->length = cpu_to_be16(len);
 	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
 
 	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
@@ -631,16 +633,16 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 
 	/* Set capability */
 	len = 0;
-	hci->cmd_evt = H2B(WIMAX_SET_INFO);
+	hci->cmd_evt = cpu_to_be16(WIMAX_SET_INFO);
 	hci->data[len++] = TLV_T(T_CAPABILITY);
 	hci->data[len++] = TLV_L(T_CAPABILITY);
-	val = DH2B(val);
-	memcpy(&hci->data[len], &val, TLV_L(T_CAPABILITY));
+	val_be32 = cpu_to_be32(val);
+	memcpy(&hci->data[len], &val_be32, TLV_L(T_CAPABILITY));
 	len += TLV_L(T_CAPABILITY);
-	hci->length = H2B(len);
+	hci->length = cpu_to_be16(len);
 	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
 
-	netdev_info(dev, "GDM WiMax Set CAPABILITY: 0x%08X\n", DB2H(val));
+	netdev_info(dev, "GDM WiMax Set CAPABILITY: 0x%08X\n", val);
 }
 
 static int gdm_wimax_hci_get_tlv(u8 *buf, u8 *T, u16 *L, u8 **V)
@@ -650,7 +652,7 @@ static int gdm_wimax_hci_get_tlv(u8 *buf, u8 *T, u16 *L, u8 **V)
 
 	*T = buf[0];
 	if (buf[1] == 0x82) {
-		*L = B2H(__U82U16(&buf[2]));
+		*L = be16_to_cpu(__U82U16(&buf[2]));
 		next_pos = 1/*type*/+3/*len*/;
 	} else {
 		*L = buf[1];
@@ -670,8 +672,8 @@ static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf,
 	u16 cmd_evt, cmd_len;
 	int pos = HCI_HEADER_SIZE;
 
-	cmd_evt = B2H(*(u16 *)&buf[0]);
-	cmd_len = B2H(*(u16 *)&buf[2]);
+	cmd_evt = be16_to_cpup((const __be16 *)&buf[0]);
+	cmd_len = be16_to_cpup((const __be16 *)&buf[2]);
 
 	if (len < cmd_len + HCI_HEADER_SIZE) {
 		netdev_err(dev, "%s: invalid length [%d/%d]\n", __func__,
@@ -744,13 +746,13 @@ static void gdm_wimax_transmit_aggr_pkt(struct net_device *dev, char *buf,
 	while (len > 0) {
 		hci = (struct hci_s *)buf;
 
-		if (B2H(hci->cmd_evt) != WIMAX_RX_SDU) {
+		if (hci->cmd_evt != cpu_to_be16(WIMAX_RX_SDU)) {
 			netdev_err(dev, "Wrong cmd_evt(0x%04X)\n",
-				   B2H(hci->cmd_evt));
+				   be16_to_cpu(hci->cmd_evt));
 			break;
 		}
 
-		length = B2H(hci->length);
+		length = be16_to_cpu(hci->length);
 		gdm_wimax_netif_rx(dev, hci->data, length);
 
 		if (length & 0x3) {
@@ -775,8 +777,8 @@ static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
 	if (len == 0)
 		return;
 
-	cmd_evt = B2H(*(u16 *)&buf[0]);
-	cmd_len = B2H(*(u16 *)&buf[2]);
+	cmd_evt = be16_to_cpup((const __be16 *)&buf[0]);
+	cmd_len = be16_to_cpup((const __be16 *)&buf[2]);
 
 	if (len < cmd_len + HCI_HEADER_SIZE) {
 		if (len)
@@ -816,14 +818,14 @@ static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
 static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm)
 {
 	u16 buf[32 / sizeof(u16)];
-	u8 *hci_pkt_buf = (u8 *)&buf[0];
+	struct hci_s *hci = (struct hci_s *)buf;
 
 	/* Indicate updating fsm */
-	buf[0] = H2B(WIMAX_FSM_UPDATE);
-	buf[1] = H2B(sizeof(struct fsm_s));
-	memcpy(&hci_pkt_buf[HCI_HEADER_SIZE], fsm, sizeof(struct fsm_s));
+	hci->cmd_evt = cpu_to_be16(WIMAX_FSM_UPDATE);
+	hci->length = cpu_to_be16(sizeof(struct fsm_s));
+	memcpy(&hci->data[0], fsm, sizeof(struct fsm_s));
 
-	gdm_wimax_event_send(dev, hci_pkt_buf,
+	gdm_wimax_event_send(dev, (char *)hci,
 			     HCI_HEADER_SIZE + sizeof(struct fsm_s));
 }
 
@@ -836,8 +838,8 @@ static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up)
 	up_down = if_up ? WIMAX_IF_UP : WIMAX_IF_DOWN;
 
 	/* Indicate updating fsm */
-	hci->cmd_evt = H2B(WIMAX_IF_UPDOWN);
-	hci->length = H2B(sizeof(up_down));
+	hci->cmd_evt = cpu_to_be16(WIMAX_IF_UPDOWN);
+	hci->length = cpu_to_be16(sizeof(up_down));
 	hci->data[0] = up_down;
 
 	gdm_wimax_event_send(dev, (char *)hci, HCI_HEADER_SIZE+sizeof(up_down));
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index c640d2c..ae852dd 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -23,16 +23,6 @@
 
 #define DRIVER_VERSION		"3.2.3"
 
-#define H2L(x)		__cpu_to_le16(x)
-#define L2H(x)		__le16_to_cpu(x)
-#define DH2L(x)		__cpu_to_le32(x)
-#define DL2H(x)		__le32_to_cpu(x)
-
-#define H2B(x)		__cpu_to_be16(x)
-#define B2H(x)		__be16_to_cpu(x)
-#define DH2B(x)		__cpu_to_be32(x)
-#define DB2H(x)		__be32_to_cpu(x)
-
 struct phy_dev {
 	void			*priv_dev;
 	struct net_device	*netdev;
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index ff6941e..dd2931d 100644
--- a/drivers/staging/gdm72xx/hci.h
+++ b/drivers/staging/gdm72xx/hci.h
@@ -199,9 +199,9 @@
 #define T_DUPLEX_MODE			(0xdb	| (4 << 16))
 
 struct hci_s {
-	unsigned short cmd_evt;
-	unsigned short length;
-	unsigned char  data[0];
+	__be16	cmd_evt;
+	__be16	length;
+	u8	data[0];
 } __packed;
 
 #endif /* __GDM72XX_HCI_H__ */
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
index d59bac8..3ccc447 100644
--- a/drivers/staging/gdm72xx/usb_boot.c
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -36,8 +36,8 @@
 #define FW_FS			"ramdisk.jffs2"
 
 struct dn_header {
-	u32	magic_num;
-	u32	file_size;
+	__be32	magic_num;
+	__be32	file_size;
 };
 
 struct img_header {
@@ -69,7 +69,7 @@ static void array_le32_to_cpu(u32 *arr, int num)
 	int i;
 
 	for (i = 0; i < num; i++, arr++)
-		*arr = __le32_to_cpu(*arr);
+		le32_to_cpus(arr);
 }
 
 static u8 *tx_buf;
@@ -115,8 +115,8 @@ static int download_image(struct usb_device *usbdev,
 	u32 size;
 
 	size = ALIGN(img_len, DOWNLOAD_SIZE);
-	h.magic_num = __cpu_to_be32(magic_num);
-	h.file_size = __cpu_to_be32(size);
+	h.magic_num = cpu_to_be32(magic_num);
+	h.file_size = cpu_to_be32(size);
 
 	ret = gdm_wibro_send(usbdev, &h, sizeof(h));
 	if (ret < 0)
-- 
2.0.0.526.g5318336

