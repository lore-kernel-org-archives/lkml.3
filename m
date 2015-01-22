Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbbAVR1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:27:39 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:50789 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbbAVR1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:27:36 -0500
Date: Thu, 22 Jan 2015 19:27:16 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Guenter Roeck <linux@roeck-us.net>, davem@davemloft.net
Cc: Mel Gorman <mgorman@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 20 -- sparc32: fix broken set_pte()
Message-ID: <20150122172716.GA1194@node.dhcp.inet.fi>
References: <20150120185308.53f4af4e@canb.auug.org.au>
 <20150120202642.GA6178@roeck-us.net>
 <20150120225443.GA19629@node.dhcp.inet.fi>
 <54BF1785.7040300@roeck-us.net>
 <20150121104325.GA22449@node.dhcp.inet.fi>
 <54C06B19.8060305@roeck-us.net>
 <20150122171338.GA1039@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122171338.GA1039@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 07:13:38PM +0200, Kirill A. Shutemov wrote:
> On Wed, Jan 21, 2015 at 07:14:33PM -0800, Guenter Roeck wrote:
> > On 01/21/2015 02:43 AM, Kirill A. Shutemov wrote:
> > 
> > >>BUG: Bad page state in process init.sh  pfn:00000
> > >>page:f05e7460 count:0 mapcount:-1 mapping:  (null) index:0x0
> > >>flags: 0x400(reserved)
> > >>page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> > >>bad because of flags:
> > >>flags: 0x400(reserved)
> > >>CPU: 0 PID: 1 Comm: init.sh Not tainted 3.19.0-rc5-next-20150120 #1
> > >>[f0076010 : bad_page+0xdc/0xfc ] [f00760c0 : free_pages_prepare+0x90/0x1f8 ] [f00775cc : free_hot_cold_page+0x20/0x160 ] [f00919e8 : do_wp_page+0x680/0x6ac ] [f00939f4 : handle_mm_fault+0xc94/0xd08 ] [f0015900 : do_sparc_fault+0xfc/0x3ec ] [f000af90 : srmmu_fault+0x58/0x68 ] [f00e74f4 : load_elf_binary+0x9a8/0xe94 ] [f00b0cac : search_binary_handler+0x68/0x12c ] [f00e67d0 : load_script+0x214/0x224 ] [f00b0cac : search_binary_handler+0x68/0x12c ] [f00b11a4 : do_execveat_common+0x434/0x584 ] [f00b1310 : do_execve+0x1c/0x2c ] [f02b50b0 : kernel_init+0x70/0xf0 ] [f000b200 : ret_from_kernel_thread+0xc/0x38 ] [00000000 :   (null) ]
> > >>Disabling lock debugging due to kernel taint
> > >>: applet not found
> > >>Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000100
> > >
> > >It doesn't make much sense to me. It tries to free page with pfn==0 on
> > >handling wp-fault. How it got mapped in the first place?
> > >
> > If I comment out the added call to vm_normal_page(), the code works fine.
> > If the call to vm_local_page() is there but everything else from your patch
> > is commented out, the crash occurs. Also, any log message added to the new
> > code patch (inside the if statements) is not getting printed, meaning the
> > new code (besides the call to vm_local_page) is not reached.
> > 
> > I guess that means that something in the call to vm_normal_page() appears
> > to go wrong. No idea what that might be, though.
> 
> vm_normal_page() is never called in this case, since prot_numa is always
> zero.
> 
> I tracked the bug down. It's a sparc bug. The commit only triggers it,
> because affect how GCC optimize the code around faulty point.
> 
> Please, test.

+CC: Andrew, Sam, sparclinux@

> 
> From 5b9232753217412116a4cdc2897be0db818371ca Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Thu, 22 Jan 2015 18:42:13 +0200
> Subject: [PATCH] sparc32: fix broken set_pte()
> 
> 32-bit sparc uses swap instruction to implement set_pte(). It called
> using GCC inline assembler. But it misses the "memory" clobber to
> indicate that pte value will be updated in memory.
> 
> As result GCC doesn't know that it cannot postpone pte pointer
> dereference which occurs before set_pte() to post-set_pte() time.
> 
> It leads to real-world bugs -- [1]. In this situation we have code:
> 
> 	ptent = ptep_modify_prot_start(mm, addr, pte);
> 	ptent = pte_modify(ptent, newprot);
> 	...
> 	ptep_modify_prot_commit(mm, addr, pte, ptent);
> 
> ptep_modify_prot_start() in sparc case is just 'pte' dereference plus
> pte_clear(). pte_clear() calls broken set_pte(). GCC thinks it's valid
> to dereference 'pte' again on pte_modify() and gets cleared pte.
> ptep_modify_prot_commit() puts 'pteent' with pfn==0 back to page table,
> which eventually leads to the crash.
> 
> [1] http://lkml.kernel.org/r/54C06B19.8060305@roeck-us.net
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/sparc/include/asm/pgtable_32.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
> index b2f7dc46a7d1..9912eb0b499a 100644
> --- a/arch/sparc/include/asm/pgtable_32.h
> +++ b/arch/sparc/include/asm/pgtable_32.h
> @@ -102,7 +102,8 @@ extern unsigned long empty_zero_page;
>   */
>  static inline unsigned long srmmu_swap(unsigned long *addr, unsigned long value)
>  {
> -	__asm__ __volatile__("swap [%2], %0" : "=&r" (value) : "0" (value), "r" (addr));
> +	__asm__ __volatile__("swap [%2], %0" :
> +			"=&r" (value) : "0" (value), "r" (addr) : "memory");
>  	return value;
>  }
>  
> -- 
>  Kirill A. Shutemov
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
