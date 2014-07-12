Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaGLN7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 09:59:48 -0400
Received: from mail.efficios.com ([78.47.125.74]:35592 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaGLN7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 09:59:45 -0400
Date: Sat, 12 Jul 2014 13:59:45 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Message-ID: <1321708462.13569.1405173585327.JavaMail.zimbra@efficios.com>
In-Reply-To: <alpine.DEB.2.10.1407121002540.4357@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <743517199.13168.1405109080248.JavaMail.zimbra@efficios.com> <alpine.DEB.2.10.1407121002540.4357@nanos>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
Thread-Index: es16jrpIb7TTLKe8yNXEFFtdCfkkMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Thomas Gleixner" <tglx@linutronix.de>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "John Stultz" <john.stultz@linaro.org>, "Peter Zijlstra"
> <peterz@infradead.org>, "Steven Rostedt" <rostedt@goodmis.org>
> Sent: Saturday, July 12, 2014 4:11:17 AM
> Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
> 
> On Fri, 11 Jul 2014, Mathieu Desnoyers wrote:
> 
> > ----- Original Message -----
> > > From: "Thomas Gleixner" <tglx@linutronix.de>
> > > To: "LKML" <linux-kernel@vger.kernel.org>
> > > Cc: "John Stultz" <john.stultz@linaro.org>, "Peter Zijlstra"
> > > <peterz@infradead.org>, "Steven Rostedt"
> > > <rostedt@goodmis.org>, "Mathieu Desnoyers"
> > > <mathieu.desnoyers@efficios.com>
> > > Sent: Friday, July 11, 2014 9:45:19 AM
> > > Subject: [patch 54/55] timekeeping: Provide fast and NMI safe access to
> > > CLOCK_MONOTONIC[_RAW]
> > > On the update side:
> > > 
> > >   tkf->seq++;
> > >   smp_wmb();
> > >   update(tkf->base[0], tk;
> > 
> > missing ")"
> 
> :)
>  
> > Any reason why the updater wouldn't do:
> > 
> > tkf->seq++;
> > smp_wmb();
> > update(tkf->base[1 - (tkf->seq & 0x01)], tk);
> > 
> > instead of updating both array entries each time ?
> 
>   base[0];   	      <- Current active
>   seq++;	      -> Makes base[1] the active one for readers
>   update(base[0]);
> 
> So readers are always one update cycle behind. Probably not an issue
> most of the time, but think about fast wrapping clocksources and
> NOHZ....

Ah, yep, got it.

So instead of calling update() twice per update, could we do
the following instead ?

tkf->seq++;
smp_wmb();
update(tkf->base[0], tk);
tkf->seq++;
smp_wmb();
memcpy(tkf->base[1], tkf->base[0], sizeof(tkf->base[1]);

just in case "update" would happen to be expensive for
some clock implementation.

Thanks,

Mathieu


> 
> Thanks,
> 
> 	tglx
> 
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
