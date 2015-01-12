Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbbALSpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:45:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbbALSai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 178/216] iscsi-target: Fail connection on short sendmsg writes
Date: Mon, 12 Jan 2015 18:29:16 +0000
Message-Id: <1421087394-2712-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index fd90b28f1d94..2e96ae6cf3c1 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1356,15 +1356,15 @@ static int iscsit_do_tx_data(
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
 
@@ -1373,20 +1373,16 @@ static int iscsit_do_tx_data(
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
2.1.4

