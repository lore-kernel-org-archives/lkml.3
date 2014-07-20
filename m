Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaGTAfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 20:35:42 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44782 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaGTAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 20:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140719182859.GJ3935@laptop>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
	<20140719180120.GA20887@localhost.localdomain>
	<20140719182859.GJ3935@laptop>
Date: Sun, 20 Jul 2014 02:35:39 +0200
Message-ID: <CAFTL4hw1Sn_f3UBwh_bRnuHixxAF=FUFm6y2LLxZXo_nt7HLYg@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running for
 non-nohz_full= CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        =?UTF-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Darren Hart <dvhart@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        pranith kumar <bobby.prani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-19 20:28 GMT+02:00 Peter Zijlstra <peterz@infradead.org>:
> On Sat, Jul 19, 2014 at 08:01:24PM +0200, Frederic Weisbecker wrote:
>> This can be changed by allowing timekeeping duty from all non-nohz_full CPUs, that's
>> the initial direction I took, but it involved a lot of complications and scalability
>> issues.
>
> How so, currently any CPU can be timekeeper, how is any !nohz_full cpu
> different?

If timekeeping becomes a movable target in nohz full then we need to
make rcu_sys_is_idle() callable concurrently and we must send the
timekeeping-wakeup IPI to a possibly moving target. All that is a
predictable nightmare both in terms of complexity and scalability.

That's the direction I took initially
(https://lkml.org/lkml/2013/12/17/708) but I quickly resigned. The
changestat needed to be doubled to do it correctly. Moreover having
non-nohz-full CPUs other than CPU 0 is expected to be a corner case. A
corner case for a barely used feature (nohz full) as of today.

Also you might want to read tglx opinion on movable timekeepers in
nohz full: http://marc.info/?i=alpine.DEB.2.02.1405092358390.6261%40ionos.tec.linutronix.de
