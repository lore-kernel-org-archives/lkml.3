Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3DNBxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 21:53:04 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55640 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3DNBxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 21:53:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
References: <1365794853-23912-1-git-send-email-avagin@openvz.org>
	<20130413142246.GA864@redhat.com> <20130413155457.GA6533@redhat.com>
	<20130413155521.GB6533@redhat.com>
Date: Sat, 13 Apr 2013 18:52:50 -0700
In-Reply-To: <20130413155521.GB6533@redhat.com> (Oleg Nesterov's message of
	"Sat, 13 Apr 2013 17:55:21 +0200")
Message-ID: <87ip3pri8d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18aznUAcG9Fu5/yOY+wx4S7MLEvt4/aEQY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] move exit_task_namespaces() outside of exit_notify()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> exit_notify() does exit_task_namespaces() after
> forget_original_parent(). This was needed to ensure that ->nsproxy
> can't be cleared prematurely, an exiting child we are going to
> reparent can do do_notify_parent() and use the parent's (ours) pid_ns.
>
> However, after 32084504 "pidns: use task_active_pid_ns in
> do_notify_parent" ->nsproxy != NULL is no longer needed, we rely
> on task_active_pid_ns().
>
> Move exit_task_namespaces() from exit_notify() to do_exit(), after
> exit_fs() and before exit_task_work().
>
> This solves the problem reported by Andrey, free_ipc_ns()->shm_destroy()
> does fput() which needs task_work_add(). And this allows us do simplify
> exit_notify(), we can avoid unlock/lock(tasklist) and we can change
> ->exit_state instead of PF_EXITING in forget_original_parent().

It feels like this ought to work, certainly the pid namespace should not
need this, and the pid namespace was the motivating case for most of the
movement.  However we haven't called exit_task_namespaces this early
since 2006.

Ugh. I goofed and used that field in scm.c. Sigh.  I will push a patch
to rename that field nsproxy->childrens_pid_ns so it is harder to
make the mistake I just made.

None of the uses of nsproxy->net_ns look like they will be used on the
exit path.

The /proc/<pid>/ns/{uts,ipc,net,mnt,pid} files are fine as nsproxy
itself is what becomes NULL and they test for that.  Well except the pid
file uses task_active_pid_ns.

nsproxy->ipc_ns is isolated to files under ipc so it is probably fine.

Likewise the nsproxy->uts_ns uses look like they will be fine.

Likewise the nsproxy->mnt_ns uses look like they will be fine.

So in a quick skim through the uses no problem cases stick out, nor
can I think of anything that would cause trouble.  This looks like a
good patch.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Reported-by: Andrey Vagin <avagin@openvz.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> --- x/kernel/exit.c
> +++ x/kernel/exit.c
> @@ -649,7 +649,6 @@ static void exit_notify(struct task_stru
>  	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
>  	 */
>  	forget_original_parent(tsk);
> -	exit_task_namespaces(tsk);
>  
>  	write_lock_irq(&tasklist_lock);
>  	if (group_dead)
> @@ -795,6 +794,7 @@ void do_exit(long code)
>  	exit_shm(tsk);
>  	exit_files(tsk);
>  	exit_fs(tsk);
> +	exit_task_namespaces(tsk);
>  	exit_task_work(tsk);
>  	check_stack_usage();
>  	exit_thread();
