Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbaCTJnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:43:13 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58417 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbaCTJnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:43:08 -0400
Subject: [PATCH 27/33] [libgencore] Request for dump
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
Date: Thu, 20 Mar 2014 15:12:57 +0530
Message-ID: <20140320094257.14878.9997.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-9574-0000-0000-00000C888BF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request for a self dump and wait for an acknowledgement first and then a
response about the status of the dump.

  --------    gencore(file_name) --------
 |        |   ----------------> |        |
 |        |   ack(errno)        |        |
 | CLIENT |   <---------------- | SERVER |
 |        |   status(errno)     |(daemon)|
 |        |   <---------------- |        |
  --------                       --------

a) The client connects to the server(daemon)

b) Once the connection is accepted, request for dump is sent. This request
contains the file name where the dump is to be saved.

c) Once the request is sent, the client waits for an acknowledgment from the
server, that it has received the message.

d) Then the client waits for the status response from the server which either
is a sucess or a failure. If it is a failure, the correct errno is sent back.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/Makefile.am |    1 +
 src/client.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/gencore.h   |    1 +
 3 files changed, 53 insertions(+)
 create mode 100644 src/gencore.h

diff --git a/src/Makefile.am b/src/Makefile.am
index a1d57ca..c8a52b7 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,6 +3,7 @@ HAVE_SYSTEMD_SOCKET_SUPPORT = 0
 SOCKET_PATH = /var/run/gencored.socket
 CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)' -DSOCKET_PATH='"$(SOCKET_PATH)"'
 
+include_HEADERS = gencore.h
 lib_LTLIBRARIES = libgencore.la
 libgencore_la_LDFLAGS = -fPIC
 libgencore_la_SOURCES = client.c
diff --git a/src/client.c b/src/client.c
index cddaf94..8d078b7 100644
--- a/src/client.c
+++ b/src/client.c
@@ -27,6 +27,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
+#include <gencore.h>
 
 int setup_connection(void)
 {
@@ -53,6 +54,51 @@ int setup_connection(void)
 	return socket_fd;
 }
 
+/* Sends message to client */
+int send_core_filename(int socket_fd, char *corefile)
+{
+	if (write(socket_fd, corefile , strlen(corefile) + 1) == -1)
+		return errno;
+
+	return 0;
+}
+
+/* Receive message from client */
+int receive_reply(int socket_fd)
+{
+	int reply;
+
+	if (read(socket_fd, &reply , sizeof(reply)) == -1)
+		return errno;
+
+	return reply;
+}
+
+int dump_request(int socket_fd, char *corefile)
+{
+	int ret;
+
+	/* Sends request */
+	ret = send_core_filename(socket_fd, corefile);
+	if (ret)
+		goto cleanup;
+
+	/* Receives acknowledgment */
+	ret = receive_reply(socket_fd);
+	if (ret)
+		goto cleanup;
+
+	/* Receives status */
+	ret = receive_reply(socket_fd);
+	if (ret)
+		goto cleanup;
+
+cleanup:
+	close(socket_fd);
+
+	return ret;
+}
+
 int gencore(char *corefile)
 {
 	int socket, ret;
@@ -64,6 +110,11 @@ int gencore(char *corefile)
 		goto cleanup;
 	}
 
+	/* Asks for a self dump */
+	ret = dump_request(socket, corefile);
+	if (ret)
+		goto cleanup;
+
 cleanup:
 
 	return ret;
diff --git a/src/gencore.h b/src/gencore.h
new file mode 100644
index 0000000..8ad0ca8
--- /dev/null
+++ b/src/gencore.h
@@ -0,0 +1 @@
+int gencore(char *corefile);

