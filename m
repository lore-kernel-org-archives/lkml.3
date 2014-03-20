Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbaCTJmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:42:09 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:52852 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678AbaCTJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:42:02 -0400
Subject: [PATCH 21/33] Get Clients PID
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
Date: Thu, 20 Mar 2014 15:11:48 +0530
Message-ID: <20140320094148.14878.73813.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-6102-0000-0000-0000052BBD8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the Clients PID using getsockopt. This is done for security reasons. So
that we dont get any malicious dump requests.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index fadb7cd..599a912 100755
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -22,6 +22,7 @@
  *      Suzuki K. Poulose <suzuki@in.ibm.com>
  */
 
+#define _GNU_SOURCE
 #include <stdarg.h>
 #include <stdio.h>
 #include <string.h>
@@ -430,17 +431,38 @@ int receive_core_filename(char *core_file)
 	return 0;
 }
 
+/* Get client details */
+int get_client_pid(struct ucred *client_info)
+{
+	socklen_t len = sizeof(struct ucred);
+	if (getsockopt(new_sock, SOL_SOCKET, SO_PEERCRED,
+				client_info, &len)) {
+		send_reply(errno);
+		gencore_log("[%d]: Can't get credentials of the client:%s\n",
+				pid_log, strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
 /* Services requests */
 int service_request(void)
 {
 	int ret;
 	char core_file[CORE_FILE_NAME_SZ];
+	struct ucred client_info;
 
 	/* Receive the message */
 	ret = receive_core_filename(core_file);
 	if (ret)
 		goto cleanup;
 
+	/* Fetch client PID */
+	ret = get_client_pid(&client_info);
+	if (ret)
+		goto cleanup;
+
 cleanup:
 	close(new_sock);
 	if (ret == -1)

