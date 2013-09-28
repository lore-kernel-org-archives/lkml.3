Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3I1RpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:45:00 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:36394 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928Ab3I1Rna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:43:30 -0400
X-RRZE-Submit-IP: 212.255.254.196
From: Dominik Paulus <dominik.paulus@fau.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org, tobias.polzer@fau.de,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCHv3  10/16] staging: usbip: TLS for all userspace communication
Date: Sat, 28 Sep 2013 19:42:47 +0200
Message-Id: <1380390173-3746-10-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the TLS support to cover all communication in
userspace. The TLS connection is released shortly before the socket is
passed to the kernel.

This requires for additional connection state to be passed between
functions. We thus replaced the sockfd by a struct containing the TLS
context as well as the fd.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/src/usbip_attach.c |  24 +-
 drivers/staging/usbip/userspace/src/usbip_list.c   |  24 +-
 .../staging/usbip/userspace/src/usbip_network.c    | 279 +++++++++++++++++----
 .../staging/usbip/userspace/src/usbip_network.h    |  49 +++-
 drivers/staging/usbip/userspace/src/usbipd.c       | 244 ++++--------------
 5 files changed, 358 insertions(+), 262 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 651e93a..25c68e2 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -86,7 +86,8 @@ static int record_connection(char *host, char *port, char *busid, int rhport)
 	return 0;
 }
 
-static int import_device(int sockfd, struct usbip_usb_device *udev)
+static int import_device(struct usbip_connection *conn,
+			 struct usbip_usb_device *udev)
 {
 	int rc;
 	int port;
@@ -104,8 +105,10 @@ static int import_device(int sockfd, struct usbip_usb_device *udev)
 		return -1;
 	}
 
-	rc = usbip_vhci_attach_device(port, sockfd, udev->busnum,
+	usbip_net_bye(conn);
+	rc = usbip_vhci_attach_device(port, conn->sockfd, udev->busnum,
 				      udev->devnum, udev->speed);
+
 	if (rc < 0) {
 		err("import device");
 		usbip_vhci_driver_close();
@@ -117,7 +120,7 @@ static int import_device(int sockfd, struct usbip_usb_device *udev)
 	return port;
 }
 
-static int query_import_device(int sockfd, char *busid)
+static int query_import_device(struct usbip_connection *conn, char *busid)
 {
 	int rc;
 	struct op_import_request request;
@@ -128,7 +131,7 @@ static int query_import_device(int sockfd, char *busid)
 	memset(&reply, 0, sizeof(reply));
 
 	/* send a request */
-	rc = usbip_net_send_op_common(sockfd, OP_REQ_IMPORT, 0);
+	rc = usbip_net_send_op_common(conn, OP_REQ_IMPORT, 0);
 	if (rc < 0) {
 		err("send op_common");
 		return -1;
@@ -138,20 +141,20 @@ static int query_import_device(int sockfd, char *busid)
 
 	PACK_OP_IMPORT_REQUEST(0, &request);
 
-	rc = usbip_net_send(sockfd, (void *) &request, sizeof(request));
+	rc = usbip_net_send(conn, (void *) &request, sizeof(request));
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
+	rc = usbip_net_recv(conn, (void *) &reply, sizeof(reply));
 	if (rc < 0) {
 		err("recv op_import_reply");
 		return -1;
@@ -166,7 +169,7 @@ static int query_import_device(int sockfd, char *busid)
 	}
 
 	/* import a device */
-	return import_device(sockfd, &reply.udev);
+	return import_device(conn, &reply.udev);
 }
 
 static int attach_device(char *host, char *busid)
@@ -174,14 +177,15 @@ static int attach_device(char *host, char *busid)
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
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index ff7acf8..187eb7d 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
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
 	int j, rc;
 
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
@@ -106,7 +106,7 @@ static int get_exported_devices(char *host, int sockfd)
 		printf("%11s: %s\n", "", class_name);
 
 		for (j = 0; j < udev.bNumInterfaces; j++) {
-			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
+			rc = usbip_net_recv(conn, &uintf, sizeof(uintf));
 			if (rc < 0) {
 				dbg("usbip_net_recv failed: usbip_usb_intf[%d]",
 				    j);
@@ -130,23 +130,23 @@ static int get_exported_devices(char *host, int sockfd)
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
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index a606e2b..22fa680 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -24,6 +24,7 @@
 #include <netdb.h>
 #include <netinet/tcp.h>
 #include <unistd.h>
+#include <assert.h>
 
 #ifdef HAVE_LIBWRAP
 #include <tcpd.h>
@@ -32,6 +33,7 @@
 #include "../config.h"
 #ifdef HAVE_GNUTLS
 #include <gnutls/gnutls.h>
+#include <gnutls/crypto.h>
 #endif
 
 #include "usbip_common.h"
@@ -112,8 +114,8 @@ void usbip_net_pack_usb_interface(int pack __attribute__((unused)),
 	/* uint8_t members need nothing */
 }
 
-static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
-			      int sending)
+static ssize_t usbip_net_xmit(struct usbip_connection *conn, void *buff,
+			      size_t bufflen, int sending)
 {
 	ssize_t nbytes;
 	ssize_t total = 0;
@@ -122,10 +124,22 @@ static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
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
+			nbytes = gnutls_record_send(conn->session, buff, bufflen);
 		else
-			nbytes = recv(sockfd, buff, bufflen, MSG_WAITALL);
+			nbytes = gnutls_record_recv(conn->session, buff, bufflen);
+#else
+		/*
+		 * Assertion to let gcc be able to infer proper initialization
+		 * of nbytes.
+		 */
+		assert(!conn->have_crypto);
+#endif
 
 		if (nbytes <= 0)
 			return -1;
@@ -139,17 +153,20 @@ static ssize_t usbip_net_xmit(int sockfd, void *buff, size_t bufflen,
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
@@ -162,7 +179,7 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
 
 	PACK_OP_COMMON(1, &op_common);
 
-	rc = usbip_net_send(sockfd, &op_common, sizeof(op_common));
+	rc = usbip_net_send(conn, &op_common, sizeof(op_common));
 	if (rc < 0) {
 		dbg("usbip_net_send failed: %d", rc);
 		return -1;
@@ -171,14 +188,15 @@ int usbip_net_send_op_common(int sockfd, uint32_t code, uint32_t status)
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
@@ -224,7 +242,8 @@ const char *usbip_net_strerror(int status)
 		/* ERR_AUTHREQ */ "Server requires authentication",
 		/* ERR_PERM */ "Permission denied",
 		/* ERR_NOTFOUND */ "Requested device not found",
-		/* ERR_NOAUTH */ "Server doesn't support authentication"
+		/* ERR_NOAUTH */ "Server doesn't support authentication",
+		/* ERR_INUSE */ "Requested device is already in use"
 	};
 	if (status < 0)
 		status = -status;
@@ -250,7 +269,8 @@ int usbip_net_set_nodelay(int sockfd)
 	const int val = 1;
 	int ret;
 
-	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
+	ret = setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &val,
+		sizeof(val));
 	if (ret < 0)
 		dbg("setsockopt: TCP_NODELAY");
 
@@ -329,82 +349,249 @@ int usbip_net_tcp_connect(char *hostname, char *service)
 }
 
 #ifdef HAVE_GNUTLS
-int usbip_net_srp_handshake(int sockfd)
+static gnutls_datum_t usbip_net_srp_salt, usbip_net_srp_verifier;
+static gnutls_srp_server_credentials_t usbip_net_srp_cred;
+
+#define SRP_GROUP gnutls_srp_2048_group_generator
+#define SRP_PRIME gnutls_srp_2048_group_prime
+
+int usbip_net_srp_client_handshake(struct usbip_connection *conn)
 {
 	int ret;
-	gnutls_session_t session;
-	gnutls_srp_client_credentials_t srp_cred;
 
-	ret = gnutls_srp_allocate_client_credentials(&srp_cred);
+	ret = gnutls_srp_allocate_client_credentials(&conn->srp_client_cred);
 	if (ret < 0)
 		return ret;
 
-	gnutls_srp_set_client_credentials(srp_cred, "dummyuser",
+	gnutls_srp_set_client_credentials(conn->srp_client_cred, "dummyuser",
 		usbip_srp_password);
 
-	ret = gnutls_init(&session, GNUTLS_CLIENT);
+	ret = gnutls_init(&conn->session, GNUTLS_CLIENT);
 	if (ret < 0) {
-		gnutls_srp_free_client_credentials(srp_cred);
+		gnutls_srp_free_client_credentials(conn->srp_client_cred);
 		return ret;
 	}
 
-	gnutls_priority_set_direct(session, "NORMAL:+SRP", NULL);
+	gnutls_priority_set_direct(conn->session, "NORMAL:+SRP", NULL);
 
-	gnutls_credentials_set(session, GNUTLS_CRD_SRP, srp_cred);
-	gnutls_transport_set_int (session, sockfd);
+	gnutls_credentials_set(conn->session, GNUTLS_CRD_SRP,
+			conn->srp_client_cred);
+	gnutls_transport_set_int (conn->session, conn->sockfd);
 
 	do {
-		ret = gnutls_handshake(session);
+		ret = gnutls_handshake(conn->session);
 	} while (ret < 0 && !gnutls_error_is_fatal(ret));
 
-	gnutls_bye(session, GNUTLS_SHUT_RDWR);
+	return ret;
+}
 
-	gnutls_deinit(session);
-	gnutls_srp_free_client_credentials(srp_cred);
+int usbip_net_srp_server_handshake(struct usbip_connection *conn)
+{
+	int ret;
+
+	if (gnutls_init(&conn->session, GNUTLS_SERVER) != 0)
+		return -1;
+	gnutls_priority_set_direct(conn->session, "NORMAL:-KX-ALL:+SRP", NULL);
+	if (gnutls_credentials_set(conn->session, GNUTLS_CRD_SRP,
+		usbip_net_srp_cred) != 0)
+		return -1;
+
+	gnutls_transport_set_int(conn->session, conn->sockfd);
+
+	do {
+		ret = gnutls_handshake(conn->session);
+	} while (ret < 0 && gnutls_error_is_fatal(ret) == 0);
+
+	if (ret < 0)
+		err("GnuTLS handshake failed (%s)", gnutls_strerror(ret));
+	else
+		info("GnuTLS handshake completed");
+
+	conn->have_crypto = 1;
 
 	return ret;
 }
+
+static int net_srp_callback(gnutls_session_t sess, const char *username,
+	gnutls_datum_t *nsalt, gnutls_datum_t *nverifier, gnutls_datum_t *g,
+	gnutls_datum_t *n)
+{
+	/*
+	 * GnuTLS expects us to allocate all data returned from callbacks
+	 * using gnutls_malloc(), thus, we have to create a fresh copy of
+	 * our static credentials for every connection.
+	 */
+	nsalt->data = gnutls_malloc(usbip_net_srp_salt.size);
+	nverifier->data = gnutls_malloc(usbip_net_srp_verifier.size);
+	if (nsalt->data == NULL || nverifier->data == NULL) {
+		gnutls_free(nsalt->data);
+		gnutls_free(nverifier->data);
+		return -1;
+	}
+	nsalt->size = usbip_net_srp_salt.size;
+	nverifier->size = usbip_net_srp_verifier.size;
+	memcpy(nverifier->data, usbip_net_srp_verifier.data,
+			usbip_net_srp_verifier.size);
+	memcpy(nsalt->data, usbip_net_srp_salt.data, usbip_net_srp_salt.size);
+
+	*g = SRP_GROUP;
+	*n = SRP_PRIME;
+
+	/* We only have a single session, thus, ignore it */
+	(void) sess;
+
+	if (strcmp(username, "dummyuser"))
+		/* User invalid, stored dummy data in g and n. */
+		return 1;
+
+	return 0;
+}
+
+int usbip_net_init_gnutls(void)
+{
+	int ret;
+
+	gnutls_global_init();
+
+	usbip_net_srp_salt.data = gnutls_malloc(16);
+	if (!usbip_net_srp_salt.data)
+		return GNUTLS_E_MEMORY_ERROR;
+
+	ret = gnutls_rnd(GNUTLS_RND_NONCE, usbip_net_srp_salt.data, 16);
+	if (ret < 0)
+		return ret;
+	usbip_net_srp_salt.size = 16;
+
+	ret = gnutls_srp_allocate_server_credentials(&usbip_net_srp_cred);
+	if (ret < 0)
+		return ret;
+
+	ret = gnutls_srp_verifier("dummyuser", optarg, &usbip_net_srp_salt,
+		&SRP_GROUP, &SRP_PRIME, &usbip_net_srp_verifier);
+	if (ret < 0)
+		return ret;
+
+	gnutls_srp_set_server_credentials_function(usbip_net_srp_cred,
+		net_srp_callback);
+
+	return GNUTLS_E_SUCCESS;
+}
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
+
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
 
-	sockfd = usbip_net_tcp_connect(hostname, usbip_port_string);
-	if (sockfd < 0)
-		return sockfd;
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
 
-		rc = usbip_net_srp_handshake(sockfd);
+		rc = usbip_net_srp_client_handshake(conn);
 		if (rc < 0) {
 			err("Unable to perform TLS handshake (wrong password?): %s",
 				gnutls_strerror(rc));
-			close(sockfd);
-			return EAI_SYSTEM;
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
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index 6a41fd8..cdc6769 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -9,6 +9,10 @@
 #include "../config.h"
 #endif
 
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#endif
+
 #include <sys/types.h>
 #include <sysfs/libsysfs.h>
 
@@ -25,6 +29,19 @@ extern char *usbip_port_string;
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
@@ -44,6 +61,7 @@ struct op_common {
 #define ERR_PERM       0x06
 #define ERR_NOTFOUND   0x07
 #define ERR_NOAUTH     0x08
+#define ERR_INUSE      0x09
 	uint32_t status; /* op_code status (for reply) */
 
 } __attribute__((packed));
@@ -194,19 +212,40 @@ void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
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
+int usbip_net_init_gnutls(void);
 
 #endif /* __USBIP_NETWORK_H */
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 6550460..6bd97a0 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -59,6 +59,7 @@
 #define DEFAULT_PID_FILE "/var/run/" PROGNAME ".pid"
 
 static const char usbip_version_string[] = PACKAGE_STRING;
+static int need_auth;
 
 static const char usbipd_help_string[] =
 	"usage: usbipd [options]\n"
@@ -93,78 +94,6 @@ static const char usbipd_help_string[] =
 	"	-v, --version\n"
 	"		Show version.\n";
 
-static int need_auth;
-#ifdef HAVE_GNUTLS
-static gnutls_datum_t srp_salt, srp_verifier;
-static gnutls_srp_server_credentials_t srp_cred;
-
-#define SRP_GROUP gnutls_srp_2048_group_generator
-#define SRP_PRIME gnutls_srp_2048_group_prime
-
-static int net_srp_callback(gnutls_session_t sess, const char *username,
-	gnutls_datum_t *nsalt, gnutls_datum_t *nverifier, gnutls_datum_t *g,
-	gnutls_datum_t *n)
-{
-	/*
-	 * GnuTLS expects us to allocate all data returned from callbacks
-	 * using gnutls_malloc(), thus, we have to create a fresh copy of
-	 * our static credentials for every connection.
-	 */
-	nsalt->data = gnutls_malloc(srp_salt.size);
-	nverifier->data = gnutls_malloc(srp_verifier.size);
-	if (nsalt->data == NULL || nverifier->data == NULL) {
-		gnutls_free(nsalt->data);
-		gnutls_free(nverifier->data);
-		return -1;
-	}
-	nsalt->size = srp_salt.size;
-	nverifier->size = srp_verifier.size;
-	memcpy(nverifier->data, srp_verifier.data, srp_verifier.size);
-	memcpy(nsalt->data, srp_salt.data, srp_salt.size);
-
-	*g = SRP_GROUP;
-	*n = SRP_PRIME;
-
-	/* We only have a single session, thus, ignore it */
-	(void) sess;
-
-	if (strcmp(username, "dummyuser"))
-		/* User invalid, stored dummy data in g and n. */
-		return 1;
-
-	return 0;
-}
-
-static int net_srp_server_handshake(int connfd)
-{
-	int ret;
-	gnutls_session_t session;
-
-	if (gnutls_init(&session, GNUTLS_SERVER) != 0)
-		return -1;
-	gnutls_priority_set_direct(session, "NORMAL:-KX-ALL:+SRP", NULL);
-	if (gnutls_credentials_set(session, GNUTLS_CRD_SRP, srp_cred) != 0)
-		return -1;
-
-	gnutls_transport_set_int(session, connfd);
-
-	do {
-		ret = gnutls_handshake(session);
-	} while (ret < 0 && gnutls_error_is_fatal(ret) == 0);
-
-	if (ret < 0)
-		err("GnuTLS handshake failed (%s)", gnutls_strerror(ret));
-	else
-		info("GnuTLS handshake completed");
-
-	if (gnutls_bye(session, GNUTLS_SHUT_RDWR) != 0)
-		err("Unable to shutdown TLS connection.");
-	gnutls_deinit(session);
-
-	return ret;
-}
-#endif
-
 static void usbipd_help(void)
 {
 	printf("%s\n", usbipd_help_string);
@@ -225,7 +154,7 @@ static int check_allowed(char *acls, int sockfd)
 	return match;
 }
 
-static int recv_request_import(int sockfd)
+static int recv_request_import(struct usbip_connection *conn)
 {
 	struct op_import_request req;
 	struct op_common reply;
@@ -240,7 +169,7 @@ static int recv_request_import(int sockfd)
 	memset(&req, 0, sizeof(req));
 	memset(&reply, 0, sizeof(reply));
 
-	rc = usbip_net_recv(sockfd, &req, sizeof(req));
+	rc = usbip_net_recv(conn, &req, sizeof(req));
 	if (rc < 0) {
 		dbg("usbip_net_recv failed: import request");
 		return -1;
@@ -258,12 +187,7 @@ static int recv_request_import(int sockfd)
 
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
 		snprintf(ip_attr_path, sizeof(ip_attr_path), "%s/%s:%d.%d/%s",
@@ -276,7 +200,8 @@ static int recv_request_import(int sockfd)
 			if (rc < 0) {
 				err("Unable to open sysfs");
 				error = ERR_SYSERR;
-			} else if (check_allowed(usbip_acl->value, sockfd) != 1) {
+			} else if (check_allowed(usbip_acl->value,
+						conn->sockfd) != 1) {
 				info("Access denied to device %s",
 					edev->udev.busid);
 				error = ERR_PERM;
@@ -285,12 +210,22 @@ static int recv_request_import(int sockfd)
 		} else {
 			err("failed to get ip list");
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
@@ -304,18 +239,27 @@ static int recv_request_import(int sockfd)
 	memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 	usbip_net_pack_usb_device(1, &pdu_udev);
 
-	rc = usbip_net_send(sockfd, &pdu_udev, sizeof(pdu_udev));
+	rc = usbip_net_send(conn, &pdu_udev, sizeof(pdu_udev));
 	if (rc < 0) {
 		dbg("usbip_net_send failed: devinfo");
 		return -1;
 	}
 
+	usbip_net_bye(conn);
+
+	/* export device needs a TCP/IP socket descriptor */
+	rc = usbip_host_export_device(edev, conn->sockfd);
+	if (rc < 0) {
+		err("usbip_host_export_device");
+		return -1;
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
@@ -332,14 +276,14 @@ static int send_reply_devlist(int connfd)
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
@@ -351,7 +295,7 @@ static int send_reply_devlist(int connfd)
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 		usbip_net_pack_usb_device(1, &pdu_udev);
 
-		rc = usbip_net_send(connfd, &pdu_udev, sizeof(pdu_udev));
+		rc = usbip_net_send(conn, &pdu_udev, sizeof(pdu_udev));
 		if (rc < 0) {
 			dbg("usbip_net_send failed: pdu_udev");
 			return -1;
@@ -362,7 +306,7 @@ static int send_reply_devlist(int connfd)
 			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
 			usbip_net_pack_usb_interface(1, &pdu_uinf);
 
-			rc = usbip_net_send(connfd, &pdu_uinf,
+			rc = usbip_net_send(conn, &pdu_uinf,
 					    sizeof(pdu_uinf));
 			if (rc < 0) {
 				dbg("usbip_net_send failed: pdu_uinf");
@@ -374,20 +318,20 @@ static int send_reply_devlist(int connfd)
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
@@ -396,7 +340,7 @@ static int recv_request_devlist(int connfd)
 	return 0;
 }
 
-static int recv_pdu(int connfd)
+static int recv_pdu(struct usbip_connection *conn)
 {
 	int auth = !need_auth, cont = 1, ret;
 
@@ -413,19 +357,19 @@ static int recv_pdu(int connfd)
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
 
@@ -433,15 +377,16 @@ static int recv_pdu(int connfd)
 #ifdef HAVE_GNUTLS
 		case OP_REQ_STARTTLS:
 			if (!need_auth) {
-				usbip_net_send_op_common(connfd, OP_REPLY,
+				usbip_net_send_op_common(conn, OP_REPLY,
 					ERR_NOAUTH);
 				err("Unexpected TLS handshake attempt (client "
 					"uses password, server doesn't)");
 				ret = -1;
 			} else {
-				usbip_net_send_op_common(connfd, OP_REPLY,
+				usbip_net_send_op_common(conn, OP_REPLY,
 					ERR_OK);
-				ret = net_srp_server_handshake(connfd);
+				err("Starting handshake");
+				ret = usbip_net_srp_server_handshake(conn);
 				if (ret != 0)
 					err("TLS handshake failed");
 				auth = 1;
@@ -449,11 +394,11 @@ static int recv_pdu(int connfd)
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
@@ -464,9 +409,9 @@ static int recv_pdu(int connfd)
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
@@ -474,71 +419,23 @@ static int recv_pdu(int connfd)
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
 
@@ -775,37 +672,6 @@ static int do_standalone_mode(int daemonize, int ipv4, int ipv6)
 	return 0;
 }
 
-#ifdef HAVE_GNUTLS
-static int usbip_init_gnutls(void)
-{
-	int ret;
-
-	gnutls_global_init();
-
-	srp_salt.data = gnutls_malloc(16);
-	if (!srp_salt.data)
-		return GNUTLS_E_MEMORY_ERROR;
-
-	ret = gnutls_rnd(GNUTLS_RND_NONCE, srp_salt.data, 16);
-	if (ret < 0)
-		return ret;
-	srp_salt.size = 16;
-
-	ret = gnutls_srp_allocate_server_credentials(&srp_cred);
-	if (ret < 0)
-		return ret;
-
-	ret = gnutls_srp_verifier("dummyuser", optarg, &srp_salt, &SRP_GROUP,
-		&SRP_PRIME, &srp_verifier);
-	if (ret < 0)
-		return ret;
-
-	gnutls_srp_set_server_credentials_function(srp_cred, net_srp_callback);
-
-	return GNUTLS_E_SUCCESS;
-}
-#endif
-
 int main(int argc, char *argv[])
 {
 	static const struct option longopts[] = {
@@ -859,7 +725,7 @@ int main(int argc, char *argv[])
 		case 's':
 #ifdef HAVE_GNUTLS
 			need_auth = 1;
-			ret = usbip_init_gnutls();
+			ret = usbip_net_init_gnutls();
 			if (ret < 0) {
 				err("Unable to initialize GnuTLS: %s",
 					gnutls_strerror(ret));
-- 
1.8.4

