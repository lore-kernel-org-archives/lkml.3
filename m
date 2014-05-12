Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbaELN5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:57:46 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:62697 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbaELN5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:57:44 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2014 09:57:44 EDT
Message-ID: <5370CFAC.40705@imgtec.com>
Date: Mon, 12 May 2014 14:42:04 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in __compiletime_assert()
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/05/14 07:31, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Usually, BUG_ON and friends aren't even evaluated in sparse, but
> recently compiletime_assert_atomic_type() was added, and that now
> results in a sparse warning every time it is used.
> 
> The reason turns out to be the temporary variable, after it sparse
> no longer considers the value to be a constant, and results in a
> warning and an error. The error is the more annoying part of this
> as it suppresses any further warnings in the same file, hiding
> other problems.
> 
> Since this is all about compile time and the condition should be
> side-effect free to start with, there's no downside (apart maybe
> from a slight compilation time penalty?) to just duplicating it,
> leaving sparse able to evaluate it at check time, getting rid of
> the warning and error.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/linux/compiler.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 2472740d7ab2..38c0e00ddef8 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -324,11 +324,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  
>  #define __compiletime_assert(condition, msg, prefix, suffix)		\
>  	do {								\
> -		bool __cond = !(condition);				\
>  		extern void prefix ## suffix(void) __compiletime_error(msg); \
> -		if (__cond)						\
> +		if (!(condition))					\
>  			prefix ## suffix();				\
> -		__compiletime_error_fallback(__cond);			\
> +		__compiletime_error_fallback(!(condition));		\
>  	} while (0)
>  
>  #define _compiletime_assert(condition, msg, prefix, suffix) \
> 

Unfortunately this breaks the build of today's linux-next for the Meta
architecture (arch/metag), which happens to use a fairly old compiler
(based on gcc 4.2.4) which I presume is the reason why.

A bunch of compile time asserts fail, even in code which should be
optimised out. E.g. here's one which I analysed:

mm/gup.c: In function ‘follow_page_mask’:
mm/gup.c:208: error: size of array ‘type name’ is negative

Line 208 uses HPAGE_PMD_NR which expands to a HPAGE_PMD_SHIFT, which
expands to a BUILD_BUG(). However that line is inside an if block
conditioned on pmd_trans_huge(*pmd) which include/asm-generic/pgtable.h
defines inline to return 0, so the whole block should already be being
optimised out.

I don't understand why your patch should break things, I suspect it's
related to the sparse behaviour you're trying to work around, but can we
please drop this patch until a more portable workaround can be found?
I'm happy to test further patches with metag if it helps.

Full "make ARCH=metag -k -s" output below.

Cheers
James


mm/gup.c: In function ‘follow_page_mask’:
mm/gup.c:208: error: size of array ‘type name’ is negative
In file included from arch/metag/include/asm/fixmap.h:55,
                 from arch/metag/mm/init.c:26:
include/asm-generic/fixmap.h: In function ‘fix_to_virt’:
include/asm-generic/fixmap.h:31: error: size of array ‘type name’ is negative
scripts/Makefile.build:318: recipe for target 'arch/metag/mm/init.o' failed
make[1]: *** [arch/metag/mm/init.o] Error 1
make[1]: Target '__build' not remade because of errors.
Makefile:878: recipe for target 'arch/metag/mm' failed
make: *** [arch/metag/mm] Error 2
mm/memory.c: In function ‘copy_pmd_range’:
mm/memory.c:965: error: size of array ‘type name’ is negative
mm/memory.c: In function ‘zap_pmd_range’:
mm/memory.c:1232: error: size of array ‘type name’ is negative
scripts/Makefile.build:318: recipe for target 'mm/memory.o' failed
make[1]: *** [mm/memory.o] Error 1
mm/mremap.c: In function ‘move_page_tables’:
mm/mremap.c:197: error: size of array ‘type name’ is negative
mm/mprotect.c: In function ‘change_pmd_range’:
mm/mprotect.c:164: error: size of array ‘type name’ is negative
mm/mprotect.c:171: error: size of array ‘type name’ is negative
mm/mprotect.c:172: error: size of array ‘type name’ is negative
scripts/Makefile.build:318: recipe for target 'mm/mremap.o' failed
make[1]: *** [mm/mremap.o] Error 1
scripts/Makefile.build:318: recipe for target 'mm/mprotect.o' failed
make[1]: *** [mm/mprotect.o] Error 1
fs/proc/task_mmu.c: In function ‘smaps_pmd’:
fs/proc/task_mmu.c:502: error: size of array ‘type name’ is negative
fs/proc/task_mmu.c:504: error: size of array ‘type name’ is negative
scripts/Makefile.build:318: recipe for target 'mm/gup.o' failed
make[1]: *** [mm/gup.o] Error 1
scripts/Makefile.build:318: recipe for target 'fs/proc/task_mmu.o' failed
make[2]: *** [fs/proc/task_mmu.o] Error 1
make[2]: Target '__build' not remade because of errors.
scripts/Makefile.build:465: recipe for target 'fs/proc' failed
make[1]: *** [fs/proc] Error 2
make[1]: Target '__build' not remade because of errors.
Makefile:878: recipe for target 'fs' failed
make: *** [fs] Error 2
mm/pgtable-generic.c: In function ‘pmdp_clear_flush_young’:
mm/pgtable-generic.c:104: error: size of array ‘type name’ is negative
scripts/Makefile.build:318: recipe for target 'mm/pgtable-generic.o' failed
make[1]: *** [mm/pgtable-generic.o] Error 1
make[1]: Target '__build' not remade because of errors.
Makefile:878: recipe for target 'mm' failed
make: *** [mm] Error 2
In file included from arch/metag/include/asm/fixmap.h:55,
                 from arch/metag/include/asm/highmem.h:7,
                 from arch/metag/kernel/setup.c:37:
include/asm-generic/fixmap.h: In function ‘fix_to_virt’:
include/asm-generic/fixmap.h:31: error: size of array ‘type name’ is negative
scripts/Makefile.build:318: recipe for target 'arch/metag/kernel/setup.o' failed
make[1]: *** [arch/metag/kernel/setup.o] Error 1
make[1]: Target '__build' not remade because of errors.
Makefile:878: recipe for target 'arch/metag/kernel' failed
make: *** [arch/metag/kernel] Error 2
make: Target '_all' not remade because of errors.
