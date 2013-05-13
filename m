Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3EMIoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:44:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33892 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EMIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:44:53 -0400
Message-ID: <1368434680.2618.33.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH v3 2/5] powerpc: Exception hooks for context
 tracking subsystem
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, paulus@samba.org,
        michael@ellerman.id.au
Date: Mon, 13 May 2013 16:44:40 +0800
In-Reply-To: <1368424667.19924.26.camel@pasglop>
References: <1368422493-9831-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368422493-9831-3-git-send-email-zhong@linux.vnet.ibm.com>
	 <1368424667.19924.26.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051308-9574-0000-0000-000007D81F4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 15:57 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-13 at 13:21 +0800, Li Zhong wrote:
> >  	int recover = 0;
> > +	enum ctx_state prev_state;
> > +
> > +	prev_state = exception_enter();
> 
> Please make it nicer:
> 
> 	enum ctx_state prev_state = exception_enter();
> 	int recover = 0;

OK, I'll fix it, and all the others.

> >  	__get_cpu_var(irq_stat).mce_exceptions++;
> >  
> > @@ -683,7 +687,7 @@ void machine_check_exception(struct pt_regs *regs)
> >  		recover = cur_cpu_spec->machine_check(regs);
> >  
> >  	if (recover > 0)
> > -		return;
> > +		goto exit;
> 
> I'm no fan of "exit" as a label as it's otherwise a libc function (I
> know there is no relationship here but I just find that annoying).
> 
> I usually use "bail"

OK, I'll fix it, and all the others.

> 
> >  #if defined(CONFIG_8xx) && defined(CONFIG_PCI)
> >  	/* the qspan pci read routines can cause machine checks -- Cort
> > @@ -693,20 +697,23 @@ void machine_check_exception(struct pt_regs *regs)
> >  	 * -- BenH
> >  	 */
> >  	bad_page_fault(regs, regs->dar, SIGBUS);
> > -	return;
> > +	goto exit;
> >  #endif
> >  
> >  	if (debugger_fault_handler(regs))
> > -		return;
> > +		goto exit;
> >  
> >  	if (check_io_access(regs))
> > -		return;
> > +		goto exit;
> >  
> >  	die("Machine check", regs, SIGBUS);
> >  
> >  	/* Must die if the interrupt is not recoverable */
> >  	if (!(regs->msr & MSR_RI))
> >  		panic("Unrecoverable Machine check");
> > +
> > +exit:
> > +	exception_exit(prev_state);
> >  }
> >  
> >  void SMIException(struct pt_regs *regs)
> > @@ -716,20 +723,31 @@ void SMIException(struct pt_regs *regs)
> >  
> >  void unknown_exception(struct pt_regs *regs)
> >  {
> > +	enum ctx_state prev_state;
> > +	prev_state = exception_enter();
> > +
> 
> Same cosmetic comment for all other cases
> 
>  ..../...
> 
> >  #include <asm/firmware.h>
> >  #include <asm/page.h>
> > @@ -193,8 +194,8 @@ static int mm_fault_error(struct pt_regs *regs, unsigned long addr, int fault)
> >   * The return value is 0 if the fault was handled, or the signal
> >   * number if this is a kernel fault that can't be handled here.
> >   */
> > -int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
> > -			    unsigned long error_code)
> > +static int __kprobes __do_page_fault(struct pt_regs *regs,
> > +				unsigned long address, unsigned long error_code)
> >  {
> >  	struct vm_area_struct * vma;
> >  	struct mm_struct *mm = current->mm;
> > @@ -475,6 +476,17 @@ bad_area_nosemaphore:
> >  
> >  }
> >  
> > +int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
> > +			    unsigned long error_code)
> > +{
> > +	int ret;
> > +	enum ctx_state prev_state;
> > +	prev_state = exception_enter();
> > +	ret = __do_page_fault(regs, address, error_code);
> > +	exception_exit(prev_state);
> > +	return ret;
> > +}
> 
> Any reason why you didn't use the same wrapping trick in traps.c ? I'd
> rather we stay consistent in the way we do things between the two files.

OK, I'll make it consistent with those in traps.c

> 
> >  /*
> >   * bad_page_fault is called when we have a bad access from the kernel.
> >   * It is called from the DSI and ISI handlers in head.S and from some
> > diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
> > index 88ac0ee..d92fb26 100644
> > --- a/arch/powerpc/mm/hash_utils_64.c
> > +++ b/arch/powerpc/mm/hash_utils_64.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/init.h>
> >  #include <linux/signal.h>
> >  #include <linux/memblock.h>
> > +#include <linux/context_tracking.h>
> >  
> >  #include <asm/processor.h>
> >  #include <asm/pgtable.h>
> > @@ -962,6 +963,9 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> >  	const struct cpumask *tmp;
> >  	int rc, user_region = 0, local = 0;
> >  	int psize, ssize;
> > +	enum ctx_state prev_state;
> > +
> > +	prev_state = exception_enter();
> >  
> >  	DBG_LOW("hash_page(ea=%016lx, access=%lx, trap=%lx\n",
> >  		ea, access, trap);
> > @@ -973,7 +977,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> >  		mm = current->mm;
> >  		if (! mm) {
> >  			DBG_LOW(" user region with no mm !\n");
> > -			return 1;
> > +			rc = 1;
> > +			goto exit;
> >  		}
> >  		psize = get_slice_psize(mm, ea);
> >  		ssize = user_segment_size(ea);
> > @@ -992,19 +997,23 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> >  		/* Not a valid range
> >  		 * Send the problem up to do_page_fault 
> >  		 */
> > -		return 1;
> > +		rc = 1;
> > +		goto exit;
> >  	}
> >  	DBG_LOW(" mm=%p, mm->pgdir=%p, vsid=%016lx\n", mm, mm->pgd, vsid);
> >  
> >  	/* Bad address. */
> >  	if (!vsid) {
> >  		DBG_LOW("Bad address!\n");
> > -		return 1;
> > +		rc = 1;
> > +		goto exit;
> >  	}
> >  	/* Get pgdir */
> >  	pgdir = mm->pgd;
> > -	if (pgdir == NULL)
> > -		return 1;
> > +	if (pgdir == NULL) {
> > +		rc = 1;
> > +		goto exit;
> > +	}
> >  
> >  	/* Check CPU locality */
> >  	tmp = cpumask_of(smp_processor_id());
> > @@ -1027,7 +1036,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> >  	ptep = find_linux_pte_or_hugepte(pgdir, ea, &hugeshift);
> >  	if (ptep == NULL || !pte_present(*ptep)) {
> >  		DBG_LOW(" no PTE !\n");
> > -		return 1;
> > +		rc = 1;
> > +		goto exit;
> >  	}
> >  
> >  	/* Add _PAGE_PRESENT to the required access perm */
> > @@ -1038,13 +1048,16 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> >  	 */
> >  	if (access & ~pte_val(*ptep)) {
> >  		DBG_LOW(" no access !\n");
> > -		return 1;
> > +		rc = 1;
> > +		goto exit;
> >  	}
> >  
> >  #ifdef CONFIG_HUGETLB_PAGE
> > -	if (hugeshift)
> > -		return __hash_page_huge(ea, access, vsid, ptep, trap, local,
> > +	if (hugeshift) {
> > +		rc = __hash_page_huge(ea, access, vsid, ptep, trap, local,
> >  					ssize, hugeshift, psize);
> > +		goto exit;
> > +	}
> >  #endif /* CONFIG_HUGETLB_PAGE */
> >  
> >  #ifndef CONFIG_PPC_64K_PAGES
> > @@ -1124,6 +1137,8 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> >  		pte_val(*(ptep + PTRS_PER_PTE)));
> >  #endif
> >  	DBG_LOW(" -> rc=%d\n", rc);
> > +exit:
> > +	exception_exit(prev_state);
> >  	return rc;
> >  }
> >  EXPORT_SYMBOL_GPL(hash_page);
> > @@ -1259,6 +1274,9 @@ void flush_hash_range(unsigned long number, int local)
> >   */
> >  void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
> >  {
> > +	enum ctx_state prev_state;
> > +	prev_state = exception_enter();
> > +
> >  	if (user_mode(regs)) {
> >  #ifdef CONFIG_PPC_SUBPAGE_PROT
> >  		if (rc == -2)
> > @@ -1268,6 +1286,8 @@ void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
> >  			_exception(SIGBUS, regs, BUS_ADRERR, address);
> >  	} else
> >  		bad_page_fault(regs, address, SIGBUS);
> > +
> > +	exception_exit(prev_state);
> >  }
> 
> So the above comes from the return of hash page following an error, it's
> technically the same exception. I don't know if that matters however.
> Also some exceptions are directly handled in asm such as SLB misses,
> again I don't know if that matters as I'm not familiar with what the
> context tracing code is actually doing.

Yes, the above and hash_page() are two C functions for a same exception.
And the exception hooks enable RCU usage in those C codes. But for asm
codes, I think we could assume that there would be no RCU usage there,
so we don't need wrap them in the hooks.

Thanks, Zhong

> 
> >  long hpte_insert_repeating(unsigned long hash, unsigned long vpn,
> 
> Cheers,
> Ben.
> 
> 





