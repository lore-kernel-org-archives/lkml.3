Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3FQRew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:34:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab3FQRet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:34:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 66/84] Bluetooth: Fix missing length checks for L2CAP signalling PDUs
Date: Mon, 17 Jun 2013 10:31:10 -0700
Message-Id: <1371490288-23167-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/l2cap_core.c | 70 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 18 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 22e6583..1275126 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3573,10 +3573,14 @@ static void l2cap_conf_rfc_get(struct l2cap_chan *chan, void *rsp, int len)
 }
 
 static inline int l2cap_command_rej(struct l2cap_conn *conn,
-				    struct l2cap_cmd_hdr *cmd, u8 *data)
+				    struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				    u8 *data)
 {
 	struct l2cap_cmd_rej_unk *rej = (struct l2cap_cmd_rej_unk *) data;
 
+	if (cmd_len < sizeof(*rej))
+		return -EPROTO;
+
 	if (rej->reason != L2CAP_REJ_NOT_UNDERSTOOD)
 		return 0;
 
@@ -3725,11 +3729,14 @@ sendresp:
 }
 
 static int l2cap_connect_req(struct l2cap_conn *conn,
-			     struct l2cap_cmd_hdr *cmd, u8 *data)
+			     struct l2cap_cmd_hdr *cmd, u16 cmd_len, u8 *data)
 {
 	struct hci_dev *hdev = conn->hcon->hdev;
 	struct hci_conn *hcon = conn->hcon;
 
+	if (cmd_len < sizeof(struct l2cap_conn_req))
+		return -EPROTO;
+
 	hci_dev_lock(hdev);
 	if (test_bit(HCI_MGMT, &hdev->dev_flags) &&
 	    !test_and_set_bit(HCI_CONN_MGMT_CONNECTED, &hcon->flags))
@@ -3743,7 +3750,8 @@ static int l2cap_connect_req(struct l2cap_conn *conn,
 }
 
 static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
-				    struct l2cap_cmd_hdr *cmd, u8 *data)
+				    struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				    u8 *data)
 {
 	struct l2cap_conn_rsp *rsp = (struct l2cap_conn_rsp *) data;
 	u16 scid, dcid, result, status;
@@ -3751,6 +3759,9 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
 	u8 req[128];
 	int err;
 
+	if (cmd_len < sizeof(*rsp))
+		return -EPROTO;
+
 	scid   = __le16_to_cpu(rsp->scid);
 	dcid   = __le16_to_cpu(rsp->dcid);
 	result = __le16_to_cpu(rsp->result);
@@ -3848,6 +3859,9 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 	struct l2cap_chan *chan;
 	int len, err = 0;
 
+	if (cmd_len < sizeof(*req))
+		return -EPROTO;
+
 	dcid  = __le16_to_cpu(req->dcid);
 	flags = __le16_to_cpu(req->flags);
 
@@ -3871,7 +3885,7 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 
 	/* Reject if config buffer is too small. */
 	len = cmd_len - sizeof(*req);
-	if (len < 0 || chan->conf_len + len > sizeof(chan->conf_req)) {
+	if (chan->conf_len + len > sizeof(chan->conf_req)) {
 		l2cap_send_cmd(conn, cmd->ident, L2CAP_CONF_RSP,
 			       l2cap_build_conf_rsp(chan, rsp,
 			       L2CAP_CONF_REJECT, flags), rsp);
@@ -3949,14 +3963,18 @@ unlock:
 }
 
 static inline int l2cap_config_rsp(struct l2cap_conn *conn,
-				   struct l2cap_cmd_hdr *cmd, u8 *data)
+				   struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				   u8 *data)
 {
 	struct l2cap_conf_rsp *rsp = (struct l2cap_conf_rsp *)data;
 	u16 scid, flags, result;
 	struct l2cap_chan *chan;
-	int len = le16_to_cpu(cmd->len) - sizeof(*rsp);
+	int len = cmd_len - sizeof(*rsp);
 	int err = 0;
 
+	if (cmd_len < sizeof(*rsp))
+		return -EPROTO;
+
 	scid   = __le16_to_cpu(rsp->scid);
 	flags  = __le16_to_cpu(rsp->flags);
 	result = __le16_to_cpu(rsp->result);
@@ -4057,7 +4075,8 @@ done:
 }
 
 static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
-				       struct l2cap_cmd_hdr *cmd, u8 *data)
+				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				       u8 *data)
 {
 	struct l2cap_disconn_req *req = (struct l2cap_disconn_req *) data;
 	struct l2cap_disconn_rsp rsp;
@@ -4065,6 +4084,9 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 	struct l2cap_chan *chan;
 	struct sock *sk;
 
+	if (cmd_len != sizeof(*req))
+		return -EPROTO;
+
 	scid = __le16_to_cpu(req->scid);
 	dcid = __le16_to_cpu(req->dcid);
 
@@ -4104,12 +4126,16 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn,
 }
 
 static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
-				       struct l2cap_cmd_hdr *cmd, u8 *data)
+				       struct l2cap_cmd_hdr *cmd, u16 cmd_len,
+				       u8 *data)
 {
 	struct l2cap_disconn_rsp *rsp = (struct l2cap_disconn_rsp *) data;
 	u16 dcid, scid;
 	struct l2cap_chan *chan;
 
+	if (cmd_len != sizeof(*rsp))
+		return -EPROTO;
+
 	scid = __le16_to_cpu(rsp->scid);
 	dcid = __le16_to_cpu(rsp->dcid);
 
@@ -4139,11 +4165,15 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn,
 }
 
 static inline int l2cap_information_req(struct l2cap_conn *conn,
-					struct l2cap_cmd_hdr *cmd, u8 *data)
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
@@ -4190,11 +4220,15 @@ static inline int l2cap_information_req(struct l2cap_conn *conn,
 }
 
 static inline int l2cap_information_rsp(struct l2cap_conn *conn,
-					struct l2cap_cmd_hdr *cmd, u8 *data)
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
 
@@ -5060,16 +5094,16 @@ static inline int l2cap_bredr_sig_cmd(struct l2cap_conn *conn,
 
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
 	case L2CAP_CREATE_CHAN_RSP:
-		err = l2cap_connect_create_rsp(conn, cmd, data);
+		err = l2cap_connect_create_rsp(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_CONF_REQ:
@@ -5077,15 +5111,15 @@ static inline int l2cap_bredr_sig_cmd(struct l2cap_conn *conn,
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
@@ -5096,11 +5130,11 @@ static inline int l2cap_bredr_sig_cmd(struct l2cap_conn *conn,
 		break;
 
 	case L2CAP_INFO_REQ:
-		err = l2cap_information_req(conn, cmd, data);
+		err = l2cap_information_req(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_INFO_RSP:
-		err = l2cap_information_rsp(conn, cmd, data);
+		err = l2cap_information_rsp(conn, cmd, cmd_len, data);
 		break;
 
 	case L2CAP_CREATE_CHAN_REQ:
-- 
1.8.1.2

