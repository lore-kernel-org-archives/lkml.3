Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab3CVPvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:51:33 -0400
Received: from a192-166.smtp-out.amazonses.com ([199.255.192.166]:41149 "EHLO
	a192-166.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933488Ab3CVPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:51:32 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 11:51:31 EDT
Date: Fri, 22 Mar 2013 15:41:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <1363906545.6345.81.camel@gandalf.local.home>
Message-ID: <0000013d92c37ff3-5fb85400-bec1-4eda-8ba1-332566884c59-000000@email.amazonses.com>
References: <1363906545.6345.81.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.192.166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Steven Rostedt wrote:

> The ffffffff8115517a is just before put_cpu_partial() which calls
> unfreeze_partials() with irqs disabled. So I started tracing again, this
> time with:

Hmmm... That is strange. unfreeze_partials should be rather fast.

> It ran for 249.51 microseconds!!! With interrupts disabled! This was
> what caused the interrupt to go off late. I have no idea why adding
> tracing makes this latency go away. Perhaps it changes the timings just
> enough to not let things line up?
>
> I did a report with '-R' and showing the raw events, which will show the
> exit part of the function graph we have:
>
>    <...>-80563  14d...0 262219.108982: funcgraph_entry:       func=0xffffffff81154954 depth=0
>    <...>-80563  14d...0 262219.109233: funcgraph_exit:        func=0xffffffff81154954 calltime=0xee7ca4d8200f rettime=0xee7ca4dbeeb5 overrun=0x0 depth=0
>    <...>-80563  14d...0 262219.109233: funcgraph_entry:       func=0xffffffff81528e47 depth=0
>
> The funcgraph_exit is within the same microsecond the
> smp_apic_timer_interrupt() went off, so yes this is what delayed it.
>
> Anyway, this is run on 3.6.11-rt30, but looking at the current code, it
> doesn't look like it changed in any meaningful way. The while ((page =
> c->partial)) makes me nervous. How big can this list be? Is there a way
> to limit the amount this can run?

The control is via the cpu_partial field in /sys/kernel/slab/<cache>/

There is also slabs_cpu_partial which gives a view as to how many objects
are cached in each per cpu structure. Do a cat

/sys/kernel/*/slabs_cpu_partial to get a view of what the situation is.
Any abnormally high numbers?

The default for the number of per cpu partial objects should be 30 or so.



