Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaJaJS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:18:57 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37576 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbaJaJSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:18:55 -0400
Date: Fri, 31 Oct 2014 11:18:50 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: ursula.braun@de.ibm.com, blaschka@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        opw-kernel@googlegroups.com
Subject: [PATCH v2] drivers: s390: net: ctcm: migrate variables to handle
 y2038 problem
Message-ID: <20141031091850.GA2582@localhost.localdomain>
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

 drivers/s390/net/ctcm_fsms.c | 18 +++++++-----------
 drivers/s390/net/ctcm_main.h |  2 +-
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
index fb92524..34b9820 100644
--- a/drivers/s390/net/ctcm_fsms.c
+++ b/drivers/s390/net/ctcm_fsms.c
@@ -251,13 +251,11 @@ static void chx_txdone(fsm_instance *fi, int event, void *arg)
 	int first = 1;
 	int i;
 	unsigned long duration;
-	struct timespec done_stamp = current_kernel_time(); /* xtime */
+	unsigned long done_stamp = jiffies;
 
 	CTCM_PR_DEBUG("%s(%s): %s\n", __func__, ch->id, dev->name);
 
-	duration =
-	    (done_stamp.tv_sec - ch->prof.send_stamp.tv_sec) * 1000000 +
-	    (done_stamp.tv_nsec - ch->prof.send_stamp.tv_nsec) / 1000;
+	duration = time_before(done_stamp, ch->prof.send_stamp);
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
+	duration = time_before(done_stamp, ch->prof.send_stamp);
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
-- 
1.9.3

