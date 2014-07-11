Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaGKA7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:59:34 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35714 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaGKA6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:58:35 -0400
X-AuditID: 85900ec0-d312bb9000001514-9b-53bf36b78778
Subject: [PATCH V4 2/5] trace-cmd/msg: Use poll(2) to wait for a message
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>
Date: Fri, 11 Jul 2014 00:58:29 +0000
Message-ID: <20140711005829.25516.75538.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140711005824.25516.24498.stgit@yuno-kbuild.novalocal>
References: <20140711005824.25516.24498.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use poll(2) to wait for a message. If a client/server cannot send a message for
any reasons, the current server/client will wait in a blocking read operation.
So, we use poll(2) for avoiding remaining in a blocking state.

Changes in V4: Change the argument of tracecmd_msg_recv_wait()
               Fix some typos

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-msg.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 08fa2a6..db48365 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -395,6 +395,27 @@ error:
 	return -ENOMSG;
 }
 
+#define MSG_WAIT_MSEC	5000
+
+/*
+ * A return value of 0 indicates time-out
+ */
+static int tracecmd_msg_recv_wait(int fd, struct tracecmd_msg *msg)
+{
+	struct pollfd pfd;
+	int ret;
+
+	pfd.fd = fd;
+	pfd.events = POLLIN;
+	ret = poll(&pfd, 1, MSG_WAIT_MSEC);
+	if (ret < 0)
+		return -errno;
+	else if (ret == 0)
+		return -ETIMEDOUT;
+
+	return tracecmd_msg_recv(fd, msg);
+}
+
 static void *tracecmd_msg_buf_access(struct tracecmd_msg *msg, int offset)
 {
 	return (void *)msg + offset;
@@ -405,9 +426,12 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	u32 cmd;
 	int ret;
 
-	ret = tracecmd_msg_recv(fd, msg);
-	if (ret < 0)
+	ret = tracecmd_msg_recv_wait(fd, msg);
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			warning("Connection timed out\n");
 		return ret;
+	}
 
 	cmd = ntohl(msg->cmd);
 	if (cmd == MSG_CLOSE)
@@ -487,9 +511,12 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 	u32 cmd;
 
 	msg = (struct tracecmd_msg *)buf;
-	ret = tracecmd_msg_recv(fd, msg);
-	if (ret < 0)
+	ret = tracecmd_msg_recv_wait(fd, msg);
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			warning("Connection timed out\n");
 		return ret;
+	}
 
 	cmd = ntohl(msg->cmd);
 	if (cmd != MSG_TINIT) {
@@ -627,9 +654,12 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 	msg = (struct tracecmd_msg *)buf;
 
 	do {
-		ret = tracecmd_msg_recv(ifd, msg);
+		ret = tracecmd_msg_recv_wait(ifd, msg);
 		if (ret < 0) {
-			warning("reading client");
+			if (ret == -ETIMEDOUT)
+				warning("Connection timed out\n");
+			else
+				warning("reading client");
 			return ret;
 		}
 

