Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaEBQXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:23:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaEBPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/151] iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug
Date: Fri,  2 May 2014 08:38:45 -0700
Message-Id: <1399045139-4531-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b8b7c94..55e5a03 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2468,6 +2468,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 {
 	struct iscsi_cmd *cmd;
 	struct iscsi_conn *conn_p;
+	bool found = false;
 
 	/*
 	 * Only send a Asynchronous Message on connections whos network
@@ -2476,11 +2477,12 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
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
-- 
1.9.1

