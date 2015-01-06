Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbbAFSqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:46:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342AbbAFSq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:46:28 -0500
Date: Tue, 6 Jan 2015 19:44:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Stijn Volckaert <Stijn.Volckaert@elis.ugent.be>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        John Johansen <john.johansen@canonical.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH RFC] Allow introspection to already attached ptracer in
	__ptrace_may_access
Message-ID: <20150106184427.GA18153@redhat.com>
References: <549ABF87.8060905@elis.ugent.be> <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJWFKK1oJg0iyZtTKSSzXGyDD5B=iA3y7vvyayqhbOP5Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05, Kees Cook wrote:
>
> I'm nervous to add this (or Oleg's suggestion) generally to
> __ptrace_may_access, as it would mean other LSMs would stop seeing
> access checks even when attached. It does seem silly to deny ptrace
> checks when already attached, but it does change the behavior here.

Same here.

> If the other LSM folks don't see a problem here, then it should live
> in the general case. Otherwise, I'm happy to add this check only in
> Yama.

In this case this check should probably go into ptracer_exception_found().

Btw it looks buggy... RCU protects ptrace_relation object, but not
relation->tracer (the final __put_task_struct() calls yama_task_free()
and frees task_struct without rcu gp).

This means that task_is_descendant(parent, tracer) can dereference the
already freed/unmapped parent, no?


And the usage of ->group_leader looks strange. tracee->group_leader can
point to nowhere if the task is already dead. In this case
"relation->tracee == tracee" can be false-positive (the same task_struct
can be re-allocated), but probably this is not that bad exactly because
the task is dead anyway.


prctl(PR_SET_PTRACER) looks strange too wrt group_leader. What if the caller
execs later? The comment says "we want process-level granularity of control",
but this is only true if the main thread does exec.

And get/out_task_struct(myself) look unneeded.


And it seems that task_is_descendant() doesn't need ->group_leader at all,
it could simply do

	static int task_is_descendant(struct task_struct *parent,
				      struct task_struct *child)
	{
		int rc = 0;
		struct task_struct *walker = child;

		if (!parent || !child)
			return 0;

		rcu_read_lock();
		do {
			if (same_thread_group(walker, parent)) {
				rc = 1;
				break;
			}
			walker = rcu_dereference(walker->real_parent);
		} while (walker != &init_task);
		rcu_read_unlock();

		return rc;
	}

Oleg.

