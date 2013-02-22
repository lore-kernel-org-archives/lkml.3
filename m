Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab3BVK2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:28:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46776 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3BVK2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:28:41 -0500
Date: Fri, 22 Feb 2013 10:28:36 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: too many timer retries happen when do local timer swtich with
 broadcast timer
Message-ID: <20130222102836.GB12140@e102568-lin.cambridge.arm.com>
References: <CAB4PhKevqf0e4nzYraE9ZTAFbPCFfNpguAnPoVpJh-FFe2TAZA@mail.gmail.com>
 <alpine.LFD.2.02.1302201400400.22263@ionos>
 <CAB4PhKfxPcyQfpM2Ra1OxsyYhS5fnkjtPy=uYgxFHim1rOdoug@mail.gmail.com>
 <alpine.LFD.2.02.1302211015270.22263@ionos>
 <CAB4PhKf+Z-TK4KGDZm1kYOWibg=e2Ehnhjxt_oTbFq9eqouAjA@mail.gmail.com>
 <alpine.LFD.2.02.1302211436300.22263@ionos>
 <51263975.20906@ti.com>
 <alpine.LFD.2.02.1302212214020.22263@ionos>
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302212214020.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Feb 2013 10:28:37.0326 (UTC) FILETIME=[5FEE36E0:01CE10E7]
X-MC-Unique: 113022210283907001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:19:18PM +0000, Thomas Gleixner wrote:
> On Thu, 21 Feb 2013, Santosh Shilimkar wrote:
> > On Thursday 21 February 2013 07:18 PM, Thomas Gleixner wrote:
> > > find below a completely untested patch, which should address that issue.
> > > 
> > After looking at the thread, I tried to see the issue on OMAP and could
> > see the same issue as Jason.
> 
> That's interesting. We have the same issue on x86 since 2007 and
> nobody noticed ever. It's basically the same problem there, but it
> seems that on x86 getting out of those low power states is way slower
> than the minimal reprogramming delta which is used to enforce the
> local timer to fire after the wakeup. 
> 
> I'm still amazed that as Jason stated a 1us reprogramming delta is
> sufficient to get this ping-pong going. I somehow doubt that, but
> maybe ARM is really that fast :)

It also depends on when the idle driver exits broadcast mode.
Certainly if that's the last thing it does before enabling IRQs, that
might help trigger the issue.

I am still a bit sceptic myself too, and I take advantage of Thomas'
knowledge on the subject, which is ways deeper than mine BTW, to ask a
question. The thread started with a subject "too many retries...." and
here I have a doubt. If the fix is not applied, on the CPU affine to
the broadcast timer, it is _normal_ to have local timer retries, since
the CPU is setting/forcing the local timer to fire after a min_delta_ns every
time the expired event was local to the CPU affine to the broadcast timer.

The problem, supposedly, is that the timer has not enough time (sorry for the
mouthful) to expire(fire) before IRQs are disabled and the idle thread goes
back to idle again. This means that we should notice a mismatch between
the number of broadcast timer IRQs and local timer IRQs on the CPU
affine to the broadcast timer IRQ (granted, we also have to take into
account broadcast timer IRQs meant to service (through IPI) a local timer
expired on a CPU which is not the one running the broadcast IRQ handler and
"normal" local timer IRQs as well).

I am not sure the sheer number of retries is a symptom of the problem
happening, but I might well be mistaken so I am asking.

For certain, with the fix applied, lots of duplicate IRQs on the CPU
affine to the broadcast timer are eliminated, since the local timer is
not reprogrammed anymore (before the fix, basically the broadcast timer
was firing an IRQ that did nothing since the CPU was already out of
broadcast mode by the time the broadcast handler was running, the real job
was carried out in the local timer handler).

> 
> > Your patch fixes the retries on both CPUs on my dual core machine. So
> > you use my tested by if you need one.
> 
> They are always welcome.
> 
> > Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

You can add mine too, we should fix the WARN_ON_ONCE mentioned in Santosh's
reply.

Tested-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

