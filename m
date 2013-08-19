Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322Ab3HSJmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:32 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:32816 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3HSJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:27 -0400
X-AuditID: 85900ec0-cff26b9000001514-45-5211e8807c20
Subject: [RFC PATCH 09/11] trace-cmd: Use poll(2) to wait for a message
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 19 Aug 2013 18:46:42 +0900
Message-ID: <20130819094642.26597.91454.stgit@yunodevel>
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

Use poll(2) to wait for a message. If a client/server cannot send a message for
any reasons, the current server/client will wait in a blocking read operation.
So, we use poll(2) for avoiding remaining in a blocking state.

This modification avoids to try to connect to an old-version client. An
old-version network server will send a message "tracecmd" first, and an
old-version client will start to send cpu number, pagesize, and option.
By introducing trace-msg, the new client sends a message "MSG_TCONNECT" first,
so the start point of the connection is different. If the old client tries
to connect to the new network server, the server should make the connection
close. A server applied this patch will die when the predetermined time will
have elapsed.

Note that if a new client tries to connect to an old server, the new client
will automatically die. This is because the new client which received the
inappropriate message "tracecmd" will die.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-msg.c |   50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index 777ea1f..36117cd 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -435,6 +435,27 @@ error:
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
@@ -448,9 +469,12 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg **msg)
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
@@ -549,9 +573,13 @@ int tracecmd_msg_set_connection(int fd)
 	int ret;
 
 	/* wait for connection msg by a client first */
-	ret = tracecmd_msg_recv(fd, buf);
+	ret = tracecmd_msg_recv_wait(fd, buf, &msg);
 	if (ret < 0) {
-		warning("Disconnect");
+		if (ret == -ETIMEDOUT)
+			/* network connection will be started soon */
+			warning("No connection message");
+		else
+			warning("Disconnect");
 		return ret;
 	}
 
@@ -586,9 +614,12 @@ int tracecmd_msg_initial_setting(int fd, int *cpus, int *pagesize)
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
@@ -724,9 +755,12 @@ int tracecmd_msg_collect_metadata(int ifd, int ofd)
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
 

