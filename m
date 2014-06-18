Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966502AbaFRMiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:38:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:41255 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966138AbaFRMiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:38:08 -0400
X-IronPort-AV: E=Sophos;i="5.01,499,1400025600"; 
   d="scan'208";a="144571699"
Message-ID: <53A1882D.5030201@citrix.com>
Date: Wed, 18 Jun 2014 13:38:05 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCHv2] x86: skip check for spurious faults for non-present
 faults
References: <1400251458-14891-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1400251458-14891-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Someone else asking about what _PAGE_IOMAP was for reminded me that this
was still outstanding.  Could you review and ack if appropriate?

Thanks.

David

On 16/05/14 15:44, David Vrabel wrote:
> If a fault on a kernel address is due to a non-present page, then it
> cannot be the result of stale TLB entry from a protection change (RO
> to RW or NX to X).  Thus the pagetable walk in spurious_fault() can be
> skipped.
> 
> See the initial if in spurious_fault() and the tests in
> spurious_fault_check()) for the set of possible error codes checked
> for spurious faults.  These are:
> 
>          IRUWP
> Before   x00xx && ( 1xxxx || xxx1x )
> After  ( 10001 || 00011 ) && ( 1xxxx || xxx1x )
> 
> Thus the new condition is a subset of the previous one, excluding only
> non-present faults (I == 1 and W == 1 are mutually exclusive).
> 
> This avoids spurious_fault() oopsing in some cases if the pagetables
> it attempts to walk are not accessible.  This obscures the location of
> the original fault.
> 
> This also fixes a crash with Xen PV guests when they access entries in
> the M2P corresponding to device MMIO regions.  The M2P is mapped
> (read-only) by Xen into the kernel address space of the guest and this
> mapping may contains holes for non-RAM regions.  Read faults will
> result in calls to spurious_fault(), but because the page tables for
> the M2P mappings are not accessible by the guest the pagetable walk
> would fault.
> 
> This was not normally a problem as MMIO mappings would not normally
> result in a M2P lookup because of the use of the _PAGE_IOMAP bit the
> PTE.  However, removing the _PAGE_IOMAP bit requires M2P lookups for
> MMIO mappings as well.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> ---
> x86 maintainers, this is a prerequisite for removing Xen's usage of
> _PAGE_IOMAP so I think this is best merged via the Xen tree.
> 
> v2:
> - improve comments
> ---
>  arch/x86/mm/fault.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 8e57229..7f790e4 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -924,8 +924,17 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
>   * cross-processor TLB flush, even if no stale TLB entries exist
>   * on other processors.
>   *
> + * Spurious faults may only occur if the TLB contains an entry with
> + * fewer permission than the page table entry.  Non-present (P = 0)
> + * and reserved bit (R = 1) faults are never spurious.
> + *
>   * There are no security implications to leaving a stale TLB when
>   * increasing the permissions on a page.
> + *
> + * Returns non-zero if a spurious fault was handled, zero otherwise.
> + *
> + * See Intel Developer's Manual Vol 3 Section 4.10.4.3, bullet 3
> + * (Optional Invalidation).
>   */
>  static noinline __kprobes int
>  spurious_fault(unsigned long error_code, unsigned long address)
> @@ -936,8 +945,17 @@ spurious_fault(unsigned long error_code, unsigned long address)
>  	pte_t *pte;
>  	int ret;
>  
> -	/* Reserved-bit violation or user access to kernel space? */
> -	if (error_code & (PF_USER | PF_RSVD))
> +	/*
> +	 * Only writes to RO or instruction fetches from NX may cause
> +	 * spurious faults.
> +	 *
> +	 * These could be from user or supervisor accesses but the TLB
> +	 * is only lazily flushed after a kernel mapping protection
> +	 * change, so user accesses are not expected to cause spurious
> +	 * faults.
> +	 */
> +	if (error_code != (PF_WRITE | PF_PROT)
> +	    && error_code != (PF_INSTR | PF_PROT))
>  		return 0;
>  
>  	pgd = init_mm.pgd + pgd_index(address);
> 

