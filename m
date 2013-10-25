Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3JYXje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:39:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20556 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab3JYXjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:39:33 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <526AF79A.3050002@cantab.net>
References: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com> <526AF79A.3050002@cantab.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCH v1] Set 1-1 P2M for PCI BARs and MCFG regions - if needed.
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 25 Oct 2013 19:39:05 -0400
To: David Vrabel <dvrabel@cantab.net>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Santosh.Jodh@citrix.com, JBeulich@suse.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, mukesh.rathor@oracle.com,
        xhejtman@ics.muni.cz, yuval.shaia@oracle.com
Message-ID: <f7db4ef1-fb0e-4811-bd4b-fce2a13ea3f4@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <dvrabel@cantab.net> wrote:
>On 25/10/13 16:03, Konrad Rzeszutek Wilk wrote:
>>
>>   2). Assume that INVALID_P2M_ENTRY is considered 1-1. That would
>require
>>      auditing of the code and also making sure that any
>xen_privcmd_mmap
>>      calls use the m2p_add_override.
>
>I'm not sure I understand the concern about the privcmd driver's
>foreign 
>mapping ioctls (MMAPBATCH_V2 and friends) as these all deal with MFNs 
>directly and don't use the p2m.
>
>>      However there are some
>>      valid cases in which we need to check for INVALID_P2M_ENTRY -
>>      balloon driver - that might be relaxed.
>
>Yes.  And this behaviour will be retained.   I think we only need to do
>
>the INVALID_P2M_ENTRY => 1:1 when constructing PTEs so all other
>callers 
>will see INVALID_P2M_ENTRY as before.

You are suggesting not touching the p2m code and instead change the the xen-make-pte to assume that INVALID and IDENTITY should have the same behaviour. Interesting.
>
>
>>      However again the P2M code
>>      and the ABI it places are not for the faint of the heart.
>
>I have no fear.

:-)
>
>If the above suggestion does work out it will reduce the amount of p2m 
>code /and/ remove a Xen-specific PTE bit.  So I think it is worth
>pursuing.
>
>In the meantime, the following minimal patch is a likely workaround.
>
>David
>
>8<-------------------------------
>x86/mm: set _PAGE_IOMAP in io_remap_pfn_range().
>
>Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>---
>  arch/x86/include/asm/pgtable.h |    3 +++
>  1 file changed, 3 insertions(+)
>
>diff --git a/arch/x86/include/asm/pgtable.h
>b/arch/x86/include/asm/pgtable.h
>index 3d19994..d59b22a 100644
>--- a/arch/x86/include/asm/pgtable.h
>+++ b/arch/x86/include/asm/pgtable.h
>@@ -868,6 +868,9 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t
>pte)
>  	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
>  }
>
>+#define io_remap_pfn_range(vma, addr, pfn, size, prot) \
>+  remap_pfn_range(vma, addr, pfn, size, (prot) | _PAGE_IOMAP)
>+
>  #include <asm-generic/pgtable.h>
>  #endif	/* __ASSEMBLY__ */

You are welcome to suggest it to hpa. Last time a  similar patch was proposed he was not too thrilled about it.

Looking forward to your p2m code surgery!
