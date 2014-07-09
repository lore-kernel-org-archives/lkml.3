Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaGITon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:44:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39164 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbaGITol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:44:41 -0400
X-Sasl-enc: elVl8ujarEyG2Kf23M95aw6beQhdpe6IdRzMxL7x8AEP 1404935079
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, benchan@chromium.org
Subject: [PATCH v2] staging: gdm72xx: reorder functions and remove forward declarations
Date: Wed,  9 Jul 2014 20:44:18 +0100
Message-Id: <1404935058-6542-1-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20140709185658.GA20998@kroah.com>
References: <20140709185658.GA20998@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_sdio.c  |  77 ++++++++--------
 drivers/staging/gdm72xx/gdm_usb.c   |  87 +++++++++---------
 drivers/staging/gdm72xx/gdm_wimax.c | 179 +++++++++++++++++-------------------
 3 files changed, 164 insertions(+), 179 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index a903173..6a23bef 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -38,9 +38,6 @@
 #define TX_HZ		2000
 #define TX_INTERVAL	(1000000/TX_HZ)
 
-static int init_sdio(struct sdiowm_dev *sdev);
-static void release_sdio(struct sdiowm_dev *sdev);
-
 static struct sdio_tx *alloc_tx_struct(struct tx_cxt *tx)
 {
 	struct sdio_tx *t = kzalloc(sizeof(*t), GFP_ATOMIC);
@@ -124,6 +121,43 @@ static void put_rx_struct(struct rx_cxt *rx, struct sdio_rx *r)
 	list_add_tail(&r->list, &rx->free_list);
 }
 
+static void release_sdio(struct sdiowm_dev *sdev)
+{
+	struct tx_cxt	*tx = &sdev->tx;
+	struct rx_cxt	*rx = &sdev->rx;
+	struct sdio_tx	*t, *t_next;
+	struct sdio_rx	*r, *r_next;
+
+	kfree(tx->sdu_buf);
+
+	list_for_each_entry_safe(t, t_next, &tx->free_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->sdu_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	kfree(rx->rx_buf);
+
+	list_for_each_entry_safe(r, r_next, &rx->free_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+
+	list_for_each_entry_safe(r, r_next, &rx->req_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+}
+
 static int init_sdio(struct sdiowm_dev *sdev)
 {
 	int ret = 0, i;
@@ -176,43 +210,6 @@ fail:
 	return ret;
 }
 
-static void release_sdio(struct sdiowm_dev *sdev)
-{
-	struct tx_cxt	*tx = &sdev->tx;
-	struct rx_cxt	*rx = &sdev->rx;
-	struct sdio_tx	*t, *t_next;
-	struct sdio_rx	*r, *r_next;
-
-	kfree(tx->sdu_buf);
-
-	list_for_each_entry_safe(t, t_next, &tx->free_list, list) {
-		list_del(&t->list);
-		free_tx_struct(t);
-	}
-
-	list_for_each_entry_safe(t, t_next, &tx->sdu_list, list) {
-		list_del(&t->list);
-		free_tx_struct(t);
-	}
-
-	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
-		list_del(&t->list);
-		free_tx_struct(t);
-	}
-
-	kfree(rx->rx_buf);
-
-	list_for_each_entry_safe(r, r_next, &rx->free_list, list) {
-		list_del(&r->list);
-		free_rx_struct(r);
-	}
-
-	list_for_each_entry_safe(r, r_next, &rx->req_list, list) {
-		list_del(&r->list);
-		free_rx_struct(r);
-	}
-}
-
 static void send_sdio_pkt(struct sdio_func *func, u8 *data, int len)
 {
 	int n, blocks, ret, remain;
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 5a6b86a..45b3dda 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -49,9 +49,6 @@ static int k_mode_stop;
 
 #endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
 
-static int init_usb(struct usbwm_dev *udev);
-static void release_usb(struct usbwm_dev *udev);
-
 static struct usb_tx *alloc_tx_struct(struct tx_cxt *tx)
 {
 	struct usb_tx *t = kzalloc(sizeof(*t), GFP_ATOMIC);
@@ -160,6 +157,48 @@ static void put_rx_struct(struct rx_cxt *rx, struct usb_rx *r)
 	list_move(&r->list, &rx->free_list);
 }
 
+static void release_usb(struct usbwm_dev *udev)
+{
+	struct tx_cxt *tx = &udev->tx;
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_tx *t, *t_next;
+	struct usb_rx *r, *r_next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	list_for_each_entry_safe(t, t_next, &tx->sdu_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->free_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	spin_lock_irqsave(&rx->lock, flags);
+
+	list_for_each_entry_safe(r, r_next, &rx->free_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+
+	list_for_each_entry_safe(r, r_next, &rx->used_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+
+	spin_unlock_irqrestore(&rx->lock, flags);
+}
+
 static int init_usb(struct usbwm_dev *udev)
 {
 	int ret = 0, i;
@@ -210,48 +249,6 @@ fail:
 	return ret;
 }
 
-static void release_usb(struct usbwm_dev *udev)
-{
-	struct tx_cxt *tx = &udev->tx;
-	struct rx_cxt *rx = &udev->rx;
-	struct usb_tx *t, *t_next;
-	struct usb_rx *r, *r_next;
-	unsigned long flags;
-
-	spin_lock_irqsave(&tx->lock, flags);
-
-	list_for_each_entry_safe(t, t_next, &tx->sdu_list, list) {
-		list_del(&t->list);
-		free_tx_struct(t);
-	}
-
-	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
-		list_del(&t->list);
-		free_tx_struct(t);
-	}
-
-	list_for_each_entry_safe(t, t_next, &tx->free_list, list) {
-		list_del(&t->list);
-		free_tx_struct(t);
-	}
-
-	spin_unlock_irqrestore(&tx->lock, flags);
-
-	spin_lock_irqsave(&rx->lock, flags);
-
-	list_for_each_entry_safe(r, r_next, &rx->free_list, list) {
-		list_del(&r->list);
-		free_rx_struct(r);
-	}
-
-	list_for_each_entry_safe(r, r_next, &rx->used_list, list) {
-		list_del(&r->list);
-		free_rx_struct(r);
-	}
-
-	spin_unlock_irqrestore(&rx->lock, flags);
-}
-
 static void __gdm_usb_send_complete(struct urb *urb)
 {
 	struct usb_tx *t = urb->context;
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 0f71d41..82fc95f 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -41,12 +41,6 @@ struct evt_entry {
 	int	size;
 };
 
-static void __gdm_wimax_event_send(struct work_struct *work);
-static inline struct evt_entry *alloc_event_entry(void);
-static inline void free_event_entry(struct evt_entry *e);
-static struct evt_entry *get_event_entry(void);
-static void put_event_entry(struct evt_entry *e);
-
 static struct {
 	int ref_cnt;
 	struct sock *sock;
@@ -58,9 +52,6 @@ static struct {
 
 static u8 gdm_wimax_macaddr[6] = {0x00, 0x0a, 0x3b, 0xf0, 0x01, 0x30};
 
-static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm);
-static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up);
-
 static const char *get_protocol_name(u16 protocol)
 {
 	static char buf[32];
@@ -190,6 +181,37 @@ static inline int gdm_wimax_header(struct sk_buff **pskb)
 	return 0;
 }
 
+static inline struct evt_entry *alloc_event_entry(void)
+{
+	return kmalloc(sizeof(struct evt_entry), GFP_ATOMIC);
+}
+
+static inline void free_event_entry(struct evt_entry *e)
+{
+	kfree(e);
+}
+
+static struct evt_entry *get_event_entry(void)
+{
+	struct evt_entry *e;
+
+	if (list_empty(&wm_event.freeq)) {
+		e = alloc_event_entry();
+	} else {
+		e = list_entry(wm_event.freeq.next, struct evt_entry, list);
+		list_del(&e->list);
+	}
+
+	return e;
+}
+
+static void put_event_entry(struct evt_entry *e)
+{
+	BUG_ON(!e);
+
+	list_add_tail(&e->list, &wm_event.freeq);
+}
+
 static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 				int len)
 {
@@ -204,6 +226,30 @@ static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
 	gdm_wimax_send(nic, msg, len);
 }
 
+static void __gdm_wimax_event_send(struct work_struct *work)
+{
+	int idx;
+	unsigned long flags;
+	struct evt_entry *e;
+
+	spin_lock_irqsave(&wm_event.evt_lock, flags);
+
+	while (!list_empty(&wm_event.evtq)) {
+		e = list_entry(wm_event.evtq.next, struct evt_entry, list);
+		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+
+		if (sscanf(e->dev->name, "wm%d", &idx) == 1)
+			netlink_send(wm_event.sock, idx, 0, e->evt_data,
+				     e->size);
+
+		spin_lock_irqsave(&wm_event.evt_lock, flags);
+		list_del(&e->list);
+		put_event_entry(e);
+	}
+
+	spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+}
+
 static int gdm_wimax_event_init(void)
 {
 	if (!wm_event.ref_cnt) {
@@ -249,61 +295,6 @@ static void gdm_wimax_event_exit(void)
 	}
 }
 
-static inline struct evt_entry *alloc_event_entry(void)
-{
-	return kmalloc(sizeof(struct evt_entry), GFP_ATOMIC);
-}
-
-static inline void free_event_entry(struct evt_entry *e)
-{
-	kfree(e);
-}
-
-static struct evt_entry *get_event_entry(void)
-{
-	struct evt_entry *e;
-
-	if (list_empty(&wm_event.freeq)) {
-		e = alloc_event_entry();
-	} else {
-		e = list_entry(wm_event.freeq.next, struct evt_entry, list);
-		list_del(&e->list);
-	}
-
-	return e;
-}
-
-static void put_event_entry(struct evt_entry *e)
-{
-	BUG_ON(!e);
-
-	list_add_tail(&e->list, &wm_event.freeq);
-}
-
-static void __gdm_wimax_event_send(struct work_struct *work)
-{
-	int idx;
-	unsigned long flags;
-	struct evt_entry *e;
-
-	spin_lock_irqsave(&wm_event.evt_lock, flags);
-
-	while (!list_empty(&wm_event.evtq)) {
-		e = list_entry(wm_event.evtq.next, struct evt_entry, list);
-		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
-
-		if (sscanf(e->dev->name, "wm%d", &idx) == 1)
-			netlink_send(wm_event.sock, idx, 0, e->evt_data,
-				     e->size);
-
-		spin_lock_irqsave(&wm_event.evt_lock, flags);
-		list_del(&e->list);
-		put_event_entry(e);
-	}
-
-	spin_unlock_irqrestore(&wm_event.evt_lock, flags);
-}
-
 static int gdm_wimax_event_send(struct net_device *dev, char *buf, int size)
 {
 	struct evt_entry *e;
@@ -433,6 +424,22 @@ static int gdm_wimax_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
+static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up)
+{
+	u16 buf[32 / sizeof(u16)];
+	struct hci_s *hci = (struct hci_s *)buf;
+	unsigned char up_down;
+
+	up_down = if_up ? WIMAX_IF_UP : WIMAX_IF_DOWN;
+
+	/* Indicate updating fsm */
+	hci->cmd_evt = cpu_to_be16(WIMAX_IF_UPDOWN);
+	hci->length = cpu_to_be16(sizeof(up_down));
+	hci->data[0] = up_down;
+
+	gdm_wimax_event_send(dev, (char *)hci, HCI_HEADER_SIZE+sizeof(up_down));
+}
+
 static int gdm_wimax_open(struct net_device *dev)
 {
 	struct nic *nic = netdev_priv(dev);
@@ -515,6 +522,20 @@ static void gdm_wimax_cleanup_ioctl(struct net_device *dev)
 		kdelete(&nic->sdk_data[i].buf);
 }
 
+static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm)
+{
+	u16 buf[32 / sizeof(u16)];
+	struct hci_s *hci = (struct hci_s *)buf;
+
+	/* Indicate updating fsm */
+	hci->cmd_evt = cpu_to_be16(WIMAX_FSM_UPDATE);
+	hci->length = cpu_to_be16(sizeof(struct fsm_s));
+	memcpy(&hci->data[0], fsm, sizeof(struct fsm_s));
+
+	gdm_wimax_event_send(dev, (char *)hci,
+			     HCI_HEADER_SIZE + sizeof(struct fsm_s));
+}
+
 static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
 {
 	struct nic *nic = netdev_priv(dev);
@@ -794,36 +815,6 @@ static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
 	}
 }
 
-static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm)
-{
-	u16 buf[32 / sizeof(u16)];
-	struct hci_s *hci = (struct hci_s *)buf;
-
-	/* Indicate updating fsm */
-	hci->cmd_evt = cpu_to_be16(WIMAX_FSM_UPDATE);
-	hci->length = cpu_to_be16(sizeof(struct fsm_s));
-	memcpy(&hci->data[0], fsm, sizeof(struct fsm_s));
-
-	gdm_wimax_event_send(dev, (char *)hci,
-			     HCI_HEADER_SIZE + sizeof(struct fsm_s));
-}
-
-static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up)
-{
-	u16 buf[32 / sizeof(u16)];
-	struct hci_s *hci = (struct hci_s *)buf;
-	unsigned char up_down;
-
-	up_down = if_up ? WIMAX_IF_UP : WIMAX_IF_DOWN;
-
-	/* Indicate updating fsm */
-	hci->cmd_evt = cpu_to_be16(WIMAX_IF_UPDOWN);
-	hci->length = cpu_to_be16(sizeof(up_down));
-	hci->data[0] = up_down;
-
-	gdm_wimax_event_send(dev, (char *)hci, HCI_HEADER_SIZE+sizeof(up_down));
-}
-
 static void rx_complete(void *arg, void *data, int len)
 {
 	struct nic *nic = arg;
-- 
1.8.4

