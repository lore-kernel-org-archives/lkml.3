Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaEDQld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:41:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaEDPll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arshad Hussain <arshad.hussain@calsoftinc.com>,
        santosh kulkarni <santosh.kulkarni@calsoftinc.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 091/158] iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug
Date: Sun,  4 May 2014 11:40:00 -0400
Message-Id: <20140504154042.300049751@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit d444edc679e7713412f243b792b1f964e5cff1e1 upstream.

This patch fixes a long-standing bug in iscsit_build_conn_drop_async_message()
where during ERL=2 connection recovery, a bogus conn_p pointer could
end up being used to send the ISCSI_OP_ASYNC_EVENT + DROPPING_CONNECTION
notifying the initiator that cmd->logout_cid has failed.

The bug was manifesting itself as an OOPs in iscsit_allocate_cmd() with
a bogus conn_p pointer in iscsit_build_conn_drop_async_message().

Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
Reported-by: santosh kulkarni <santosh.kulkarni@calsoftinc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2468,6 +2468,7 @@ static void iscsit_build_conn_drop_async
 {
 	struct iscsi_cmd *cmd;
 	struct iscsi_conn *conn_p;
+	bool found = false;
 
 	/*
 	 * Only send a Asynchronous Message on connections whos network
@@ -2476,11 +2477,12 @@ static void iscsit_build_conn_drop_async
 	list_for_each_entry(conn_p, &conn->sess->sess_conn_list, conn_list) {
 		if (conn_p->conn_state == TARG_CONN_STATE_LOGGED_IN) {
 			iscsit_inc_conn_usage_count(conn_p);
+			found = true;
 			break;
 		}
 	}
 
-	if (!conn_p)
+	if (!found)
 		return;
 
 	cmd = iscsit_allocate_cmd(conn_p, TASK_RUNNING);


