Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3AOWfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:43854 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab3AOWfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ugis <ugis22@gmail.com>, Alex Elder <elder@inktank.com>,
        Sage Weil <sage@inktank.com>
Subject: [ 198/221] libceph: WARN, dont BUG on unexpected connection states
Date: Tue, 15 Jan 2013 10:52:05 -0800
Message-Id: <20130115185012.330932720@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit 122070a2ffc91f87fe8e8493eb0ac61986c5557c)

A number of assertions in the ceph messenger are implemented with
BUG_ON(), killing the system if connection's state doesn't match
what's expected.  At this point our state model is (evidently) not
well understood enough for these assertions to trigger a BUG().
Convert all BUG_ON(con->state...) calls to be WARN_ON(con->state...)
so we learn about these issues without killing the machine.

We now recognize that a connection fault can occur due to a socket
closure at any time, regardless of the state of the connection.  So
there is really nothing we can assert about the state of the
connection at that point so eliminate that assertion.

Reported-by: Ugis <ugis22@gmail.com>
Tested-by: Ugis <ugis22@gmail.com>
Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -561,7 +561,7 @@ void ceph_con_open(struct ceph_connectio
 	mutex_lock(&con->mutex);
 	dout("con_open %p %s\n", con, ceph_pr_addr(&addr->in_addr));
 
-	BUG_ON(con->state != CON_STATE_CLOSED);
+	WARN_ON(con->state != CON_STATE_CLOSED);
 	con->state = CON_STATE_PREOPEN;
 
 	con->peer_name.type = (__u8) entity_type;
@@ -1509,7 +1509,7 @@ static int process_banner(struct ceph_co
 static void fail_protocol(struct ceph_connection *con)
 {
 	reset_connection(con);
-	BUG_ON(con->state != CON_STATE_NEGOTIATING);
+	WARN_ON(con->state != CON_STATE_NEGOTIATING);
 	con->state = CON_STATE_CLOSED;
 }
 
@@ -1635,7 +1635,7 @@ static int process_connect(struct ceph_c
 			return -1;
 		}
 
-		BUG_ON(con->state != CON_STATE_NEGOTIATING);
+		WARN_ON(con->state != CON_STATE_NEGOTIATING);
 		con->state = CON_STATE_OPEN;
 
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
@@ -2132,7 +2132,6 @@ more:
 		if (ret < 0)
 			goto out;
 
-		BUG_ON(con->state != CON_STATE_CONNECTING);
 		con->state = CON_STATE_NEGOTIATING;
 
 		/*
@@ -2160,7 +2159,7 @@ more:
 		goto more;
 	}
 
-	BUG_ON(con->state != CON_STATE_OPEN);
+	WARN_ON(con->state != CON_STATE_OPEN);
 
 	if (con->in_base_pos < 0) {
 		/*
@@ -2374,7 +2373,7 @@ static void ceph_fault(struct ceph_conne
 	dout("fault %p state %lu to peer %s\n",
 	     con, con->state, ceph_pr_addr(&con->peer_addr.in_addr));
 
-	BUG_ON(con->state != CON_STATE_CONNECTING &&
+	WARN_ON(con->state != CON_STATE_CONNECTING &&
 	       con->state != CON_STATE_NEGOTIATING &&
 	       con->state != CON_STATE_OPEN);
 


