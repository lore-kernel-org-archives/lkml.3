Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3ILPLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:11:09 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:50998 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3ILPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:11:07 -0400
Date: Thu, 12 Sep 2013 17:11:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130912151102.GB23839@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
 <20130911220228.GB15367@somewhere>
 <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
 <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:52:56PM +0000, Christoph Lameter wrote:
> On Thu, 12 Sep 2013, Frederic Weisbecker wrote:
> 
> > > > Ok but you can change the affinity of a kthread from userspace, as
> > > > long as you define a cpu set that is among that kthread's cpus allowed.
> > >
> > > Ok but at that point kthread has already spawned a lot of kernel threads.
> > >
> > > The same is true for init and kmod.
> > >
> >
> > Ok but then we just need to set the affinity of all these kthreads.
> > A simple lookup on /proc/[0-9]+/ should do the trick.
> 
> Yea but the kernel option makes it easy. No extras needed. Kernel brings
> it up user space cleanly configured and ready to go.

Ok but really that's just two lines of bash. I really wish we don't complicate
core kernel code for that.

I think we all agree that the big issue here is that CPU isolation requires to set up
a fragmented set of features and it's not at all obvious to do it correctly: full dynticks,
rcu nocbs, kthreads affinity, timer_list, hrtimers, workqueues, IPIs, etc...

So IMHO what is missing is a reliable userspace tool that can handle all that: do
the checks on pre-requirements, handle the kthreads and even user task affinity, tweak
some sysctl stuffs to turn off features that generate noise, etc...

> This also allows us to cleanup kernel uses of cpumasks in such a way that
> proper thread placement for various other uses (reclaim f.e. kswpad) is
> possible.

Same here, a central tool should be able to solve that.
