Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3LFOqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:46:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3LFOql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:46:41 -0500
Date: Fri, 6 Dec 2013 15:47:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selinux: selinux_setprocattr()->ptrace_parent() needs
	rcu_read_lock()
Message-ID: <20131206144735.GA2674@redhat.com>
References: <20131205165953.GA24844@redhat.com> <2222358.CI2sulrSvj@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2222358.CI2sulrSvj@sifl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Paul Moore wrote:
>
> On Thursday, December 05, 2013 05:59:53 PM Oleg Nesterov wrote:
> >
> > Note: perhaps we should simply kill ptrace_parent(), it buys
> > almost nothing and it is obviously racy. Or perhaps we should
> > change it to ensure it can't wrongly return the natural parent
> > if it races with ptrace_detach.
>
> Can you elaborate on "kill ptrace_parent()"?  If the process is being traced
> we do need to fetch the tracer's task_struct for use in the SELinux access
> check at this bottom of the diff below.  If you have something better in mind
> than ptrace_parent() it would be helpful to share that ...

Sorry for confusion.

I meant that the code like

	tracer = ptrace_parent(p);
	if (tracer)
		do_something(tracer);

doesn't look better than just

	if (p->ptrace)
		do_something(p->parent);

but this is subjective of course.

And perhaps I am wrong. Because otoh the usage of ->ptrace should be
avoided outside of the core kernel code.

Mostly it annoys me because it is racy, without tasklist_lock it can
return ->real_parent (which never traced its child) if it races with
attach or detach, and I do not see a simple fix.

Oleg.



