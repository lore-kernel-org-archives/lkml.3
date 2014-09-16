Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaIPVrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:47:07 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60211 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbaIPVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:47:03 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:48 +0000
Message-Id: <1410910735-27929-12-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 11/18] usbip: TLS for all userspace communication
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

This patch extends the TLS support to cover all communication in
userspace. The TLS connection is released shortly before the socket is
passed to the kernel.

This requires for additional connection state to be passed between
functions. We thus replaced the sockfd by a struct containing the TLS
context as well as the fd.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 tools/usb/usbip/src/usbip_attach.c  |  68 ++++++++++--
 tools/usb/usbip/src/usbip_list.c    |  26 ++---
 tools/usb/usbip/src/usbip_network.c | 210 +++++++++++++++++++++++++-----------
 tools/usb/usbip/src/usbip_network.h |  49 +++++++--
 tools/usb/usbip/src/usbipd.c        | 158 +++++++++++++--------------
 5 files changed, 334 insertions(+), 177 deletions(-)

diff --git a/tools/usb/usbip/src/usbip_attach.c b/tools/usb/usbip/src/usbip_attach.c
index fcc3efb..4bc08e0 100644
--- a/tools/usb/usbip/src/usbip_attach.c
+++ b/tools/usb/usbip/src/usbip_attach.c
@@ -28,6 +28,13 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include "../config.h"
+
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#include <gnutls/crypto.h>
+#endif
+
 #include "vhci_driver.h"
 #include "usbip_common.h"
 #include "usbip_network.h"
@@ -86,10 +93,42 @@ static int record_connection(char *host, char *port, char *busid, int rhport)
 	return 0;
 }
 
-static int import_device(int sockfd, struct usbip_usb_device *udev)
+static int import_device(struct usbip_connection *conn,
+			 struct usbip_usb_device *udev)
 {
 	int rc;
 	int port;
+	struct vhci_conf conf;
+
+	conf.use_crypto = 0;
+#ifdef HAVE_GNUTLS
+	if (conn->have_crypto) {
+		dbg("Generating session key and sending it to client");
+
+		rc = gnutls_rnd(GNUTLS_RND_RANDOM, conf.key1,
+				sizeof(conf.key1));
+		if (rc < 0) {
+			err("Session key generation failed: %s",
+			    gnutls_strerror(rc));
+			return -1;
+		}
+		rc = gnutls_rnd(GNUTLS_RND_RANDOM, conf.key2,
+				sizeof(conf.key2));
+		if (rc < 0) {
+			err("Session key generation failed: %s",
+			    gnutls_strerror(rc));
+			return -1;
+		}
+
+		if (usbip_net_send(conn, conf.key1, sizeof(conf.key1)) < 0 ||
+		    usbip_net_send(conn, conf.key2, sizeof(conf.key2)) < 0) {
+			err("Unable to send session key to client");
+			return -1;
+		}
+
+		conf.use_crypto = 1;
+	}
+#endif
 
 	rc = usbip_vhci_driver_open();
 	if (rc < 0) {
@@ -104,8 +143,14 @@ static int import_device(int sockfd, struct usbip_usb_device *udev)
 		return -1;
 	}
 
-	rc = usbip_vhci_attach_device(port, sockfd, udev->busnum,
-				      udev->devnum, udev->speed);
+	usbip_net_bye(conn);
+
+	conf.port = port;
+	conf.sockfd = conn->sockfd;
+	conf.devid = get_devid(udev->busnum, udev->devnum);
+	conf.speed = udev->speed;
+
+	rc = usbip_vhci_attach_device(&conf);
 	if (rc < 0) {
 		err("import device");
 		usbip_vhci_driver_close();
@@ -117,7 +162,7 @@ static int import_device(int sockfd, struct usbip_usb_device *udev)
 	return port;
 }
 
-static int query_import_device(int sockfd, char *busid)
+static int query_import_device(struct usbip_connection *conn, char *busid)
 {
 	int rc;
 	struct op_import_request request;
@@ -128,7 +173,7 @@ static int query_import_device(int sockfd, char *busid)
 	memset(&reply, 0, sizeof(reply));
 
 	/* send a request */
-	rc = usbip_net_send_op_common(sockfd, OP_REQ_IMPORT, 0);
+	rc = usbip_net_send_op_common(conn, OP_REQ_IMPORT, 0);
 	if (rc < 0) {
 		err("send op_common");
 		return -1;
@@ -138,20 +183,20 @@ static int query_import_device(int sockfd, char *busid)
 
 	PACK_OP_IMPORT_REQUEST(0, &request);
 
-	rc = usbip_net_send(sockfd, (void *) &request, sizeof(request));
+	rc = usbip_net_send(conn, &request, sizeof(request));
 	if (rc < 0) {
 		err("send op_import_request");
 		return -1;
 	}
 
 	/* receive a reply */
-	rc = usbip_net_recv_op_common(sockfd, &code);
+	rc = usbip_net_recv_op_common(conn, &code);
 	if (rc < 0) {
 		err("recv op_common: %s", usbip_net_strerror(rc));
 		return -1;
 	}
 
-	rc = usbip_net_recv(sockfd, (void *) &reply, sizeof(reply));
+	rc = usbip_net_recv(conn, &reply, sizeof(reply));
 	if (rc < 0) {
 		err("recv op_import_reply");
 		return -1;
@@ -166,7 +211,7 @@ static int query_import_device(int sockfd, char *busid)
 	}
 
 	/* import a device */
-	return import_device(sockfd, &reply.udev);
+	return import_device(conn, &reply.udev);
 }
 
 static int attach_device(char *host, char *busid)
@@ -174,14 +219,15 @@ static int attach_device(char *host, char *busid)
 	int sockfd;
 	int rc;
 	int rhport;
+	struct usbip_connection conn;
 
-	sockfd = usbip_net_connect(host);
+	sockfd = usbip_net_connect(host, &conn);
 	if (sockfd < 0) {
 		err("connection attempt failed");
 		return -1;
 	}
 
-	rhport = query_import_device(sockfd, busid);
+	rhport = query_import_device(&conn, busid);
 	if (rhport < 0) {
 		err("query");
 		return -1;
diff --git a/tools/usb/usbip/src/usbip_list.c b/tools/usb/usbip/src/usbip_list.c
index c122f41..f0264f6 100644
--- a/tools/usb/usbip/src/usbip_list.c
+++ b/tools/usb/usbip/src/usbip_list.c
@@ -45,7 +45,7 @@ void usbip_list_usage(void)
 	printf("usage: %s", usbip_list_usage_string);
 }
 
-static int get_exported_devices(char *host, int sockfd)
+static int get_exported_devices(char *host, struct usbip_connection *conn)
 {
 	char product_name[100];
 	char class_name[100];
@@ -56,13 +56,13 @@ static int get_exported_devices(char *host, int sockfd)
 	unsigned int i;
 	int rc, j;
 
-	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	rc = usbip_net_send_op_common(conn, OP_REQ_DEVLIST, 0);
 	if (rc < 0) {
 		dbg("usbip_net_send_op_common failed");
 		return -1;
 	}
 
-	rc = usbip_net_recv_op_common(sockfd, &code);
+	rc = usbip_net_recv_op_common(conn, &code);
 	if (rc < 0) {
 		err("usbip_net_recv_op_common failed: %s",
 		    usbip_net_strerror(rc));
@@ -70,7 +70,7 @@ static int get_exported_devices(char *host, int sockfd)
 	}
 
 	memset(&reply, 0, sizeof(reply));
-	rc = usbip_net_recv(sockfd, &reply, sizeof(reply));
+	rc = usbip_net_recv(conn, &reply, sizeof(reply));
 	if (rc < 0) {
 		dbg("usbip_net_recv_op_devlist failed");
 		return -1;
@@ -89,7 +89,7 @@ static int get_exported_devices(char *host, int sockfd)
 
 	for (i = 0; i < reply.ndev; i++) {
 		memset(&udev, 0, sizeof(udev));
-		rc = usbip_net_recv(sockfd, &udev, sizeof(udev));
+		rc = usbip_net_recv(conn, &udev, sizeof(udev));
 		if (rc < 0) {
 			dbg("usbip_net_recv failed: usbip_usb_device[%d]", i);
 			return -1;
@@ -106,10 +106,10 @@ static int get_exported_devices(char *host, int sockfd)
 		printf("%11s: %s\n", "", class_name);
 
 		for (j = 0; j < udev.bNumInterfaces; j++) {
-			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
+			rc = usbip_net_recv(conn, &uintf, sizeof(uintf));
 			if (rc < 0) {
 				err("usbip_net_recv failed: usbip_usb_intf[%d]",
-						j);
+				    j);
 
 				return -1;
 			}
@@ -131,23 +131,23 @@ static int get_exported_devices(char *host, int sockfd)
 static int list_exported_devices(char *host)
 {
 	int rc;
-	int sockfd;
+	struct usbip_connection conn;
 
-	sockfd = usbip_net_connect(host);
-	if (sockfd < 0) {
+	rc = usbip_net_connect(host, &conn);
+	if (rc < 0) {
 		err("could not connect to %s:%s: %s", host,
-		    usbip_port_string, gai_strerror(sockfd));
+		    usbip_port_string, usbip_net_strerror(rc));
 		return -1;
 	}
 	dbg("connected to %s:%s", host, usbip_port_string);
 
-	rc = get_exported_devices(host, sockfd);
+	rc = get_exported_devices(host, &conn);
 	if (rc < 0) {
 		err("failed to get device list from %s", host);
 		return -1;
 	}
 
-	close(sockfd);
+	usbip_net_bye(&conn);
 
 	return 0;
 }
diff --git a/tools/usb/usbip/src/usbip_network.c b/tools/usb/usbip/src/usbip_network.c
index 6e6216d..233ad8b 100644
--- a/tools/usb/usbip/src/usbip_network.c
+++ b/tools/usb/usbip/src/usbip_network.c
@@ -24,6 +24,7 @@
 #include <netdb.h>
 #include <netinet/tcp.h>
 #include <unistd.h>
+#include <assert.h>
 
 #ifdef HAVE_LIBWRAP
 #include <tcpd.h>
@@ -113,20 +114,34 @@ void usbip_net_pack_usb_interface(int pack __attribute__((unused)),
 	/* uint8_t members need nothing */
 }
 
-static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
-			      int sending)
+static ssize_t usbip_net_xmit(struct usbip_connection *conn, void *buff,
+			      size_t bufflen, int sending)
 {
-	ssize_t nbytes;
+	ssize_t nbytes = 0;
 	ssize_t total = 0;
 
 	if (!bufflen)
 		return 0;
 
 	do {
-		if (sending)
-			nbytes = send(sockfd, buff, bufflen, 0);
+		if (!conn->have_crypto && sending)
+			nbytes = send(conn->sockfd, buff, bufflen, 0);
+		else if (!conn->have_crypto && !sending)
+			nbytes = recv(conn->sockfd, buff, bufflen, MSG_WAITALL);
+#ifdef HAVE_GNUTLS
+		else if (sending)
+			nbytes = gnutls_record_send(conn->session, buff,
+						    bufflen);
 		else
-			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
+			nbytes = gnutls_record_recv(conn->session, buff,
+						    bufflen);
+#else
+		/*
+		 * Assertion to let gcc be able to infer proper initialization
+		 * of nbytes.
+		 */
+		assert(!conn->have_crypto);
+#endif
 
 		if (nbytes <= 0)
 			return -1;
@@ -140,17 +155,20 @@ static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
 	return total;
 }
 
-ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen)
+ssize_t usbip_net_recv(struct usbip_connection *conn, void *buff,
+		       size_t bufflen)
 {
-	return usbip_net_xmit(sockfd, buff, bufflen, 0);
+	return usbip_net_xmit(conn, buff, bufflen, 0);
 }
 
-ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen)
+ssize_t usbip_net_send(struct usbip_connection *conn, void *buff,
+		       size_t bufflen)
 {
-	return usbip_net_xmit(sockfd, buff, bufflen, 1);
+	return usbip_net_xmit(conn, buff, bufflen, 1);
 }
 
-int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
+int usbip_net_send_op_common(struct usbip_connection *conn, uint32_t code,
+			     uint32_t status)
 {
 	struct op_common op_common;
 	int rc;
@@ -163,7 +181,7 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	PACK_OP_COMMON(1, &op_common);
 
-	rc = usbip_net_send(sockfd, &op_common, sizeof(op_common));
+	rc = usbip_net_send(conn, &op_common, sizeof(op_common));
 	if (rc < 0) {
 		dbg("usbip_net_send failed: %d", rc);
 		return -1;
@@ -172,14 +190,15 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 	return 0;
 }
 
-int usbip_net_recv_op_common(int sockfd, uint16_t *code)
+
+int usbip_net_recv_op_common(struct usbip_connection *conn, uint16_t *code)
 {
 	struct op_common op_common;
 	int rc;
 
 	memset(&op_common, 0, sizeof(op_common));
 
-	rc = usbip_net_recv(sockfd, &op_common, sizeof(op_common));
+	rc = usbip_net_recv(conn, &op_common, sizeof(op_common));
 	if (rc < 0) {
 		dbg("usbip_net_recv failed: %d", rc);
 		return -ERR_SYSERR;
@@ -225,7 +244,8 @@ const char *usbip_net_strerror(int status)
 		/* ERR_AUTHREQ */ "Server requires authentication",
 		/* ERR_PERM */ "Permission denied",
 		/* ERR_NOTFOUND */ "Requested device not found",
-		/* ERR_NOAUTH */ "Server doesn't support authentication"
+		/* ERR_NOAUTH */ "Server doesn't support authentication",
+		/* ERR_INUSE */ "Requested device is already in use"
 	};
 	if (status < 0)
 		status = -status;
@@ -252,7 +272,8 @@ int usbip_net_set_nodelay(int sockfd)
 	const int val = 1;
 	int ret;
 
-	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
+	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val,
+		sizeof(val));
 	if (ret < 0)
 		dbg("setsockopt: TCP_NODELAY");
 
@@ -337,59 +358,53 @@ static gnutls_srp_server_credentials_t usbip_net_srp_cred;
 #define SRP_GROUP gnutls_srp_2048_group_generator
 #define SRP_PRIME gnutls_srp_2048_group_prime
 
-int usbip_net_srp_client_handshake(int sockfd)
+int usbip_net_srp_client_handshake(struct usbip_connection *conn)
 {
 	int ret;
-	gnutls_session_t session;
-	gnutls_srp_client_credentials_t usbip_net_srp_cred;
 
-	ret = gnutls_srp_allocate_client_credentials(&usbip_net_srp_cred);
+	ret = gnutls_srp_allocate_client_credentials(&conn->srp_client_cred);
 	if (ret < 0)
 		return ret;
 
-	gnutls_srp_set_client_credentials(usbip_net_srp_cred, "dummyuser",
+	gnutls_srp_set_client_credentials(conn->srp_client_cred, "dummyuser",
 		usbip_srp_password);
 
-	ret = gnutls_init(&session, GNUTLS_CLIENT);
+	ret = gnutls_init(&conn->session, GNUTLS_CLIENT);
 	if (ret < 0) {
-		gnutls_srp_free_client_credentials(usbip_net_srp_cred);
+		gnutls_srp_free_client_credentials(conn->srp_client_cred);
 		return ret;
 	}
 
-	gnutls_priority_set_direct(session, "NORMAL:+SRP", NULL);
+	gnutls_priority_set_direct(conn->session, "NORMAL:+SRP", NULL);
 
-	gnutls_credentials_set(session, GNUTLS_CRD_SRP, usbip_net_srp_cred);
-	gnutls_transport_set_int (session, sockfd);
+	gnutls_credentials_set(conn->session, GNUTLS_CRD_SRP,
+			       conn->srp_client_cred);
+	gnutls_transport_set_int (conn->session, conn->sockfd);
 
 	do {
-		ret = gnutls_handshake(session);
+		ret = gnutls_handshake(conn->session);
 	} while (ret < 0 && !gnutls_error_is_fatal(ret));
 
-	gnutls_bye(session, GNUTLS_SHUT_RDWR);
-
-	gnutls_deinit(session);
-	gnutls_srp_free_client_credentials(usbip_net_srp_cred);
-
 	return ret;
 }
 
-int net_srp_server_handshake(int connfd)
+int usbip_net_srp_server_handshake(struct usbip_connection *conn)
 {
 	int ret;
-	gnutls_session_t session;
 
-	if (gnutls_init(&session, GNUTLS_SERVER) != 0)
+	ret = gnutls_init(&conn->session, GNUTLS_SERVER);
+	if (ret != 0)
 		return -1;
-	gnutls_priority_set_direct(session, "NORMAL:-KX-ALL:+SRP", NULL);
-	ret = gnutls_credentials_set(session, GNUTLS_CRD_SRP,
+	gnutls_priority_set_direct(conn->session, "NORMAL:-KX-ALL:+SRP", NULL);
+	ret = gnutls_credentials_set(conn->session, GNUTLS_CRD_SRP,
 				     usbip_net_srp_cred);
-	if (!ret)
+	if (ret < 0)
 		return -1;
 
-	gnutls_transport_set_int(session, connfd);
+	gnutls_transport_set_int(conn->session, conn->sockfd);
 
 	do {
-		ret = gnutls_handshake(session);
+		ret = gnutls_handshake(conn->session);
 	} while (ret < 0 && gnutls_error_is_fatal(ret) == 0);
 
 	if (ret < 0)
@@ -397,9 +412,7 @@ int net_srp_server_handshake(int connfd)
 	else
 		info("GnuTLS handshake completed");
 
-	if (gnutls_bye(session, GNUTLS_SHUT_RDWR) != 0)
-		err("Unable to shutdown TLS connection.");
-	gnutls_deinit(session);
+	conn->have_crypto = 1;
 
 	return ret;
 }
@@ -471,45 +484,120 @@ int usbip_net_init_gnutls(void)
 }
 #endif
 
-/*
- * Connect to the server. Performs the TCP connection attempt
- * and - if necessary - the TLS handshake used for authentication.
- */
-int usbip_net_connect(char *hostname)
+#ifdef HAVE_LIBWRAP
+static int tcpd_auth(int connfd)
 {
-	int sockfd;
+	struct request_info request;
+	int rc;
+
+	request_init(&request, RQ_DAEMON, PROGNAME, RQ_FILE, connfd, 0);
+	fromhost(&request);
+	rc = hosts_access(&request);
+	if (rc == 0)
+		return -1;
+
+	return 0;
+}
+#endif
+
+int usbip_net_accept(int listenfd, struct usbip_connection *conn)
+{
+	int connfd;
+	struct sockaddr_storage ss;
+	socklen_t len = sizeof(ss);
+	char host[NI_MAXHOST], port[NI_MAXSERV];
+	int rc;
+
+	memset(&ss, 0, sizeof(ss));
+
+	connfd = accept(listenfd, (struct sockaddr *)&ss, &len);
+	if (connfd < 0) {
+		err("failed to accept connection");
+		return -1;
+	}
 
-	sockfd = usbip_net_tcp_connect(hostname, usbip_port_string);
-	if (sockfd < 0)
-		return sockfd;
+	rc = getnameinfo((struct sockaddr *)&ss, len, host, sizeof(host),
+			 port, sizeof(port), NI_NUMERICHOST | NI_NUMERICSERV);
+	if (rc)
+		err("getnameinfo: %s", gai_strerror(rc));
+
+#ifdef HAVE_LIBWRAP
+	rc = tcpd_auth(connfd);
+	if (rc < 0) {
+		info("denied access from %s", host);
+		close(connfd);
+		return -1;
+	}
+#endif
+	info("connection from %s, port %s", host, port);
+
+	conn->sockfd = connfd;
+	conn->have_crypto = 0;
+	conn->server = 1;
+
+	return 0;
+}
+
+int usbip_net_connect(char *hostname, struct usbip_connection *conn)
+{
+	conn->sockfd = usbip_net_tcp_connect(hostname, usbip_port_string);
+	if (conn->sockfd < 0) {
+		err("TCP connection attempt failed: %s",
+				gai_strerror(conn->sockfd));
+		return ERR_SYSERR;
+	}
+
+	conn->have_crypto = 0;
+	conn->server = 0;
 
 #ifdef HAVE_GNUTLS
 	if (usbip_srp_password) {
 		int rc;
 		uint16_t code = OP_REP_STARTTLS;
 
-		rc = usbip_net_send_op_common(sockfd, OP_REQ_STARTTLS, 0);
+		rc = usbip_net_send_op_common(conn, OP_REQ_STARTTLS, 0);
 		if (rc < 0) {
+			close(conn->sockfd);
 			err("usbip_net_send_op_common failed");
-			return EAI_SYSTEM;
+			return ERR_SYSERR;
 		}
 
-		rc = usbip_net_recv_op_common(sockfd, &code);
+		rc = usbip_net_recv_op_common(conn, &code);
 		if (rc < 0) {
 			err("STARTTLS attempt failed: %s",
 			    usbip_net_strerror(rc));
-			return -1;
+			close(conn->sockfd);
+			return ERR_SYSERR;
 		}
 
-		rc = usbip_net_srp_client_handshake(sockfd);
+		rc = usbip_net_srp_client_handshake(conn);
 		if (rc < 0) {
 			err("Unable to perform TLS handshake (wrong password?): %s",
-			    gnutls_strerror(rc));
-			close(sockfd);
-			return EAI_SYSTEM;
+				gnutls_strerror(rc));
+			close(conn->sockfd);
+			return ERR_SYSERR;
 		}
+
+		conn->have_crypto = 1;
 	}
 #endif
 
-	return sockfd;
+	return 0;
+}
+
+void usbip_net_bye(struct usbip_connection *conn)
+{
+#ifdef HAVE_GNUTLS
+	if (conn->have_crypto) {
+		gnutls_bye(conn->session, GNUTLS_SHUT_RDWR);
+
+		gnutls_deinit(conn->session);
+		if (!conn->server)
+			gnutls_srp_free_client_credentials(conn->srp_client_cred);
+
+		conn->have_crypto = 0;
+	}
+#else
+	(void)conn;
+#endif
 }
diff --git a/tools/usb/usbip/src/usbip_network.h b/tools/usb/usbip/src/usbip_network.h
index 942d1bb..22fddfc 100644
--- a/tools/usb/usbip/src/usbip_network.h
+++ b/tools/usb/usbip/src/usbip_network.h
@@ -9,6 +9,10 @@
 #include "../config.h"
 #endif
 
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#endif
+
 #include <sys/types.h>
 
 #include <stdint.h>
@@ -24,6 +28,19 @@ extern char *usbip_port_string;
 extern char *usbip_srp_password;
 void usbip_setup_port_number(char *arg);
 
+/*
+ * Connection handle
+ */
+struct usbip_connection {
+#ifdef HAVE_GNUTLS
+	gnutls_session_t session;
+	gnutls_srp_client_credentials_t srp_client_cred;
+#endif
+	int have_crypto;
+	int sockfd;
+	int server;
+};
+
 /* ---------------------------------------------------------------------- */
 /* Common header for all the kinds of PDUs. */
 struct op_common {
@@ -43,6 +60,7 @@ struct op_common {
 #define ERR_PERM       0x06
 #define ERR_NOTFOUND   0x07
 #define ERR_NOAUTH     0x08
+#define ERR_INUSE      0x09
 	uint32_t status; /* op_code status (for reply) */
 
 } __attribute__((packed));
@@ -193,21 +211,40 @@ void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
 void usbip_net_pack_usb_interface(int pack, struct usbip_usb_interface *uinf);
 const char *usbip_net_strerror(int status);
 
-ssize_t usbip_net_recv(int sockfd, void *buff, size_t bufflen);
-ssize_t usbip_net_send(int sockfd, void *buff, size_t bufflen);
-int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status);
+ssize_t usbip_net_recv(struct usbip_connection *conn, void *buff,
+		       size_t bufflen);
+ssize_t usbip_net_send(struct usbip_connection *conn, void *buff,
+		       size_t bufflen);
+int usbip_net_send_op_common(struct usbip_connection *conn, uint32_t code,
+			     uint32_t status);
 /*
  * Receive opcode.
  * Returns: 0 on success, negative error code (that may be passed to
  * usbip_net_strerror) on failure.
  */
-int usbip_net_recv_op_common(int sockfd, uint16_t *code);
+int usbip_net_recv_op_common(struct usbip_connection *conn, uint16_t *code);
 int usbip_net_set_reuseaddr(int sockfd);
 int usbip_net_set_nodelay(int sockfd);
 int usbip_net_set_keepalive(int sockfd);
 int usbip_net_set_v6only(int sockfd);
-int usbip_net_connect(char *hostname);
-int net_srp_server_handshake(int connfd);
+/*
+ * Connect to the server. Performs the TCP connection attempt
+ * and - if necessary - the TLS handshake used for authentication.
+ *
+ * Newly generated connection parameters are stored in the - caller
+ * allocated - usbip_connection struct conn.
+ *
+ * Returns:
+ *	0 on success
+ *	negative error code on failure
+ */
+int usbip_net_connect(char *hostname, struct usbip_connection *conn);
+int usbip_net_accept(int listenfd, struct usbip_connection *conn);
+int usbip_net_srp_server_handshake(struct usbip_connection *conn);
+/*
+ * Shuts down the TLS connection, but leaves the socket intact
+ */
+void usbip_net_bye(struct usbip_connection *conn);
 int usbip_net_init_gnutls(void);
 
 #endif /* __USBIP_NETWORK_H */
diff --git a/tools/usb/usbip/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
index a7db6dc..122175e 100644
--- a/tools/usb/usbip/src/usbipd.c
+++ b/tools/usb/usbip/src/usbipd.c
@@ -61,6 +61,7 @@
 #define DEFAULT_PID_FILE "/var/run/" PROGNAME ".pid"
 
 static const char usbip_version_string[] = PACKAGE_STRING;
+static int need_auth;
 
 static const char usbipd_help_string[] =
 	"usage: usbipd [options]\n"
@@ -95,8 +96,6 @@ static const char usbipd_help_string[] =
 	"	-v, --version\n"
 	"		Show version.\n";
 
-static int need_auth;
-
 static void usbipd_help(void)
 {
 	printf("%s\n", usbipd_help_string);
@@ -157,7 +156,7 @@ static int check_allowed(char *acls, int sockfd)
 	return match;
 }
 
-static int recv_request_import(int sockfd)
+static int recv_request_import(struct usbip_connection *conn)
 {
 	struct op_import_request req;
 	struct op_common reply;
@@ -173,7 +172,7 @@ static int recv_request_import(int sockfd)
 	memset(&req, 0, sizeof(req));
 	memset(&reply, 0, sizeof(reply));
 
-	rc = usbip_net_recv(sockfd, &req, sizeof(req));
+	rc = usbip_net_recv(conn, &req, sizeof(req));
 	if (rc < 0) {
 		dbg("usbip_net_recv failed: import request");
 		return -1;
@@ -191,12 +190,7 @@ static int recv_request_import(int sockfd)
 
 	if (found) {
 		/* should set TCP_NODELAY for usbip */
-		usbip_net_set_nodelay(sockfd);
-
-		/* export device needs a TCP/IP socket descriptor */
-		rc = usbip_host_export_device(edev, sockfd);
-		if (rc < 0)
-			error = ERR_SYSERR;
+		usbip_net_set_nodelay(conn->sockfd);
 
 		/* check for allowed IPs */
 		snprintf(ip_attr_path, sizeof(ip_attr_path), "%s/%s",
@@ -211,12 +205,22 @@ static int recv_request_import(int sockfd)
 			     edev->udev.busid);
 			error = ERR_PERM;
 		}
+
+		/*
+		 * There is a race condition here: Other clients might
+		 * take it, as this check doesn't lock the device
+		 * However, this seems hardly avoidable here.
+		 */
+		if (edev->status != SDEV_ST_AVAILABLE) {
+			error = ERR_INUSE;
+			found = 0;
+		}
 	} else {
 		info("requested device not found: %s", req.busid);
 		error = ERR_NOTFOUND;
 	}
 
-	rc = usbip_net_send_op_common(sockfd, OP_REP_IMPORT, error);
+	rc = usbip_net_send_op_common(conn, OP_REP_IMPORT, error);
 	if (rc < 0) {
 		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_IMPORT);
 		return -1;
@@ -230,18 +234,47 @@ static int recv_request_import(int sockfd)
 	memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 	usbip_net_pack_usb_device(1, &pdu_udev);
 
-	rc = usbip_net_send(sockfd, &pdu_udev, sizeof(pdu_udev));
+	rc = usbip_net_send(conn, &pdu_udev, sizeof(pdu_udev));
 	if (rc < 0) {
 		dbg("usbip_net_send failed: devinfo");
 		return -1;
 	}
 
+	if (found) {
+		struct host_conf conf = {
+			.sockfd = conn->sockfd,
+			.use_crypto = 0
+		};
+
+#ifdef HAVE_GNUTLS
+		if (conn->have_crypto) {
+			if (usbip_net_recv(conn, conf.key1,
+						 sizeof(conf.key1)) < 0 ||
+			    usbip_net_recv(conn, conf.key2,
+						 sizeof(conf.key2)) < 0) {
+				err("Unable to receive session key");
+				return -1;
+			}
+			conf.use_crypto = 1;
+		}
+#endif
+
+		usbip_net_bye(conn);
+		/* export device needs a TCP/IP socket descriptor */
+		conf.sockfd = conn->sockfd;
+		rc = usbip_host_export_device(edev, &conf);
+		if (rc < 0) {
+			err("usbip_host_export_device");
+			return -1;
+		}
+	}
+
 	dbg("import request busid %s: complete", req.busid);
 
 	return 0;
 }
 
-static int send_reply_devlist(int connfd)
+static int send_reply_devlist(struct usbip_connection *conn)
 {
 	struct usbip_exported_device *edev;
 	struct usbip_usb_device pdu_udev;
@@ -257,14 +290,14 @@ static int send_reply_devlist(int connfd)
 	}
 	info("exportable devices: %d", reply.ndev);
 
-	rc = usbip_net_send_op_common(connfd, OP_REP_DEVLIST, ERR_OK);
+	rc = usbip_net_send_op_common(conn, OP_REP_DEVLIST, ERR_OK);
 	if (rc < 0) {
 		dbg("usbip_net_send_op_common failed: %#0x", OP_REP_DEVLIST);
 		return -1;
 	}
 	PACK_OP_DEVLIST_REPLY(1, &reply);
 
-	rc = usbip_net_send(connfd, &reply, sizeof(reply));
+	rc = usbip_net_send(conn, &reply, sizeof(reply));
 	if (rc < 0) {
 		dbg("usbip_net_send failed: %#0x", OP_REP_DEVLIST);
 		return -1;
@@ -276,7 +309,7 @@ static int send_reply_devlist(int connfd)
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 		usbip_net_pack_usb_device(1, &pdu_udev);
 
-		rc = usbip_net_send(connfd, &pdu_udev, sizeof(pdu_udev));
+		rc = usbip_net_send(conn, &pdu_udev, sizeof(pdu_udev));
 		if (rc < 0) {
 			dbg("usbip_net_send failed: pdu_udev");
 			return -1;
@@ -287,7 +320,7 @@ static int send_reply_devlist(int connfd)
 			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
 			usbip_net_pack_usb_interface(1, &pdu_uinf);
 
-			rc = usbip_net_send(connfd, &pdu_uinf,
+			rc = usbip_net_send(conn, &pdu_uinf,
 					sizeof(pdu_uinf));
 			if (rc < 0) {
 				err("usbip_net_send failed: pdu_uinf");
@@ -299,20 +332,20 @@ static int send_reply_devlist(int connfd)
 	return 0;
 }
 
-static int recv_request_devlist(int connfd)
+static int recv_request_devlist(struct usbip_connection *conn)
 {
 	struct op_devlist_request req;
 	int rc;
 
 	memset(&req, 0, sizeof(req));
 
-	rc = usbip_net_recv(connfd, &req, sizeof(req));
+	rc = usbip_net_recv(conn, &req, sizeof(req));
 	if (rc < 0) {
 		dbg("usbip_net_recv failed: devlist request");
 		return -1;
 	}
 
-	rc = send_reply_devlist(connfd);
+	rc = send_reply_devlist(conn);
 	if (rc < 0) {
 		dbg("send_reply_devlist failed");
 		return -1;
@@ -321,7 +354,7 @@ static int recv_request_devlist(int connfd)
 	return 0;
 }
 
-static int recv_pdu(int connfd)
+static int recv_pdu(struct usbip_connection *conn)
 {
 	int auth = !need_auth, cont = 1, ret;
 
@@ -338,19 +371,19 @@ static int recv_pdu(int connfd)
 	while (cont) {
 		uint16_t code = OP_UNSPEC;
 
-		ret = usbip_net_recv_op_common(connfd, &code);
+		ret = usbip_net_recv_op_common(conn, &code);
 		if (ret < 0) {
 			dbg("could not receive opcode: %#0x: %s", code,
 			    usbip_net_strerror(ret));
 			return -1;
 		}
 
-		info("received request: %#0x(%d)", code, connfd);
+		info("received request: %#0x", code);
 
 		/* We require an authenticated encryption */
 		if (!auth && code != OP_REQ_STARTTLS) {
 			info("Unauthenticated connection attempt");
-			usbip_net_send_op_common(connfd, OP_REPLY, ERR_AUTHREQ);
+			usbip_net_send_op_common(conn, OP_REPLY, ERR_AUTHREQ);
 			return -1;
 		}
 
@@ -358,14 +391,15 @@ static int recv_pdu(int connfd)
 #ifdef HAVE_GNUTLS
 		case OP_REQ_STARTTLS:
 			if (!need_auth) {
-				usbip_net_send_op_common(connfd, OP_REPLY,
+				usbip_net_send_op_common(conn, OP_REPLY,
 							 ERR_NOAUTH);
 				err("Unexpected TLS handshake attempt (client uses password, server doesn't)");
 				ret = -1;
 			} else {
-				usbip_net_send_op_common(connfd, OP_REPLY,
+				usbip_net_send_op_common(conn, OP_REPLY,
 							 ERR_OK);
-				ret = net_srp_server_handshake(connfd);
+				info("Starting handshake");
+				ret = usbip_net_srp_server_handshake(conn);
 				if (ret != 0)
 					err("TLS handshake failed");
 				auth = 1;
@@ -373,11 +407,11 @@ static int recv_pdu(int connfd)
 			break;
 #endif
 		case OP_REQ_DEVLIST:
-			ret = recv_request_devlist(connfd);
+			ret = recv_request_devlist(conn);
 			cont = 0;
 			break;
 		case OP_REQ_IMPORT:
-			ret = recv_request_import(connfd);
+			ret = recv_request_import(conn);
 			cont = 0;
 			break;
 		case OP_REQ_DEVINFO:
@@ -388,9 +422,9 @@ static int recv_pdu(int connfd)
 		}
 
 		if (ret == 0)
-			info("request %#0x(%d): complete", code, connfd);
+			info("request %#0x: complete", code);
 		else {
-			info("request %#0x(%d): failed", code, connfd);
+			info("request %#0x: failed", code);
 			break;
 		}
 	}
@@ -398,71 +432,23 @@ static int recv_pdu(int connfd)
 	return ret;
 }
 
-#ifdef HAVE_LIBWRAP
-static int tcpd_auth(int connfd)
-{
-	struct request_info request;
-	int rc;
-
-	request_init(&request, RQ_DAEMON, PROGNAME, RQ_FILE, connfd, 0);
-	fromhost(&request);
-	rc = hosts_access(&request);
-	if (rc == 0)
-		return -1;
-
-	return 0;
-}
-#endif
-
-static int do_accept(int listenfd)
-{
-	int connfd;
-	struct sockaddr_storage ss;
-	socklen_t len = sizeof(ss);
-	char host[NI_MAXHOST], port[NI_MAXSERV];
-	int rc;
-
-	memset(&ss, 0, sizeof(ss));
-
-	connfd = accept(listenfd, (struct sockaddr *)&ss, &len);
-	if (connfd < 0) {
-		err("failed to accept connection");
-		return -1;
-	}
-
-	rc = getnameinfo((struct sockaddr *)&ss, len, host, sizeof(host),
-			 port, sizeof(port), NI_NUMERICHOST | NI_NUMERICSERV);
-	if (rc)
-		err("getnameinfo: %s", gai_strerror(rc));
-
-#ifdef HAVE_LIBWRAP
-	rc = tcpd_auth(connfd);
-	if (rc < 0) {
-		info("denied access from %s", host);
-		close(connfd);
-		return -1;
-	}
-#endif
-	info("connection from %s, port %s", host, port);
-
-	return connfd;
-}
-
 int process_request(int listenfd)
 {
 	pid_t childpid;
-	int connfd;
+	struct usbip_connection conn;
+	int rc;
 
-	connfd = do_accept(listenfd);
-	if (connfd < 0)
+	rc = usbip_net_accept(listenfd, &conn);
+	if (rc < 0)
 		return -1;
 	childpid = fork();
 	if (childpid == 0) {
 		close(listenfd);
-		recv_pdu(connfd);
+		recv_pdu(&conn);
+		usbip_net_bye(&conn);
 		exit(0);
 	}
-	close(connfd);
+	close(conn.sockfd);
 	return 0;
 }
 
-- 
2.1.0

