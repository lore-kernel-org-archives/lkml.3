Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaBJCXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:23:16 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39708 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaBJCXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:11 -0500
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
Subject: [PATCH 07/24] Bluetooth: Release rfcomm_dev only once
Date: Sun,  9 Feb 2014 20:59:07 -0500
Message-Id: <1391997564-1805-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No logic prevents an rfcomm_dev from being released multiple
times. For example, if the rfcomm_dev ref count is large due
to pending tx, then multiple RFCOMMRELEASEDEV ioctls may
mistakenly release the rfcomm_dev too many times. Note that
concurrent ioctls are not required to create this condition.

Introduce RFCOMM_DEV_RELEASED status bit which guarantees the
rfcomm_dev can only be released once.

NB: Since the flags are exported to userspace, introduce the status
field to track state for which userspace should not be aware.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/net/bluetooth/rfcomm.h |  6 +++++-
 net/bluetooth/rfcomm/tty.c     | 11 +++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 486213a..29d9727 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -323,11 +323,15 @@ int  rfcomm_connect_ind(struct rfcomm_session *s, u8 channel,
 #define RFCOMMGETDEVINFO	_IOR('R', 211, int)
 #define RFCOMMSTEALDLC		_IOW('R', 220, int)
 
+/* rfcomm_dev.flags bit definitions */
 #define RFCOMM_REUSE_DLC      0
 #define RFCOMM_RELEASE_ONHUP  1
 #define RFCOMM_HANGUP_NOW     2
 #define RFCOMM_TTY_ATTACHED   3
-#define RFCOMM_TTY_RELEASED   4
+#define RFCOMM_DEFUNCT_BIT4   4	  /* don't reuse this bit - userspace visible */
+
+/* rfcomm_dev.status bit definitions */
+#define RFCOMM_DEV_RELEASED   0
 
 struct rfcomm_dev_req {
 	s16      dev_id;
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index b385d99..d9d4bc8 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -51,6 +51,8 @@ struct rfcomm_dev {
 	unsigned long		flags;
 	int			err;
 
+	unsigned long		status;		/* don't export to userspace */
+
 	bdaddr_t		src;
 	bdaddr_t		dst;
 	u8			channel;
@@ -423,6 +425,12 @@ static int rfcomm_release_dev(void __user *arg)
 		return -EPERM;
 	}
 
+	/* only release once */
+	if (test_and_set_bit(RFCOMM_DEV_RELEASED, &dev->status)) {
+		tty_port_put(&dev->port);
+		return -EALREADY;
+	}
+
 	if (req.flags & (1 << RFCOMM_HANGUP_NOW))
 		rfcomm_dlc_close(dev->dlc, 0);
 
@@ -433,8 +441,7 @@ static int rfcomm_release_dev(void __user *arg)
 		tty_kref_put(tty);
 	}
 
-	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags) &&
-	    !test_and_set_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
 		tty_port_put(&dev->port);
 
 	tty_port_put(&dev->port);
-- 
1.8.1.2

