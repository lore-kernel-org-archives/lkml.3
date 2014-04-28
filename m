Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbaD1Bd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42868 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Arshad Hussain" <arshad.hussain@calsoftinc.com>,
        "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "santosh kulkarni" <santosh.kulkarni@calsoftinc.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.845538709@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 79/94] iscsi-target: Fix ERL=2 ASYNC_EVENT connection
 pointer bug
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2358,6 +2358,7 @@ static void iscsit_build_conn_drop_async
 {
 	struct iscsi_cmd *cmd;
 	struct iscsi_conn *conn_p;
+	bool found = false;
 
 	/*
 	 * Only send a Asynchronous Message on connections whos network
@@ -2366,11 +2367,12 @@ static void iscsit_build_conn_drop_async
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
 
 	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);

