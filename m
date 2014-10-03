Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaJCWro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:47:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbaJCWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 089/143] iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid
Date: Fri,  3 Oct 2014 14:34:44 -0700
Message-Id: <20141003213317.172996137@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4453,6 +4453,7 @@ static void iscsit_logout_post_handler_d
 {
 	struct iscsi_conn *l_conn;
 	struct iscsi_session *sess = conn->sess;
+	bool conn_found = false;
 
 	if (!sess)
 		return;
@@ -4461,12 +4462,13 @@ static void iscsit_logout_post_handler_d
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


