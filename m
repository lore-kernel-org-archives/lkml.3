Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaBCSL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaBCSL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:11:56 -0500
Date: Mon, 3 Feb 2014 19:11:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] audit: Only use the syscall slowpath when syscall
	audit rules exist
Message-ID: <20140203181144.GA29296@redhat.com>
References: <a8356e46aed7213128e84a888170391adb6afe30.1391449825.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8356e46aed7213128e84a888170391adb6afe30.1391449825.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Andy Lutomirski wrote:
>
> @@ -911,6 +918,47 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
>  	return context;
>  }
>  
> +void audit_inc_n_rules()
> +{
> +	struct task_struct *p, *g;
> +
> +	write_lock(&n_rules_lock);
> +
> +	if (audit_n_rules++ != 0)
> +		goto out;  /* The overall state isn't changing. */
> +
> +	read_lock(&tasklist_lock);
> +	do_each_thread(g, p) {
> +		if (p->audit_context)
> +			set_tsk_thread_flag(p, TIF_SYSCALL_AUDIT);
> +	} while_each_thread(g, p);
> +	read_unlock(&tasklist_lock);

Cosmetic, but I'd suggest to use for_each_process_thread() instead
of do_each_thread/while_each_thread.

And I am not sure why n_rules_lock is rwlock_t... OK, to make
audit_alloc() more scalable, I guess. Please see below.

> @@ -942,8 +995,14 @@ int audit_alloc(struct task_struct *tsk)
>  	}
>  	context->filterkey = key;
>
> +	read_lock(&n_rules_lock);
>  	tsk->audit_context  = context;
> -	set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> +	if (audit_n_rules)
> +		set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> +	else
> +		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> +	read_unlock(&n_rules_lock);

Perhaps this is fine, but n_rules_lock can't prevent the race with
audit_inc/dec_n_rules(). The problem is, this is called before the
new task is visible to for_each_process_thread().

If we want to fix this race, we need something like audit_sync_flags()
called after copy_process() drops tasklist, or from tasklist_lock
protected section (in this case it doesn't need n_rules_lock).

Or perhaps audit_alloc() should not try to clear TIF_SYSCALL_AUDIT at all.
In both cases n_rules_lock can be spinlock_t.

Oleg.

