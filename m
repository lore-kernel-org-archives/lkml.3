Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3CXLEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 07:04:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54372 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab3CXLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 07:04:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Caj Larsson <caj@omnicloud.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <CAMoAvfEsvah6VELu9D7k1prB2GLhvyubd35tKgBaJdB=P08+pQ@mail.gmail.com>
Date: Sun, 24 Mar 2013 04:04:14 -0700
In-Reply-To: <CAMoAvfEsvah6VELu9D7k1prB2GLhvyubd35tKgBaJdB=P08+pQ@mail.gmail.com>
	(Caj Larsson's message of "Wed, 20 Mar 2013 09:43:26 +0100")
Message-ID: <87txo1kqj5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18WmnqTm7e165DldAQV9/Xt0jvU5CGRy1U=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Caj Larsson <caj@omnicloud.com>
X-Spam-Relay-Country: 
Subject: Re: Zombie stuck in zap_pid_ns_processes()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Caj Larsson <caj@omnicloud.com> writes:

> Hello,
>
> We are setting up a container using a CLONE_NEWNS linux namespace.
> Previously we used the 3.4.4 kernel, which worked fine. After I
> upgraded i also experienced races in netlink, which has been resolved
> by placing a monitor around the namespace setup. When we upgraded to
> Linux 3.8.0 however our init processes does not get reaped when the
> namespace is killed and lingers as zombie process under the global
> init.
>
> The init has multiple threads when running and two remain in the
> zombie. One of them is hung in zap_pid_ns_processes() and has been set
> uninterruptible. The other one, which has Tgid=PID, is still in
> do_exit().

Doh.

Thank you for the detailed bug report it appears I goofed, and failed
to account for a multi-threaded init.

Will you please verify that the following patch fixes it for you.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c1c3dc1..72b7722 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -181,6 +181,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	int nr;
 	int rc;
 	struct task_struct *task, *me = current;
+	int init_pids = task_pid_vnr(me) == 1 ? 1 : 2;
 
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
@@ -230,7 +231,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 */
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (pid_ns->nr_hashed == 1)
+		if (pid_ns->nr_hashed == init_pids)
 			break;
 		schedule();
 	}

