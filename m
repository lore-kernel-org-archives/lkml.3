Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBJC1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:27:47 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39579 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaBJCUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:17 -0500
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
Subject: [PATCH 10/24] Bluetooth: Verify dlci not in use before rfcomm_dev create
Date: Sun,  9 Feb 2014 20:59:10 -0500
Message-Id: <1391997564-1805-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one session/channel combination may be in use at any one
time. However, the failure does not occur until the tty is
opened (in rfcomm_dlc_open()).

Because these settings are actually bound at rfcomm device
creation (via RFCOMMCREATEDEV ioctl), validate and fail before
creating the rfcomm tty device.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/net/bluetooth/rfcomm.h |  1 +
 net/bluetooth/rfcomm/core.c    | 26 +++++++++++++++++++++++++-
 net/bluetooth/rfcomm/tty.c     |  8 ++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 6f3fbc5..79bb913 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -241,6 +241,7 @@ int  rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb);
 int  rfcomm_dlc_set_modem_status(struct rfcomm_dlc *d, u8 v24_sig);
 int  rfcomm_dlc_get_modem_status(struct rfcomm_dlc *d, u8 *v24_sig);
 void rfcomm_dlc_accept(struct rfcomm_dlc *d);
+struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel);
 
 #define rfcomm_dlc_lock(d)     spin_lock(&d->lock)
 #define rfcomm_dlc_unlock(d)   spin_unlock(&d->lock)
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index facd8a7..646b6ff 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -359,6 +359,11 @@ static struct rfcomm_dlc *rfcomm_dlc_get(struct rfcomm_session *s, u8 dlci)
 	return NULL;
 }
 
+static int rfcomm_check_channel(u8 channel)
+{
+	return channel < 1 || channel > 30;
+}
+
 static int __rfcomm_dlc_open(struct rfcomm_dlc *d, bdaddr_t *src, bdaddr_t *dst, u8 channel)
 {
 	struct rfcomm_session *s;
@@ -368,7 +373,7 @@ static int __rfcomm_dlc_open(struct rfcomm_dlc *d, bdaddr_t *src, bdaddr_t *dst,
 	BT_DBG("dlc %p state %ld %pMR -> %pMR channel %d",
 	       d, d->state, src, dst, channel);
 
-	if (channel < 1 || channel > 30)
+	if (rfcomm_check_channel(channel))
 		return -EINVAL;
 
 	if (d->state != BT_OPEN && d->state != BT_CLOSED)
@@ -513,6 +518,25 @@ no_session:
 	return r;
 }
 
+struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel)
+{
+	struct rfcomm_session *s;
+	struct rfcomm_dlc *dlc = NULL;
+	u8 dlci;
+
+	if (rfcomm_check_channel(channel))
+		return ERR_PTR(-EINVAL);
+
+	rfcomm_lock();
+	s = rfcomm_session_get(src, dst);
+	if (s) {
+		dlci = __dlci(!s->initiator, channel);
+		dlc = rfcomm_dlc_get(s, dlci);
+	}
+	rfcomm_unlock();
+	return dlc;
+}
+
 int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
 	int len = skb->len;
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 6ea08b0..a58d693 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -385,6 +385,14 @@ static int rfcomm_create_dev(struct sock *sk, void __user *arg)
 		dlc = rfcomm_pi(sk)->dlc;
 		rfcomm_dlc_hold(dlc);
 	} else {
+		/* Validate the channel is unused */
+		dlc = rfcomm_dlc_exists(&req.src, &req.dst, req.channel);
+		if (IS_ERR(dlc))
+			return PTR_ERR(dlc);
+		else if (dlc) {
+			rfcomm_dlc_put(dlc);
+			return -EBUSY;
+		}
 		dlc = rfcomm_dlc_alloc(GFP_KERNEL);
 		if (!dlc)
 			return -ENOMEM;
-- 
1.8.1.2

