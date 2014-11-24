Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbaKXWIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:08:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47649 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaKXWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:08:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
References: <20141124200626.GA21006@redhat.com>
Date: Mon, 24 Nov 2014 16:07:26 -0600
In-Reply-To: <20141124200626.GA21006@redhat.com> (Oleg Nesterov's message of
	"Mon, 24 Nov 2014 21:06:26 +0100")
Message-ID: <874mtodzhd.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1999CvAZokB4RpJoQY4J2nLz3tDrNg9EWI=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  1.0 T_XMHurry_00 Hurry and Do Something
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 282 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.9 (1.0%), b_tie_ro: 2.1 (0.7%), parse: 0.70 (0.2%),
	extract_message_metadata: 3.4 (1.2%), get_uri_detail_list: 1.97 (0.7%),
	tests_pri_-1000: 3.2 (1.1%), tests_pri_-950: 1.09 (0.4%), tests_pri_-900:
	0.90 (0.3%), tests_pri_-400: 29 (10.3%), check_bayes: 28 (9.9%), b_tokenize:
	7 (2.3%), b_tok_get_all: 10 (3.6%), b_comp_prob: 2.3 (0.8%), b_tok_touch_all:
	6 (2.0%), b_finish: 2.1 (0.7%), tests_pri_0: 229 (81.0%), tests_pri_500: 4.3
	(1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/2] exit: reparent: fix/update the comments in zap_pid_ns_processes()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> The comments in zap_pid_ns_processes() are simply wrong, we need
> to explain how this code actually works.
>
> 1. "Ignore SIGCHLD" looks like optimization but it is not, we also
>    need this for correctness.
>
> 2. The comment above sys_wait4() could be more clear.
>
> 3. The comment about TASK_DEAD children is outdated. Contrary to
>    what it says we do not need to make sure they all go away.

We absolutely do need to wait until they all go away.

- rusage will be wrong if we don't wait.
- We won't wait for an injected process in a pid namespace,
  or a processes debugged with gdb to be reaped before the pid
  init process exits if we don't wait.

>    At the same time, we do need to wait for nr_hashed == init_pids,
>    but the reason is quite different and not obvious.

The user visible semantics go from weird to completely insane if we
relax the rule that the init process is the last process in a pid
namespace.

I don't see anything approaching a good reason for changing the user
space semantics.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/pid_namespace.c |   23 +++++++++++++++++++----
>  1 files changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index db95d8e..1519b02 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -190,7 +190,11 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	/* Don't allow any more processes into the pid namespace */
>  	disable_pid_allocation(pid_ns);

        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The above line disables injections of new processes in this pid
namespace.

>  
> -	/* Ignore SIGCHLD causing any terminated children to autoreap */
> +	/*
> +	 * Ignore SIGCHLD causing any terminated children to autoreap.
> +	 * This speeds up the namespace shutdown, plus see the comment
> +	 * below.
> +	 */

	This speeds up the namespace shutdown and ensures that after we
	have waited for all existing zombies there will be no more
	zombies to wait for.

>  	spin_lock_irq(&me->sighand->siglock);
>  	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
>  	spin_unlock_irq(&me->sighand->siglock);
> @@ -223,15 +227,26 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  	}
>  	read_unlock(&tasklist_lock);
>  
> -	/* Firstly reap the EXIT_ZOMBIE children we may have. */
> +	/* Reap the EXIT_ZOMBIE children we had before we ignored SIGCHLD */
>  	do {
>  		clear_thread_flag(TIF_SIGPENDING);
>  		rc = sys_wait4(-1, NULL, __WALL, NULL);
>  	} while (rc != -ECHILD);
>  
>  	/*
> -	 * sys_wait4() above can't reap the TASK_DEAD children.
> -	 * Make sure they all go away, see free_pid().
> +	 * sys_wait4() above can't reap the TASK_DEAD children but we do not
> +	 * really care, we could reparent them to the global init. 

We do care.


> We could
> +	 * exit and reap ->child_reaper even if it is not the last thread in
> +	 * this pid_ns, free_pid(nr_hashed == 0) calls proc_cleanup_work(),
> +	 * pid_ns can not go away until proc_kill_sb() drops the reference.


> +	 * But this namespace can also have other tasks injected by setns().
> +	 * Again, we do not really need to wait until they are all reaped,

We do, and setns does not matter here.  Injection was stopped way up above.


> +	 * but they can be reparented to us and thus we need to ensure that
> +	 * pid->child_reaper is valid until they all go away.


> +	 * We rely on ignored SIGCHLD, an injected zombie must be autoreaped
> +	 * if reparented.

Your new comment is about 90% wrong.

>  	 */
>  	for (;;) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
