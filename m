Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985AbaD2Sid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:38:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964962AbaD2Sia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:38:30 -0400
Date: Tue, 29 Apr 2014 20:38:34 +0200
From: Libor Pechacek <lpechacek@suse.cz>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Cho <acho@suse.com>
Subject: [PATCH] rfcomm: Convert spinlocks into mutexes
Message-ID: <20140429183834.GA6076@fmn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling CONFIG_DEBUG_ATOMIC_SLEEP has shown that some rfcomm functions
acquiring spinlocks call sleeping locks further in the chain.  Converting
the offending spinlocks into mutexes makes sleeping safe.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
---
 include/net/bluetooth/rfcomm.h |  6 +++---
 net/bluetooth/rfcomm/core.c    |  2 +-
 net/bluetooth/rfcomm/tty.c     | 20 ++++++++++----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 2611cc389d7d..578b83127af1 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -173,7 +173,7 @@ struct rfcomm_dlc {
 	struct sk_buff_head   tx_queue;
 	struct timer_list     timer;
 
-	spinlock_t    lock;
+	struct mutex  lock;
 	unsigned long state;
 	unsigned long flags;
 	atomic_t      refcnt;
@@ -244,8 +244,8 @@ int  rfcomm_dlc_get_modem_status(struct rfcomm_dlc *d, u8 *v24_sig);
 void rfcomm_dlc_accept(struct rfcomm_dlc *d);
 struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel);
 
-#define rfcomm_dlc_lock(d)     spin_lock(&d->lock)
-#define rfcomm_dlc_unlock(d)   spin_unlock(&d->lock)
+#define rfcomm_dlc_lock(d)     mutex_lock(&d->lock)
+#define rfcomm_dlc_unlock(d)   mutex_unlock(&d->lock)
 
 static inline void rfcomm_dlc_hold(struct rfcomm_dlc *d)
 {
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index cf620260affa..754b6fe4f742 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -307,7 +307,7 @@ struct rfcomm_dlc *rfcomm_dlc_alloc(gfp_t prio)
 	setup_timer(&d->timer, rfcomm_dlc_timeout, (unsigned long)d);
 
 	skb_queue_head_init(&d->tx_queue);
-	spin_lock_init(&d->lock);
+	mutex_init(&d->lock);
 	atomic_set(&d->refcnt, 1);
 
 	rfcomm_dlc_clear_state(d);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 403ec09f480a..8e385a0ae60e 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -70,7 +70,7 @@ struct rfcomm_dev {
 };
 
 static LIST_HEAD(rfcomm_dev_list);
-static DEFINE_SPINLOCK(rfcomm_dev_lock);
+static DEFINE_MUTEX(rfcomm_dev_lock);
 
 static void rfcomm_dev_data_ready(struct rfcomm_dlc *dlc, struct sk_buff *skb);
 static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err);
@@ -96,9 +96,9 @@ static void rfcomm_dev_destruct(struct tty_port *port)
 	if (dev->tty_dev)
 		tty_unregister_device(rfcomm_tty_driver, dev->id);
 
-	spin_lock(&rfcomm_dev_lock);
+	mutex_lock(&rfcomm_dev_lock);
 	list_del(&dev->list);
-	spin_unlock(&rfcomm_dev_lock);
+	mutex_unlock(&rfcomm_dev_lock);
 
 	kfree(dev);
 
@@ -161,14 +161,14 @@ static struct rfcomm_dev *rfcomm_dev_get(int id)
 {
 	struct rfcomm_dev *dev;
 
-	spin_lock(&rfcomm_dev_lock);
+	mutex_lock(&rfcomm_dev_lock);
 
 	dev = __rfcomm_dev_lookup(id);
 
 	if (dev && !tty_port_get(&dev->port))
 		dev = NULL;
 
-	spin_unlock(&rfcomm_dev_lock);
+	mutex_unlock(&rfcomm_dev_lock);
 
 	return dev;
 }
@@ -224,7 +224,7 @@ static struct rfcomm_dev *__rfcomm_dev_add(struct rfcomm_dev_req *req,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock(&rfcomm_dev_lock);
+	mutex_lock(&rfcomm_dev_lock);
 
 	if (req->dev_id < 0) {
 		dev->id = 0;
@@ -305,11 +305,11 @@ static struct rfcomm_dev *__rfcomm_dev_add(struct rfcomm_dev_req *req,
 	   holds reference to this module. */
 	__module_get(THIS_MODULE);
 
-	spin_unlock(&rfcomm_dev_lock);
+	mutex_unlock(&rfcomm_dev_lock);
 	return dev;
 
 out:
-	spin_unlock(&rfcomm_dev_lock);
+	mutex_unlock(&rfcomm_dev_lock);
 	kfree(dev);
 	return ERR_PTR(err);
 }
@@ -524,7 +524,7 @@ static int rfcomm_get_dev_list(void __user *arg)
 
 	di = dl->dev_info;
 
-	spin_lock(&rfcomm_dev_lock);
+	mutex_lock(&rfcomm_dev_lock);
 
 	list_for_each_entry(dev, &rfcomm_dev_list, list) {
 		if (!tty_port_get(&dev->port))
@@ -540,7 +540,7 @@ static int rfcomm_get_dev_list(void __user *arg)
 			break;
 	}
 
-	spin_unlock(&rfcomm_dev_lock);
+	mutex_unlock(&rfcomm_dev_lock);
 
 	dl->dev_num = n;
 	size = sizeof(*dl) + n * sizeof(*di);
-- 
1.7.12.4

