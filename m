Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3HSJmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:32784 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3HSJmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:17 -0400
X-AuditID: 85900ec0-d272ab9000001514-40-5211e876bd9d
Subject: [RFC PATCH 05/11] [CLEANUP] trace-cmd: Split out the connect
 waiting loop from do_listen()
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:32 +0900
Message-ID: <20130819094632.26597.59570.stgit@yunodevel>
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

Split out the connect waiting loop from do_listen() for avoiding duplicate codes
between listen mode and virt-server mode.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-listen.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/trace-listen.c b/trace-listen.c
index 6c1bcac..c741fa4 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -580,14 +580,35 @@ static void clean_up(int sig)
 	} while (ret > 0);
 }
 
+static void do_accept_loop(int sfd)
+{
+	struct sockaddr_storage peer_addr;
+	socklen_t peer_addr_len;
+	int cfd, pid;
+
+	peer_addr_len = sizeof(peer_addr);
+
+	do {
+		cfd = accept(sfd, (struct sockaddr *)&peer_addr,
+			     &peer_addr_len);
+		printf("connected!\n");
+		if (cfd < 0 && errno == EINTR)
+			continue;
+		if (cfd < 0)
+			pdie("connecting");
+
+		pid = do_connection(cfd, &peer_addr, peer_addr_len);
+		if (pid > 0)
+			add_process(pid);
+
+	} while (!done);
+}
+
 static void do_listen(char *port)
 {
 	struct addrinfo hints;
 	struct addrinfo *result, *rp;
-	int sfd, s, cfd;
-	struct sockaddr_storage peer_addr;
-	socklen_t peer_addr_len;
-	int pid;
+	int sfd, s;
 
 	if (!debug)
 		signal_setup(SIGCHLD, clean_up);
@@ -621,21 +642,7 @@ static void do_listen(char *port)
 	if (listen(sfd, backlog) < 0)
 		pdie("listen");
 
-	peer_addr_len = sizeof(peer_addr);
-
-	do {
-		cfd = accept(sfd, (struct sockaddr *)&peer_addr, &peer_addr_len);
-		printf("connected!\n");
-		if (cfd < 0 && errno == EINTR)
-			continue;
-		if (cfd < 0)
-			pdie("connecting");
-
-		pid = do_connection(cfd, &peer_addr, peer_addr_len);
-		if (pid > 0)
-			add_process(pid);
-
-	} while (!done);
+	do_accept_loop(sfd);
 
 	kill_clients();
 }

