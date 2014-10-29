Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241AbaJ2QCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:02:41 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56723 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751AbaJ2QCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:02:39 -0400
Date: Wed, 29 Oct 2014 18:02:34 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: ursula.braun@de.ibm.com, blaschka@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        opw-kernel@googlegroups.com
Subject: [PATCH] drivers: s390: net: ctcm: migrate variables to handle y2038
 problem
Message-ID: <20141029160234.GA5003@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is concerned with migrating the time variables for the s390
network driver. The changes handle the y2038 problem where timespec will
overflow in the year 2038. timespec64 and unsigned long long were used
instead of timespec and unsigned long respectively in two files.
All timespec variables use monotonic time values through the function
ktime_get_ts64(). This is to make sure that all the time values
are calculated from a fixed point.

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
---
v1: Arnd has advised me to provide you with options for time 
    calculation. The first option: "accuracy" is used in this
    patch. The second option: "speed" can be done through
    jiffies and current_kernel_time().

 drivers/s390/net/ctcm_fsms.c | 18 +++++++++++-------
 drivers/s390/net/ctcm_main.h |  4 ++--
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index fb92524..233aef8 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -250,8 +250,10 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 	struct sk_buff *skb;
 	int first = 1;
 	int i;
-	unsigned long duration;
-	struct timespec done_stamp = current_kernel_time(); /* xtime */
+	unsigned long long duration;
+	struct timespec64 done_stamp;
+
+	ktime_get_ts64(&done_stamp);
 
 	CTCM_PR_DEBUG("%s(%s): %s\n", __func__, ch->id, dev->name);
 
@@ -307,7 +309,7 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 		spin_unlock(&ch->collect_lock);
 		ch->ccw[1].count = ch->trans_skb->len;
 		fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
-		ch->prof.send_stamp = current_kernel_time(); /* xtime */
+		ktime_get_ts64(&ch->prof.sendstamp);
 		rc = ccw_device_start(ch->cdev, &ch->ccw[0],
 						(unsigned long)ch, 0xff, 0);
 		ch->prof.doios_multi++;
@@ -1224,12 +1226,14 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 	int		first = 1;
 	int		i;
 	__u32		data_space;
-	unsigned long	duration;
+	unsigned long long	duration;
 	struct sk_buff	*peekskb;
 	int		rc;
 	struct th_header *header;
 	struct pdu	*p_header;
-	struct timespec done_stamp = current_kernel_time(); /* xtime */
+	struct timespec64 done_stamp;
+
+	ktime_get_ts64(&done_stamp);
 
 	CTCM_PR_DEBUG("Enter %s: %s cp:%i\n",
 			__func__, dev->name, smp_processor_id());
@@ -1361,7 +1365,7 @@ static void ctcmpc_chx_txdone(fsm_instance *fi, int event, void *arg)
 
 	ch->ccw[1].count = ch->trans_skb->len;
 	fsm_addtimer(&ch->timer, CTCM_TIME_5_SEC, CTC_EVENT_TIMER, ch);
-	ch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ktime_get_ts64(&ch->prof.send_stamp);
 	if (do_debug_ccw)
 		ctcmpc_dumpit((char *)&ch->ccw[0], sizeof(struct ccw1) * 3);
 	rc = ccw_device_start(ch->cdev, &ch->ccw[0],
@@ -1827,7 +1831,7 @@ static void ctcmpc_chx_send_sweep(fsm_instance *fsm, int event, void *arg)
 	fsm_newstate(wch->fsm, CTC_STATE_TX);
 
 	spin_lock_irqsave(get_ccwdev_lock(wch->cdev), saveflags);
-	wch->prof.send_stamp = current_kernel_time(); /* xtime */
+	ktime_get_ts64(&wch->prof.send_stamp);
 	rc = ccw_device_start(wch->cdev, &wch->ccw[3],
 					(unsigned long) wch, 0xff, 0);
 	spin_unlock_irqrestore(get_ccwdev_lock(wch->cdev), saveflags);
diff --git a/drivers/s390/net/ctcm_main.h b/drivers/s390/net/ctcm_main.h
index 477c933..ed7d44a 100644
--- a/drivers/s390/net/ctcm_main.h
+++ b/drivers/s390/net/ctcm_main.h
@@ -120,8 +120,8 @@ struct ctcm_profile {
 	unsigned long doios_single;
 	unsigned long doios_multi;
 	unsigned long txlen;
-	unsigned long tx_time;
-	struct timespec send_stamp;
+	unsigned long long tx_time;
+	struct timespec64 send_stamp;
 };
 
 /*
-- 
1.9.3

