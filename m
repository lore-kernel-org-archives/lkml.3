Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3LPVLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:11:08 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:34895 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3LPVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:11:06 -0500
From: Paul Moore <paul@paul-moore.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
Date: Mon, 16 Dec 2013 16:11:01 -0500
Message-ID: <8164425.ZmoIzv0qh9@sifl>
User-Agent: KMail/4.11.4 (Linux/3.12.4-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20131214163256.GA21675@redhat.com>
References: <20131205165953.GA24844@redhat.com> <CAHC9VhQPn-aZ79BcO=Ljvn2V2fW9QdQ964M_yppJWoaQ-9_GLg@mail.gmail.com> <20131214163256.GA21675@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 14, 2013 05:32:56 PM Oleg Nesterov wrote:
> On 12/14, Paul Moore wrote:
> > ... I'm curious about the removal of the task lock; shouldn't we keep
> > the task lock in place?
> 
> Why? It protects nothing in this case, afaics. Unless of course it
> protects cred->security somehow, but it doesn't look as if.
> 
> Probably task_lock() is here because PTRACE_ATTACH used the same lock,
> but this was changed by 4b105cbbaf7c0 in 2009 (ptrace_attach() still
> takes it for __ptrace_may_access() but this is another story).
> 
> However (iirc) PTRACE_DETACH never took this lock, so this was always
> racy and task_lock() is simply misleading and confusing, at least
> currently.

Okay, you convinced me.

> So I think the patch is fine, but I decided to send v2 without pid_alive().
> If we are going to keep ptrace_parent(), it would be better to add the
> comment into ptrace_parent() to explain that ->ptrace != 0 guarantees that
> this task is not unhashed.
> 
> IOW, I also changed my mind about this part
> 
> 	The patch also checks pid_alive(p) before ptrace_parent(p) to
> 	ensure that this task can't be dead even before rcu_read_lock(),
> 	in this case its ->parent points to nowhere. This is not really
> 	needed "in practice", task->ptrace must be already cleared in
> 	this case but we should not rely on this.
> 
> in the changelog.

Seems reasonable to me.  I'll let you work on the ptrace_parent() side of 
things and I'll go ahead and merge your v2 patch; it looks fine to me and 
regardless of what happens with ptrace_parent() we should dump the task_lock() 
and add a RCU lock in its place.

Thanks for your help.

-- 
paul moore
www.paul-moore.com

