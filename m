Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3AOWm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:42:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:43910 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab3AOWf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 200/221] libceph: fix protocol feature mismatch failure path
Date: Tue, 15 Jan 2013 10:52:07 -0800
Message-Id: <20130115185012.466262403@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sage Weil <sage@inktank.com>

(cherry picked from commit 0fa6ebc600bc8e830551aee47a0e929e818a1868)

We should not set con->state to CLOSED here; that happens in
ceph_fault() in the caller, where it first asserts that the state
is not yet CLOSED.  Avoids a BUG when the features don't match.

Since the fail_protocol() has become a trivial wrapper, replace
calls to it with direct calls to reset_connection().

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -506,6 +506,7 @@ static void reset_connection(struct ceph
 {
 	/* reset connection, out_queue, msg_ and connect_seq */
 	/* discard existing out_queue and msg_seq */
+	dout("reset_connection %p\n", con);
 	ceph_msg_remove_list(&con->out_queue);
 	ceph_msg_remove_list(&con->out_sent);
 
@@ -1506,13 +1507,6 @@ static int process_banner(struct ceph_co
 	return 0;
 }
 
-static void fail_protocol(struct ceph_connection *con)
-{
-	reset_connection(con);
-	WARN_ON(con->state != CON_STATE_NEGOTIATING);
-	con->state = CON_STATE_CLOSED;
-}
-
 static int process_connect(struct ceph_connection *con)
 {
 	u64 sup_feat = con->msgr->supported_features;
@@ -1530,7 +1524,7 @@ static int process_connect(struct ceph_c
 		       ceph_pr_addr(&con->peer_addr.in_addr),
 		       sup_feat, server_feat, server_feat & ~sup_feat);
 		con->error_msg = "missing required protocol features";
-		fail_protocol(con);
+		reset_connection(con);
 		return -1;
 
 	case CEPH_MSGR_TAG_BADPROTOVER:
@@ -1541,7 +1535,7 @@ static int process_connect(struct ceph_c
 		       le32_to_cpu(con->out_connect.protocol_version),
 		       le32_to_cpu(con->in_reply.protocol_version));
 		con->error_msg = "protocol version mismatch";
-		fail_protocol(con);
+		reset_connection(con);
 		return -1;
 
 	case CEPH_MSGR_TAG_BADAUTHORIZER:
@@ -1631,7 +1625,7 @@ static int process_connect(struct ceph_c
 			       ceph_pr_addr(&con->peer_addr.in_addr),
 			       req_feat, server_feat, req_feat & ~server_feat);
 			con->error_msg = "missing required protocol features";
-			fail_protocol(con);
+			reset_connection(con);
 			return -1;
 		}
 


