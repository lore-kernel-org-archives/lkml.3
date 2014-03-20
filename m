Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbaCTJpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:45:53 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:41411 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbaCTJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:42:31 -0400
Subject: [PATCH 23/33] Handling SIG TERM of the daemon
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
Date: Thu, 20 Mar 2014 15:12:10 +0530
Message-ID: <20140320094210.14878.75209.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-2000-0000-0000-00001044DD15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We handle SIGTERM on the daemon, by closing the socket opened for that
connection.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index 72ba8d8..c0da457 100755
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -562,6 +562,17 @@ int handle_request(void)
 	return 0;
 }
 
+/* Handles Signals to the Daemon */
+void sig_daemon_handler(int sig)
+{
+	close(socket_fd);
+	unlink(SOCKET_PATH);
+
+	gencore_log("[%d]: Cleanup done and daemon exiting.\n", pid_log);
+
+	fclose(fp_log);
+}
+
 /* Daemon for self dump */
 int daemon_dump(void)
 {
@@ -602,6 +613,11 @@ int daemon_dump(void)
 	/* SIGCHILD - Signal handler */
 	signal(SIGCHLD, sigchild_handler);
 
+	/* Terminate Daemon - signal handler */
+	signal(SIGTERM, sig_daemon_handler);
+	signal(SIGSEGV, sig_daemon_handler);
+	signal(SIGPIPE, sig_daemon_handler);
+
 	while (1) {
 
 		/* Blocks on request */

