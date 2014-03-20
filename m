Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbaCTJnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:43:03 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49042 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbaCTJnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:43:00 -0400
Subject: [PATCH 26/33] [libgencore] Setting up Connection
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
Date: Thu, 20 Mar 2014 15:12:38 +0530
Message-ID: <20140320094238.14878.9756.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-7014-0000-0000-0000048ABBB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating a socket and setting up a connection with the server(daemon).

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/Makefile.am |    4 +++
 src/client.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)
 create mode 100644 src/client.c

diff --git a/src/Makefile.am b/src/Makefile.am
index b9b2e9b..a1d57ca 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,6 +3,10 @@ HAVE_SYSTEMD_SOCKET_SUPPORT = 0
 SOCKET_PATH = /var/run/gencored.socket
 CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)' -DSOCKET_PATH='"$(SOCKET_PATH)"'
 
+lib_LTLIBRARIES = libgencore.la
+libgencore_la_LDFLAGS = -fPIC
+libgencore_la_SOURCES = client.c
+
 bin_PROGRAMS = gencore
 gencore_SOURCES = coredump.c proc.c elf32.c elf64.c
 
diff --git a/src/client.c b/src/client.c
new file mode 100644
index 0000000..cddaf94
--- /dev/null
+++ b/src/client.c
@@ -0,0 +1,70 @@
+/*
+ * Client interface for selfdump.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2013
+ *
+ * Authors:
+ *      Janani Venkataraman <jananve@in.ibm.com>
+ */
+
+#include <stdio.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+
+int setup_connection(void)
+{
+	int socket_fd;
+	struct sockaddr_un address;
+	socklen_t len = sizeof(struct sockaddr_un);
+
+	/* Creating the socket */
+	socket_fd = socket(PF_UNIX, SOCK_STREAM, 0);
+	if (socket_fd < 0)
+		return -1;
+
+	memset(&address, 0, len);
+
+	address.sun_family = PF_FILE;
+	strcpy(address.sun_path, SOCKET_PATH);
+
+	/* Connecting to the server */
+	if (connect(socket_fd, (struct sockaddr *) &address, len)) {
+		close(socket_fd);
+		return -1;
+	}
+
+	return socket_fd;
+}
+
+int gencore(char *corefile)
+{
+	int socket, ret;
+
+	/* Socket operation */
+	socket = setup_connection();
+	if (socket == -1) {
+		ret = errno;
+		goto cleanup;
+	}
+
+cleanup:
+
+	return ret;
+}

