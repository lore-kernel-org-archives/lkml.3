Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3LNQcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 11:32:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab3LNQcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:32:06 -0500
Date: Sat, 14 Dec 2013 17:32:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: selinux_setprocattr()->ptrace_parent() needs
	rcu_read_lock()
Message-ID: <20131214163256.GA21675@redhat.com>
References: <20131205165953.GA24844@redhat.com> <2222358.CI2sulrSvj@sifl> <20131206144735.GA2674@redhat.com> <CAHC9VhQPn-aZ79BcO=Ljvn2V2fW9QdQ964M_yppJWoaQ-9_GLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQPn-aZ79BcO=Ljvn2V2fW9QdQ964M_yppJWoaQ-9_GLg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Paul Moore wrote:
>
> I understand your point, but I still think there is some value in
> keeping the call to ptrace_parent() rather than fetching the ptrace
> pointer on our own.

Yes, agreed, I changed my mind ;)

> However, that said, I think we should try and do something about the
> "suspicious RCU usage" you mentioned in your original posting.

Yes, this was the only motivation for this patch.

> but
> I'm curious about the removal of the task lock; shouldn't week keep
> the task lock in place?

Why? It protects nothing in this case, afaics. Unless of course it
protects cred->security somehow, but it doesn't look as if.

Probably task_lock() is here because PTRACE_ATTACH used the same lock,
but this was changed by 4b105cbbaf7c0 in 2009 (ptrace_attach() still
takes it for __ptrace_may_access() but this is another story).

However (iirc) PTRACE_DETACH never took this lock, so this was always
racy and task_lock() is simply misleading and confusing, at least
currently.

So I think the patch is fine, but I decided to send v2 without pid_alive().
If we are going to keep ptrace_parent(), it would be better to add the
comment into ptrace_parent() to explain that ->ptrace != 0 guarantees that
this task is not unhashed.

IOW, I also changed my mind about this part

	The patch also checks pid_alive(p) before ptrace_parent(p) to
	ensure that this task can't be dead even before rcu_read_lock(),
	in this case its ->parent points to nowhere. This is not really
	needed "in practice", task->ptrace must be already cleared in
	this case but we should not rely on this.

in the changelog.

> > And perhaps I am wrong. Because otoh the usage of ->ptrace should be
> > avoided outside of the core kernel code.
>
> Not to muddy things up, but one could argue that this particular
> LSM/SELinux hook should be regarded as part of the "core" kernel code.
>  However, I'm not sure that the distinction is really important here.

Yes, yes, sorry for confusion. I meant, the core kernel code which works
with ptrace/exit/fork/etc.

Oleg.

