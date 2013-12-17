Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3LQDAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:00:33 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36700 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3LQDA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:00:28 -0500
X-AuditID: 85900ec0-d312bb9000001514-b1-52afbe49fa1c
Subject: [PATCH V3 3/6] trace-cmd: Use poll(2) to wait for a message
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 17 Dec 2013 12:00:25 +0900
Message-ID: <20131217030025.31730.28028.stgit@yunodevel>
In-Reply-To: <20131217030017.31730.66046.stgit@yunodevel>
References: <20131217030017.31730.66046.stgit@yunodevel>
User-Agent: StGit/0.16
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

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-msg.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 2551617..2e4c0b0 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -396,6 +396,27 @@ error:
 	return -ENOMSG;
 }
 
+#define MSG_WAIT_MSEC	5000
+
+/*
+ * A return value of 0 indicates time-out
+ */
+static int tracecmd_msg_recv_wait(int fd, char *buf, struct tracecmd_msg **msg)
+{
+	struct pollfd pfd;
+	int ret;
+
+	pfd.fd = fd;
+	pfd.events = POLLIN;
+	ret = poll(&pfd, 1, MSG_WAIT_MSEC);
+	if (ret < 0) {
+		return -errno;
+	} else if (ret == 0)
+		return -ETIMEDOUT;
+
+	return tracecmd_msg_recv(fd, buf);
+}
+
 static void *tracecmd_msg_buf_access(struct tracecmd_msg *msg, int offset)
 {
 	return (void *)msg + offset;
@@ -407,9 +428,12 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
 	u32 cmd;
 	int ret;
 
-	ret = tracecmd_msg_recv(fd, msg_tmp);
-	if (ret < 0)
+	ret = tracecmd_msg_recv_wait(fd, msg_tmp, msg);
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			warning("Connection timed out\n");
 		return ret;
+	}
 
 	*msg = (struct tracecmd_msg *)msg_tmp;
 	cmd = ntohl((*msg)->cmd);
@@ -487,9 +511,12 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
 	u32 size = 0;
 	u32 cmd;
 
-	ret = tracecmd_msg_recv(fd, buf);
-	if (ret < 0)
+	ret = tracecmd_msg_recv_wait(fd, buf, &msg);
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			warning("Connection timed out\n");
 		return ret;
+	}
 
 	msg = (struct tracecmd_msg *)buf;
 	cmd = ntohl(msg->cmd);
@@ -625,9 +652,12 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
 	int ret;
 
 	do {
-		ret = tracecmd_msg_recv(ifd, buf);
+		ret = tracecmd_msg_recv_wait(ifd, buf, &msg);
 		if (ret < 0) {
-			warning("reading client");
+			if (ret == -ETIMEDOUT)
+				warning("Connection timed out\n");
+			else
+				warning("reading client");
 			return ret;
 		}
 

