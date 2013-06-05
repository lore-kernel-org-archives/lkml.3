Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3FEVry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:47:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab3FEVf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>
Subject: [ 089/127] ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session
Date: Wed,  5 Jun 2013 14:34:16 -0700
Message-Id: <20130605213228.001976532@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 1d19f7800d643b270b28d0a969c5eca455d54397 upstream.

Given that srpt_release_channel_work() calls target_wait_for_sess_cmds()
to allow outstanding se_cmd_t->cmd_kref a change to complete, the call
to perform target_sess_cmd_list_set_waiting() needs to happen in
srpt_shutdown_session()

Also, this patch adds an explicit call to srpt_shutdown_session() within
srpt_drain_channel() so that target_sess_cmd_list_set_waiting() will be
called in the cases where TFO->shutdown_session() is not triggered
directly by TCM.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Roland Dreier <roland@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   32 ++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    1 +
 2 files changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2227,6 +2227,27 @@ static void srpt_close_ch(struct srpt_rd
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
@@ -2264,6 +2285,9 @@ static void srpt_drain_channel(struct ib
 	spin_unlock_irq(&sdev->spinlock);
 
 	if (do_reset) {
+		if (ch->sess)
+			srpt_shutdown_session(ch->sess);
+
 		ret = srpt_ch_qp_err(ch);
 		if (ret < 0)
 			printk(KERN_ERR "Setting queue pair in error state"
@@ -3467,14 +3491,6 @@ static void srpt_release_cmd(struct se_c
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
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -325,6 +325,7 @@ struct srpt_rdma_ch {
 	u8			sess_name[36];
 	struct work_struct	release_work;
 	struct completion	*release_done;
+	bool			in_shutdown;
 };
 
 /**


