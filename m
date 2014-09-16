Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaIPWKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:10:49 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60286 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbaIPWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:08:26 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:44 +0000
Message-Id: <1410910735-27929-8-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 07/18] usbip: Add proper error reporting
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

This patch adds new error codes and features extended error reporting in
op_common packets.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/src/usbip_attach.c  |  4 +--
 tools/usb/usbip/src/usbip_list.c    |  3 ++-
 tools/usb/usbip/src/usbip_network.c | 51 ++++++++++++++++++++++++++++---------
 tools/usb/usbip/src/usbip_network.h | 17 +++++++++++--
 tools/usb/usbip/src/usbipd.c        | 25 ++++++++++--------
 5 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/tools/usb/usbip/src/usbip_attach.c b/tools/usb/usbip/src/usbip_attach.c
index 4421ebc..51c67a2 100644
--- a/tools/usb/usbip/src/usbip_attach.c
+++ b/tools/usb/usbip/src/usbip_attach.c
@@ -147,7 +147,7 @@ static int query_import_device(int sockfd, char *busid)
 	/* receive a reply */
 	rc = usbip_net_recv_op_common(sockfd, &code);
 	if (rc < 0) {
-		err("recv op_common");
+		err("recv op_common: %s", usbip_net_strerror(rc));
 		return -1;
 	}
 
@@ -177,7 +177,7 @@ static int attach_device(char *host, char *busid)
 
 	sockfd = usbip_net_connect(host);
 	if (sockfd < 0) {
-		err("tcp connect");
+		err("connection attempt failed");
 		return -1;
 	}
 
diff --git a/tools/usb/usbip/src/usbip_list.c b/tools/usb/usbip/src/usbip_list.c
index 6042b7e..c122f41 100644
--- a/tools/usb/usbip/src/usbip_list.c
+++ b/tools/usb/usbip/src/usbip_list.c
@@ -64,7 +64,8 @@ static int get_exported_devices(char *host, int sockfd)
 
 	rc = usbip_net_recv_op_common(sockfd, &code);
 	if (rc < 0) {
-		dbg("usbip_net_recv_op_common failed");
+		err("usbip_net_recv_op_common failed: %s",
+		    usbip_net_strerror(rc));
 		return -1;
 	}
 
diff --git a/tools/usb/usbip/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
index 6b8f949..f68741d 100644
--- a/tools/usb/usbip/src/usbip_network.c
+++ b/tools/usb/usbip/src/usbip_network.c
@@ -182,7 +182,7 @@ int usbip_net_recv_op_common(int sockfd, uint16_t *code)
 	rc = usbip_net_recv(sockfd, &op_common, sizeof(op_common));
 	if (rc < 0) {
 		dbg("usbip_net_recv failed: %d", rc);
-		goto err;
+		return -ERR_SYSERR;
 	}
 
 	PACK_OP_COMMON(0, &op_common);
@@ -190,30 +190,49 @@ int usbip_net_recv_op_common(int sockfd, uint16_t *code)
 	if (op_common.version != USBIP_VERSION) {
 		dbg("version mismatch: %d %d", op_common.version,
 		    USBIP_VERSION);
-		goto err;
+		return -ERR_MISMATCH;
 	}
 
 	switch (*code) {
 	case OP_UNSPEC:
 		break;
 	default:
-		if (op_common.code != *code) {
+		/*
+		 * Only accept expected opcode. Exception: OP_REPLY
+		 * flag set may be sent as a reply to all requests,
+		 * if only used for status reporting.
+		 */
+		if (op_common.code != *code && op_common.code != OP_REPLY) {
 			dbg("unexpected pdu %#0x for %#0x", op_common.code,
 			    *code);
-			goto err;
+			return -ERR_UNEXPECTED;
 		}
 	}
 
-	if (op_common.status != ST_OK) {
-		dbg("request failed at peer: %d", op_common.status);
-		goto err;
-	}
-
 	*code = op_common.code;
 
-	return 0;
-err:
-	return -1;
+	return -op_common.status;
+}
+
+const char *usbip_net_strerror(int status)
+{
+	static const char *const errs[] = {
+		/* ERR_OK */ "Success",
+		/* ERR_NA */ "Command failed",
+		/* ERR_MISMATCH */ "Protocol version mismatch",
+		/* ERR_SYSERR */ "System error",
+		/* ERR_UNEXPECTED */ "Unexpected opcode received",
+		/* ERR_AUTHREQ */ "Server requires authentication",
+		/* ERR_PERM */ "Permission denied",
+		/* ERR_NOTFOUND */ "Requested device not found",
+		/* ERR_NOAUTH */ "Server doesn't support authentication"
+	};
+	if (status < 0)
+		status = -status;
+	if (status >= (int) (sizeof(errs) / sizeof(*errs)) ||
+	    status < 0) /* Happens if status was INT_MIN before */
+		return "Invalid";
+	return errs[status];
 }
 
 int usbip_net_set_reuseaddr(int sockfd)
@@ -467,6 +486,7 @@ int usbip_net_connect(char *hostname)
 #ifdef HAVE_GNUTLS
 	if (usbip_srp_password) {
 		int rc;
+		uint16_t code = OP_REP_STARTTLS;
 
 		rc = usbip_net_send_op_common(sockfd, OP_REQ_STARTTLS, 0);
 		if (rc < 0) {
@@ -474,6 +494,13 @@ int usbip_net_connect(char *hostname)
 			return EAI_SYSTEM;
 		}
 
+		rc = usbip_net_recv_op_common(sockfd, &code);
+		if (rc < 0) {
+			err("STARTTLS attempt failed: %s",
+			    usbip_net_strerror(rc));
+			return -1;
+		}
+
 		rc = usbip_net_srp_client_handshake(sockfd);
 		if (rc < 0) {
 			err("Unable to perform TLS handshake (wrong password?): %s",
diff --git a/tools/usb/usbip/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
index 292d584..151e815 100644
--- a/tools/usb/usbip/src/usbip_network.h
+++ b/tools/usb/usbip/src/usbip_network.h
@@ -28,8 +28,15 @@ struct op_common {
 	uint16_t code;
 
 	/* add more error code */
-#define ST_OK	0x00
-#define ST_NA	0x01
+#define ERR_OK         0x00
+#define ERR_NA         0x01
+#define ERR_MISMATCH   0x02
+#define ERR_SYSERR     0x03
+#define ERR_UNEXPECTED 0x04
+#define ERR_AUTHREQ    0x05
+#define ERR_PERM       0x06
+#define ERR_NOTFOUND   0x07
+#define ERR_NOAUTH     0x08
 	uint32_t status; /* op_code status (for reply) */
 
 } __attribute__((packed));
@@ -178,10 +185,16 @@ void usbip_net_pack_uint32_t(int pack, uint32_t *num);
 void usbip_net_pack_uint16_t(int pack, uint16_t *num);
 void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
 void usbip_net_pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
+const char *usbip_net_strerror(int status);
 
 ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen);
 ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen);
 int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status);
+/*
+ * Receive opcode.
+ * Returns: 0 on success, negative error code (that may be passed to
+ * usbip_net_strerror) on failure.
+ */
 int usbip_net_recv_op_common(int sockfd, uint16_t *code);
 int usbip_net_set_reuseaddr(int sockfd);
 int usbip_net_set_nodelay(int sockfd);
diff --git a/tools/usb/usbip/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
index 7c0a46d..4ac4206 100644
--- a/tools/usb/usbip/src/usbipd.c
+++ b/tools/usb/usbip/src/usbipd.c
@@ -167,7 +167,7 @@ static int recv_request_import(int sockfd)
 	char sysfs_attr[SYSFS_IP_ACLS_MAX];
 	char ip_attr_path[SYSFS_PATH_MAX];
 	int found = 0;
-	int error = 0;
+	int error = ERR_OK;
 	int rc;
 
 	memset(&req, 0, sizeof(req));
@@ -196,7 +196,7 @@ static int recv_request_import(int sockfd)
 		/* export device needs a TCP/IP socket descriptor */
 		rc = usbip_host_export_device(edev, sockfd);
 		if (rc < 0)
-			error = 1;
+			error = ERR_SYSERR;
 
 		/* check for allowed IPs */
 		snprintf(ip_attr_path, sizeof(ip_attr_path), "%s/%s",
@@ -213,17 +213,16 @@ static int recv_request_import(int sockfd)
 		}
 	} else {
 		info("requested device not found: %s", req.busid);
-		error = 1;
+		error = ERR_NOTFOUND;
 	}
 
-	rc = usbip_net_send_op_common(sockfd, OP_REP_IMPORT,
-				      (!error ? ST_OK : ST_NA));
+	rc = usbip_net_send_op_common(sockfd, OP_REP_IMPORT, error);
 	if (rc < 0) {
 		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_IMPORT);
 		return -1;
 	}
 
-	if (error) {
+	if (error != 0) {
 		dbg("import request busid %s: failed", req.busid);
 		return -1;
 	}
@@ -258,7 +257,7 @@ static int send_reply_devlist(int connfd)
 	}
 	info("exportable devices: %d", reply.ndev);
 
-	rc = usbip_net_send_op_common(connfd, OP_REP_DEVLIST, ST_OK);
+	rc = usbip_net_send_op_common(connfd, OP_REP_DEVLIST, ERR_OK);
 	if (rc < 0) {
 		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_DEVLIST);
 		return -1;
@@ -341,7 +340,8 @@ static int recv_pdu(int connfd)
 
 		ret = usbip_net_recv_op_common(connfd, &code);
 		if (ret < 0) {
-			dbg("could not receive opcode: %#0x", code);
+			dbg("could not receive opcode: %#0x: %s", code,
+			    usbip_net_strerror(ret));
 			return -1;
 		}
 
@@ -349,7 +349,8 @@ static int recv_pdu(int connfd)
 
 		/* We require an authenticated encryption */
 		if (!auth && code != OP_REQ_STARTTLS) {
-			usbip_net_send_op_common(connfd, OP_REPLY, ST_NA);
+			info("Unauthenticated connection attempt");
+			usbip_net_send_op_common(connfd, OP_REPLY, ERR_AUTHREQ);
 			return -1;
 		}
 
@@ -357,9 +358,13 @@ static int recv_pdu(int connfd)
 #ifdef HAVE_GNUTLS
 		case OP_REQ_STARTTLS:
 			if (!need_auth) {
-				ret = -1;
+				usbip_net_send_op_common(connfd, OP_REPLY,
+							 ERR_NOAUTH);
 				err("Unexpected TLS handshake attempt (client uses password, server doesn't)");
+				ret = -1;
 			} else {
+				usbip_net_send_op_common(connfd, OP_REPLY,
+							 ERR_OK);
 				ret = net_srp_server_handshake(connfd);
 				if (ret != 0)
 					err("TLS handshake failed");
-- 
2.1.0

