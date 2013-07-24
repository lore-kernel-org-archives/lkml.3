Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3GXO3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:29:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45737 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab3GXOGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Stephane Eranian" <eranian@google.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Jiri Olsa" <jolsa@redhat.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.748649913@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [42/85] perf: Disable monitoring on setuid processes for regular
 users
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Eranian <eranian@google.com>

commit 2976b10f05bd7f6dab9f9e7524451ddfed656a89 upstream.

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
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/exec.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1159,13 +1159,6 @@ void setup_new_exec(struct linux_binprm
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
 
@@ -1229,6 +1222,15 @@ void install_exec_creds(struct linux_bin
 
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

