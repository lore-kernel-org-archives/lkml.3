Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3BVOFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:05:13 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55028
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755642Ab3BVOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:05:10 -0500
Message-ID: <1361541894.26780.62.camel@laptop>
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Date: Fri, 22 Feb 2013 15:04:54 +0100
In-Reply-To: <20130222135411.GA9202@gmail.com>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
	 <1361522767.26780.44.camel@laptop>
	 <20130222125019.GC17948@somewhere.redhat.com>
	 <1361540926.26780.56.camel@laptop> <20130222135411.GA9202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 14:54 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2013-02-22 at 13:50 +0100, Frederic Weisbecker wrote:
> 
> > > atomic64_read() and atomic64_set() are supposed to take care 
> > > of that, without even the need for _inc() or _add() parts 
> > > that use LOCK.
> > 
> > Are you sure? Generally atomic*_set() is not actually an 
> > atomic operation.
> 
> as per Documentation/atomic_ops.h:

I think the interesting part is:

"The setting is atomic in that the return values of the atomic
operations by
all threads are guaranteed to be correct reflecting either the value
that has
been set with this operation or set with another operation.  A proper
implicit
or explicit memory barrier is needed before the value set with the
operation
is guaranteed to be readable with atomic_read from another thread."

Which does give us the wanted guarantee, however:

I checked arch/x86/include/asm/atomic64_32.h and we use cmpxchg8b for
everything from _set() to _read(), which translates into 'horridly
stupendifyingly slow' for a number of machines, but coherent.



