Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3HMP6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10925 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab3HMP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:41 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=falZnxYBv7AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Mwp1obgYTwcA:10 a=1XWaLZrsAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=79MtlePNNPh5LprQaZcA:9 a=UTB_XpHje0EA:10 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155831.157308061@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, <stable@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [48/88] perf: Disable monitoring on setuid processes for regular users
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0048-perf-Disable-monitoring-on-setuid-processes-for-regu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephane Eranian <eranian@google.com>

[ Upstream commit 2976b10f05bd7f6dab9f9e7524451ddfed656a89 ]

There was a a bug in setup_new_exec(), whereby
the test to disabled perf monitoring was not
correct because the new credentials for the
process were not yet committed and therefore
the get_dumpable() test was never firing.

The patch fixes the problem by moving the
perf_event test until after the credentials
are committed.

Signed-off-by: Stephane Eranian <eranian@google.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/exec.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 39b6a3c..6f238c8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1162,13 +1162,6 @@ void setup_new_exec(struct linux_binprm * bprm)
 			set_dumpable(current->mm, suid_dumpable);
 	}
 
-	/*
-	 * Flush performance counters when crossing a
-	 * security domain:
-	 */
-	if (!get_dumpable(current->mm))
-		perf_event_exit_task(current);
-
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
@@ -1217,6 +1210,15 @@ void install_exec_creds(struct linux_binprm *bprm)
 
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
+
+	/*
+	 * Disable monitoring for regular users
+	 * when executing setuid binaries. Must
+	 * wait until new credentials are committed
+	 * by commit_creds() above
+	 */
+	if (get_dumpable(current->mm) != SUID_DUMP_USER)
+		perf_event_exit_task(current);
 	/*
 	 * cred_guard_mutex must be held at least to this point to prevent
 	 * ptrace_attach() from altering our determination of the task's
-- 
1.7.10.4


