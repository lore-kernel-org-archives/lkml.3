Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaBJC1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:27:16 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39601 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaBJCUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:31 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 22/24] Bluetooth: Don't fail RFCOMM tty writes
Date: Sun,  9 Feb 2014 20:59:22 -0500
Message-Id: <1391997564-1805-23-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty driver api design prefers no-fail writes if the driver
write_room() method has previously indicated space is available
to accept writes. Since this is trivially possible for the
RFCOMM tty driver, do so.

Introduce rfcomm_dlc_send_noerror(), which queues but does not
schedule the krfcomm thread if the dlc is not yet connected
(and thus does not error based on the connection state).
The mtu size test is also unnecessary since the caller already
chunks the written data into mtu size.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/net/bluetooth/rfcomm.h |  1 +
 net/bluetooth/rfcomm/core.c    | 14 ++++++++++++++
 net/bluetooth/rfcomm/tty.c     | 23 +++++++----------------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 79bb913..11aca1e 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -238,6 +238,7 @@ int  rfcomm_dlc_open(struct rfcomm_dlc *d, bdaddr_t *src, bdaddr_t *dst,
 								u8 channel);
 int  rfcomm_dlc_close(struct rfcomm_dlc *d, int reason);
 int  rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb);
+void rfcomm_dlc_send_noerror(struct rfcomm_dlc *d, struct sk_buff *skb);
 int  rfcomm_dlc_set_modem_status(struct rfcomm_dlc *d, u8 v24_sig);
 int  rfcomm_dlc_get_modem_status(struct rfcomm_dlc *d, u8 *v24_sig);
 void rfcomm_dlc_accept(struct rfcomm_dlc *d);
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 8e14df6..112749c 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -568,6 +568,20 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 	return len;
 }
 
+void rfcomm_dlc_send_noerror(struct rfcomm_dlc *d, struct sk_buff *skb)
+{
+	int len = skb->len;
+
+	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+
+	rfcomm_make_uih(skb, d->addr);
+	skb_queue_tail(&d->tx_queue, skb);
+
+	if (d->state == BT_CONNECTED &&
+	    !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
+		rfcomm_schedule();
+}
+
 void __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index f6b9f0c..af775f3 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -374,14 +374,10 @@ static void rfcomm_set_owner_w(struct sk_buff *skb, struct rfcomm_dev *dev)
 
 static struct sk_buff *rfcomm_wmalloc(struct rfcomm_dev *dev, unsigned long size, gfp_t priority)
 {
-	if (atomic_read(&dev->wmem_alloc) < rfcomm_room(dev->dlc)) {
-		struct sk_buff *skb = alloc_skb(size, priority);
-		if (skb) {
-			rfcomm_set_owner_w(skb, dev);
-			return skb;
-		}
-	}
-	return NULL;
+	struct sk_buff *skb = alloc_skb(size, priority);
+	if (skb)
+		rfcomm_set_owner_w(skb, dev);
+	return skb;
 }
 
 /* ---- Device IOCTLs ---- */
@@ -786,7 +782,7 @@ static int rfcomm_tty_write(struct tty_struct *tty, const unsigned char *buf, in
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
 	struct rfcomm_dlc *dlc = dev->dlc;
 	struct sk_buff *skb;
-	int err = 0, sent = 0, size;
+	int sent = 0, size;
 
 	BT_DBG("tty %p count %d", tty, count);
 
@@ -794,7 +790,6 @@ static int rfcomm_tty_write(struct tty_struct *tty, const unsigned char *buf, in
 		size = min_t(uint, count, dlc->mtu);
 
 		skb = rfcomm_wmalloc(dev, size + RFCOMM_SKB_RESERVE, GFP_ATOMIC);
-
 		if (!skb)
 			break;
 
@@ -802,17 +797,13 @@ static int rfcomm_tty_write(struct tty_struct *tty, const unsigned char *buf, in
 
 		memcpy(skb_put(skb, size), buf + sent, size);
 
-		err = rfcomm_dlc_send(dlc, skb);
-		if (err < 0) {
-			kfree_skb(skb);
-			break;
-		}
+		rfcomm_dlc_send_noerror(dlc, skb);
 
 		sent  += size;
 		count -= size;
 	}
 
-	return sent ? sent : err;
+	return sent;
 }
 
 static int rfcomm_tty_write_room(struct tty_struct *tty)
-- 
1.8.1.2

