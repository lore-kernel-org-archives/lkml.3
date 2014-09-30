Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaI3TUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:20:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaI3TUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:20:22 -0400
Message-ID: <542B0237.6020601@redhat.com>
Date: Tue, 30 Sep 2014 15:19:19 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com, oleg@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched, time: fix build error with 64 bit cputime_t on
 32 bit systems
References: <2547036.UshV4pXvhf@wuerfel> <20140930134011.232bc7bf@annuminas.surriel.com> <6735433.ACfjMtVDYF@wuerfel>
In-Reply-To: <6735433.ACfjMtVDYF@wuerfel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/30/2014 02:49 PM, Arnd Bergmann wrote:
> On Tuesday 30 September 2014 13:40:11 Rik van Riel wrote:
>> On Tue, 30 Sep 2014 13:56:37 +0200 Arnd Bergmann <arnd@arndb.de>
>> wrote:
>> 
>>> A recent change to update the stime/utime members of
>>> task_struct using atomic cmpxchg broke configurations on 32-bit
>>> machines with CONFIG_VIRT_CPU_ACCOUNTING_GEN set, because that
>>> uses 64-bit nanoseconds, leading to a link-time error:
>>> 
>>> kernel/built-in.o: In function `cputime_adjust': 
>>> :(.text+0x25234): undefined reference to `__bad_cmpxchg'
>> 
>> Arnd, this should fix your problem, while still ensuring that the
>> cpu time counters only ever go forward.
>> 
>> I do not have cross compiling toolchains set up here, but I
>> assume this fixes your bug.
>> 
>> Ingo & Peter, if this patch fixes the bug for Arnd, could you
>> please merge it into -tip?
>> 
>> Linus, the changeset causing the problem is only in -tip right
>> now, and this patch will not apply to your tree.
> 
> It compiles and links on arm32 with both 32-bit and 64-bit
> cputime_t, but I now get a new warning for the former case:
> 
> kernel/sched/cputime.c: In function 'cputime_advance': 
> kernel/sched/cputime.c:576:29: warning: passing argument 1 of
> '__cmpxchg64_mb' from incompatible pointer type cmpxchg64(counter,
> old, new); ^ In file included from
> /git/arm-soc/arch/arm/include/asm/atomic.h:19:0, from
> /git/arm-soc/include/linux/atomic.h:4, from
> /git/arm-soc/include/linux/debug_locks.h:5, from
> /git/arm-soc/include/linux/lockdep.h:23, from
> /git/arm-soc/include/linux/spinlock_types.h:18, from
> /git/arm-soc/include/linux/spinlock.h:81, from
> /git/arm-soc/include/linux/seqlock.h:35, from
> /git/arm-soc/include/linux/time.h:5, from
> /git/arm-soc/include/uapi/linux/timex.h:56, from
> /git/arm-soc/include/linux/timex.h:56, from
> /git/arm-soc/include/linux/sched.h:19, from
> /git/arm-soc/kernel/sched/cputime.c:2: 
> /git/arm-soc/arch/arm/include/asm/cmpxchg.h:255:105: note: expected
> 'long long unsigned int *' but argument is of type 'cputime_t *' 
> static inline unsigned long long __cmpxchg64_mb(unsigned long long
> *ptr, kernel/sched/cputime.c:576:5: warning: value computed is not
> used [-Wunused-value] cmpxchg64(counter, old, new); ^

Is u64 on arm defined to "long long unsigned int", and is the compiler
really blowing up over the difference between that and "unsigned long
long"?

Is u64 on arm really supposed to be "long long unsigned int"?

Am I overlooking something?

> I suspect there is no solution that doesn't involve the
> preprocessor. How about adding a cputime_cmpxchg() helper next to
> the cputime_t definition?

I thought of that first, and quickly dismissed it with "yuck" :)

I guess we could cast cputime_t to unsigned long long in the branch
that calls cmpxchg64.  Is that acceptable/unacceptable to people?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUKwI2AAoJEM553pKExN6Dr+kIAJMePKlT90h75zAPeVeofpGn
OPZ/V6N7do+pqZ3u56MdxmbCt1Rmbbp9Ka3tWZIJRS8OvyTQsPImmUiYD4KLiDL0
fOrADIiEIqj+hzvX9w6iSRTg8HwQSb8lL1jLSklhfE9bayN9/O0Pl4x80sqtfBfW
LJF+JGzktHQOq+VnfptQuPhCEKXFYgBHcP0JsVadkj/okXYmpQ4Iwk9pVs9WF1AG
+i251YZR0E8H8PEIEY5IPLP/xM64SwyxS6NUSJx4J8mMarIg2onXJuSabisOLARI
2bATM0UYPNLMJfSIO0E0dWCgEi/V8TyR7tzRBETFT1JQW6iWnIk4yVgoYMAaFPY=
=1+D4
-----END PGP SIGNATURE-----
