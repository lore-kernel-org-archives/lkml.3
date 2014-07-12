Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaGLUdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:33:11 -0400
Received: from mail.efficios.com ([78.47.125.74]:37289 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaGLUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:33:07 -0400
Date: Sat, 12 Jul 2014 20:33:09 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Message-ID: <2088242765.13629.1405197189418.JavaMail.zimbra@efficios.com>
In-Reply-To: <alpine.DEB.2.10.1407122145580.4357@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <318411977.13587.1405176797949.JavaMail.zimbra@efficios.com> <alpine.DEB.2.10.1407122124130.4357@nanos> <alpine.DEB.2.10.1407122145580.4357@nanos>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
Thread-Index: KALxn38vhShYrhx0nRhE5cCKE8oQvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Thomas Gleixner" <tglx@linutronix.de>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "John Stultz" <john.stultz@linaro.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Steven Rostedt" <rostedt@goodmis.org>
> Sent: Saturday, July 12, 2014 4:04:59 PM
> Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
> 
> On Sat, 12 Jul 2014, Thomas Gleixner wrote:
> > On Sat, 12 Jul 2014, Mathieu Desnoyers wrote:
> > > I'm perhaps missing something here, but what happens with the
> > > following scenario ?
> > > 
> > > Initial conditions:
> > > 
> > > tkf->seq = 0
> > > tkf->base[0] and tkf->base[1] are initialized.
> > > 
> > > CPU 0                                      CPU 1
> > > ------------                               ----------------
> > > update:
> > >   tkf->seq++
> > >   smb_wmb()
> > >   tkf->seq++ (reordered before update)
> > >                                            reader:
> > >                                            seq = tkf->seq (reads 2)
> > >                                            smp_rmb()
> > >                                            idx = seq & 0x01
> > >                                            now = now(tkf->base[idx]
> > >                                            (reads base[0])
> > >   update(tkf->base[0], tk) (racy concurrent update)
> > >                                            smp_rmb()
> > >                                            while (seq != tkf->seq) (they
> > >                                            are equal)
> > > 
> > > So AFAIU, we end up returning a corrupted value. Adding a
> > > smp_wmb() between update of base[0] and increment of seq,
> > > as well as between update of base[1] and the _following_
> > > increment of seq (next update call) would fix this.
> > > 
> > > Thoughts ?
> 
> Second thoughts :)
> 
> > Well, the actual implementation does:
> > 
> > +       /* Force readers off to base[1] */
> > +       raw_write_seqcount_begin(&tkf->seq);
> 
> i.e:
> 	seq++;
> 	smp_wmb();
> 
> > +
> > +       /* Update base[0] */
> > +       base->clock = clk;
> > +       base->cycle_last = clk->cycle_last;
> > +       base->base = tbase;
> > +       base->shift = shift;
> > +       base->mult = mult;
> > +
> > +       /* Force readers back to base[0] */
> > +       raw_write_seqcount_end(&tkf->seq);
> 
> i.e:
> 	smp_wmb();
> 	seq++;
> 
> So while this orders against the update of base0, it does not prevent
> reordering against the update of base1. So you're right, we need a
> 
>   	smp_wmb();
> 
> before we start updating base1.
> 
> > +       /* Update base[1] */
> > +       base++;
> > +       base->clock = clk;
> > +       base->cycle_last = clk->cycle_last;
> > +       base->base = tbase;
> > +       base->shift = shift;
> > +       base->mult = mult;
> 
> So as a consequence we need another one here:
> 
>       	smp_wmb();
> 
> to protect against the unlikely, but possible seq++ at the begin of
> the update. Debatable whether this can happen without another wmb()
> between the two calls, but yes for sanity reasons we should add it
> until we can prove that the actual call chains prevent this.
> 
> Nice catch!

Thanks! Yep, the barriers you propose are what appears
to be missing,

Mathieu

> 
>      tglx
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
