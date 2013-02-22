Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3BVNyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:54:19 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:61477 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3BVNyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:54:16 -0500
Date: Fri, 22 Feb 2013 14:54:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Message-ID: <20130222135411.GA9202@gmail.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
 <1361522767.26780.44.camel@laptop>
 <20130222125019.GC17948@somewhere.redhat.com>
 <1361540926.26780.56.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361540926.26780.56.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:

> > atomic64_read() and atomic64_set() are supposed to take care 
> > of that, without even the need for _inc() or _add() parts 
> > that use LOCK.
> 
> Are you sure? Generally atomic*_set() is not actually an 
> atomic operation.

as per Documentation/atomic_ops.h:

        #define atomic_read(v)  ((v)->counter)

 which simply reads the counter value currently visible to the 
 calling thread. The read is atomic in that the return value is 
 guaranteed to be one of the values initialized or modified with 
 the interface operations if a proper implicit or explicit 
 memory barrier is used after possible runtime initialization by 
 any other thread and the value is modified only with the 
 interface operations.

 ...

 Properly aligned pointers, longs, ints, and chars (and unsigned 
 equivalents) may be atomically loaded from and stored to in the 
 same sense as described for atomic_read() and atomic_set().  

 The ACCESS_ONCE() macro should be used to prevent the compiler 
 from using optimizations that might otherwise optimize accesses 
 out of existence on the one hand, or that might create 
 unsolicited accesses on the other.

This is usually a side effect of M[O]ESI cache coherency 
protocols - you can only get a 'split' word access if the word 
crosses cache line boundaries (multiples of 32 bytes, 
generally).

Thanks,

	Ingo
