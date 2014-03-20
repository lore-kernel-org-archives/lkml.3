Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbaCTJmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:42:16 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55640 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807AbaCTJmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:42:13 -0400
Subject: [PATCH 22/33] Dump the task
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
Date: Thu, 20 Mar 2014 15:11:59 +0530
Message-ID: <20140320094159.14878.9459.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-3568-0000-0000-00000520E693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have the PID and the absolute or relative path of the core. We now call
the do_coredump function with the appropriate parameters.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index 599a912..72ba8d8 100755
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -446,6 +446,61 @@ int get_client_pid(struct ucred *client_info)
 	return 0;
 }
 
+/* Dumps the client process */
+int dump_task(struct ucred *client_info, char *core_file)
+{
+
+	char filename[40], cwd[CORE_FILE_NAME_SZ], corefile[CORE_FILE_NAME_SZ];
+	memset(filename, 0, 40);
+	memset(cwd, 0, CORE_FILE_NAME_SZ);
+	memset(corefile, 0, CORE_FILE_NAME_SZ);
+
+	if (setgid(client_info->gid)) {
+		send_reply(errno);
+		gencore_log("[%d]: Could not change GID:%s\n",
+				pid_log, strerror(errno));
+		return -1;
+	}
+
+	if (setuid(client_info->uid)) {
+		send_reply(errno);
+		gencore_log("[%d]: Could not change UID:%s\n",
+				pid_log, strerror(errno));
+		return -1;
+	}
+
+	/* Checking if UID was changed */
+	if (geteuid() != client_info->uid) {
+		send_reply(errno);
+		gencore_log("[%d]: Could not change UID:%s\n",
+				pid_log, strerror(errno));
+		return -1;
+	}
+
+	/* Converting the path to absolute path */
+	if (core_file[0] != '/') {
+		snprintf(filename, 40, "/proc/%d/cwd", client_info->pid);
+		readlink(filename, cwd, CORE_FILE_NAME_SZ);
+		snprintf(corefile, CORE_FILE_NAME_SZ, "%s/%s", cwd, core_file);
+	} else
+		strcpy(corefile, core_file);
+
+	if (do_coredump(client_info->pid, (char *)corefile)) {
+		send_reply(errno);
+		gencore_log("[%d]: Could not create core file %s.\n",
+						pid_log, corefile);
+		fflush(fp_log);
+		return -1;
+	}
+
+	gencore_log("[%d]: Core file %s created.\n", pid_log,
+							corefile);
+
+	send_reply(0);
+
+	return 0;
+}
+
 /* Services requests */
 int service_request(void)
 {
@@ -463,6 +518,11 @@ int service_request(void)
 	if (ret)
 		goto cleanup;
 
+	/* Dump process */
+	ret = dump_task(&client_info, core_file);
+	if (ret)
+		goto cleanup;
+
 cleanup:
 	close(new_sock);
 	if (ret == -1)

