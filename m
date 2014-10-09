Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbaJIVI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:08:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59284 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbaJIVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 100/163] iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid
Date: Thu,  9 Oct 2014 14:02:05 -0700
Message-Id: <1412888588-26755-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit b53b0d99d6fbf7d44330395349a895521cfdbc96 upstream.

This patch fixes a bug in iscsit_logout_post_handler_diffcid() where
a pointer used as storage for list_for_each_entry() was incorrectly
being used to determine if no matching entry had been found.

This patch changes iscsit_logout_post_handler_diffcid() to key off
bool conn_found to determine if the function needs to exit early.

Reported-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6c727b9..bc45c3a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4512,6 +4512,7 @@ static void iscsit_logout_post_handler_diffcid(
 {
 	struct iscsi_conn *l_conn;
 	struct iscsi_session *sess = conn->sess;
+	bool conn_found = false;
 
 	if (!sess)
 		return;
@@ -4520,12 +4521,13 @@ static void iscsit_logout_post_handler_diffcid(
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

