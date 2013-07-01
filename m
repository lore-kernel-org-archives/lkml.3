Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3GAUMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:12:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3GAUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 5/8] perf: Disable monitoring on setuid processes for regular users
Date: Mon,  1 Jul 2013 13:10:37 -0700
Message-Id: <20130701200234.240989629@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200232.909858308@linuxfoundation.org>
References: <20130701200232.909858308@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exec.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1149,13 +1149,6 @@ void setup_new_exec(struct linux_binprm
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
 
@@ -1219,6 +1212,15 @@ void install_exec_creds(struct linux_bin
 
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


