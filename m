Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbaKSXc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:32:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:48240 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaKSXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:32:57 -0500
Date: Thu, 20 Nov 2014 00:32:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack
 in schedule and __might_sleep
In-Reply-To: <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411200025440.3909@nanos>
References: <cover.1416352397.git.luto@amacapital.net> <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net> <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com> <20141119192928.GL12538@two.firstfloor.org>
 <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com> <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com> <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Linus Torvalds wrote:

> On Wed, Nov 19, 2014 at 3:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Does that include nmi?  I'm a bit afraid of touching that code.
> 
> NMI is kind of special, since it's really not supposed to touch
> 'current' or anything like that, and that's how we do preempt-count
> (and that's where irq-count is) right now.
> 
> I would prefer to have preempt_count be a percpu variable rather than
> a per-thread one, but there are historical reasons for that horror. Oh
> well.

preempt_count is a per cpu variable at least on x86 since:

  commit c2daa3bed53a 'sched, x86: Provide a per-cpu preempt_count
  implementation'
    
> > It's certainly easy enough to bump irq_count in the paranoid entries.
> 
> It definitely shouldn't be done from the assembly code. Usually it's
> "irq_enter/exit()" that does it, but for NMI you'd presumably just do
> it explicitly from do_nmi() or similar. But NMI really is nastier than
> other cases, see above.

do_nmi()
  nmi_enter()
    preempt_count_add(NMI_OFFSET + HARDIRQ_OFFSET); 

> (That said, I thought we did it anyway, but now that I look I can't
> find it. So I was probably just smoking something)

Certainly something you should not smoke again :)

Thanks,

	tglx
