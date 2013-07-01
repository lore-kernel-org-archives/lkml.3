Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3GAJTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:19:36 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:58679 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3GAJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAC4Lta3dpTDc19rXLVQkZrxbu8AJL+Foc6ocAktUAozCpk2-Mg@mail.gmail.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<20130611170249.GA1091@linux.vnet.ibm.com>
	<20130612154008.GA9714@linux.vnet.ibm.com>
	<CAC4Lta3dpTDc19rXLVQkZrxbu8AJL+Foc6ocAktUAozCpk2-Mg@mail.gmail.com>
Date: Mon, 1 Jul 2013 14:49:34 +0530
Message-ID: <CAC4Lta02wcg6CuYfXA3zqcUR-LoKGR4hs5KYM+1aS1Qg7A8xvg@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] v3 Auto-queued ticketlock
From: Raghavendra KT <raghavendra.kt.linux@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org, walken@google.com, waiman.long@hp.com,
        davidlohr.bueso@hp.com,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 11:23 PM, Raghavendra KT
<raghavendra.kt.linux@gmail.com> wrote:
>
>
> On Wed, Jun 12, 2013 at 9:10 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>>
>> Breaking up locks is better than implementing high-contention locks, but
>> if we must have high-contention locks, why not make them automatically
>> switch between light-weight ticket locks at low contention and queued
>> locks at high contention?  After all, this would remove the need for
>> the developer to predict which locks will be highly contended.
>>
>> This commit allows ticket locks to automatically switch between pure
>> ticketlock and queued-lock operation as needed.  If too many CPUs are
>> spinning on a given ticket lock, a queue structure will be allocated
>> and the lock will switch to queued-lock operation.  When the lock becomes
>> free, it will switch back into ticketlock operation.  The low-order bit
>> of the head counter is used to indicate that the lock is in queued mode,
>> which forces an unconditional mismatch between the head and tail counters.
>> This approach means that the common-case code path under conditions of
>> low contention is very nearly that of a plain ticket lock.
>>
>> A fixed number of queueing structures is statically allocated in an
>> array.  The ticket-lock address is used to hash into an initial element,
>> but if that element is already in use, it moves to the next element.  If
>> the entire array is already in use, continue to spin in ticket mode.
>>
>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> [ paulmck: Eliminate duplicate code and update comments (Steven Rostedt).
>> ]
>> [ paulmck: Address Eric Dumazet review feedback. ]
>> [ paulmck: Use Lai Jiangshan idea to eliminate smp_mb(). ]
>> [ paulmck: Expand ->head_tkt from s32 to s64 (Waiman Long). ]
>> [ paulmck: Move cpu_relax() to main spin loop (Steven Rostedt). ]
>> [ paulmck: Reduce queue-switch contention (Waiman Long). ]
>> [ paulmck: __TKT_SPIN_INC for __ticket_spin_trylock() (Steffen Persvold).
>> ]
>> [ paulmck: Type safety fixes (Steven Rostedt). ]
>> [ paulmck: Pre-check cmpxchg() value (Waiman Long). ]
>> [ paulmck: smp_mb() downgrade to smp_wmb() (Lai Jiangshan). ]
>>
> [...]
>
> I did test this on 32 core machine with 32 vcpu guests.
>
> This version gave me around 20% improvement fro sysbench and 36% improvement
> for ebizzy, for 1x commit though other overcommited results showed
> degradation. I have not tested Lai Jiangshan's patches on top of this yet.
> Will report any findings.

Sorry for late report.

With Lai's patch I see few percentage of improvement in ebizzy 1x and
reduction in degradation in dbench 1x.

But over-commit degradation seem to still persist. seeing this,  I
feel it is more of qmode overhead itself for large guests,

+---+-----------+-----------+-----------+------------+-----------+
                              ebizzy (rec/sec higher is better)
+---+---+-----------+-----------+-----------+------------+-----------+
    base      stdev         patched       stdev     %improvement
+---+-----------+-----------+-----------+------------+-----------+
1x  5574.9000   237.4997          7851.9000   148.6737    40.84378
2x  2741.5000   561.3090          1620.9000   410.8299   -40.87543
3x  2146.2500   216.7718          1751.8333    96.5023   -18.37702
+---+-----------+-----------+-----------+------------+-----------+
+---+-----------+-----------+-----------+------------+-----------+
                              dbench (throughput higher is better)
+---+-----------+-----------+-----------+------------+-----------+
    base      stdev         patched       stdev     %improvement
+---+-----------+-----------+-----------+------------+-----------+
1x 14111.5600   754.4525         13826.5700  1458.0744    -2.01955
2x  2481.6270    71.2665          1549.3740   245.3777   -37.56620
3x  1510.2483    31.8634          1116.0158    26.4882   -26.10382
+---+-----------+-----------+-----------+------------+-----------+
