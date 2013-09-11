Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab3IKQE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:04:58 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:57498 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755541Ab3IKQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:04:52 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: linux-kernel@vger.kernel.org
Cc: Dominik Paulus <dominik.paulus@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>, Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@i4.cs.fau.de, devel@driverdev.osuosl.org
Subject: [PATCH 01/11] staging: usbip: Fix IPv6 support in usbipd
Date: Wed, 11 Sep 2013 18:06:47 +0200
Message-Id: <1378915617-29791-2-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
References: <1378732471-5967-1-git-send-email-dominik.paulus@fau.de>
 <1378915617-29791-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getaddrinfo() leaves the order of the returned addrinfo structs
unspecified. On systems with bindv6only disabled (this is the default),
PF_INET6 sockets bind to IPv4, too. Thus, IPv6 support in usbipd was
broken when getaddrinfo returned first IPv4 and then IPv6 addrinfos, as
the IPv6 bind failed with EADDRINUSE.

This patch uses seperate sockets for IPv4 and IPv6 and sets IPV6_V6ONLY
on all IPv6 sockets. Two command line arguments, -4 and -6 were added to
manually select the socket family.

Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
---
 .../staging/usbip/userspace/src/usbip_network.c    | 12 ++++
 .../staging/usbip/userspace/src/usbip_network.h    |  1 +
 drivers/staging/usbip/userspace/src/usbipd.c       | 69 ++++++++++++++++------
 3 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index c39a07f..e78279c 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -239,6 +239,18 @@ int usbip_net_set_keepalive(int sockfd)
 	return ret;
 }
 
+int usbip_net_set_v6only(int sockfd)
+{
+	const int val = 1;
+	int ret;
+
+	ret = setsockopt(sockfd, IPPROTO_IPV6, IPV6_V6ONLY, &val, sizeof(val));
+	if (ret < 0)
+		dbg("setsockopt: IPV6_V6ONLY");
+
+	return ret;
+}
+
 /*
  * IPv6 Ready
  */
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.h b/drivers/staging/usbip/userspace/src/usbip_network.h
index 2d0e427..f19ae19 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.h
+++ b/drivers/staging/usbip/userspace/src/usbip_network.h
@@ -180,6 +180,7 @@ int usbip_net_recv_op_common(int sockfd, uint16_t *code);
 int usbip_net_set_reuseaddr(int sockfd);
 int usbip_net_set_nodelay(int sockfd);
 int usbip_net_set_keepalive(int sockfd);
+int usbip_net_set_v6only(int sockfd);
 int usbip_net_tcp_connect(char *hostname, char *port);
 
 #endif /* __USBIP_NETWORK_H */
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 1c76cfd..7980f8b 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -56,6 +56,13 @@ static const char usbip_version_string[] = PACKAGE_STRING;
 
 static const char usbipd_help_string[] =
 	"usage: usbipd [options]\n"
+	"\n"
+	"	-4, --ipv4\n"
+	"		Bind to IPv4. Default is both.\n"
+	"\n"
+	"	-6, --ipv6\n"
+	"		Bind to IPv6. Default is both.\n"
+	"\n"
 	"	-D, --daemon\n"
 	"		Run as a daemon process.\n"
 	"\n"
@@ -354,14 +361,15 @@ static void addrinfo_to_text(struct addrinfo *ai, char buf[],
 	snprintf(buf, buf_size, "%s:%s", hbuf, sbuf);
 }
 
-static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[])
+static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[],
+			     int maxsockfd)
 {
 	struct addrinfo *ai;
 	int ret, nsockfd = 0;
 	const size_t ai_buf_size = NI_MAXHOST + NI_MAXSERV + 2;
 	char ai_buf[ai_buf_size];
 
-	for (ai = ai_head; ai && nsockfd < MAXSOCKFD; ai = ai->ai_next) {
+	for (ai = ai_head; ai && nsockfd < maxsockfd; ai = ai->ai_next) {
 		int sock;
 		addrinfo_to_text(ai, ai_buf, ai_buf_size);
 		dbg("opening %s", ai_buf);
@@ -374,6 +382,9 @@ static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[])
 
 		usbip_net_set_reuseaddr(sock);
 		usbip_net_set_nodelay(sock);
+		/* We use seperate sockets for IPv4 and IPv6
+		 * (see do_standalone_mode()) */
+		usbip_net_set_v6only(sock);
 
 		if (sock >= FD_SETSIZE) {
 			err("FD_SETSIZE: %s: sock=%d, max=%d",
@@ -402,11 +413,6 @@ static int listen_all_addrinfo(struct addrinfo *ai_head, int sockfdlist[])
 		sockfdlist[nsockfd++] = sock;
 	}
 
-	if (nsockfd == 0)
-		return -1;
-
-	dbg("listening on %d address%s", nsockfd, (nsockfd == 1) ? "" : "es");
-
 	return nsockfd;
 }
 
@@ -473,11 +479,11 @@ static void remove_pid_file()
 	}
 }
 
-static int do_standalone_mode(int daemonize)
+static int do_standalone_mode(int daemonize, int ipv4, int ipv6)
 {
 	struct addrinfo *ai_head;
 	int sockfdlist[MAXSOCKFD];
-	int nsockfd;
+	int nsockfd, family;
 	int i, terminate;
 	struct pollfd *fds;
 	struct timespec timeout;
@@ -501,21 +507,36 @@ static int do_standalone_mode(int daemonize)
 	set_signal();
 	write_pid_file();
 
-	ai_head = do_getaddrinfo(NULL, PF_UNSPEC);
+	info("starting " PROGNAME " (%s)", usbip_version_string);
+
+	/*
+	 * To suppress warnings on systems with bindv6only disabled
+	 * (default), we use seperate sockets for IPv6 and IPv4 and set
+	 * IPV6_V6ONLY on the IPv6 sockets.
+	 */
+	if (ipv4 && ipv6)
+		family = AF_UNSPEC;
+	else if (ipv4)
+		family = AF_INET;
+	else
+		family = AF_INET6;
+
+	ai_head = do_getaddrinfo(NULL, family);
 	if (!ai_head) {
 		usbip_host_driver_close();
 		return -1;
 	}
-
-	info("starting " PROGNAME " (%s)", usbip_version_string);
-
-	nsockfd = listen_all_addrinfo(ai_head, sockfdlist);
+	nsockfd = listen_all_addrinfo(ai_head, sockfdlist,
+		sizeof(sockfdlist) / sizeof(*sockfdlist));
+	freeaddrinfo(ai_head);
 	if (nsockfd <= 0) {
 		err("failed to open a listening socket");
-		freeaddrinfo(ai_head);
 		usbip_host_driver_close();
 		return -1;
 	}
+
+	dbg("listening on %d address%s", nsockfd, (nsockfd == 1) ? "" : "es");
+
 	fds = calloc(nsockfd, sizeof(struct pollfd));
 	for (i = 0; i < nsockfd; i++) {
 		fds[i].fd = sockfdlist[i];
@@ -551,7 +572,6 @@ static int do_standalone_mode(int daemonize)
 
 	info("shutting down " PROGNAME);
 	free(fds);
-	freeaddrinfo(ai_head);
 	usbip_host_driver_close();
 
 	return 0;
@@ -560,6 +580,9 @@ static int do_standalone_mode(int daemonize)
 int main(int argc, char *argv[])
 {
 	static const struct option longopts[] = {
+		{ "ipv4",     no_argument,       NULL, '4' },
+		{ "ipv6",     no_argument,       NULL, '6' },
+		{ "daemon",   no_argument,       NULL, 'D' },
 		{ "daemon",   no_argument,       NULL, 'D' },
 		{ "debug",    no_argument,       NULL, 'd' },
 		{ "pid",      optional_argument, NULL, 'P' },
@@ -576,6 +599,7 @@ int main(int argc, char *argv[])
 	} cmd;
 
 	int daemonize = 0;
+	int ipv4 = 0, ipv6 = 0;
 	int opt, rc = -1;
 	pid_file = NULL;
 
@@ -587,12 +611,18 @@ int main(int argc, char *argv[])
 
 	cmd = cmd_standalone_mode;
 	for (;;) {
-		opt = getopt_long(argc, argv, "DdP::t:hv", longopts, NULL);
+		opt = getopt_long(argc, argv, "46DdP::t:hv", longopts, NULL);
 
 		if (opt == -1)
 			break;
 
 		switch (opt) {
+		case '4':
+			ipv4 = 1;
+			break;
+		case '6':
+			ipv6 = 1;
+			break;
 		case 'D':
 			daemonize = 1;
 			break;
@@ -618,9 +648,12 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (!ipv4 && !ipv6)
+		ipv4 = ipv6 = 1;
+
 	switch (cmd) {
 	case cmd_standalone_mode:
-		rc = do_standalone_mode(daemonize);
+		rc = do_standalone_mode(daemonize, ipv4, ipv6);
 		remove_pid_file();
 		break;
 	case cmd_version:
-- 
1.8.4

