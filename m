Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231Ab3E2Nn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:43:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965895Ab3E2NnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:43:24 -0400
Date: Wed, 29 May 2013 15:39:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] proc: simplify proc_task_readdir/first_tid paths
Message-ID: <20130529133930.GB5741@redhat.com>
References: <20130527202822.GA19288@redhat.com> <87ppwa1jn0.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppwa1jn0.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > proc_task_readdir() does not really need "leader", first_tid()
> > has to revalidate it anyway. Just pass proc_pid(inode) to
> > first_tid() instead, it can do pid_task(PIDTYPE_PID) itself
> > and read ->group_leader only if necessary.
> >
> > Note: I am not sure proc_task_readdir() really needs the initial
> > -ENOENT check, but this is what the current code does.
>
> This looks like a nice cleanup.
>
> We would need either -ENOENT or a return of 0 and an empty directory at
> the least.  We need the check so that empty directories don't have "."
> and ".." entries.

And this is not clear to me...

Why the empty "." + ".." dir is bad if the task(s) has gone away after
opendir?

> >  	if (tid && (nr > 0)) {
> >  		pos = find_task_by_pid_ns(tid, ns);
> > -		if (pos && (pos->group_leader == leader))
> > +		if (pos && same_thread_group(pos, task))
>
> Sigh this reminds me we need to figure out how to kill task->pid and
> task->tgid,

Yeah.

> which I assume means fixing same_thread_group.

Now that ->signal can't go away before task_struct, we can make it

	static inline
	int same_thread_group(struct task_struct *p1, struct task_struct *p2)
	{
		return p1->signal == p2->signal;
	}


> > +	if (!pid_task(proc_pid(inode), PIDTYPE_PID))
> > +		return -ENOENT;
>
> Strictly speaking this call to pid_task needs to be in a rcu critical
> section.

Argh, thanks.

we do not really need rcu, we are not going to dereference this pointer,
but we should make __rcu_dereference_check() happy...

I'll change this... but once again, can't we simply remove this check?






While you are here. Could you explain the ->d_inode check in
proc_fill_cache() ? The code _looks_ wrong,

	if (!child || IS_ERR(child) || !child->d_inode)
		goto end_instantiate;

If d_inode == NULL, who does dput() ?

OTOH, if we ensure d_inode != NULL, why do we check "if (inode)" after
inode = child->d_inode ?

IOW, it seems that this check should be simply removed?

Oleg.

