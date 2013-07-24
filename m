Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab3GXAD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:03:59 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29155 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3GXAD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:03:56 -0400
Message-ID: <51EF19D8.2090307@hp.com>
Date: Tue, 23 Jul 2013 20:03:36 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com> <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de> <51E49FA3.4030202@hp.com> <20130718074204.GA22623@gmail.com> <51E7F03A.4090305@hp.com> <20130719084023.GB25784@gmail.com> <51E95B85.8090003@hp.com> <20130722103402.GA1991@gmail.com>
In-Reply-To: <20130722103402.GA1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 06:34 AM, Ingo Molnar wrote:
> * Waiman Long<waiman.long@hp.com>  wrote:
>
>> I had run some performance tests using the fserver and new_fserver
>> benchmarks (on ext4 filesystems) of the AIM7 test suite on a 80-core
>> DL980 with HT on. The following kernels were used:
>>
>> 1. Modified 3.10.1 kernel with mb_cache_spinlock in fs/mbcache.c
>>     replaced by a rwlock
>> 2. Modified 3.10.1 kernel + modified __read_lock_failed code as suggested
>>     by Ingo
>> 3. Modified 3.10.1 kernel + queue read/write lock
>> 4. Modified 3.10.1 kernel + queue read/write lock in classic read/write
>>     lock behavior
>>
>> The last one is with the read lock stealing flag set in the qrwlock
>> structure to give priority to readers and behave more like the classic
>> read/write lock with less fairness.
>>
>> The following table shows the averaged results in the 200-1000
>> user ranges:
>>
>> +-----------------+--------+--------+--------+--------+
>> |  Kernel         |    1   |    2   |    3   |   4    |
>> +-----------------+--------+--------+--------+--------+
>> | fserver JPM     | 245598 | 274457 | 403348 | 411941 |
>> | % change from 1 |   0%   | +11.8% | +64.2% | +67.7% |
>> +-----------------+--------+--------+--------+--------+
>> | new-fserver JPM | 231549 | 269807 | 399093 | 399418 |
>> | % change from 1 |   0%   | +16.5% | +72.4% | +72.5% |
>> +-----------------+--------+--------+--------+--------+
> So it's not just herding that is a problem.
>
> I'm wondering, how sensitive is this particular benchmark to fairness?
> I.e. do the 200-1000 simulated users each perform the same number of ops,
> so that any smearing of execution time via unfairness gets amplified?
>
> I.e. does steady-state throughput go up by 60%+ too with your changes?

For this particular benchmark, there are interplay of different locks 
that determine the overall performance of the system. Yes, I got steady 
state performance gain of 60%+ with the qrwlock change with the modified 
mbcache.c. Without the modified mbcache.c file, the performance gain 
drop to 20-30%. I am still trying to find out more about the performance 
variations in different situations.

Regards,
Longman
