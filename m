Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaGLOxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 10:53:19 -0400
Received: from mail.efficios.com ([78.47.125.74]:35839 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbaGLOxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 10:53:17 -0400
Date: Sat, 12 Jul 2014 14:53:17 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Message-ID: <318411977.13587.1405176797949.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140711133709.835700036@linutronix.de>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF30 (Linux)/8.0.7_GA_6021)
Thread-Topic: timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
Thread-Index: 3lvxbUWAeJJpc3FDU5Uj3AzAxyBgsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Thomas Gleixner" <tglx@linutronix.de>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "John Stultz" <john.stultz@linaro.org>, "Peter Zijlstra" <peterz@infradead.org>, "Steven Rostedt"
> <rostedt@goodmis.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Sent: Friday, July 11, 2014 9:45:19 AM
> Subject: [patch 54/55] timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]
> 
> Tracers want a correlated time between the kernel instrumentation and
> user space. We really do not want to export sched_clock() to user
> space, so we need to provide something sensible for this.
> 
> Using separate data structures with an non blocking sequence count
> based update mechanism allows us to do that. The data structure
> required for the readout has a sequence counter and two copies of the
> timekeeping data.
> 
> On the update side:
> 
>   tkf->seq++;
>   smp_wmb();
>   update(tkf->base[0], tk;
>   tkf->seq++;
>   smp_wmb();
>   update(tkf->base[1], tk;
> 
> On the reader side:
> 
>   do {
>      seq = tkf->seq;
>      smp_rmb();
>      idx = seq & 0x01;
>      now = now(tkf->base[idx]);
>      smp_rmb();
>   } while (seq != tkf->seq)
> 
> So if NMI hits the update of base[0] it will use base[1] which is
> still consistent. In case of CLOCK_MONOTONIC this can result in
> slightly wrong timestamps (a few nanoseconds) accross an update. Not a
> big issue for the intended use case.

Hi Thomas,

I'm perhaps missing something here, but what happens with the
following scenario ?

Initial conditions:

tkf->seq = 0
tkf->base[0] and tkf->base[1] are initialized.

CPU 0                                      CPU 1
------------                               ----------------
update:
  tkf->seq++
  smb_wmb()
  tkf->seq++ (reordered before update)
                                           reader:
                                           seq = tkf->seq (reads 2)
                                           smp_rmb()
                                           idx = seq & 0x01
                                           now = now(tkf->base[idx]   (reads base[0])
  update(tkf->base[0], tk) (racy concurrent update)
                                           smp_rmb()
                                           while (seq != tkf->seq) (they are equal)

So AFAIU, we end up returning a corrupted value. Adding a
smp_wmb() between update of base[0] and increment of seq,
as well as between update of base[1] and the _following_
increment of seq (next update call) would fix this.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
