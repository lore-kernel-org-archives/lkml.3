Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbaKAAQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:16:22 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48708 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaKAAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:16:19 -0400
Date: Sat, 1 Nov 2014 02:16:14 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: ursula.braun@de.ibm.com, blaschka@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        opw-kernel@googlegroups.com
Subject: [PATCH v3] drivers: s390: net: ctcm: migrate variables to handle
 y2038 problem
Message-ID: <20141101001614.GA9494@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is concerned with migrating the time variables for the s390
network driver. The changes handle the y2038 problem where timespec will
overflow in the year 2038. timespec was replaced by unsigned long and
all time variables get their values from the jiffies global variable.
This was done for the sake of speed and efficiency.

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
---
v1: Arnd has advised me to provide you with options for time
    calculation. The first option: "accuracy" is used in this
    patch. The second option: "speed" can be done through
    jiffies.

v2: Moved on to the speed option. Let me know if I explicitly
    need to include the jiffies header. The module compiles with
    no problems on my side.

v3: Handled the error pointed out by Ursula. The current version
    does not handle overflows. There are two solutions for this.
    The first is to use jiffies_64 since s/390 is a 64-bit
    architecture after all. The second is to use wrapper functions
    like time_before and time_after. Two files were added too. 
    They are: ctcm_main.c and netiucv.c. This patch could be sent
    as a patchset in its final version for convenience. 

 drivers/s390/net/ctcm_fsms.c | 19 ++++++++-----------
 drivers/s390/net/ctcm_main.c |  5 +++--
 drivers/s390/net/ctcm_main.h |  4 +++-
 drivers/s390/net/netiucv.c   |  8 +++++---
 4 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index fb92524..86ed7bf 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 #include <linux/signal.h>
 #include <linux/string.h>
@@ -251,13 +252,11 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 	int first = 1;
 	int i;
 	unsigned long duration;
-	struct timespec done_stamp = current_kernel_time(); /* xtime */
+	unsigned long done_stamp = jiffies;
 
 	CTCM_PR_DEBUG("%s(%s): %s\n", __func__, ch->id, dev->name);
 
-	duration =
-	    (done_stamp.tv_sec - ch->prof.send_stamp.tv_sec) * 1000000 +
-	    (done_stamp.tv_nsec - ch->prof.send_stamp.tv_nsec) / 1000;
+	duration =  jiffies_to_usecs(done_stamp - ch->prof.send_stamp);
 	if (duration > ch->prof.tx_time)
 		ch->prof.tx_time = duration;
 
@@ -307,7 +306,7 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 		spin_unlock(&ch->collect_lock);
 		ch->ccw[1].count = ch->trans_skb->len;
 		fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
-		ch->prof.send_stamp = current_kernel_time(); /* xtime */
+		ch->prof.send_stamp = jiffies;
 		rc = ccw_device_start(ch->cdev, &ch->ccw[0],
 						(unsigned long)ch, 0xff, 0);
 		ch->prof.doios_multi++;
@@ -1229,14 +1228,12 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 	int		rc;
 	struct th_header *header;
 	struct pdu	*p_header;
-	struct timespec done_stamp = current_kernel_time(); /* xtime */
+	unsigned long done_stamp = jiffies;
 
 	CTCM_PR_DEBUG("Enter %s: %s cp:%i\n",
 			__func__, dev->name, smp_processor_id());
 
-	duration =
-		(done_stamp.tv_sec - ch->prof.send_stamp.tv_sec) * 1000000 +
-		(done_stamp.tv_nsec - ch->prof.send_stamp.tv_nsec) / 1000;
+	duration =  jiffies_to_usecs(done_stamp - ch->prof.send_stamp);
 	if (duration > ch->prof.tx_time)
 		ch->prof.tx_time = duration;
 
@@ -1361,7 +1358,7 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 
 	ch->ccw[1].count = ch->trans_skb->len;
 	fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ch->prof.send_stamp = jiffies;
 	if (do_debug_ccw)
 		ctcmpc_dumpit((char *)&ch->ccw[0], sizeof(struct ccw1) * 3);
 	rc = ccw_device_start(ch->cdev, &ch->ccw[0],
@@ -1827,7 +1824,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
 	fsm_newstate(wch->fsm, CTC_STATE_TX);
 
 	spin_lock_irqsave(get_ccwdev_lock(wch->cdev), saveflags);
-	wch->prof.send_stamp = current_kernel_time(); /* xtime */
+	wch->prof.send_stamp = jiffies;
 	rc = ccw_device_start(wch->cdev, &wch->ccw[3],
 					(unsigned long) wch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(wch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index e056dd4..5dd68d9 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 #include <linux/signal.h>
 #include <linux/string.h>
@@ -567,7 +568,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	fsm_newstate(ch->fsm, CTC_STATE_TX);
 	fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
 	spin_lock_irqsave(get_ccwdev_lock(ch->cdev), saveflags);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ch->prof.send_stamp = jiffies;
 	rc = ccw_device_start(ch->cdev, &ch->ccw[ccw_idx],
 					(unsigned long)ch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(ch->cdev), saveflags);
@@ -831,7 +832,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 					sizeof(struct ccw1) * 3);
 
 	spin_lock_irqsave(get_ccwdev_lock(ch->cdev), saveflags);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ch->prof.send_stamp = jiffies;
 	rc = ccw_device_start(ch->cdev, &ch->ccw[ccw_idx],
 					(unsigned long)ch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(ch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index 477c933..c036e43 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -10,6 +10,8 @@
 #include <asm/ccwdev.h>
 #include <asm/ccwgroup.h>
 
+#include <linux/jiffies.h>
+
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
@@ -121,7 +123,7 @@ struct ctcm_profile {
 	unsigned long doios_multi;
 	unsigned long txlen;
 	unsigned long tx_time;
-	struct timespec send_stamp;
+	unsigned long send_stamp;
 };
 
 /*
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 0a87809..5ea43fb 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -49,6 +49,8 @@
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
+
 
 #include <linux/signal.h>
 #include <linux/string.h>
@@ -178,7 +180,7 @@ struct connection_profile {
 	unsigned long doios_multi;
 	unsigned long txlen;
 	unsigned long tx_time;
-	struct timespec send_stamp;
+	unsigned long send_stamp;
 	unsigned long tx_pending;
 	unsigned long tx_max_pending;
 };
@@ -786,7 +788,7 @@ static void conn_action_txdone(fsm_instance *fi, int event, void *arg)
 
 	header.next = 0;
 	memcpy(skb_put(conn->tx_buff, NETIUCV_HDRLEN), &header, NETIUCV_HDRLEN);
-	conn->prof.send_stamp = current_kernel_time();
+	conn->prof.send_stamp = jiffies;
 	txmsg.class = 0;
 	txmsg.tag = 0;
 	rc = iucv_message_send(conn->path, &txmsg, 0, 0,
@@ -1220,7 +1222,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 		memcpy(skb_put(nskb, NETIUCV_HDRLEN), &header,  NETIUCV_HDRLEN);
 
 		fsm_newstate(conn->fsm, CONN_STATE_TX);
-		conn->prof.send_stamp = current_kernel_time();
+		conn->prof.send_stamp = jiffies;
 
 		msg.tag = 1;
 		msg.class = 0;
-- 
1.9.3

