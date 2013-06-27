Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3F0NLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:11:39 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41234 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3F0NLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:11:38 -0400
Date: Thu, 27 Jun 2013 15:11:34 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fix
Message-ID: <20130627131134.GA9273@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 2976b10f05bd7f6dab9f9e7524451ddfed656a89 perf: Disable monitoring on setuid processes for regular users

One more fix for a recently discovered bug.

 Thanks,

	Ingo

------------------>
Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users


 fs/exec.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6430195..ffd7a81 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1135,13 +1135,6 @@ void setup_new_exec(struct linux_binprm * bprm)
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
 
@@ -1205,6 +1198,15 @@ void install_exec_creds(struct linux_binprm *bprm)
 
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
