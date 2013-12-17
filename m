Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3LQT1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:27:33 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:33314 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3LQT1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:27:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131217192128.GA15969@linux.vnet.ibm.com>
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
	<1385147087-26588-2-git-send-email-Waiman.Long@hp.com>
	<20131217192128.GA15969@linux.vnet.ibm.com>
Date: Tue, 17 Dec 2013 11:27:29 -0800
X-Google-Sender-Auth: aeeMkdMiuzs5m2VDUXIfen2q-pY
Message-ID: <CA+55aFzNSZCKnuEm+CDWUN2G4bfrN+HafX8r13NcfT2tJ4h-jw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] qrwlock: A queue read/write lock implementation
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:21 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Looks like xadd() is x86-specific, but this is common code.  One
> approach would be to do xadd() for other arches, another approach
> would be to make .rw be an atomic_t rather than a u32.  Making it
> be atomic_t is probably easiest.  (The cmpxchg()s would then need
> to be atomic_cmpxchg().)

Note that "xadd()" has different semantics from "atomic_add_return()".

xadd() returns the original value, while atomic_add_return() returns
the result of the addition.

In this case, we seem to want the xadd() semantics. I guess we can use
"atomic_add_return(val,&atomic)-val" and just assume that the compiler
gets it right (with the addition and the subtraction cancelling out).
Or maybe we should have a "atomic_add_return_original()" with xadd
semantics?

               Linus
