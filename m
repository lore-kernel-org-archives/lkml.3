Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3FOReT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab3FOReS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:34:18 -0400
Date: Sat, 15 Jun 2013 19:29:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/3] (Was: fput: task_work_add() can fail if the caller has
	passed exit_task_work())
Message-ID: <20130615172959.GA14656@redhat.com>
References: <20130614190915.GA8226@redhat.com> <20130614190947.GA8259@redhat.com> <20130614145831.c65ad42447637e3ad33eb79d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614145831.c65ad42447637e3ad33eb79d@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Andrew Morton wrote:
>
> On Fri, 14 Jun 2013 21:09:47 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > +		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> > +			init_task_work(&file->f_u.fu_rcuhead, ____fput);
> > +			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
> > +				return;
>
> A comment here would be useful, explaining the circumstances under
> which we fall through to the delayed fput.

Thanks!

> This is particularly needed
> because kernel/task_work.c is such undocumented crap.

It seems that you are trying to force me to make the doc patch ;)
OK, I'll try. task_work.c needs a couple of cosmetic cleanups anyway.

> > +		spin_lock_irqsave(&delayed_fput_lock, flags);
> > +		list_add(&file->f_u.fu_list, &delayed_fput_list);
> > +		schedule_work(&delayed_fput_work);
> > +		spin_unlock_irqrestore(&delayed_fput_lock, flags);
>
> OT: I don't think that schedule_work() needs to be inside the locked
> region.  Scalability improvements beckon!

Yeees, I thought about this too.

Performance-wise this can't really help, this case is unlikely. But
I think this change makes this code a bit simpler, so please see 1/3.

2/3 fixes the (theoretical) bug in llist_add() and imho cleanups the
code.

3/3 comes as a separate change because I do not want to argue if
someone dislike the non-inline llist_add(). But once again, we can
make llist_add_batch() inline, and I believe it is never good to
duplicate the code even if it is simple.

Oleg.

