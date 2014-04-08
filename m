Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaDHUbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:31:38 -0400
Received: from mout.gmx.net ([212.227.15.19]:56083 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbaDHUbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:31:36 -0400
Message-ID: <53445BEA.1060702@gmx.de>
Date: Tue, 08 Apr 2014 22:28:26 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michele Ballabio <barra_cuda@katamail.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
References: <5341707F.5000406@katamail.com> <20140407150337.GO10526@twins.programming.kicks-ass.net> <20140407150705.GB13658@twins.programming.kicks-ass.net> <5342EB78.3060002@gmx.de> <20140407185658.GK11096@twins.programming.kicks-ass.net> <20140408122128.GC13658@twins.programming.kicks-ass.net>
In-Reply-To: <20140408122128.GC13658@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:GMC+NsjYx7ElxZwg8DJ8mrlieA7OJDSRSehLYoM4YiJrQet+BFK
 0Qn0GWxKVGjl+NUJ6DAA9rOUw9iNPE4b84n4eOiq1KlJKVCdceH62rgB1PeFnQtTKNTaFYb
 d2nn3ZzN3KiJ35z2hHLfQE2fGo+tmOHW630jPBEtyLMX1AR/jnkJn3AdRlJwg2T0wnIhUsw
 IVsy+0tXHNCNN+xkhWPHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 04/08/2014 02:21 PM, Peter Zijlstra wrote:
> On Mon, Apr 07, 2014 at 08:56:58PM +0200, Peter Zijlstra wrote:
>> On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf Förster wrote:
>> 
>>> v3.14-10353-g2b3a8fd works fine AFAICS (BTW the fix is stable
>>> material, right ?)
>> 
>> I'm fairly sure its not; its a rather invasive series; see:
>> 
>> 2432e1364bbe x86: Nuke the supervisor_stack field in i386
>> thread_info b807902a88c4 x86: Nuke GET_THREAD_INFO_WITH_ESP()
>> macro for i386 0788aa6a23cb x86: Prepare removal of previous_esp
>> from i386 thread_info structure 198d208df437 x86: Keep
>> thread_info on thread stack in x86_32
>> 
>> Let me see if there's anything 'simpler' we can stuff in .13+
> 
> OK.. so could someone test the below patch to see if that makes
> things work for .13 and .14?
> 
patch applied on 3.1.3.9 and 3.14.0 it fixed the issue AFAICT

> --- arch/x86/include/asm/preempt.h | 11 +++++++++++ 
> include/linux/preempt.h        |  4 ++++ 
> include/linux/thread_info.h    |  2 -- 3 files changed, 15
> insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/preempt.h
> b/arch/x86/include/asm/preempt.h index c8b051933b1b..7ada46d8d4d8
> 100644 --- a/arch/x86/include/asm/preempt.h +++
> b/arch/x86/include/asm/preempt.h @@ -5,6 +5,17 @@ #include
> <asm/percpu.h> #include <linux/thread_info.h>
> 
> +#ifdef CONFIG_X86_32 +/* + * i386's current_thread_info() depends
> on ESP and for interrupt/exception + * stacks this doesn't yield
> the actual task thread_info. + * + * We hard rely on the fact that
> all the TIF_NEED_RESCHED bits are + * the same, therefore use the
> slightly more expensive version below. + */ +#define
> tif_need_resched() test_tsk_thread_flag(current, TIF_NEED_RESCHED) 
> +#endif + DECLARE_PER_CPU(int, __preempt_count);
> 
> /* diff --git a/include/linux/preempt.h b/include/linux/preempt.h 
> index de83b4eb1642..891c8f8b52fe 100644 ---
> a/include/linux/preempt.h +++ b/include/linux/preempt.h @@ -17,6
> +17,10 @@
> 
> #include <asm/preempt.h>
> 
> +#ifndef tif_need_resched +#define tif_need_resched()
> test_thread_flag(TIF_NEED_RESCHED) +#endif + #if
> defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER) 
> extern void preempt_count_add(int val); extern void
> preempt_count_sub(int val); diff --git
> a/include/linux/thread_info.h b/include/linux/thread_info.h index
> fddbe2023a5d..a629e4b23217 100644 ---
> a/include/linux/thread_info.h +++ b/include/linux/thread_info.h @@
> -118,8 +118,6 @@ static inline __deprecated void
> set_need_resched(void) */ }
> 
> -#define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED) - 
> #if defined TIF_RESTORE_SIGMASK && !defined
> HAVE_SET_RESTORE_SIGMASK /* * An arch can define its own version of
> set_restore_sigmask() to get the
> 


- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF0EAREIAAYFAlNEW+EACgkQxOrN3gB26U5RkAD4ysUp9CrCajM7zXLsdWRLTZFi
oX0lYgrKo/gCrcS9UwD/ZdaRPlP6vTKApfxQ7F48KTTA+tNcyTD4xSyCdwI8l0Q=
=WeKZ
-----END PGP SIGNATURE-----
