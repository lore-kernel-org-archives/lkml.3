Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3GCStl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:49:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14026 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3GCSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:01 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Yf9BbMIkiqoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=A0ULFo7Cn30A:10 a=z11f-joXAAAA:8 a=4K-K1uyHAAAA:8 a=VwQbUJbxAAAA:8 a=qvslCP9VxmXRqQ6kDZUA:9 a=CJVq-v20pXUA:10 a=wATGTE7Z8MQA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184051.699171439@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [043/141] ib_srpt: Call target_sess_cmd_list_set_waiting during
 shutdown_session
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0043-ib_srpt-Call-target_sess_cmd_list_set_waiting-during.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

[ Upstream commit 1d19f7800d643b270b28d0a969c5eca455d54397 ]

Given that srpt_release_channel_work() calls target_wait_for_sess_cmds()
to allow outstanding se_cmd_t->cmd_kref a change to complete, the call
to perform target_sess_cmd_list_set_waiting() needs to happen in
srpt_shutdown_session()

Also, this patch adds an explicit call to srpt_shutdown_session() within
srpt_drain_channel() so that target_sess_cmd_list_set_waiting() will be
called in the cases where TFO->shutdown_session() is not triggered
directly by TCM.

Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   32 ++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 +
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9e1449f..1f269f1 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2276,6 +2276,27 @@ static void srpt_close_ch(struct srpt_rdma_ch *ch)
 }
 
 /**
+ * srpt_shutdown_session() - Whether or not a session may be shut down.
+ */
+static int srpt_shutdown_session(struct se_session *se_sess)
+{
+	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ch->spinlock, flags);
+	if (ch->in_shutdown) {
+		spin_unlock_irqrestore(&ch->spinlock, flags);
+		return true;
+	}
+
+	ch->in_shutdown = true;
+	target_sess_cmd_list_set_waiting(se_sess);
+	spin_unlock_irqrestore(&ch->spinlock, flags);
+
+	return true;
+}
+
+/**
  * srpt_drain_channel() - Drain a channel by resetting the IB queue pair.
  * @cm_id: Pointer to the CM ID of the channel to be drained.
  *
@@ -2313,6 +2334,9 @@ static void srpt_drain_channel(struct ib_cm_id *cm_id)
 	spin_unlock_irq(&sdev->spinlock);
 
 	if (do_reset) {
+		if (ch->sess)
+			srpt_shutdown_session(ch->sess);
+
 		ret = srpt_ch_qp_err(ch);
 		if (ret < 0)
 			printk(KERN_ERR "Setting queue pair in error state"
@@ -3493,14 +3517,6 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 }
 
 /**
- * srpt_shutdown_session() - Whether or not a session may be shut down.
- */
-static int srpt_shutdown_session(struct se_session *se_sess)
-{
-	return true;
-}
-
-/**
  * srpt_close_session() - Forcibly close a session.
  *
  * Callback function invoked by the TCM core to clean up sessions associated
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 61e52b8..01b7791 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -326,6 +326,7 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	struct work_struct	release_work;
 	struct completion	*release_done;
+	bool			in_shutdown;
 };
 
 /**
-- 
1.7.10.4


