Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaKAWtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:49:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60201 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaKAWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Joern Engel" <joern@logfs.org>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.711177567@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 053/102] iscsi-target: Fix memory corruption in
 iscsit_logout_post_handler_diffcid
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4306,6 +4306,7 @@ static void iscsit_logout_post_handler_d
 {
 	struct iscsi_conn *l_conn;
 	struct iscsi_session *sess = conn->sess;
+	bool conn_found = false;
 
 	if (!sess)
 		return;
@@ -4314,12 +4315,13 @@ static void iscsit_logout_post_handler_d
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

