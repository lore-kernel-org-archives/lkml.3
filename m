Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab3AOXYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:24:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:47167 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933762Ab3AOWxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 142/171] libceph: socket can close in any connection state
Date: Tue, 15 Jan 2013 14:45:07 -0800
Message-Id: <20130115224323.595583335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

A connection's socket can close for any reason, independent of the
state of the connection (and without irrespective of the connection
mutex).  As a result, the connectino can be in pretty much any state
at the time its socket is closed.

Handle those other cases at the top of con_work().  Pull this whole
block of code into a separate function to reduce the clutter.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 7bb21d68c535ad8be38e14a715632ae398b37ac1)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2258,6 +2258,35 @@ static void queue_con(struct ceph_connec
 	}
 }
 
+static bool con_sock_closed(struct ceph_connection *con)
+{
+	if (!test_and_clear_bit(CON_FLAG_SOCK_CLOSED, &con->flags))
+		return false;
+
+#define CASE(x)								\
+	case CON_STATE_ ## x:						\
+		con->error_msg = "socket closed (con state " #x ")";	\
+		break;
+
+	switch (con->state) {
+	CASE(CLOSED);
+	CASE(PREOPEN);
+	CASE(CONNECTING);
+	CASE(NEGOTIATING);
+	CASE(OPEN);
+	CASE(STANDBY);
+	default:
+		pr_warning("%s con %p unrecognized state %lu\n",
+			__func__, con, con->state);
+		con->error_msg = "unrecognized con state";
+		BUG();
+		break;
+	}
+#undef CASE
+
+	return true;
+}
+
 /*
  * Do some work on a connection.  Drop a connection ref when we're done.
  */
@@ -2269,24 +2298,8 @@ static void con_work(struct work_struct
 
 	mutex_lock(&con->mutex);
 restart:
-	if (test_and_clear_bit(CON_FLAG_SOCK_CLOSED, &con->flags)) {
-		switch (con->state) {
-		case CON_STATE_CONNECTING:
-			con->error_msg = "connection failed";
-			break;
-		case CON_STATE_NEGOTIATING:
-			con->error_msg = "negotiation failed";
-			break;
-		case CON_STATE_OPEN:
-			con->error_msg = "socket closed";
-			break;
-		default:
-			dout("unrecognized con state %d\n", (int)con->state);
-			con->error_msg = "unrecognized con state";
-			BUG();
-		}
+	if (con_sock_closed(con))
 		goto fault;
-	}
 
 	if (test_and_clear_bit(CON_FLAG_BACKOFF, &con->flags)) {
 		dout("con_work %p backing off\n", con);


