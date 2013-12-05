Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3LEOmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:42:36 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:64583 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3LEOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:42:35 -0500
Date: Thu, 5 Dec 2013 15:42:27 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
 ____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131205144224.GA20828@localhost.localdomain>
References: <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128142359.GA6420@redhat.com>
 <20131128143155.GC3925@htj.dyndns.org>
 <20131128150055.GA11956@redhat.com>
 <20131128150233.GA10022@twins.programming.kicks-ass.net>
 <20131128193330.GA24767@redhat.com>
 <20131128193349.GB24767@redhat.com>
 <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com>
 <20131205143745.GA18488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205143745.GA18488@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 03:37:45PM +0100, Oleg Nesterov wrote:
> On 12/05, Frederic Weisbecker wrote:
> >
> > 2013/11/28 Oleg Nesterov <oleg@redhat.com>:
> > > ____call_usermodehelper() does set_cpus_allowed_ptr(cpu_all_mask),
> > > this (and the comment) is misleading. We no longer have keventd_wq,
> > > and kmod.c switched to khelper_wq a long ago.
> > >
> > > And more importantly, "unlike our parent" is no longer true too,
> > > this thread was created by WQ_UNBOUND worker thread which has the
> > > full ->cpus_allowed mask, so this set_cpus_allowed_ptr() is simply
> > > unnecessary.
> > >
> > > Perhaps we will change this later, so that userspace can control
> > > the affinity of the usermode helper tasks, but this is yet another
> > > reason to remove this set_cpus_allowed_ptr().
> > >
> > > To some degree this also applies to set_user_nice(), but this
> > > patch only updates the comment.
> > >
> > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> >
> > I'm adding Christophe in Cc because he is interested in tweaking the
> > affinity of call_usermodehelper for cpu isolation. This welcome
> > cleanup confirms that we want to take the direction of being able to
> > change the affinity of workqueue themselves instead of just
> > call_usermodehelper() alone.
> 
> OK, but I'd like to remind just in case, as Tejun pointed out this
> patch is wrong ;)

Ok, I see that's because unboud workqueues are actually bound to NUMA nodes.
Doesn't that eventually work for call_usermodehelper() as well? Or may be there
are some reasons for it to keep a global affinity?

> 
> And "change the affinity of workqueue themselves" is not simple, but
> we can make khelper_wq WQ_SYSFS.

Right it can be either user driven like through sysfs or some adaptive decision
taken by the kernel on top of full dynticks CPUs, etc...

But the sysfs interface based solution looks better from a quick POV.
