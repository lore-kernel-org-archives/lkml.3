Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3H0DF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3H0DFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:05:20 -0400
Date: Mon, 26 Aug 2013 23:04:48 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130827030448.GE21110@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
 <20130822214347.GB21110@madcap2.tricolour.ca>
 <20130823192807.GA6504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823192807.GA6504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 09:28:07PM +0200, Oleg Nesterov wrote:
> On 08/22, Richard Guy Briggs wrote:
> >
> > On Thu, Aug 22, 2013 at 10:05:55PM +0200, Peter Zijlstra wrote:
> > >
> > > Why would you ever want to do this? It just makes these tests more
> > > expensive for no gain what so ff'ing ever.
> >
> > Backups are generally considered a good idea, but in this case, I'd
> > quote:
> 
> And perhaps you are right. At least we can probably kill task->tgid.
> And I agree, it would be nice to kill task->pid.
> 
> But: I also agree with Peter, we should try to not make the current
> code more expensive.

I don't disagree.  I was given some hope by Eric Biederman that it might
not cause cache-line misses...

> Anyway. Imho, you should not mix the different things in one series.
> If you want to fix audit, do not add the patches like 10/12 or 11/12
> into this series.

They were included to gain reassurance that PIDs reported in audit logs
were accurate.  If those assurances can be made, then I can limit my
work to audit itself.

> Or 3/12.

That is a cleanup to make clear what parts are actually pid-related and
what isn't.

> OK, I agree sys_getppid() in audit_log_task_info() looks
> strange at least. Just fix it using the helpers we already have and
> add the new helpers later. Or send the patch(es) which adds the new
> helpers first.

Patch 04/12 is that helper.  It is used in only two places in audit (and
once in apparmor), so I could have duplicated the code, but since it
needs rcu locking, an inline funciton in the audit namespace seemed
somewhat pointless when it could just as easily be shared with other
subsystems.

> Or task_pid_nr_init_ns()... For what? We already have task_pid_nr().
> Use the helper we already have, or introduce the new one first and
> change the current users of task_pid_nr().

If task_struct::pid is definitely not going away, then that whole part
is moot and we'll just use task_pid_nr() as is.

> In short. Fortunately you do not need to convince me, I do not
> maintain audit or namespaces ;) But imho this series looks a bit
> confusing.

It is incomplete.  The last step(s) were intended to purge
task_struct::pid (or abstract it using task_pid_nr()), which haven't
been submitted yet.  The whole point of the patchset was to give
confidence in the PIDs reported in any audit logs.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
