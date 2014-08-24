Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaHXKFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 06:05:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41228 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaHXKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 06:05:08 -0400
Date: Sun, 24 Aug 2014 12:05:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, linux-mm@kvack.org, kirill@shutemov.name,
        lauraa@codeaurora.org, davej@redhat.com
Subject: Re: [PATCH] [v4] warn on performance-impacting configs aka.
 TAINT_PERFORMANCE
Message-ID: <20140824100503.GA929@gmail.com>
References: <20140822205625.657E9890@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822205625.657E9890@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Changes from v3:
>  * remove vestiges of TAINT_PERFORMANCE
>  * change filename to check-configs
>  * fix typos in description
>  * print out CONFIG_FOO=y
>  * tone down warning message
>  * add KMEMCHECK and GCOV
>  * add PROVE_LOCKING, but keep LOCKDEP since _anything_ selecting
>    it will cause scalaing issues at least.  But, move LOCKDEP
>    below LOCK_STAT and PROVE_LOCKING.
>  * no more perfo-mance (missing an 'r')
>  * temporary variable in lieu of multiple ARRAY_SIZE()
>  * break early out of snprintf() loop
> 
> Changes from v2:
>  * remove tainting and stack track
>  * add debugfs file
>  * added a little text to guide folks who want to add more
>    options
> 
> Changes from v1:
>  * remove schedstats
>  * add DEBUG_PAGEALLOC and SLUB_DEBUG_ON
> 
> --
> 
> I have more than once myself been the victim of an accidentally-
> enabled kernel config option being mistaken for a true
> performance problem.
> 
> I'm sure I've also taken profiles or performance measurements
> and assumed they were real-world when really I was measuring the
> performance with an option that nobody turns on in production.
> 
> A warning like this late in boot will help remind folks when
> these kinds of things are enabled.  We can also teach tooling to
> look for and capture /sys/kernel/debug/config_debug .
> 
> As for the patch...
> 
> I originally wanted this for CONFIG_DEBUG_VM, but I think it also
> applies to things like lockdep and slab debugging.  See the patch
> for the list of offending config options.  I'm open to adding
> more, but this seemed like a good list to start.
> 
> The compiler is smart enough to really trim down the code when
> the array is empty.  An objdump -d looks like this:
> 
> 	lib/check-configs.o:     file format elf64-x86-64
> 
> 	Disassembly of section .init.text:
> 
> 	000000000000000 <check_configs>:
> 	  0:	55                   	push   %rbp
> 	  1:	31 c0                	xor    %eax,%eax
> 	  3:	48 89 e5             	mov    %rsp,%rbp
> 	  6:	5d                   	pop    %rbp
> 	  7:	c3                   	retq
> 
> This could be done with Kconfig and an #ifdef to save us 8 bytes
> of text and the entry in the late_initcall() section.  Doing it
> this way lets us keep the list of these things in one spot, and
> also gives us a convenient way to dump out the name of the
> offending option.
> 
> For anybody that *really* cares, I put the whole thing under
> CONFIG_DEBUG_KERNEL in the Makefile.
> 
> The messages look like this:
> 
> [    3.865297] INFO: Be careful when using this kernel for performance measurement.
> [    3.868776] INFO: Potentially performance-altering options enabled:
> [    3.871558] 	CONFIG_LOCKDEP=y
> [    3.873326] 	CONFIG_SLUB_DEBUG_ON=y
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: ak@linux.intel.com
> Cc: tim.c.chen@linux.intel.com
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kirill@shutemov.name
> Cc: lauraa@codeaurora.org
> Cc: davej@redhat.com

Looks good to me in principle. (haven't tested it)

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
