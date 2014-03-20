Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaCTJmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:42:43 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52907 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbaCTJmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:42:39 -0400
Subject: [PATCH 25/33] Systemd Socket ID retrieval
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
Date: Thu, 20 Mar 2014 15:12:27 +0530
Message-ID: <20140320094227.14878.96667.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-6102-0000-0000-0000052BBDBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The socket created by systemd, waits for connections. Once it accepts a
connection, it starts the service which handles the request for a dump.

>From this service, we fetch the socket ID and perform the dump.

This is not functional yet, due to the absence of the sd-daemon.h header file.
For this we need to have the correct version of systemd which has this socket
option enabled.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index ab120b9..98a7146 100755
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -39,6 +39,9 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <coredump.h>
+#if HAVE_SYSTEMD_SOCKET_SUPPORT
+#include <sd-daemon.h>
+#endif
 
 /* Main Socket */
 int socket_fd;
@@ -670,6 +673,35 @@ cleanup:
 /* Systemd socket for self dump */
 int socket_dump(void)
 {
+	int n, ret;
+	char core_file[CORE_FILE_NAME_SZ];
+	struct ucred client_info;
+
+	/* Fetching the Socket ID from systemd */
+	n = sd_listen_fds(0);
+	if (n > 1) {
+		gencore_log("Too many file descriptors received.\n");
+		return -1;
+	} else if (n == 1)
+		new_sock = SD_LISTEN_FDS_START + 0;
+	else
+		return -1;
+
+	/* Receive the message */
+	ret = receive_core_filename(core_file);
+	if (ret)
+		return -1;
+
+	/* Fetch client PID */
+	ret = get_client_pid(&client_info);
+	if (ret)
+		return -1;
+
+	/* Dump process */
+	ret = dump_task(&client_info, core_file);
+	if (ret)
+		return -1;
+
 	return 0;
 }
 #endif

