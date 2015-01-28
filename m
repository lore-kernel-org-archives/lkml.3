Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbbA2KGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:06:54 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44750 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757586AbbA2JBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 084/176] iscsi-target: Fail connection on short sendmsg writes
Date: Wed, 28 Jan 2015 15:28:34 +0100
Message-Id: <32f04f1f001a1ee45bc071323bb04f600a8dbb84.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6bf6ca7515c1df06f5c03737537f5e0eb191e29e upstream.

This patch changes iscsit_do_tx_data() to fail on short writes
when kernel_sendmsg() returns a value different than requested
transfer length, returning -EPIPE and thus causing a connection
reset to occur.

This avoids a potential bug in the original code where a short
write would result in kernel_sendmsg() being called again with
the original iovec base + length.

In practice this has not been an issue because iscsit_do_tx_data()
is only used for transferring 48 byte headers + 4 byte digests,
along with seldom used control payloads from NOPIN + TEXT_RSP +
REJECT with less than 32k of data.

So following Al's audit of iovec consumers, go ahead and fail
the connection on short writes for now, and remove the bogus
logic ahead of his proper upstream fix.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target_util.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 658c9c77ec04..c5c98559f7f6 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1355,15 +1355,15 @@ static int iscsit_do_tx_data(
 	struct iscsi_conn *conn,
 	struct iscsi_data_count *count)
 {
-	int data = count->data_length, total_tx = 0, tx_loop = 0, iov_len;
+	int ret, iov_len;
 	struct kvec *iov_p;
 	struct msghdr msg;
 
 	if (!conn || !conn->sock || !conn->conn_ops)
 		return -1;
 
-	if (data <= 0) {
-		pr_err("Data length is: %d\n", data);
+	if (count->data_length <= 0) {
+		pr_err("Data length is: %d\n", count->data_length);
 		return -1;
 	}
 
@@ -1372,20 +1372,16 @@ static int iscsit_do_tx_data(
 	iov_p = count->iov;
 	iov_len = count->iov_count;
 
-	while (total_tx < data) {
-		tx_loop = kernel_sendmsg(conn->sock, &msg, iov_p, iov_len,
-					(data - total_tx));
-		if (tx_loop <= 0) {
-			pr_debug("tx_loop: %d total_tx %d\n",
-				tx_loop, total_tx);
-			return tx_loop;
-		}
-		total_tx += tx_loop;
-		pr_debug("tx_loop: %d, total_tx: %d, data: %d\n",
-					tx_loop, total_tx, data);
+	ret = kernel_sendmsg(conn->sock, &msg, iov_p, iov_len,
+			     count->data_length);
+	if (ret != count->data_length) {
+		pr_err("Unexpected ret: %d send data %d\n",
+		       ret, count->data_length);
+		return -EPIPE;
 	}
+	pr_debug("ret: %d, sent data: %d\n", ret, count->data_length);
 
-	return total_tx;
+	return ret;
 }
 
 int rx_data(
-- 
2.2.2

