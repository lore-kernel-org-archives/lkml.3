Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaE0Vsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:48:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:21369 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751736AbaE0Vst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:48:49 -0400
Date: Tue, 27 May 2014 17:48:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with
 irqsoff tracers
Message-ID: <20140527174847.7b405b5c@gandalf.local.home>
In-Reply-To: <17051981.niWmA6MIgX@wuerfel>
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org>
	<17051981.niWmA6MIgX@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 22:11:25 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 27 May 2014 13:08:04 Stephen Boyd wrote:
> > @@ -380,7 +382,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
> >  
> >         cpu = raw_smp_processor_id();
> >  
> > -       if (per_cpu(tracing_cpu, cpu))
> > +       if (per_cpu(timings_stopped, cpu) || per_cpu(tracing_cpu, cpu))
> >                 return;
> >  
> >         data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> > 
> 
> Where exactly do you see other code calling here while
> per_cpu(timings_stopped) is set? Would it be possible to just
> change that call site?

Arnd brings up a good point. If we disable irqs off tracing completely,
we may be missing places in the idle path that disable interrupts for
long periods of time. We may want to move the stop down further.

The way it works (IIRC), and why tracing can start again is that it can
nest. Perhaps we need to stop it further down if we can't move it
completely.

-- Steve
