Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3LEOhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:37:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab3LEOhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:37:11 -0500
Date: Thu, 5 Dec 2013 15:37:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
	____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131205143745.GA18488@redhat.com>
References: <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128142359.GA6420@redhat.com> <20131128143155.GC3925@htj.dyndns.org> <20131128150055.GA11956@redhat.com> <20131128150233.GA10022@twins.programming.kicks-ass.net> <20131128193330.GA24767@redhat.com> <20131128193349.GB24767@redhat.com> <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Frederic Weisbecker wrote:
>
> 2013/11/28 Oleg Nesterov <oleg@redhat.com>:
> > ____call_usermodehelper() does set_cpus_allowed_ptr(cpu_all_mask),
> > this (and the comment) is misleading. We no longer have keventd_wq,
> > and kmod.c switched to khelper_wq a long ago.
> >
> > And more importantly, "unlike our parent" is no longer true too,
> > this thread was created by WQ_UNBOUND worker thread which has the
> > full ->cpus_allowed mask, so this set_cpus_allowed_ptr() is simply
> > unnecessary.
> >
> > Perhaps we will change this later, so that userspace can control
> > the affinity of the usermode helper tasks, but this is yet another
> > reason to remove this set_cpus_allowed_ptr().
> >
> > To some degree this also applies to set_user_nice(), but this
> > patch only updates the comment.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> I'm adding Christophe in Cc because he is interested in tweaking the
> affinity of call_usermodehelper for cpu isolation. This welcome
> cleanup confirms that we want to take the direction of being able to
> change the affinity of workqueue themselves instead of just
> call_usermodehelper() alone.

OK, but I'd like to remind just in case, as Tejun pointed out this
patch is wrong ;)

And "change the affinity of workqueue themselves" is not simple, but
we can make khelper_wq WQ_SYSFS.

> >  kernel/kmod.c |    8 ++------
> >  1 files changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/kmod.c b/kernel/kmod.c
> > index b086006..2fe4544 100644
> > --- a/kernel/kmod.c
> > +++ b/kernel/kmod.c
> > @@ -208,13 +208,9 @@ static int ____call_usermodehelper(void *data)
> >         spin_lock_irq(&current->sighand->siglock);
> >         flush_signal_handlers(current, 1);
> >         spin_unlock_irq(&current->sighand->siglock);
> > -
> > -       /* We can run anywhere, unlike our parent keventd(). */
> > -       set_cpus_allowed_ptr(current, cpu_all_mask);
> > -
> >         /*
> > -        * Our parent is keventd, which runs with elevated scheduling priority.
> > -        * Avoid propagating that into the userspace child.
> > +        * Our parent is a workqueue thread, which can run with elevated
> > +        * scheduling priority. Avoid propagating that into the userspace.
> >          */
> >         set_user_nice(current, 0);
> >
> > --
> > 1.5.5.1
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

