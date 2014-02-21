Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaBUSLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:11:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790AbaBUSLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:11:42 -0500
Date: Fri, 21 Feb 2014 13:10:55 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 7/7] pid: get pid_t ppid of task in init_pid_ns
Message-ID: <20140221181055.GE17952@madcap2.tricolour.ca>
References: <cover.1390495874.git.rgb@redhat.com>
 <328c85752a7eb053e72d9194827b91fc228d4f67.1390495874.git.rgb@redhat.com>
 <20140220190114.GC23993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220190114.GC23993@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/20, Oleg Nesterov wrote:
> On 01/23, Richard Guy Briggs wrote:
> >
> > Added the functions task_ppid_nr_ns() and task_ppid_nr() to abstract the lookup
> > of the PPID (real_parent's pid_t) of a process, including rcu locking, in the
> > arbitrary and init_pid_ns.
> > This provides an alternative to sys_getppid(), which is relative to the child
> > process' pid namespace.
> 
> I agree, this makes sense.
> 
> 
> imho it would be better to send this patch along with sys_getppid()
> conversions, but I won't argue.

I don't think sys_getppid() should be changed since it is a syscall
whose userspace user would assume the working namespace.  Many of the
kernel internal uses of it are likely wrong though, so fixing that
should probably fall under another patch.  I fixed audit in another
patch.

> > +static int pid_alive(const struct task_struct *p);
> > +static inline pid_t task_ppid_nr_ns(const struct task_struct *tsk, struct pid_namespace *ns)
> > +{
> > +	pid_t pid = 0;
> > +
> > +	rcu_read_lock();
> > +	if (pid_alive(tsk))
> > +		pid = task_tgid_nr_ns(rcu_dereference(tsk->real_parent), ns);
> > +	rcu_read_unlock();
> > +
> > +	return pid;
> > +}
> 
> Perhaps it should be named task_ptgid_nr_ns() or even parent_tgid_nr_ns().
> Since it returns tgid, not pid (== tid).

I like task_ptgid_nr_ns() (or maybe even task_parent_tgid_nr_ns() but
that gets a bit long.

> But this is cosmetic, I won't insist.
> 
> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
