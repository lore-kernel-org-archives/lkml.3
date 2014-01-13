Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaAMFcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:32:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaAMFcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:32:48 -0500
Date: Mon, 13 Jan 2014 13:32:40 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an
 arbitrary pagetable
Message-ID: <20140113053240.GA11237@dhcp-16-126.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389473370-1940-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/14 at 09:49pm, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> With reusing the ->trampoline_pgd page table for mapping EFI regions in
> order to use them after having switched to EFI virtual mode, it is very
> useful to be able to dump aforementioned page table in dmesg. This adds
> that functionality through the walk_pgd_level() interface which can be
> called from somewhere else.
> 
> The original functionality of dumping to debugfs remains untouched.
> 
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/include/asm/pgtable.h |  3 +-
>  arch/x86/mm/dump_pagetables.c  | 77 ++++++++++++++++++++++++++++--------------
>  2 files changed, 53 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index bbc8b12fa443..0001851fa785 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -15,9 +15,10 @@
>  	 : (prot))
>  
>  #ifndef __ASSEMBLY__
> -
>  #include <asm/x86_init.h>
>  
> +void walk_pgd_level(struct seq_file *m, pgd_t *pgd);
> +
>  /*
>   * ZERO_PAGE is a global shared page that is always zero: used
>   * for zero-mapped memory areas etc..
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
> index 0002a3a33081..f987ecff9226 100644
> --- a/arch/x86/mm/dump_pagetables.c
> +++ b/arch/x86/mm/dump_pagetables.c
> @@ -19,6 +19,8 @@
>  
>  #include <asm/pgtable.h>
>  
> +static bool dump_to_dmesg;
> +
>  /*
>   * The dumper groups pagetable entries of the same type into one, and for
>   * that it needs to keep some state when walking, and flush this state
> @@ -88,6 +90,24 @@ static struct addr_marker address_markers[] = {
>  #define PUD_LEVEL_MULT (PTRS_PER_PMD * PMD_LEVEL_MULT)
>  #define PGD_LEVEL_MULT (PTRS_PER_PUD * PUD_LEVEL_MULT)
>  
> +#define pt_dump_seq_printf(m, fmt, args...)			\
> +({								\
> +	if (dump_to_dmesg)					\
> +		printk(KERN_INFO fmt, ##args);			\

pr_info? This is for debug purpose, maybe pr_debug is better?
Ditto to other printk callbacks.

> +	else							\
> +		if (m)						\
> +			seq_printf(m, fmt, ##args);		\
> +})
> +
> +#define pt_dump_cont_printf(m, fmt, args...)			\
> +({								\
> +	if (dump_to_dmesg)					\
> +		printk(KERN_CONT fmt, ##args);			\
> +	else							\
> +		if (m)						\
> +			seq_printf(m, fmt, ##args);		\
> +})
> +
>  /*
>   * Print a readable form of a pgprot_t to the seq_file
>   */
> @@ -99,47 +119,47 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
>  
>  	if (!pgprot_val(prot)) {
>  		/* Not present */
> -		seq_printf(m, "                          ");
> +		pt_dump_cont_printf(m, "                          ");
>  	} else {
>  		if (pr & _PAGE_USER)
> -			seq_printf(m, "USR ");
> +			pt_dump_cont_printf(m, "USR ");
>  		else
> -			seq_printf(m, "    ");
> +			pt_dump_cont_printf(m, "    ");
>  		if (pr & _PAGE_RW)
> -			seq_printf(m, "RW ");
> +			pt_dump_cont_printf(m, "RW ");
>  		else
> -			seq_printf(m, "ro ");
> +			pt_dump_cont_printf(m, "ro ");
>  		if (pr & _PAGE_PWT)
> -			seq_printf(m, "PWT ");
> +			pt_dump_cont_printf(m, "PWT ");
>  		else
> -			seq_printf(m, "    ");
> +			pt_dump_cont_printf(m, "    ");
>  		if (pr & _PAGE_PCD)
> -			seq_printf(m, "PCD ");
> +			pt_dump_cont_printf(m, "PCD ");
>  		else
> -			seq_printf(m, "    ");
> +			pt_dump_cont_printf(m, "    ");
>  
>  		/* Bit 9 has a different meaning on level 3 vs 4 */
>  		if (level <= 3) {
>  			if (pr & _PAGE_PSE)
> -				seq_printf(m, "PSE ");
> +				pt_dump_cont_printf(m, "PSE ");
>  			else
> -				seq_printf(m, "    ");
> +				pt_dump_cont_printf(m, "    ");
>  		} else {
>  			if (pr & _PAGE_PAT)
> -				seq_printf(m, "pat ");
> +				pt_dump_cont_printf(m, "pat ");
>  			else
> -				seq_printf(m, "    ");
> +				pt_dump_cont_printf(m, "    ");
>  		}
>  		if (pr & _PAGE_GLOBAL)
> -			seq_printf(m, "GLB ");
> +			pt_dump_cont_printf(m, "GLB ");
>  		else
> -			seq_printf(m, "    ");
> +			pt_dump_cont_printf(m, "    ");
>  		if (pr & _PAGE_NX)
> -			seq_printf(m, "NX ");
> +			pt_dump_cont_printf(m, "NX ");
>  		else
> -			seq_printf(m, "x  ");
> +			pt_dump_cont_printf(m, "x  ");
>  	}
> -	seq_printf(m, "%s\n", level_name[level]);
> +	pt_dump_cont_printf(m, "%s\n", level_name[level]);
>  }
>  
>  /*
> @@ -178,7 +198,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
>  		st->current_prot = new_prot;
>  		st->level = level;
>  		st->marker = address_markers;
> -		seq_printf(m, "---[ %s ]---\n", st->marker->name);
> +		pt_dump_seq_printf(m, "---[ %s ]---\n", st->marker->name);
>  	} else if (prot != cur || level != st->level ||
>  		   st->current_address >= st->marker[1].start_address) {
>  		const char *unit = units;
> @@ -188,16 +208,16 @@ static void note_page(struct seq_file *m, struct pg_state *st,
>  		/*
>  		 * Now print the actual finished series
>  		 */
> -		seq_printf(m, "0x%0*lx-0x%0*lx   ",
> -			   width, st->start_address,
> -			   width, st->current_address);
> +		pt_dump_seq_printf(m, "0x%0*lx-0x%0*lx   ",
> +				   width, st->start_address,
> +				   width, st->current_address);
>  
>  		delta = (st->current_address - st->start_address) >> 10;
>  		while (!(delta & 1023) && unit[1]) {
>  			delta >>= 10;
>  			unit++;
>  		}
> -		seq_printf(m, "%9lu%c ", delta, *unit);
> +		pt_dump_cont_printf(m, "%9lu%c ", delta, *unit);
>  		printk_prot(m, st->current_prot, st->level);
>  
>  		/*
> @@ -207,7 +227,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
>  		 */
>  		if (st->current_address >= st->marker[1].start_address) {
>  			st->marker++;
> -			seq_printf(m, "---[ %s ]---\n", st->marker->name);
> +			pt_dump_seq_printf(m, "---[ %s ]---\n", st->marker->name);
>  		}
>  
>  		st->start_address = st->current_address;
> @@ -296,7 +316,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
>  #define pgd_none(a)  pud_none(__pud(pgd_val(a)))
>  #endif
>  
> -static void walk_pgd_level(struct seq_file *m)
> +void walk_pgd_level(struct seq_file *m, pgd_t *pgd)

How about do not limit to only if (pgd) case, instead do something like below:
set dump_to_dmesg as a module parameter, so user can enable it via kernel cmdline
or set it while insmod.

>  {
>  #ifdef CONFIG_X86_64
>  	pgd_t *start = (pgd_t *) &init_level4_pgt;
> @@ -306,6 +326,11 @@ static void walk_pgd_level(struct seq_file *m)
>  	int i;
>  	struct pg_state st;
>  
> +	if (pgd) {
> +		start = pgd;
> +		dump_to_dmesg = true;
> +	}
> +
>  	memset(&st, 0, sizeof(st));
>  
>  	for (i = 0; i < PTRS_PER_PGD; i++) {
> @@ -331,7 +356,7 @@ static void walk_pgd_level(struct seq_file *m)
>  
>  static int ptdump_show(struct seq_file *m, void *v)
>  {
> -	walk_pgd_level(m);
> +	walk_pgd_level(m, NULL);
>  	return 0;
>  }
>  
> -- 
> 1.8.5.2.192.g7794a68
> 
