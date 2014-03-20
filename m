Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbaCTJlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:41:46 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40667 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172AbaCTJlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:42 -0400
Subject: [PATCH 18/33] Socket operations
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
Date: Thu, 20 Mar 2014 15:11:32 +0530
Message-ID: <20140320094132.14878.87442.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-4790-0000-0000-0000003F2911
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creates a file socket using socket passing PF_UNIX, binds and then listens on
the connection.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/Makefile.am |    3 +-
 src/coredump.c  |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 90d8b25..b9b2e9b 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,6 +1,7 @@
 AUTOMAKE_OPTIONS = foreign
 HAVE_SYSTEMD_SOCKET_SUPPORT = 0
-CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)'
+SOCKET_PATH = /var/run/gencored.socket
+CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)' -DSOCKET_PATH='"$(SOCKET_PATH)"'
 
 bin_PROGRAMS = gencore
 gencore_SOURCES = coredump.c proc.c elf32.c elf64.c
diff --git a/src/coredump.c b/src/coredump.c
index 09fb8da..c992c66 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -33,8 +33,15 @@
 #include <syslog.h>
 #include <signal.h>
 #include <sys/ptrace.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/types.h>
+#include <sys/stat.h>
 #include <coredump.h>
 
+/* Main Socket */
+int socket_fd;
+
 /* For logging all the messages */
 FILE *fp_log;
 
@@ -255,9 +262,98 @@ cleanup:
 	return ret;
 }
 
+/* Creating a Unix socket */
+int create_socket(void)
+{
+	socket_fd = socket(PF_UNIX, SOCK_STREAM, 0);
+	if (socket_fd < 0) {
+		gencore_log("[%d]: Could not create a socket:%s.\n",
+					pid_log, strerror(errno));
+		return -1;
+	}
+
+	gencore_log("[%d]: Created socket.\n", pid_log);
+
+	return 0;
+}
+
+/* Binding the socket to a address */
+int bind_socket(void)
+{
+	struct sockaddr_un address;
+	struct stat buffer;
+	if (stat(SOCKET_PATH, &buffer) == 0)
+		unlink(SOCKET_PATH);
+
+	memset(&address, 0, sizeof(struct sockaddr_un));
+
+	address.sun_family = PF_FILE;
+	strcpy(address.sun_path, SOCKET_PATH);
+
+	if (bind(socket_fd, (struct sockaddr *) &address,
+			sizeof(struct sockaddr_un)) != 0) {
+		gencore_log("[%d]: Could not bind:%s.\n", pid_log,
+							strerror(errno));
+		close(socket_fd);
+		return -1;
+	}
+
+	if (chmod(SOCKET_PATH, S_IROTH | S_IWOTH
+						| S_IRUSR | S_IWUSR)) {
+		gencore_log("[%d]: Could not change permissions of socket:%s.\n",
+						pid_log, strerror(errno));
+		close(socket_fd);
+		return -1;
+	}
+
+	gencore_log("[%d]: Bind done.\n", pid_log);
+
+	return 0;
+}
+
+/* Listen for connections */
+int listen_conn(void)
+{
+	if (listen(socket_fd, 5) != 0) {
+		gencore_log("[%d]: Could not listen:%s.\n", pid_log,
+							strerror(errno));
+		close(socket_fd);
+		return -1;
+	}
+
+	gencore_log("[%d]: Listening.\n", pid_log);
+
+	return 0;
+}
+
+/* Setting up server */
+int setup_server(void)
+{
+	int ret;
+
+	/* Create Socket */
+	ret = create_socket();
+	if (ret)
+		return -1;
+
+	/* Bind Socket */
+	ret = bind_socket();
+	if (ret)
+		return -1;
+
+	/* Listen for connections */
+	ret = listen_conn();
+	if (ret)
+		return -1;
+
+	return 0;
+}
+
 /* Daemon for self dump */
 int daemon_dump(void)
 {
+	int ret;
+
 	/* Check if daemon is running as root */
 	if (geteuid()) {
 		fprintf(stderr, "Run the daemon as root.\n");
@@ -282,7 +378,21 @@ int daemon_dump(void)
 		return -1;
 	}
 
+	/* Setting up server */
+	ret = setup_server();
+	if (ret)
+		goto cleanup;
+
+	/* Flush the log */
+	fflush(fp_log);
+
+cleanup:
+
 	fclose(fp_log);
+
+	if (ret == -1)
+		return -1;
+
 	return 0;
 }
 

