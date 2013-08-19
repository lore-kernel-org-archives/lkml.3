Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab3HSJoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:44:32 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36499 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3HSJmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:14 -0400
X-AuditID: 85900ec0-cff26b9000001514-3f-5211e874e7c4
Subject: [RFC PATCH 04/11] [CLEANUP] trace-cmd: Split out the communication
 with listener from setup_network()
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:30 +0900
Message-ID: <20130819094630.26597.86145.stgit@yunodevel>
In-Reply-To: <20130819094620.26597.79499.stgit@yunodevel>
References: <20130819094620.26597.79499.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the communication with listener from the setup_network() for avoiding
duplicate codes between listen mode and virt-server mode.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-record.c |  119 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 62 insertions(+), 57 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index ac9f70a..6a096bd 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -1607,59 +1607,13 @@ static int create_recorder(struct buffer_instance *instance, int cpu, int extrac
 	exit(0);
 }
 
-static void setup_network(void)
+static void communicate_with_listener(int fd)
 {
-	struct tracecmd_output *handle;
-	struct addrinfo hints;
-	struct addrinfo *result, *rp;
-	int sfd, s;
-	ssize_t n;
 	char buf[BUFSIZ];
-	char *server;
-	char *port;
-	char *p;
-	int cpu;
-	int i;
-
-	if (!strchr(host, ':')) {
-		server = strdup("localhost");
-		if (!server)
-			die("alloctating server");
-		port = host;
-		host = server;
-	} else {
-		host = strdup(host);
-		if (!host)
-			die("alloctating server");
-		server = strtok_r(host, ":", &p);
-		port = strtok_r(NULL, ":", &p);
-	}
-
-	memset(&hints, 0, sizeof(hints));
-	hints.ai_family = AF_UNSPEC;
-	hints.ai_socktype = SOCK_STREAM;
-
-	s = getaddrinfo(server, port, &hints, &result);
-	if (s != 0)
-		die("getaddrinfo: %s", gai_strerror(s));
-
-	for (rp = result; rp != NULL; rp = rp->ai_next) {
-		sfd = socket(rp->ai_family, rp->ai_socktype,
-			     rp->ai_protocol);
-		if (sfd == -1)
-			continue;
-
-		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
-			break;
-		close(sfd);
-	}
-
-	if (!rp)
-		die("Can not connect to %s:%s", server, port);
-
-	freeaddrinfo(result);
+	ssize_t n;
+	int cpu, i;
 
-	n = read(sfd, buf, 8);
+	n = read(fd, buf, 8);
 
 	/* Make sure the server is the tracecmd server */
 	if (memcmp(buf, "tracecmd", 8) != 0)
@@ -1670,13 +1624,13 @@ static void setup_network(void)
 	sprintf(buf, "%d", cpu_count);
 
 	/* include \0 */
-	write(sfd, buf, strlen(buf)+1);
+	write(fd, buf, strlen(buf)+1);
 
 	/* write the pagesize (in ASCII) */
 	sprintf(buf, "%d", page_size);
 
 	/* include \0 */
-	write(sfd, buf, strlen(buf)+1);
+	write(fd, buf, strlen(buf)+1);
 
 	/*
 	 * If we are using IPV4 and our page size is greater than
@@ -1691,14 +1645,14 @@ static void setup_network(void)
 
 	if (use_tcp) {
 		/* Send one option */
-		write(sfd, "1", 2);
+		write(fd, "1", 2);
 		/* Size 4 */
-		write(sfd, "4", 2);
+		write(fd, "4", 2);
 		/* use TCP */
-		write(sfd, "TCP", 4);
+		write(fd, "TCP", 4);
 	} else
 		/* No options */
-		write(sfd, "0", 2);
+		write(fd, "0", 2);
 
 	client_ports = malloc_or_die(sizeof(int) * cpu_count);
 
@@ -1708,7 +1662,7 @@ static void setup_network(void)
 	 */
 	for (cpu = 0; cpu < cpu_count; cpu++) {
 		for (i = 0; i < BUFSIZ; i++) {
-			n = read(sfd, buf+i, 1);
+			n = read(fd, buf+i, 1);
 			if (n != 1)
 				die("Error, reading server ports");
 			if (!buf[i] || buf[i] == ',')
@@ -1719,6 +1673,57 @@ static void setup_network(void)
 		buf[i] = 0;
 		client_ports[cpu] = atoi(buf);
 	}
+}
+
+static void setup_network(void)
+{
+	struct tracecmd_output *handle;
+	struct addrinfo hints;
+	struct addrinfo *result, *rp;
+	int sfd, s;
+	char *server;
+	char *port;
+	char *p;
+
+	if (!strchr(host, ':')) {
+		server = strdup("localhost");
+		if (!server)
+			die("alloctating server");
+		port = host;
+		host = server;
+	} else {
+		host = strdup(host);
+		if (!host)
+			die("alloctating server");
+		server = strtok_r(host, ":", &p);
+		port = strtok_r(NULL, ":", &p);
+	}
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+
+	s = getaddrinfo(server, port, &hints, &result);
+	if (s != 0)
+		die("getaddrinfo: %s", gai_strerror(s));
+
+	for (rp = result; rp != NULL; rp = rp->ai_next) {
+		sfd = socket(rp->ai_family, rp->ai_socktype,
+			     rp->ai_protocol);
+		if (sfd == -1)
+			continue;
+
+		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
+			break;
+		close(sfd);
+	}
+
+	if (!rp)
+		die("Can not connect to %s:%s", server, port);
+
+	freeaddrinfo(result);
+
+	communicate_with_listener(sfd);
 
 	/* Now create the handle through this socket */
 	handle = tracecmd_create_init_fd_glob(sfd, listed_events);

