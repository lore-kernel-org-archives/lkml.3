Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3KIDFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 22:05:40 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:36893 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3KIDFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 22:05:37 -0500
Message-ID: <527DA67A.2070505@hp.com>
Date: Fri, 08 Nov 2013 22:05:30 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, aswin@hp.com,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v5 1/4] qrwlock: A queue read/write lock implementation
References: <1383585440-4391-1-git-send-email-Waiman.Long@hp.com> <1383585440-4391-2-git-send-email-Waiman.Long@hp.com> <20131108211123.GH18245@linux.vnet.ibm.com> <527D675C.2040008@hp.com> <20131108235108.GA22696@linux.vnet.ibm.com>
In-Reply-To: <20131108235108.GA22696@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 06:51 PM, Paul E. McKenney wrote:
> On Fri, Nov 08, 2013 at 05:36:12PM -0500, Waiman Long wrote:
>> I have some incorrect assumptions about memory barrier. Anyway, this
>> issue will be gone once I use the MCS lock/unlock code.
> Here is a presentation that has some diagrams that might help:
>
> http://www.rdrop.com/users/paulmck/scalability/paper/Scaling.2013.10.25c.pdf
>
> So, for example, if X and Y are both initially zero:
>
> 	CPU 0			CPU 1
>
> 	ACCESS_ONCE(X) = 1;	r1 = ACCESS_ONCE(Y);
> 	smp_wmb();		smp_rmb();
> 	ACCESS_ONCE(Y) = 1;	r2 = ACCESS_ONCE(X);
>
> Then the two memory barriers enforce a conditional ordering.  The
> condition is whether or not CPU 0's store to Y is seen by CPU 1's
> load from Y.  If it is, then the pair of memory barriers ensure that
> CPU 1's load from X sees the result of CPU 0's store to X.  In other
> words, BUG_ON(r1 == 1&&  r2 == 0) will never fire.
>
> In general, if a memory access after memory barrier A happens before
> a memory access before memory barrier B, then the two memory barriers
> will ensure that applicable accesses before memory barrier A happen
> before applicable accesses after memory barrier B.
>
> Does that help?
>
> 							Thanx, Paul
>
>

Thank for the pointer. I understand the purpose of the memory barrier. I 
just thought that memory barrier can also kind of flush the cached data 
to the memory faster. Apparently that is not the case. Anyway, I now 
have a better understanding of what kind of barriers are needed in 
locking primitives by observing conversation in this and related threads.

-Longman
