Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbbAYSvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:51:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbbAYSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.18 070/183] iscsi-target: Fail connection on short sendmsg writes
Date: Sun, 25 Jan 2015 10:06:32 -0800
Message-Id: <20150125180813.222247637@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_util.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1358,15 +1358,15 @@ static int iscsit_do_tx_data(
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
 
@@ -1375,20 +1375,16 @@ static int iscsit_do_tx_data(
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


