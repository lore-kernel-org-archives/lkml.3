Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBXSlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaBXSlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:41:09 -0500
Date: Mon, 24 Feb 2014 19:40:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, eparis@redhat.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 4/7] pid: modify task_tgid_nr to work without
	task->tgid.
Message-ID: <20140224184013.GB21474@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com> <4c2bd4df9a53965a50c83e7ea38e0d39601a4326.1390495874.git.rgb@redhat.com> <20140220183518.GA23993@redhat.com> <20140221204752.GF16640@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221204752.GF16640@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Richard Guy Briggs wrote:
>
> On 14/02/20, Oleg Nesterov wrote:
> > On 01/23, Richard Guy Briggs wrote:
> > >
> > > task->tgid is an error prone construct and results in duplicate maintenance.
> > > Start it's demise by modifying task_tgid_nr to not use it.
> >
> > Well, I disagree.
> >
> > Yes I agree that ->tgid should probably die. But this change itself doesn't
> > help, it only makes task_tgid_nr() slower. We need to convert other users
> > first, then consider this change along with ->tgid removal.
>
> I thought I recently saw a statistic that there were only 7 instances of
> ->tgid, but a quick search comes up with >50 outside of audit!

Yes, so I don't think it makes sense to start from task_tgid_nr().

> > > -	return tsk->tgid;
> > > +	return pid_nr(task_tgid(tsk));
> > >  }
> >
> > And what protect task_tgid? This is racy.
> >
> > The race is very unlikely, pid_nr() will likely hit pid == NULL if tsk
> > exits. But still it can use the freed/unmapped/reused memory.
>
> So at the very least, I'd need
>
> static inline pid_t task_tgid_nr(struct task_struct *tsk)
> {
> 	return pid_nr(is_alive(tsk) ? task_tgid(tsk) : NULL);
> }
>
> And it sounds like I might even need this since the status of is_alive
> could change between the time I call it and the time I call task_tgid:
>
> static inline pid_t task_tgid_nr(struct task_struct *tsk)
> {
> 	pid_t pid;
>
> 	task_lock(&tsk);
> 	pid = pid_nr(is_alive(tsk) ? task_tgid(tsk) : NULL);
> 	task_unlock(&tsk);
> 	return pid;
> }
>
> Is task_lock() sufficient, or do I need the heavier
> read_lock(&tasklist_lock)?

You need rcu_read_lock(), I think. In any case task_lock() has nothing to
do with pids.

> > And even if we add rcu_read_lock() the patch will add the semantics change,
> > task_tgid_nr() can return 0 if tsk has already exited. At least this should
> > be documented, but you also need to audit the users.
>
> Basically check for an inline error return of 0 signalling a failure
> rather than the idle task.

Perhaps...

Oleg.

