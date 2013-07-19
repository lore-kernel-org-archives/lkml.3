Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3GSXQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:16:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3GSXQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:16:17 -0400
Date: Fri, 19 Jul 2013 16:16:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: vmstats: track TLB flush stats on UP too
Message-Id: <20130719161616.b3805734beb57a657a122e25@linux-foundation.org>
In-Reply-To: <20130719204004.B28D1C10@viggo.jf.intel.com>
References: <20130719204004.B28D1C10@viggo.jf.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013 13:40:04 -0700 Dave Hansen <dave@sr71.net> wrote:

> 
> Andrew, this fixes up the TLB flush vmstats for UP.  It's on top
> of the previous patch, but I'm happy to combine them and send a
> replacement if you'd prefer.
> 
> This also removes the NR_TLB_LOCAL_FLUSH_ONE_KERNEL counter.  We
> do not have a good API on UP to separate out the kernel from the
> non-kernel flushes.  It's probably not an important distinction
> anyway.
> 
> Compile and boot tested on 64-bit SMP and UP.  Compile tested
> for x86_32 SMP.
> 
> --
> 
> The previous patch doing vmstats for TLB flushes effectively
> missed UP since arch/x86/mm/tlb.c is only compiled for SMP.
> 
> UP systems do not do remote TLB flushes, so compile those
> counters out on UP.
> 
> arch/x86/kernel/cpu/mtrr/generic.c calls __flush_tlb() directly.
> This is probably an optimization since both the mtrr code and
> __flush_tlb() write cr4.  It would probably be safe to make that
> a flush_tlb_all() (and then get these statistics), but the mtrr
> code is ancient and I'm hesitant to touch it other than to just
> stick in the counters.

Do we really want to do this?  I agree that UP isn't super-important,
particularly on x86, and the benefit here is small.

Often I mention things just to check that they have been considered. 
Considered-and-rejected is better than forgot-about-that.

> ...
>
> --- linux.git/include/linux/vm_event_item.h~compile-useless-stats-out-on-up	2013-07-19 08:21:37.408237538 -0700
> +++ linux.git-davehans/include/linux/vm_event_item.h	2013-07-19 09:13:16.903143205 -0700
> @@ -70,11 +70,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
>  		THP_ZERO_PAGE_ALLOC,
>  		THP_ZERO_PAGE_ALLOC_FAILED,
>  #endif
> +#ifdef CONFIG_SMP
>  		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
>  		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
> +#endif
>  		NR_TLB_LOCAL_FLUSH_ALL,
>  		NR_TLB_LOCAL_FLUSH_ONE,
> -		NR_TLB_LOCAL_FLUSH_ONE_KERNEL,
>  		NR_VM_EVENT_ITEMS

I was all excited, expecting documentation for these as discussed
yesterday, but it was not to be :(

> +/* "_up" is for UniProcessor
> + *
> + * This is a helper for other header functions.  *Not*
> + * intended to be called directly.  All global TLB
> + * flushes need to either call this, or do the bump the
> + * vm statistics themselves.
> + */

Comment seems a bit sickly.  Have a pill:

--- a/arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too-fix
+++ a/arch/x86/include/asm/tlbflush.h
@@ -85,11 +85,10 @@ static inline void __flush_tlb_one(unsig
 
 #ifndef CONFIG_SMP
 
-/* "_up" is for UniProcessor
+/* "_up" is for UniProcessor.
  *
- * This is a helper for other header functions.  *Not*
- * intended to be called directly.  All global TLB
- * flushes need to either call this, or do the bump the
+ * This is a helper for other header functions.  *Not* intended to be called
+ * directly.  All global TLB flushes need to either call this, or to bump the
  * vm statistics themselves.
  */
 static inline void __flush_tlb_up(void)

