Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaHMJWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:22:35 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56221 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaHMJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:22:33 -0400
Date: Wed, 13 Aug 2014 14:52:27 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] bluetooth/dtl1_cs: Remove typedefs nsh_t and dtl1_info_t
Message-ID: <20140813092227.GA3221@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedefs for nsh_t and
dtl1_info_t. Also, the name of the struct is changed to drop the _t,
to make the name look less typedef-like.

The following Coccinelle semantic patch detects the case for dtl1_info_t
and a similar patch finds the nsh_t case:

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/bluetooth/dtl1_cs.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 2bd8fad..78e10f0 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -62,7 +62,7 @@ MODULE_LICENSE("GPL");
 /* ======================== Local structures ======================== */
 
 
-typedef struct dtl1_info_t {
+struct dtl1_info {
 	struct pcmcia_device *p_dev;
 
 	struct hci_dev *hdev;
@@ -78,7 +78,7 @@ typedef struct dtl1_info_t {
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-} dtl1_info_t;
+};
 
 
 static int dtl1_config(struct pcmcia_device *link);
@@ -94,11 +94,11 @@ static int dtl1_config(struct pcmcia_device *link);
 #define RECV_WAIT_DATA  1
 
 
-typedef struct {
+struct nsh {
 	u8 type;
 	u8 zero;
 	u16 len;
-} __packed nsh_t;	/* Nokia Specific Header */
+} __packed;	/* Nokia Specific Header */
 
 #define NSHL  4				/* Nokia Specific Header Length */
 
@@ -126,7 +126,7 @@ static int dtl1_write(unsigned int iobase, int fifo_size, __u8 *buf, int len)
 }
 
 
-static void dtl1_write_wakeup(dtl1_info_t *info)
+static void dtl1_write_wakeup(struct dtl1_info *info)
 {
 	if (!info) {
 		BT_ERR("Unknown device");
@@ -176,7 +176,7 @@ static void dtl1_write_wakeup(dtl1_info_t *info)
 }
 
 
-static void dtl1_control(dtl1_info_t *info, struct sk_buff *skb)
+static void dtl1_control(struct dtl1_info *info, struct sk_buff *skb)
 {
 	u8 flowmask = *(u8 *)skb->data;
 	int i;
@@ -199,10 +199,10 @@ static void dtl1_control(dtl1_info_t *info, struct sk_buff *skb)
 }
 
 
-static void dtl1_receive(dtl1_info_t *info)
+static void dtl1_receive(struct dtl1_info *info)
 {
 	unsigned int iobase;
-	nsh_t *nsh;
+	struct nsh *nsh;
 	int boguscount = 0;
 
 	if (!info) {
@@ -227,7 +227,7 @@ static void dtl1_receive(dtl1_info_t *info)
 		}
 
 		*skb_put(info->rx_skb, 1) = inb(iobase + UART_RX);
-		nsh = (nsh_t *)info->rx_skb->data;
+		nsh = (struct nsh *)info->rx_skb->data;
 
 		info->rx_count--;
 
@@ -287,7 +287,7 @@ static void dtl1_receive(dtl1_info_t *info)
 
 static irqreturn_t dtl1_interrupt(int irq, void *dev_inst)
 {
-	dtl1_info_t *info = dev_inst;
+	struct dtl1_info *info = dev_inst;
 	unsigned int iobase;
 	unsigned char msr;
 	int boguscount = 0;
@@ -365,7 +365,7 @@ static int dtl1_hci_open(struct hci_dev *hdev)
 
 static int dtl1_hci_flush(struct hci_dev *hdev)
 {
-	dtl1_info_t *info = hci_get_drvdata(hdev);
+	struct dtl1_info *info = hci_get_drvdata(hdev);
 
 	/* Drop TX queue */
 	skb_queue_purge(&(info->txq));
@@ -387,9 +387,9 @@ static int dtl1_hci_close(struct hci_dev *hdev)
 
 static int dtl1_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	dtl1_info_t *info = hci_get_drvdata(hdev);
+	struct dtl1_info *info = hci_get_drvdata(hdev);
 	struct sk_buff *s;
-	nsh_t nsh;
+	struct nsh nsh;
 
 	switch (bt_cb(skb)->pkt_type) {
 	case HCI_COMMAND_PKT:
@@ -436,7 +436,7 @@ static int dtl1_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 /* ======================== Card services HCI interaction ======================== */
 
 
-static int dtl1_open(dtl1_info_t *info)
+static int dtl1_open(struct dtl1_info *info)
 {
 	unsigned long flags;
 	unsigned int iobase = info->p_dev->resource[0]->start;
@@ -505,7 +505,7 @@ static int dtl1_open(dtl1_info_t *info)
 }
 
 
-static int dtl1_close(dtl1_info_t *info)
+static int dtl1_close(struct dtl1_info *info)
 {
 	unsigned long flags;
 	unsigned int iobase = info->p_dev->resource[0]->start;
@@ -534,7 +534,7 @@ static int dtl1_close(dtl1_info_t *info)
 
 static int dtl1_probe(struct pcmcia_device *link)
 {
-	dtl1_info_t *info;
+	struct dtl1_info *info;
 
 	/* Create new info device */
 	info = devm_kzalloc(&link->dev, sizeof(*info), GFP_KERNEL);
@@ -552,7 +552,7 @@ static int dtl1_probe(struct pcmcia_device *link)
 
 static void dtl1_detach(struct pcmcia_device *link)
 {
-	dtl1_info_t *info = link->priv;
+	struct dtl1_info *info = link->priv;
 
 	dtl1_close(info);
 	pcmcia_disable_device(link);
@@ -571,7 +571,7 @@ static int dtl1_confcheck(struct pcmcia_device *p_dev, void *priv_data)
 
 static int dtl1_config(struct pcmcia_device *link)
 {
-	dtl1_info_t *info = link->priv;
+	struct dtl1_info *info = link->priv;
 	int ret;
 
 	/* Look for a generic full-sized window */
-- 
1.9.1

