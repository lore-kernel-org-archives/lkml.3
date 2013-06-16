Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3FPWLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:11:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755774Ab3FPWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hedberg" <johan.hedberg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Gustavo Padovan" <gustavo.padovan@collabora.co.uk>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.930723427@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [67/83] Bluetooth: Fix missing length checks for L2CAP signalling
 PDUs
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit cb3b3152b2f5939d67005cff841a1ca748b19888 upstream.

There has been code in place to check that the L2CAP length header
matches the amount of data received, but many PDU handlers have not been
checking that the data received actually matches that expected by the
specific PDU. This patch adds passing the length header to the specific
handler functions and ensures that those functions fail cleanly in the
case of an incorrect amount of data.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Move uses of *req below the new check in l2cap_connect_req]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2297,10 +2297,15 @@ done:
 	}
 }
 
-static inline int l2cap_command_rej(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_command_rej(struct l2cap_conn *conn,
+				    struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				    u8 *data)
 {
 	struct l2cap_cmd_rej_unk *rej = (struct l2cap_cmd_rej_unk *) data;
 
+	if (cmd_len < sizeof(*rej))
+		return -EPROTO;
+
 	if (rej->reason != L2CAP_REJ_NOT_UNDERSTOOD)
 		return 0;
 
@@ -2317,7 +2322,8 @@ static inline int l2cap_command_rej(stru
 	return 0;
 }
 
-static inline int l2cap_connect_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static int l2cap_connect_req(struct l2cap_conn *conn,
+			     struct l2cap_cmd_hdr *cmd, u16 cmd_len, u8 *data)
 {
 	struct l2cap_conn_req *req = (struct l2cap_conn_req *) data;
 	struct l2cap_conn_rsp rsp;
@@ -2325,8 +2331,14 @@ static inline int l2cap_connect_req(stru
 	struct sock *parent, *sk = NULL;
 	int result, status = L2CAP_CS_NO_INFO;
 
-	u16 dcid = 0, scid = __le16_to_cpu(req->scid);
-	__le16 psm = req->psm;
+	u16 dcid = 0, scid;
+	__le16 psm;
+
+	if (cmd_len < sizeof(struct l2cap_conn_req))
+		return -EPROTO;
+
+	scid = __le16_to_cpu(req->scid);
+	psm = req->psm;
 
 	BT_DBG("psm 0x%2.2x scid 0x%4.4x", psm, scid);
 
@@ -2451,7 +2463,9 @@ sendresp:
 	return 0;
 }
 
-static inline int l2cap_connect_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static int l2cap_connect_rsp(struct l2cap_conn *conn,
+			      struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+			      u8 *data)
 {
 	struct l2cap_conn_rsp *rsp = (struct l2cap_conn_rsp *) data;
 	u16 scid, dcid, result, status;
@@ -2459,6 +2473,9 @@ static inline int l2cap_connect_rsp(stru
 	struct sock *sk;
 	u8 req[128];
 
+	if (cmd_len < sizeof(*rsp))
+		return -EPROTO;
+
 	scid   = __le16_to_cpu(rsp->scid);
 	dcid   = __le16_to_cpu(rsp->dcid);
 	result = __le16_to_cpu(rsp->result);
@@ -2534,6 +2551,9 @@ static inline int l2cap_config_req(struc
 	struct sock *sk;
 	int len;
 
+	if (cmd_len < sizeof(*req))
+		return -EPROTO;
+
 	dcid  = __le16_to_cpu(req->dcid);
 	flags = __le16_to_cpu(req->flags);
 
@@ -2559,7 +2579,7 @@ static inline int l2cap_config_req(struc
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (len < 0 || chan->conf_len + len > sizeof(chan->conf_req)) {
+	if (chan->conf_len + len > sizeof(chan->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 				l2cap_build_conf_rsp(chan, rsp,
 					L2CAP_CONF_REJECT, flags), rsp);
@@ -2621,13 +2641,18 @@ unlock:
 	return 0;
 }
 
-static inline int l2cap_config_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_config_rsp(struct l2cap_conn *conn,
+				   struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				   u8 *data)
 {
 	struct l2cap_conf_rsp *rsp = (struct l2cap_conf_rsp *)data;
 	u16 scid, flags, result;
 	struct l2cap_chan *chan;
 	struct sock *sk;
-	int len = cmd->len - sizeof(*rsp);
+	int len = cmd_len - sizeof(*rsp);
+
+	if (cmd_len < sizeof(*rsp))
+		return -EPROTO;
 
 	scid   = __le16_to_cpu(rsp->scid);
 	flags  = __le16_to_cpu(rsp->flags);
@@ -2703,7 +2728,9 @@ done:
 	return 0;
 }
 
-static inline int l2cap_disconnect_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
+				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				       u8 *data)
 {
 	struct l2cap_disconn_req *req = (struct l2cap_disconn_req *) data;
 	struct l2cap_disconn_rsp rsp;
@@ -2711,6 +2738,9 @@ static inline int l2cap_disconnect_req(s
 	struct l2cap_chan *chan;
 	struct sock *sk;
 
+	if (cmd_len != sizeof(*req))
+		return -EPROTO;
+
 	scid = __le16_to_cpu(req->scid);
 	dcid = __le16_to_cpu(req->dcid);
 
@@ -2744,13 +2774,18 @@ static inline int l2cap_disconnect_req(s
 	return 0;
 }
 
-static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
+				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				       u8 *data)
 {
 	struct l2cap_disconn_rsp *rsp = (struct l2cap_disconn_rsp *) data;
 	u16 dcid, scid;
 	struct l2cap_chan *chan;
 	struct sock *sk;
 
+	if (cmd_len != sizeof(*rsp))
+		return -EPROTO;
+
 	scid = __le16_to_cpu(rsp->scid);
 	dcid = __le16_to_cpu(rsp->dcid);
 
@@ -2778,11 +2813,16 @@ static inline int l2cap_disconnect_rsp(s
 	return 0;
 }
 
-static inline int l2cap_information_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_information_req(struct l2cap_conn *conn,
+					struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+					u8 *data)
 {
 	struct l2cap_info_req *req = (struct l2cap_info_req *) data;
 	u16 type;
 
+	if (cmd_len != sizeof(*req))
+		return -EPROTO;
+
 	type = __le16_to_cpu(req->type);
 
 	BT_DBG("type 0x%4.4x", type);
@@ -2818,11 +2858,16 @@ static inline int l2cap_information_req(
 	return 0;
 }
 
-static inline int l2cap_information_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr *cmd, u8 *data)
+static inline int l2cap_information_rsp(struct l2cap_conn *conn,
+					struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+					u8 *data)
 {
 	struct l2cap_info_rsp *rsp = (struct l2cap_info_rsp *) data;
 	u16 type, result;
 
+	if (cmd_len != sizeof(*rsp))
+		return -EPROTO;
+
 	type   = __le16_to_cpu(rsp->type);
 	result = __le16_to_cpu(rsp->result);
 
@@ -2941,15 +2986,15 @@ static inline int l2cap_bredr_sig_cmd(st
 
 	switch (cmd->code) {
 	case L2CAP_COMMAND_REJ:
-		l2cap_command_rej(conn, cmd, data);
+		l2cap_command_rej(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_CONN_REQ:
-		err = l2cap_connect_req(conn, cmd, data);
+		err = l2cap_connect_req(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_CONN_RSP:
-		err = l2cap_connect_rsp(conn, cmd, data);
+		err = l2cap_connect_rsp(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_CONF_REQ:
@@ -2957,15 +3002,15 @@ static inline int l2cap_bredr_sig_cmd(st
 		break;
 
 	case L2CAP_CONF_RSP:
-		err = l2cap_config_rsp(conn, cmd, data);
+		err = l2cap_config_rsp(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_DISCONN_REQ:
-		err = l2cap_disconnect_req(conn, cmd, data);
+		err = l2cap_disconnect_req(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_DISCONN_RSP:
-		err = l2cap_disconnect_rsp(conn, cmd, data);
+		err = l2cap_disconnect_rsp(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_ECHO_REQ:
@@ -2976,11 +3021,11 @@ static inline int l2cap_bredr_sig_cmd(st
 		break;
 
 	case L2CAP_INFO_REQ:
-		err = l2cap_information_req(conn, cmd, data);
+		err = l2cap_information_req(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_INFO_RSP:
-		err = l2cap_information_rsp(conn, cmd, data);
+		err = l2cap_information_rsp(conn, cmd, cmd_len, data);
 		break;
 
 	default:

