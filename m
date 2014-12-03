Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaLCJkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:40:10 -0500
Received: from bes.se.axis.com ([195.60.68.10]:54458 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaLCJcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:32:03 -0500
Message-ID: <1417599104.10996.16.camel@lnxlarper.se.axis.com>
Subject: Re: [PATCH] Revert "MIPS: Remove race window in page fault handling"
From: Lars Persson <lars.persson@axis.com>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paul.burton@imgtec.com" <paul.burton@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "manuel.lauss@gmail.com" <manuel.lauss@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "markos.chandras@imgtec.com" <markos.chandras@imgtec.com>
Date: Wed, 3 Dec 2014 10:31:44 +0100
In-Reply-To: <20141203032542.15388.17340.stgit@linux-yegoshin>
References: <20141203032542.15388.17340.stgit@linux-yegoshin>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leonid

First let me describe the mechanism of this race condition, which was a
fault in the kernel's MIPS architecture code. Specifically in its
implementation of lazy dcache flushing. AFAIK, it would only hit on
systems where the pagein code path writes to the page from the CPU.

The order of calls is:
flush_dcache_page() (from the FS's readpage)
set_pte_at()
update_mmu_cache()

The thread number one has executed the set_pte_at() when thread number
two hits the same page. It finds a valid PTE and proceeds to execute
code from a page that is not yet flushed to the point of I/D coherency.
That flush would happen in update_mmu_cache().

My patch does increase number of cache flushes for CoW yes and there
could be an optimization opportunity by playing tricks with the pte_t to
include information about executability of the mapping. 

Reverting the patch is a big no-no, then we go back to a state of
undefined CPU behavior.

- Lars


On Wed, 2014-12-03 at 04:25 +0100, Leonid Yegoshin wrote:
> This reverts commit 64f23ab30b1fec86b91a48bf1f088840e5299971
> (commit 2a4a8b1e5d9d343e13ff22e19af7b353f7b52d6f in Linux 'master')
> 
> Unfortunately the original commit effectively kills Imagination MIPS CPUs
> performance because it enforces page cache flush each time then PTE is changed
> for our CPUs. Basically - each CoW, each process start, each library attachment
> or detachment. And it happens even in "fully-coherent" systems (in MIPS sense -
> we have non coherent I-cache). Last tendency for increasing page size to 16K-64K
> even exaggerate the performance loss.
> 
> Original commit discussion says:
> 
>     Kernel call stacks showed one thread handling an illegal instruction
>     exception while another thread was somewhere around the
>     set_pte_at/update_mmu_cache calls for the same page.
> 
> If this is taken correct then it points to a major problem unrelated to MIPS -
> if by chance a first thread hits the page just before set_pte_at then it should
> get a non-present PTE: set_pte_at with _PAGE_PRESENT/_PAGE_VALID flags can be
> used only on "disactivated" PTE, after pte_clear* functions, effectively -
> non-present, non-valid. And application can get SIGSEGV. It is a major race
> condition and kernel should not offer it to applications. And in my
> understanding set_pte_at is used in cases then page is available after kernel
> finishes page handling, at least in theory.
> 
> Test note: I ran MIPS 1004K with 8 VPEs on 4 cores around 1.5 month on SOAK test
> and never seen that problem on 3.10 kernel.
> 
> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
>  
> 



