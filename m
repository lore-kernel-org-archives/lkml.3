Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaKETEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:04:55 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53519 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaKETEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:04:51 -0500
Date: Wed, 5 Nov 2014 21:04:43 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: ursula.braun@de.ibm.com, blaschka@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [PATCH v5] drivers: s390: net: ctcm: migrate variables to handle
 y2038 problem
Message-ID: <20141105190443.GA3868@localhost.localdomain>
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

ch->prof.tx_time will now hold the difference between two jiffies'
values instead of the difference between two xtime values
represented in microseconds.

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
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

v4: removed #include <linux/jiffies.h> per Ursula's feedback.
    Changed duration to hold the difference between jiffies
    instead of difference between microsecond values per Arnd's
    suggestion.

v5: added changes written by Ursula to handle missed modifications.

 drivers/s390/net/ctcm_fsms.c  | 18 +++++++-----------
 drivers/s390/net/ctcm_main.c  |  4 ++--
 drivers/s390/net/ctcm_main.h  |  2 +-
 drivers/s390/net/ctcm_sysfs.c |  4 ++--
 drivers/s390/net/netiucv.c    |  6 +++---
 5 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index fb92524..49143c3 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -251,13 +251,11 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 	int first = 1;
 	int i;
 	unsigned long duration;
-	struct timespec done_stamp = current_kernel_time(); /* xtime */
+	unsigned long done_stamp jiffies;
 
 	CTCM_PR_DEBUG("%s(%s): %s\n", __func__, ch->id, dev->name);
 
-	duration =
-	    (done_stamp.tv_sec - ch->prof.send_stamp.tv_sec) * 1000000 +
-	    (done_stamp.tv_nsec - ch->prof.send_stamp.tv_nsec) / 1000;
+	duration = done_stamp -ch->prof.send_stamp;
 	if (duration > ch->prof.tx_time)
 		ch->prof.tx_time = duration;
 
@@ -307,7 +305,7 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 		spin_unlock(&ch->collect_lock);
 		ch->ccw[1].count = ch->trans_skb->len;
 		fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
-		ch->prof.send_stamp = current_kernel_time(); /* xtime */
+		ch->prof.send_stamp = jiffies;
 		rc = ccw_device_start(ch->cdev, &ch->ccw[0],
 						(unsigned long)ch, 0xff, 0);
 		ch->prof.doios_multi++;
@@ -1229,14 +1227,12 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
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
+	duration = done_stamp -ch->prof.send_stamp;
 	if (duration > ch->prof.tx_time)
 		ch->prof.tx_time = duration;
 
@@ -1361,7 +1357,7 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 
 	ch->ccw[1].count = ch->trans_skb->len;
 	fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ch->prof.send_stamp = jiffies;
 	if (do_debug_ccw)
 		ctcmpc_dumpit((char *)&ch->ccw[0], sizeof(struct ccw1) * 3);
 	rc = ccw_device_start(ch->cdev, &ch->ccw[0],
@@ -1827,7 +1823,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
 	fsm_newstate(wch->fsm, CTC_STATE_TX);
 
 	spin_lock_irqsave(get_ccwdev_lock(wch->cdev), saveflags);
-	wch->prof.send_stamp = current_kernel_time(); /* xtime */
+	wch->prof.send_stamp = jiffies;
 	rc = ccw_device_start(wch->cdev, &wch->ccw[3],
 					(unsigned long) wch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(wch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index e056dd4..05c37d6 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -567,7 +567,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	fsm_newstate(ch->fsm, CTC_STATE_TX);
 	fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
 	spin_lock_irqsave(get_ccwdev_lock(ch->cdev), saveflags);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ch->prof.send_stamp = jiffies;
 	rc = ccw_device_start(ch->cdev, &ch->ccw[ccw_idx],
 					(unsigned long)ch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(ch->cdev), saveflags);
@@ -831,7 +831,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 					sizeof(struct ccw1) * 3);
 
 	spin_lock_irqsave(get_ccwdev_lock(ch->cdev), saveflags);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ch->prof.send_stamp = jiffies;
 	rc = ccw_device_start(ch->cdev, &ch->ccw[ccw_idx],
 					(unsigned long)ch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(ch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index 477c933..6f4417c 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -121,7 +121,7 @@ struct ctcm_profile {
 	unsigned long doios_multi;
 	unsigned long txlen;
 	unsigned long tx_time;
-	struct timespec send_stamp;
+	unsigned long send_stamp;
 };
 
 /*
diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index 6bcfbbb..c88f465 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -100,8 +100,8 @@ static void ctcm_print_statistics(struct ctcm_priv *priv)
 		     priv->channel[WRITE]->prof.doios_multi);
 	p += sprintf(p, "  Netto bytes written: %ld\n",
 		     priv->channel[WRITE]->prof.txlen);
-	p += sprintf(p, "  Max. TX IO-time: %ld\n",
-		     priv->channel[WRITE]->prof.tx_time);
+	p += sprintf(p, "  Max. TX IO-time: %u\n",
+		jiffies_to_usecs(priv->channel[WRITE]->prof.tx_time));
 
 	printk(KERN_INFO "Statistics for %s:\n%s",
 				priv->channel[CTCM_WRITE]->netdev->name, sbuf);
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 0a87809..7e91f54 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -178,7 +178,7 @@ struct connection_profile {
 	unsigned long doios_multi;
 	unsigned long txlen;
 	unsigned long tx_time;
-	struct timespec send_stamp;
+	unsigned long send_stamp;
 	unsigned long tx_pending;
 	unsigned long tx_max_pending;
 };
@@ -786,7 +786,7 @@ static void conn_action_txdone(fsm_instance *fi, int event, void *arg)
 
 	header.next = 0;
 	memcpy(skb_put(conn->tx_buff, NETIUCV_HDRLEN), &header, NETIUCV_HDRLEN);
-	conn->prof.send_stamp = current_kernel_time();
+	conn->prof.send_stamp = jiffies;
 	txmsg.class = 0;
 	txmsg.tag = 0;
 	rc = iucv_message_send(conn->path, &txmsg, 0, 0,
@@ -1220,7 +1220,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 		memcpy(skb_put(nskb, NETIUCV_HDRLEN), &header,  NETIUCV_HDRLEN);
 
 		fsm_newstate(conn->fsm, CONN_STATE_TX);
-		conn->prof.send_stamp = current_kernel_time();
+		conn->prof.send_stamp = jiffies;
 
 		msg.tag = 1;
 		msg.class = 0;
-- 
1.9.3

