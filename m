Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3JJSKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:10:41 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45302 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3JJSKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
	<20131010094355.6f75e5a2.akpm@linux-foundation.org>
	<20131010165337.GT3081@twins.programming.kicks-ass.net>
	<20131010131305.58558079@gandalf.local.home>
	<20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
Date: Thu, 10 Oct 2013 11:10:35 -0700
X-Google-Sender-Auth: kkbI29sVjkAXK-TWaeuLDiHB0YQ
Message-ID: <CA+55aFx-JxRBbPa5EF1foZORpX_+o3T-qqm+1vh5Goa9znmOxA@mail.gmail.com>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:48 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Yes, I'd have thought that the cases where a CPU is fiddling with
> another CPU's percpu data with preemption enabled would be rather rare.
>
> I can't actually think of any off the top.  Are there examples we can
> look at?

You can't do that right now - since you have to get the cpu list. So
it may not be with "preemption enabled", but it should always be under
the locking provided by get_online_cpus().. That one allows sleeping,
though.

I personally would *love* to make CPU hotplug be a lockless thing
entirely. But I detest stop-machine too, because it has these really
annoying properties.

So if we want to make it zero-cost to look at online CPU data, can we
avoid even the stop-machine synchronization, instead saying that the
cpu hotplug bitmap is updated completely locklessly, but if you see a
bit set, the data associated with that CPU is guaranteed to still be
available.

IOW, just use "RCU semantics" on a per-bit level. When we offline a CPU, we do

     clear_bit(cpu, cpu_online_mask);
     rcu_synchronize();
     .. now we can free all the percpu data and kill the CPU ..

without any locking anywhere - not stop-machine, not anything. If
somebody is doing a "for_each_cpu()" (under just a regular
rcu_read_lock()) and they see the bit set while it's going down, who
cares? The CPU is still there, the data is accessible..

I'm sure there's some reason the above wouldn't work, but the above
would seem to be pretty optimal. Why do we really force this big
locking thing? The new patches make that locking _smarter_, but it's
still a damn big lock. Could we possibly go _beyond_ the lock?

                 Linus
