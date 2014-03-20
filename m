Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbaCTJro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:47:44 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40731 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbaCTJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:51 -0400
Subject: [PATCH 20/33] Handling Requests
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:11:43 +0530
Message-ID: <20140320094143.14878.80702.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-4790-0000-0000-0000003F2951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accepting requests and then spawning a new thread to service them.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)
 mode change 100644 => 100755 src/coredump.c

diff --git a/src/coredump.c b/src/coredump.c
old mode 100644
new mode 100755
index d93f4b2..fadb7cd
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -42,6 +42,11 @@
 /* Main Socket */
 int socket_fd;
 
+/* Accepted Socket */
+int new_sock;
+
+#define CORE_FILE_NAME_SZ 1000	/* Size of core file name */
+
 /* For logging all the messages */
 FILE *fp_log;
 
@@ -381,6 +386,100 @@ int block_on_request(void)
 	return 0;
 }
 
+/* Handles a SIGCHILD */
+void sigchild_handler(int sig)
+{
+	int pid;
+
+	pid = waitpid(0, &status, WNOHANG);
+
+	gencore_log("[%d]: Request handled by child with PID:%d and exited.\n",
+				pid_log, pid);
+}
+
+/* Sends message to client */
+int send_reply(int err)
+{
+	if (write(new_sock, &err , sizeof(err)) == -1) {
+		gencore_log("[%d]: Could not send message:%s\n",
+					pid_log, strerror(errno));
+		return -1;
+	}
+
+	gencore_log("[%d]: Message sent:%d\n", pid_log, err);
+
+	return 0;
+}
+
+/* Receive message from client */
+int receive_core_filename(char *core_file)
+{
+	memset(core_file, 0, CORE_FILE_NAME_SZ);
+	if (read(new_sock, core_file , CORE_FILE_NAME_SZ) == -1) {
+		send_reply(errno);
+		gencore_log("[%d]: Could not get Core file name:%s\n",
+					pid_log, strerror(errno));
+		return -1;
+	}
+
+	gencore_log("[%d]: Core file path received:%s\n", pid_log,
+						core_file);
+	/* Sending the acknowledgment */
+	send_reply(0);
+
+	return 0;
+}
+
+/* Services requests */
+int service_request(void)
+{
+	int ret;
+	char core_file[CORE_FILE_NAME_SZ];
+
+	/* Receive the message */
+	ret = receive_core_filename(core_file);
+	if (ret)
+		goto cleanup;
+
+cleanup:
+	close(new_sock);
+	if (ret == -1)
+		exit(EXIT_FAILURE);
+
+	exit(EXIT_SUCCESS);
+}
+
+/* Handles new requests */
+int handle_request(void)
+{
+	int pid_new;
+	struct sockaddr_un client_address;
+	socklen_t client_size = sizeof(client_address);
+
+	new_sock = accept(socket_fd, (struct sockaddr *) &client_address,
+							&client_size);
+	if (new_sock < 0) {
+		gencore_log("[%d]: Could not accept:%s\n", pid_log,
+							strerror(errno));
+		close(socket_fd);
+		fclose(fp_log);
+		return -1;
+	}
+
+	gencore_log("[%d]: Accepted.\n", pid_log);
+
+	gencore_log("[%d]: Handling request.\n", pid_log);
+
+	/* New thread to service request */
+	pid_new = fork();
+	if (pid_new == 0) {
+		pid_log = getpid();
+		service_request();
+	}
+
+	return 0;
+}
+
 /* Daemon for self dump */
 int daemon_dump(void)
 {
@@ -418,6 +517,9 @@ int daemon_dump(void)
 	/* Flush the log */
 	fflush(fp_log);
 
+	/* SIGCHILD - Signal handler */
+	signal(SIGCHLD, sigchild_handler);
+
 	while (1) {
 
 		/* Blocks on request */
@@ -427,6 +529,14 @@ int daemon_dump(void)
 
 		/* Flush the log */
 		fflush(fp_log);
+
+		/* Handle new connections */
+		ret = handle_request();
+		if (ret)
+			goto cleanup;
+
+		/* Flush the log */
+		fflush(fp_log);
 	}
 
 	return 0;

