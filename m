Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560Ab3GQW4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934522Ab3GQW41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 041/145] perf: Disable monitoring on setuid processes for regular users
Date: Wed, 17 Jul 2013 15:46:13 -0700
Message-Id: <1374101277-7915-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/exec.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ac014f1..ea5dc8d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1136,13 +1136,6 @@ void setup_new_exec(struct linux_binprm * bprm)
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
 
@@ -1206,6 +1199,15 @@ void install_exec_creds(struct linux_binprm *bprm)
 
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
1.8.1.2

