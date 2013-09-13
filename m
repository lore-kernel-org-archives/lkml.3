Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3IMCCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:02:25 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40977 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab3IMCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:02:19 -0400
X-AuditID: 85900ec0-d1328b9000001514-a5-523272283915
Subject: [PATCH V2 1/5] [CLEANUP] trace-cmd: Split out binding a port and
 fork reader from open_udp()
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 13 Sep 2013 11:06:30 +0900
Message-ID: <20130913020630.28927.94339.stgit@yunodevel>
In-Reply-To: <20130913020627.28927.69090.stgit@yunodevel>
References: <20130913020627.28927.69090.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out binding a port and fork reader from open_udp() for avoiding duplicate
codes between listen mode and virt-server mode.

Changes in V2: Add a comment in open_udp()

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-listen.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index 8b8f02c..bf187c9 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -228,13 +228,12 @@ static void process_udp_child(int sfd, const char *host, const char *port,
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
 
-static int open_udp(const char *node, const char *port, int *pid,
-		    int cpu, int pagesize, int start_port)
+static int udp_bind_a_port(int start_port, int *sfd)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
-	int sfd, s;
 	char buf[BUFSIZ];
+	int s;
 	int num_port = start_port;
 
  again:
@@ -250,15 +249,15 @@ static int open_udp(const char *node, const char *port, int *pid,
 		pdie("getaddrinfo: error opening udp socket");
 
 	for (rp = result; rp != NULL; rp = rp->ai_next) {
-		sfd = socket(rp->ai_family, rp->ai_socktype,
-			     rp->ai_protocol);
-		if (sfd < 0)
+		*sfd = socket(rp->ai_family, rp->ai_socktype,
+			      rp->ai_protocol);
+		if (*sfd < 0)
 			continue;
 
-		if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
+		if (bind(*sfd, rp->ai_addr, rp->ai_addrlen) == 0)
 			break;
 
-		close(sfd);
+		close(*sfd);
 	}
 
 	if (rp == NULL) {
@@ -270,6 +269,12 @@ static int open_udp(const char *node, const char *port, int *pid,
 
 	freeaddrinfo(result);
 
+	return num_port;
+}
+
+static void fork_udp_reader(int sfd, const char *node, const char *port,
+			    int *pid, int cpu, int pagesize)
+{
 	*pid = fork();
 
 	if (*pid < 0)
@@ -279,6 +284,23 @@ static int open_udp(const char *node, const char *port, int *pid,
 		process_udp_child(sfd, node, port, cpu, pagesize);
 
 	close(sfd);
+}
+
+static int open_udp(const char *node, const char *port, int *pid,
+		    int cpu, int pagesize, int start_port)
+{
+	int sfd;
+	int num_port;
+
+	/*
+	 * udp_bind_a_port() currently does not return an error, but if that
+	 * changes in the future, we have a check for it now. 
+	 */
+	num_port = udp_bind_a_port(start_port, &sfd);
+	if (num_port < 0)
+		return num_port;
+
+	fork_udp_reader(sfd, node, port, pid, cpu, pagesize);
 
 	return num_port;
 }

