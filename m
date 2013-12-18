Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3LRUSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:18:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3LRUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:18:49 -0500
Date: Wed, 18 Dec 2013 21:19:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from
	may_change_ptraced_domain()
Message-ID: <20131218201940.GA9694@redhat.com>
References: <20131218194338.GB23692@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218194338.GB23692@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Richard Guy Briggs wrote:
>
> Bcc: rgb@redhat.com
> Subject: Re: [PATCH] apparmor: remove the "task" arg from
>  may_change_ptraced_domain()
> Reply-To:
> In-Reply-To: <20130926132519.GY13968@madcap2.tricolour.ca>

The subject is empty ;) I changed it to match the above.

> On 13/09/26, Richard Guy Briggs wrote:
> > On Tue, Sep 24, 2013 at 06:44:42PM +0200, Oleg Nesterov wrote:
> > > On 09/23, Richard Guy Briggs wrote:
> > > >
> > > > On Mon, Sep 16, 2013 at 04:20:35PM +0200, Oleg Nesterov wrote:
> > > > > Unless task == current ptrace_parent(task) is not safe even under
> > > > > rcu_read_lock() and most of the current users are not right.
> > > >
> > > > Could you point to an explanation of this?
> > >
> > > If this task exits before rcu_read_lock() ->parent can point to the
> > > already freed/reused memory.
> >
> > Ok, understood.  So even though the task may have exited, the task
> > struct pointer is still valid, but not the contents of the task struct
> > to which it points.
>
> [The thread also relates to the patch
> 	"pid: get ppid pid_t of task in init_pid_ns safely"
> in which sys_getppid() (which appears safe) is replaced with something that
> references the init_pid_ns rather than current's pid_ns.]
>
> So, in the general case, that call is not safe, and we should at least
> remove the task_struct argument.

I changed my mind, please see the recent discussion with Paul:

	http://marc.info/?t=138626281900001

instead we should document why ptrace_parent() is safe without pid_alive().

I hope that the change in apparmor was fine anyway.


Otherwise I can't understand your email, at least right now... I do not
know how/where audit uses parent/real_parent.

But yes, unless tsk == current, the usage of tsk->*parent is not safe even
under rcu_read_lock() unless you verify that this task was not unhashed.

ptrace_parent() is safe because it checks ->ptrace. Previously I thought
we should not rely on this, but the additional pid_alive() looks ugly so
it would be better to simply document this. I'll send the patch.

Oleg.

