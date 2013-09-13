Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3IMJ5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:57:05 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:50369 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab3IMJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:54:06 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org
Subject: [PATCHv2 02/11] staging: usbip: Add support for client authentication
Date: Fri, 13 Sep 2013 11:55:52 +0200
Message-Id: <1379066161-8278-3-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
References: <1379066161-8278-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for authenticating both client and server using
a pre-shared passphrase using SRP (Secure Remote Password) over TLS (see
RFC 5054) using GnuTLS. Both usbip and usbipd now accept a shared secret
as a command line argument. Currently, the established TLS connection is
only used to perform a secure handshake and dropped before the socket is
passed to the kernel. The code may be extended to exchange a session key
over TLS and pass it to the kernel to perform IPsec.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/configure.ac       |  14 ++
 drivers/staging/usbip/userspace/doc/usbip.8        |   6 +
 drivers/staging/usbip/userspace/doc/usbipd.8       |   6 +
 drivers/staging/usbip/userspace/src/usbip.c        |  30 ++-
 drivers/staging/usbip/userspace/src/usbip_attach.c |   2 +-
 drivers/staging/usbip/userspace/src/usbip_list.c   |   2 +-
 .../staging/usbip/userspace/src/usbip_network.c    |  82 ++++++++
 .../staging/usbip/userspace/src/usbip_network.h    |   9 +-
 drivers/staging/usbip/userspace/src/usbipd.c       | 217 ++++++++++++++++++---
 9 files changed, 335 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 2be4060..7bba496 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -84,6 +84,20 @@ AC_ARG_WITH([tcp-wrappers],
 		AC_DEFINE([HAVE_LIBWRAP], [1], [use tcp wrapper])],
 	       [AC_MSG_RESULT([no]); LIBS="$saved_LIBS"])])
 
+# Checks for the GnuTLS library
+AC_ARG_WITH([gnutls],
+			[AS_HELP_STRING([--with-gnutls],
+							[use the GnuTLS library for authentication])],
+			dnl [ACTION-IF-GIVEN]
+			[if test "$withval" = "yes"; then
+			 PKG_CHECK_MODULES([GNUTLS], [gnutls])
+			 AC_DEFINE([HAVE_GNUTLS], [1], [use gnutls])
+			 CFLAGS="$CFLAGS $GNUTLS_CFLAGS"
+			 LDFLAGS="$LDFLAGS $GNUTLS_LIBS"
+			 fi
+			],
+			)
+
 # Sets directory containing usb.ids.
 AC_ARG_WITH([usbids-dir],
 	    [AS_HELP_STRING([--with-usbids-dir=DIR],
diff --git a/drivers/staging/usbip/userspace/doc/usbip.8 b/drivers/staging/usbip/userspace/doc/usbip.8
index a6097be..b5050ed 100644
--- a/drivers/staging/usbip/userspace/doc/usbip.8
+++ b/drivers/staging/usbip/userspace/doc/usbip.8
@@ -29,6 +29,12 @@ Log to syslog.
 Connect to PORT on remote host (used for attach and list --remote).
 .PP
 
+.HP
+\fB\-\-auth\fR
+.IP
+Set the password to be used for client authentication. See usbipd(8) for more information.
+.PP
+
 .SH COMMANDS
 .HP
 \fBversion\fR
diff --git a/drivers/staging/usbip/userspace/doc/usbipd.8 b/drivers/staging/usbip/userspace/doc/usbipd.8
index ac4635d..b2b9eee 100644
--- a/drivers/staging/usbip/userspace/doc/usbipd.8
+++ b/drivers/staging/usbip/userspace/doc/usbipd.8
@@ -54,6 +54,12 @@ If no FILE specified, use /var/run/usbipd.pid
 Listen on TCP/IP port PORT.
 .PP
 
+.HP
+\fB\-s\fR, \fB\-\-auth\fR
+.IP
+Sets the password to be used for client authentication. If -a is used, the server will only accept connections from authenticated clients. Note: USB traffic will still be unencrypted, this currently only serves for authentication.
+.PP
+
 \fB\-h\fR, \fB\-\-help\fR
 .IP
 Print the program help message and exit.
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 04a5f20..8a5de83 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -25,6 +25,12 @@
 #include <getopt.h>
 #include <syslog.h>
 
+#include "../config.h"
+
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#endif
+
 #include "usbip_common.h"
 #include "usbip_network.h"
 #include "usbip.h"
@@ -35,8 +41,12 @@ static int usbip_version(int argc, char *argv[]);
 static const char usbip_version_string[] = PACKAGE_STRING;
 
 static const char usbip_usage_string[] =
-	"usbip [--debug] [--log] [--tcp-port PORT] [version]\n"
-	"             [help] <command> <args>\n";
+	"usbip "
+#ifdef HAVE_GNUTLS
+	"[--auth PASSWORD] "
+#endif
+	"[--debug] [--log] [--tcp-port PORT]\n"
+	"             [version] [help] <command> <args>\n";
 
 static void usbip_usage(void)
 {
@@ -142,6 +152,7 @@ int main(int argc, char *argv[])
 		{ "debug",    no_argument,       NULL, 'd' },
 		{ "log",      no_argument,       NULL, 'l' },
 		{ "tcp-port", required_argument, NULL, 't' },
+		{ "auth",     required_argument, NULL, 's' },
 		{ NULL,       0,                 NULL,  0  }
 	};
 
@@ -152,12 +163,25 @@ int main(int argc, char *argv[])
 	usbip_use_stderr = 1;
 	opterr = 0;
 	for (;;) {
-		opt = getopt_long(argc, argv, "+dlt:", opts, NULL);
+		opt = getopt_long(argc, argv, "+dls:t:", opts, NULL);
 
 		if (opt == -1)
 			break;
 
 		switch (opt) {
+		case 's':
+#ifdef HAVE_GNUTLS
+			usbip_srp_password = optarg;
+			rc = gnutls_global_init();
+			if (rc < 0) {
+				err("Unable to initialize GnuTLS library: %s",
+					gnutls_strerror(rc));
+				return EXIT_FAILURE;
+			}
+#else
+			err("usbip has been compiled without GnuTLS support");
+#endif
+			break;
 		case 'd':
 			usbip_use_debug = 1;
 			break;
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 0858411..2363e56 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -175,7 +175,7 @@ static int attach_device(char *host, char *busid)
 	int rc;
 	int rhport;
 
-	sockfd = usbip_net_tcp_connect(host, usbip_port_string);
+	sockfd = usbip_net_connect(host);
 	if (sockfd < 0) {
 		err("tcp connect");
 		return -1;
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 237e099..e4fa5b8 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -131,7 +131,7 @@ static int list_exported_devices(char *host)
 	int rc;
 	int sockfd;
 
-	sockfd = usbip_net_tcp_connect(host, usbip_port_string);
+	sockfd = usbip_net_connect(host);
 	if (sockfd < 0) {
 		err("could not connect to %s:%s: %s", host,
 		    usbip_port_string, gai_strerror(sockfd));
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index e78279c..eda641f 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -25,11 +25,20 @@
 #include <netinet/tcp.h>
 #include <unistd.h>
 
+#include "../config.h"
+
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#endif
+
 #include "usbip_common.h"
 #include "usbip_network.h"
 
 int usbip_port = 3240;
 char *usbip_port_string = "3240";
+#ifdef HAVE_GNUTLS
+char *usbip_srp_password;
+#endif
 
 void usbip_setup_port_number(char *arg)
 {
@@ -297,3 +306,76 @@ int usbip_net_tcp_connect(char *hostname, char *service)
 
 	return sockfd;
 }
+
+#ifdef HAVE_GNUTLS
+int usbip_net_srp_handshake(int sockfd)
+{
+	int ret;
+	gnutls_session_t session;
+	gnutls_srp_client_credentials_t srp_cred;
+
+	ret = gnutls_srp_allocate_client_credentials(&srp_cred);
+	if (ret < 0)
+		return ret;
+
+	gnutls_srp_set_client_credentials(srp_cred, "dummyuser",
+		usbip_srp_password);
+
+	ret = gnutls_init(&session, GNUTLS_CLIENT);
+	if (ret < 0) {
+		gnutls_srp_free_client_credentials(srp_cred);
+		return ret;
+	}
+
+	gnutls_priority_set_direct(session, "NORMAL:+SRP", NULL);
+
+	gnutls_credentials_set(session, GNUTLS_CRD_SRP, srp_cred);
+	gnutls_transport_set_int (session, sockfd);
+
+	do {
+		ret = gnutls_handshake(session);
+	} while (ret < 0 && !gnutls_error_is_fatal(ret));
+
+	gnutls_bye(session, GNUTLS_SHUT_RDWR);
+
+	gnutls_deinit(session);
+	gnutls_srp_free_client_credentials(srp_cred);
+
+	return ret;
+}
+#endif
+
+/*
+ * Connect to the server. Performs the TCP connection attempt
+ * and - if necessary - the TLS handshake used for authentication.
+ */
+int usbip_net_connect(char *hostname)
+{
+	int sockfd;
+
+	sockfd = usbip_net_tcp_connect(hostname, usbip_port_string);
+	if (sockfd < 0)
+		return sockfd;
+
+#ifdef HAVE_GNUTLS
+	if (usbip_srp_password) {
+		int rc;
+
+		rc = usbip_net_send_op_common(sockfd, OP_REQ_STARTTLS, 0);
+		if (rc < 0) {
+			err("usbip_net_send_op_common failed");
+			return EAI_SYSTEM;
+		}
+
+		rc = usbip_net_srp_handshake(sockfd);
+		if (rc < 0) {
+			err("Unable to perform TLS handshake (wrong password?): %s",
+				gnutls_strerror(rc));
+			close(sockfd);
+			return EAI_SYSTEM;
+		}
+	}
+#endif
+
+	return sockfd;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index f19ae19..758656b 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -16,6 +16,7 @@
 
 extern int usbip_port;
 extern char *usbip_port_string;
+extern char *usbip_srp_password;
 void usbip_setup_port_number(char *arg);
 
 /* ---------------------------------------------------------------------- */
@@ -168,6 +169,12 @@ struct op_devlist_reply_extra {
 	usbip_net_pack_uint32_t(pack, &(reply)->ndev);\
 } while (0)
 
+/* ---------------------------------------------------------------------- */
+/* Initiate encrypted connection. */
+#define OP_STARTTLS 0x06
+#define OP_REQ_STARTTLS   (OP_REQUEST | OP_STARTTLS)
+#define OP_REP_STARTTLS   (OP_REPLY   | OP_STARTTLS)
+
 void usbip_net_pack_uint32_t(int pack, uint32_t *num);
 void usbip_net_pack_uint16_t(int pack, uint16_t *num);
 void usbip_net_pack_usb_device(int pack, struct usbip_usb_device *udev);
@@ -181,6 +188,6 @@ int usbip_net_set_reuseaddr(int sockfd);
 int usbip_net_set_nodelay(int sockfd);
 int usbip_net_set_keepalive(int sockfd);
 int usbip_net_set_v6only(int sockfd);
-int usbip_net_tcp_connect(char *hostname, char *port);
+int usbip_net_connect(char *hostname);
 
 #endif /* __USBIP_NETWORK_H */
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 7980f8b..8db2f27 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -32,6 +32,11 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 
+#ifdef HAVE_GNUTLS
+#include <gnutls/gnutls.h>
+#include <gnutls/crypto.h>
+#endif
+
 #ifdef HAVE_LIBWRAP
 #include <tcpd.h>
 #endif
@@ -63,6 +68,11 @@ static const char usbipd_help_string[] =
 	"	-6, --ipv6\n"
 	"		Bind to IPv6. Default is both.\n"
 	"\n"
+#ifdef HAVE_GNUTLS
+	"	-sPASSWORD, --auth PASSWORD\n"
+	"		Set PASSWORD as key used for authentication.\n"
+	"\n"
+#endif
 	"	-D, --daemon\n"
 	"		Run as a daemon process.\n"
 	"\n"
@@ -82,6 +92,78 @@ static const char usbipd_help_string[] =
 	"	-v, --version\n"
 	"		Show version.\n";
 
+static int need_auth;
+#ifdef HAVE_GNUTLS
+static gnutls_datum_t srp_salt, srp_verifier;
+static gnutls_srp_server_credentials_t srp_cred;
+
+#define SRP_GROUP gnutls_srp_2048_group_generator
+#define SRP_PRIME gnutls_srp_2048_group_prime
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
+	nsalt->data = gnutls_malloc(srp_salt.size);
+	nverifier->data = gnutls_malloc(srp_verifier.size);
+	if (nsalt->data == NULL || nverifier->data == NULL) {
+		gnutls_free(nsalt->data);
+		gnutls_free(nverifier->data);
+		return -1;
+	}
+	nsalt->size = srp_salt.size;
+	nverifier->size = srp_verifier.size;
+	memcpy(nverifier->data, srp_verifier.data, srp_verifier.size);
+	memcpy(nsalt->data, srp_salt.data, srp_salt.size);
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
+static int net_srp_server_handshake(int connfd)
+{
+	int ret;
+	gnutls_session_t session;
+
+	if (gnutls_init(&session, GNUTLS_SERVER) != 0)
+		return -1;
+	gnutls_priority_set_direct(session, "NORMAL:-KX-ALL:+SRP", NULL);
+	if (gnutls_credentials_set(session, GNUTLS_CRD_SRP, srp_cred) != 0)
+		return -1;
+
+	gnutls_transport_set_int(session, connfd);
+
+	do {
+		ret = gnutls_handshake(session);
+	} while (ret < 0 && gnutls_error_is_fatal(ret) == 0);
+
+	if (ret < 0)
+		err("GnuTLS handshake failed (%s)", gnutls_strerror(ret));
+	else
+		info("GnuTLS handshake completed");
+
+	if (gnutls_bye(session, GNUTLS_SHUT_RDWR) != 0)
+		err("Unable to shutdown TLS connection.");
+	gnutls_deinit(session);
+
+	return ret;
+}
+#endif
+
 static void usbipd_help(void)
 {
 	printf("%s\n", usbipd_help_string);
@@ -238,14 +320,7 @@ static int recv_request_devlist(int connfd)
 
 static int recv_pdu(int connfd)
 {
-	uint16_t code = OP_UNSPEC;
-	int ret;
-
-	ret = usbip_net_recv_op_common(connfd, &code);
-	if (ret < 0) {
-		dbg("could not receive opcode: %#0x", code);
-		return -1;
-	}
+	int auth = !need_auth, cont = 1, ret;
 
 	ret = usbip_host_refresh_device_list();
 	if (ret < 0) {
@@ -253,25 +328,64 @@ static int recv_pdu(int connfd)
 		return -1;
 	}
 
-	info("received request: %#0x(%d)", code, connfd);
-	switch (code) {
-	case OP_REQ_DEVLIST:
-		ret = recv_request_devlist(connfd);
-		break;
-	case OP_REQ_IMPORT:
-		ret = recv_request_import(connfd);
-		break;
-	case OP_REQ_DEVINFO:
-	case OP_REQ_CRYPKEY:
-	default:
-		err("received an unknown opcode: %#0x", code);
-		ret = -1;
-	}
+	/*
+	 * Process opcodes. We might receive more than one, as the
+	 * client might send STARTTLS first
+	 */
+	while (cont) {
+		uint16_t code = OP_UNSPEC;
 
-	if (ret == 0)
-		info("request %#0x(%d): complete", code, connfd);
-	else
-		info("request %#0x(%d): failed", code, connfd);
+		ret = usbip_net_recv_op_common(connfd, &code);
+		if (ret < 0) {
+			dbg("could not receive opcode: %#0x", code);
+			return -1;
+		}
+
+		info("received request: %#0x(%d)", code, connfd);
+
+		/* We require an authenticated encryption */
+		if (!auth && code != OP_REQ_STARTTLS) {
+			usbip_net_send_op_common(connfd, OP_REPLY, ST_NA);
+			return -1;
+		}
+
+		switch (code) {
+#ifdef HAVE_GNUTLS
+		case OP_REQ_STARTTLS:
+			if (!need_auth) {
+				ret = -1;
+				err("Unexpected TLS handshake attempt (client "
+					"uses password, server doesn't)");
+			} else {
+				ret = net_srp_server_handshake(connfd);
+				if (ret != 0)
+					err("TLS handshake failed");
+				auth = 1;
+			}
+			break;
+#endif
+		case OP_REQ_DEVLIST:
+			ret = recv_request_devlist(connfd);
+			cont = 0;
+			break;
+		case OP_REQ_IMPORT:
+			ret = recv_request_import(connfd);
+			cont = 0;
+			break;
+		case OP_REQ_DEVINFO:
+		case OP_REQ_CRYPKEY:
+		default:
+			err("received an unknown opcode: %#0x", code);
+			ret = -1;
+		}
+
+		if (ret == 0)
+			info("request %#0x(%d): complete", code, connfd);
+		else {
+			info("request %#0x(%d): failed", code, connfd);
+			break;
+		}
+	}
 
 	return ret;
 }
@@ -577,6 +691,37 @@ static int do_standalone_mode(int daemonize, int ipv4, int ipv6)
 	return 0;
 }
 
+#ifdef HAVE_GNUTLS
+static int usbip_init_gnutls(void)
+{
+	int ret;
+
+	gnutls_global_init();
+
+	srp_salt.data = gnutls_malloc(16);
+	if (!srp_salt.data)
+		return GNUTLS_E_MEMORY_ERROR;
+
+	ret = gnutls_rnd(GNUTLS_RND_NONCE, srp_salt.data, 16);
+	if (ret < 0)
+		return ret;
+	srp_salt.size = 16;
+
+	ret = gnutls_srp_allocate_server_credentials(&srp_cred);
+	if (ret < 0)
+		return ret;
+
+	ret = gnutls_srp_verifier("dummyuser", optarg, &srp_salt, &SRP_GROUP,
+		&SRP_PRIME, &srp_verifier);
+	if (ret < 0)
+		return ret;
+
+	gnutls_srp_set_server_credentials_function(srp_cred, net_srp_callback);
+
+	return GNUTLS_E_SUCCESS;
+}
+#endif
+
 int main(int argc, char *argv[])
 {
 	static const struct option longopts[] = {
@@ -589,6 +734,7 @@ int main(int argc, char *argv[])
 		{ "tcp-port", required_argument, NULL, 't' },
 		{ "help",     no_argument,       NULL, 'h' },
 		{ "version",  no_argument,       NULL, 'v' },
+		{ "auth",     required_argument, NULL, 's' },
 		{ NULL,	      0,                 NULL,  0  }
 	};
 
@@ -601,6 +747,9 @@ int main(int argc, char *argv[])
 	int daemonize = 0;
 	int ipv4 = 0, ipv6 = 0;
 	int opt, rc = -1;
+#ifdef HAVE_GNUTLS
+	int ret;
+#endif
 	pid_file = NULL;
 
 	usbip_use_stderr = 1;
@@ -611,7 +760,7 @@ int main(int argc, char *argv[])
 
 	cmd = cmd_standalone_mode;
 	for (;;) {
-		opt = getopt_long(argc, argv, "46DdP::t:hv", longopts, NULL);
+		opt = getopt_long(argc, argv, "46s:DdP::t:hv", longopts, NULL);
 
 		if (opt == -1)
 			break;
@@ -623,6 +772,20 @@ int main(int argc, char *argv[])
 		case '6':
 			ipv6 = 1;
 			break;
+		case 's':
+#ifdef HAVE_GNUTLS
+			need_auth = 1;
+			ret = usbip_init_gnutls();
+			if (ret < 0) {
+				err("Unable to initialize GnuTLS: %s",
+					gnutls_strerror(ret));
+				return EXIT_FAILURE;
+			}
+			break;
+#else
+			err("usbipd has been compiled without GnuTLS support");
+			break;
+#endif
 		case 'D':
 			daemonize = 1;
 			break;
-- 
1.8.4

