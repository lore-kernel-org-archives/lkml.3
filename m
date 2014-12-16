Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbaLPFUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:20:24 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:42015 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaLPFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:20:22 -0500
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] iscsi-target: Fail connection on short writes/reads
Date: Tue, 16 Dec 2014 04:48:58 +0000
Message-Id: <1418705338-23695-1-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes iscsit_do_[tx,rx]_data() to fail on short
write/reads when kernel_[send,recv]msg() returns a value different
than the requested transfer length, returning -EPIPE and thus
causing a connection reset to occur.

This avoids a potential bug in the original code where a short
write/read would result in kernel_[send,recv]msg() being called
again with the original iovec base + length.

In practice this has not been an issue because iscsit_do_tx_data()
is only used for transferring 48 byte headers + 4 byte digests,
along with seldom used control payloads from NOPIN + TEXT_RSP +
REJECT with less than 32k of data.  Nor has it been occuring with
iscsit_do_rx_data() because MSG_WAITALL won't return to caller
until the requested transfer length is reached, or an error has
occured.

So following Al's audit of iovec consumers, go ahead and fail
the connection on short writes/reads for now, and remove the
bogus logic.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 48 +++++++++++++-------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index ce87ce9..9aa24f1 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1326,7 +1326,7 @@ static int iscsit_do_rx_data(
 	struct iscsi_conn *conn,
 	struct iscsi_data_count *count)
 {
-	int data = count->data_length, rx_loop = 0, total_rx = 0, iov_len;
+	int ret, iov_len;
 	struct kvec *iov_p;
 	struct msghdr msg;
 
@@ -1338,35 +1338,31 @@ static int iscsit_do_rx_data(
 	iov_p = count->iov;
 	iov_len	= count->iov_count;
 
-	while (total_rx < data) {
-		rx_loop = kernel_recvmsg(conn->sock, &msg, iov_p, iov_len,
-					(data - total_rx), MSG_WAITALL);
-		if (rx_loop <= 0) {
-			pr_debug("rx_loop: %d total_rx: %d\n",
-				rx_loop, total_rx);
-			return rx_loop;
-		}
-		total_rx += rx_loop;
-		pr_debug("rx_loop: %d, total_rx: %d, data: %d\n",
-				rx_loop, total_rx, data);
+	ret = kernel_recvmsg(conn->sock, &msg, iov_p, iov_len,
+			     count->data_length, MSG_WAITALL);
+	if (ret != count->data_length) {
+		pr_err("Unexpected ret: %d recv data: %d\n",
+		       ret, count->data_length);
+		return -EPIPE;
 	}
+	pr_debug("ret: %d, recv data: %d\n", ret, count->data_length);
 
-	return total_rx;
+	return ret;
 }
 
 static int iscsit_do_tx_data(
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
 
@@ -1375,20 +1371,16 @@ static int iscsit_do_tx_data(
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
1.9.1

