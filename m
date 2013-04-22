Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3DVUzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:55:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45773 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3DVUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:55:44 -0400
Message-ID: <1366664138.8337.18.camel@laptop>
Subject: Re: Preemptable Ticket Spinlock
From: Peter Zijlstra <peterz@infradead.org>
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Date: Mon, 22 Apr 2013 22:55:38 +0200
In-Reply-To: <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
	 <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>
	 <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>
	 <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>
	 <CAJocwceW6BuEu0Yuyv472aarpcziZH1wd-Xbc+Om81ES8+w+SA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 16:46 -0400, Jiannan Ouyang wrote:
> On Mon, Apr 22, 2013 at 4:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> >
> > I much prefer the entire series from Jeremy since it maintains the
> > ticket semantics and doesn't degrade the lock to unfair under
> > contention.
> >
> > Now I suppose there's a reason its not been merged yet and I suspect
> > its !paravirt hotpath impact which wasn't rightly justified or somesuch
> > so maybe someone can work on that or so.. dunno.
> >
> >
> 
> In my paper, I comparable preemptable-lock and pv_lock on KVM from
> Raghu and Jeremy.

Which pv_lock? The current pv spinlock mess is basically the old unfair
thing. The later patch series I referred to earlier implemented a
paravirt ticket lock, that should perform much better under overcommit.

> Results show that:
> - preemptable-lock improves performance significantly without paravirt support

But completely wrecks our native spinlock implementation so that's not
going to happen of course ;-)

> - preemptable-lock can also be paravirtualized, which outperforms
> pv_lock, especially when overcommited by 3 or more

See above.. 

> - pv-preemptable-lock has much less performance variance compare to
> pv_lock, because it adapts to preemption within  VM,
>   other than using rescheduling that increase VM interference

I would say it has a _much_ worse worst case (and thus worse variance)
than the paravirt ticket implementation from Jeremy. While full
paravirt ticket lock results in vcpu scheduling it does maintain
fairness.

If you drop strict fairness you can end up in unbounded starvation
cases and those are very ugly indeed.

> It would still be very interesting to conduct more experiments to
> compare these two, to see if the fairness enforced by pv_lock is
> mandatory, and if preemptable-lock outperforms pv_lock in most cases,
> and how do they work with PLE.

Be more specific, pv_lock as currently upstream is a trainwreck mostly
done because pure ticket spinners and vcpu-preemption are even worse.

