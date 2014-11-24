Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaKXVrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:47:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38329 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKXVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:47:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
References: <20141124200629.GA21009@redhat.com>
Date: Mon, 24 Nov 2014 15:46:28 -0600
In-Reply-To: <20141124200629.GA21009@redhat.com> (Oleg Nesterov's message of
	"Mon, 24 Nov 2014 21:06:29 +0100")
Message-ID: <87vbm4ff0r.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19F5KHhqsTyDYfd3SIJVA/X6kNXVM5tKSk=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 237 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.0 (1.3%), b_tie_ro: 2.1 (0.9%), parse: 0.95 (0.4%),
	extract_message_metadata: 3.8 (1.6%), get_uri_detail_list: 1.93 (0.8%),
	tests_pri_-1000: 3.2 (1.4%), tests_pri_-950: 1.06 (0.4%), tests_pri_-900:
	0.92 (0.4%), tests_pri_-400: 23 (9.7%), check_bayes: 22 (9.2%), b_tokenize: 8
	(3.4%), b_tok_get_all: 7 (2.8%), b_comp_prob: 2.7 (1.1%), b_tok_touch_all:
	2.2 (0.9%), b_finish: 0.73 (0.3%), tests_pri_0: 185 (78.3%), tests_pri_500:
	4.2 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> alloc_pid() does get_pid_ns() beforehand but forgets to put_pid_ns()
> if it fails because disable_pid_allocation() was called by the exiting
> child_reaper. We can move get_pid_ns() down to successful return.
>
> While at it, simplify/cleanup the "goto out" mess, no need to confuse
> the success/error return paths.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/pid.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 9b9a266..dfc2f3b 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -320,7 +320,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>  			goto out_free;
>  	}
>  
> -	get_pid_ns(ns);
>  	atomic_set(&pid->count, 1);
>  	for (type = 0; type < PIDTYPE_MAX; ++type)
>  		INIT_HLIST_HEAD(&pid->tasks[type]);
> @@ -336,7 +335,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>  	}
>  	spin_unlock_irq(&pidmap_lock);
>  
> -out:
> +	get_pid_ns(ns);

Moving the label and changing the goto out logic is gratuitous confusing
and I think it probably even generates worse code.

Furthermore multiple exits make adding debugging code more difficult.

Moving get_pid_ns down does close a leak in the error handling path.

However at the moment my I can't figure out if it is safe to move
get_pid_ns elow hlist_add_head_rcu.  Because once we are on the rcu list
the pid is findable, and being publicly visible with a bad refcount could cause
problems.

The increment of ns->nr_hashed after the adding to the rcu list is only safe
because we always access ns->nr_hashed with the pidmap_lock held.

Eric


>  	return pid;
>  
>  out_unlock:
> @@ -346,8 +345,8 @@ out_free:
>  		free_pidmap(pid->numbers + i);
>  
>  	kmem_cache_free(ns->pid_cachep, pid);
> -	pid = NULL;
> -	goto out;
> +out:
> +	return NULL;
>  }
>  
>  void disable_pid_allocation(struct pid_namespace *ns)
