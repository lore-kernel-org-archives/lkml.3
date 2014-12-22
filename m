Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaLVJwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:52:54 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46649 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaLVJww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:52:52 -0500
Subject: [PATCH trace-cmd V5 3/6] trace-cmd/msg: Use poll(2) to wait for a
 message
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:47:57 -0500
Message-ID: <20141222174757.10068.60053.stgit@localhost.localdomain>
In-Reply-To: <20141222174736.10068.90306.stgit@localhost.localdomain>
References: <20141222174736.10068.90306.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use poll(2) to wait for a message. If a client/server cannot send a message for
any reasons, the current server/client will wait in a blocking read operation.
So, we use poll(2) for avoiding remaining in a blocking state.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
Changes in V4: Change the argument of tracecmd_msg_recv_wait()
               Fix some typos
---
 trace-msg.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/trace-msg.c b/trace-msg.c
index a97222c..3228559 100644
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
 


