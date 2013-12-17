Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3LQTt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:49:56 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44618 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3LQTtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:49:52 -0500
Date: Tue, 17 Dec 2013 11:49:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
Message-ID: <20131217194946.GO5919@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
 <1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
 <20131217192128.GA15969@linux.vnet.ibm.com>
 <CA+55aFzNSZCKnuEm+CDWUN2G4bfrN+HafX8r13NcfT2tJ4h-jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzNSZCKnuEm+CDWUN2G4bfrN+HafX8r13NcfT2tJ4h-jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121719-9332-0000-0000-00000286C581
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:27:29AM -0800, Linus Torvalds wrote:
> On Tue, Dec 17, 2013 at 11:21 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Looks like xadd() is x86-specific, but this is common code.  One
> > approach would be to do xadd() for other arches, another approach
> > would be to make .rw be an atomic_t rather than a u32.  Making it
> > be atomic_t is probably easiest.  (The cmpxchg()s would then need
> > to be atomic_cmpxchg().)
> 
> Note that "xadd()" has different semantics from "atomic_add_return()".

Gah, that one always trips me up.  :-/

> xadd() returns the original value, while atomic_add_return() returns
> the result of the addition.
> 
> In this case, we seem to want the xadd() semantics. I guess we can use
> "atomic_add_return(val,&atomic)-val" and just assume that the compiler
> gets it right (with the addition and the subtraction cancelling out).

That seems like it would work well.

> Or maybe we should have a "atomic_add_return_original()" with xadd
> semantics?

My lazy side prefers the autocancellation.  ;-)  But yes, there are a
number of architectures (including ARM and Power) where the compiler
would have to be very tricky to reach into an asm to do the cancellation.

So perhaps a generic atomic_add_return_original() that is defined in
terms of atomic_add_return() as you say above, allowing architectures
to override with more-efficient implementations?  The same could be done
for add_smp() and xadd(), for that matter.

							Thanx, Paul

