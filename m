Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBJCWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:22:42 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39694 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaBJCWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:22:39 -0500
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
Subject: [PATCH 18/24] Bluetooth: Serialize RFCOMMCREATEDEV and RFCOMMRELEASEDEV ioctls
Date: Sun,  9 Feb 2014 20:59:18 -0500
Message-Id: <1391997564-1805-19-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least two different race conditions exist with multiple concurrent
RFCOMMCREATEDEV and RFCOMMRELEASEDEV ioctls:
* Multiple concurrent RFCOMMCREATEDEVs with RFCOMM_REUSE_DLC can
  mistakenly share the same DLC.
* RFCOMMRELEASEDEV can destruct the rfcomm_dev still being
  constructed by RFCOMMCREATEDEV.

Introduce rfcomm_ioctl_mutex to serialize these add/remove operations.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 4a38b54..ef27695 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -40,6 +40,7 @@
 #define RFCOMM_TTY_MAJOR 216		/* device node major id of the usb/bluetooth.c driver */
 #define RFCOMM_TTY_MINOR 0
 
+static DEFINE_MUTEX(rfcomm_ioctl_mutex);
 static struct tty_driver *rfcomm_tty_driver;
 
 struct rfcomm_dev {
@@ -373,7 +374,7 @@ static struct sk_buff *rfcomm_wmalloc(struct rfcomm_dev *dev, unsigned long size
 
 #define NOCAP_FLAGS ((1 << RFCOMM_REUSE_DLC) | (1 << RFCOMM_RELEASE_ONHUP))
 
-static int rfcomm_create_dev(struct sock *sk, void __user *arg)
+static int __rfcomm_create_dev(struct sock *sk, void __user *arg)
 {
 	struct rfcomm_dev_req req;
 	struct rfcomm_dlc *dlc;
@@ -423,7 +424,7 @@ static int rfcomm_create_dev(struct sock *sk, void __user *arg)
 	return id;
 }
 
-static int rfcomm_release_dev(void __user *arg)
+static int __rfcomm_release_dev(void __user *arg)
 {
 	struct rfcomm_dev_req req;
 	struct rfcomm_dev *dev;
@@ -466,6 +467,28 @@ static int rfcomm_release_dev(void __user *arg)
 	return 0;
 }
 
+static int rfcomm_create_dev(struct sock *sk, void __user *arg)
+{
+	int ret;
+
+	mutex_lock(&rfcomm_ioctl_mutex);
+	ret = __rfcomm_create_dev(sk, arg);
+	mutex_unlock(&rfcomm_ioctl_mutex);
+
+	return ret;
+}
+
+static int rfcomm_release_dev(void __user *arg)
+{
+	int ret;
+
+	mutex_lock(&rfcomm_ioctl_mutex);
+	ret = __rfcomm_release_dev(arg);
+	mutex_unlock(&rfcomm_ioctl_mutex);
+
+	return ret;
+}
+
 static int rfcomm_get_dev_list(void __user *arg)
 {
 	struct rfcomm_dev *dev;
-- 
1.8.1.2

