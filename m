Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3BVMu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 07:50:29 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:45847 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3BVMu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 07:50:26 -0500
Date: Fri, 22 Feb 2013 13:50:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Message-ID: <20130222125019.GC17948@somewhere.redhat.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361522767.26780.44.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361522767.26780.44.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 09:46:07AM +0100, Peter Zijlstra wrote:
> On Thu, 2013-02-21 at 21:56 -0800, Kevin Hilman wrote:
> > On 64-bit platforms, reads/writes of the various cpustat fields are
> > atomic due to native 64-bit loads/stores.  However, on non 64-bit
> > platforms, reads/writes of the cpustat fields are not atomic and could
> > lead to inconsistent statistics.
> 
> Which is a problem how?

So here is a possible scenario, CPU 0 reads a kcpustat value, and CPU 1 writes
it at the same time:

    //Initial value of "cpustat" is 0xffffffff
         == CPU 0 ==           == CPU 1 ==

       //load low part
       mov %eax, [cpustat]
                             inc [cpustat]
                             //Update the high part if necessary
                             jnc 1f
                             inc [cpustat + 4]
                             1:
       //load high part
       mov %edx, [cpustat + 4]


Afterward, CPU 0 will think the value is 0x1ffffffff while it's actually
0x100000000.

atomic64_read() and atomic64_set() are supposed to take care of that, without
even the need for _inc() or _add() parts that use LOCK.


> 
> > This problem was originally reported by Frederic Weisbecker as a
> > 64-bit limitation with the nsec granularity cputime accounting for
> > full dynticks, but then we realized that it's a problem that's been
> > around for awhile and not specific to the new cputime accounting.
> > 
> > This series fixes this by first converting all access to the cputime
> > fields to use accessor functions, and then converting the accessor
> > functions to use the atomic64 functions.
> 
> Argh!! at what cost? 64bit atomics are like expensive. Wouldn't adding
> a seqlock be saner?

Not sure. This requires a spinlock in the write side which is called from
fast path like the timer interrupt.
