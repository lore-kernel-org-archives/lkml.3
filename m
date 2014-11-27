Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbaK0JDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:03:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:42041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaK0IsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:19 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 47/91] iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid
Date: Thu, 27 Nov 2014 16:42:30 +0800
Message-Id: <1417077794-9299-47-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit b53b0d99d6fbf7d44330395349a895521cfdbc96 upstream.

This patch fixes a bug in iscsit_logout_post_handler_diffcid() where
a pointer used as storage for list_for_each_entry() was incorrectly
being used to determine if no matching entry had been found.

This patch changes iscsit_logout_post_handler_diffcid() to key off
bool conn_found to determine if the function needs to exit early.

Reported-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d7ac2c0..56d02e0 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4297,6 +4297,7 @@ static void iscsit_logout_post_handler_diffcid(
 {
 	struct iscsi_conn *l_conn;
 	struct iscsi_session *sess = conn->sess;
+	bool conn_found = false;
 
 	if (!sess)
 		return;
@@ -4305,12 +4306,13 @@ static void iscsit_logout_post_handler_diffcid(
 	list_for_each_entry(l_conn, &sess->sess_conn_list, conn_list) {
 		if (l_conn->cid == cid) {
 			iscsit_inc_conn_usage_count(l_conn);
+			conn_found = true;
 			break;
 		}
 	}
 	spin_unlock_bh(&sess->conn_lock);
 
-	if (!l_conn)
+	if (!conn_found)
 		return;
 
 	if (l_conn->sock)
-- 
1.9.1

