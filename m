Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3H2XzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:55:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53431 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3H2XzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:55:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <87ob8gys0d.fsf@xmission.com>
Date: Thu, 29 Aug 2013 16:55:01 -0700
In-Reply-To: <87ob8gys0d.fsf@xmission.com> (Eric W. Biederman's message of
	"Thu, 29 Aug 2013 16:52:18 -0700")
Message-ID: <87a9k0yrvu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19wiWvBIH0MFIB9zeAQfAIuN/wr3HHhp3I=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0124]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 3/5] pidns: Don't have unshare(CLONE_NEWPID) imply CLONE_THREAD
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I goofed when I made unshare(CLONE_NEWPID) only work in a
single-threaded process.  There is no need for that requirement and in
fact I analyzied things right for setns.  The hard requirement
is for tasks that share a VM to all be in the pid namespace and
we properly prevent that in do_fork.

Just to be certain I took a look through do_wait and
forget_original_parent and there are no cases that make it any harder
for children to be in the multiple pid namespaces than it is for
children to be in the same pid namespace.  I also performed a check to
see if there were in uses of task->nsproxy_pid_ns I was not familiar
with, but it is only used when allocating a new pid for a new task,
and in checks to prevent craziness from happening.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/fork.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 66635c8..eb45f1d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1818,11 +1818,6 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
 	if (unshare_flags & CLONE_NEWUSER)
 		unshare_flags |= CLONE_THREAD | CLONE_FS;
 	/*
-	 * If unsharing a pid namespace must also unshare the thread.
-	 */
-	if (unshare_flags & CLONE_NEWPID)
-		unshare_flags |= CLONE_THREAD;
-	/*
 	 * If unsharing a thread from a thread group, must also unshare vm.
 	 */
 	if (unshare_flags & CLONE_THREAD)
-- 
1.7.5.4

