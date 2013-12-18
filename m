Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3LRSvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:51:15 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:36296 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3LRSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:51:13 -0500
Message-ID: <52B1EE96.9000708@hp.com>
Date: Wed, 18 Dec 2013 13:51:02 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
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
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com> <1385147087-26588-2-git-send-email-Waiman.Long@hp.com> <20131217192128.GA15969@linux.vnet.ibm.com> <CA+55aFzNSZCKnuEm+CDWUN2G4bfrN+HafX8r13NcfT2tJ4h-jw@mail.gmail.com>
In-Reply-To: <CA+55aFzNSZCKnuEm+CDWUN2G4bfrN+HafX8r13NcfT2tJ4h-jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 02:27 PM, Linus Torvalds wrote:
> On Tue, Dec 17, 2013 at 11:21 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com>  wrote:
>> Looks like xadd() is x86-specific, but this is common code.  One
>> approach would be to do xadd() for other arches, another approach
>> would be to make .rw be an atomic_t rather than a u32.  Making it
>> be atomic_t is probably easiest.  (The cmpxchg()s would then need
>> to be atomic_cmpxchg().)
> Note that "xadd()" has different semantics from "atomic_add_return()".
>
> xadd() returns the original value, while atomic_add_return() returns
> the result of the addition.
>
> In this case, we seem to want the xadd() semantics. I guess we can use
> "atomic_add_return(val,&atomic)-val" and just assume that the compiler
> gets it right (with the addition and the subtraction cancelling out).
> Or maybe we should have a "atomic_add_return_original()" with xadd
> semantics?
>
>                 Linus

I will use the atomic_add_return() for the combined count. Actually what 
the code is looking for in the returned value is the state of the writer 
byte. So it doesn't really matter if _QR_BIAS has or hasn't been added 
to the count.

-Longman
