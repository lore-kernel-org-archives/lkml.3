Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaAVFEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:04:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45289 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaAVFED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:04:03 -0500
Date: Wed, 22 Jan 2014 00:02:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Noonan <steven@uplinklabs.net>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        george.dunlap@eu.citrix.com, dario.faggioli@citrix.com,
        Elena Ufimtseva <ufimtseva@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
Message-ID: <20140122050215.GC9931@konrad-lan.dumpdata.com>
References: <20140121232708.GA29787@amazon.com>
 <20140122014908.GG18164@kroah.com>
 <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
 <20140122032045.GA22182@falcon.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122032045.GA22182@falcon.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 07:20:45PM -0800, Steven Noonan wrote:
> On Tue, Jan 21, 2014 at 06:47:07PM -0800, Linus Torvalds wrote:
> > On Tue, Jan 21, 2014 at 5:49 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:

Adding extra folks to the party.
> > >
> > > Odds are this also shows up in 3.13, right?
> 
> Reproduced using 3.13 on the PV guest:
> 
> 	[  368.756763] BUG: Bad page map in process mp  pte:80000004a67c6165 pmd:e9b706067
> 	[  368.756777] page:ffffea001299f180 count:0 mapcount:-1 mapping:          (null) index:0x0
> 	[  368.756781] page flags: 0x2fffff80000014(referenced|dirty)
> 	[  368.756786] addr:00007fd1388b7000 vm_flags:00100071 anon_vma:ffff880e9ba15f80 mapping:          (null) index:7fd1388b7
> 	[  368.756792] CPU: 29 PID: 618 Comm: mp Not tainted 3.13.0-ec2 #1
> 	[  368.756795]  ffff880e9b718958 ffff880e9eaf3cc0 ffffffff814d8748 00007fd1388b7000
> 	[  368.756803]  ffff880e9eaf3d08 ffffffff8116d289 0000000000000000 0000000000000000
> 	[  368.756809]  ffff880e9b7065b8 ffffea001299f180 00007fd1388b8000 ffff880e9eaf3e30
> 	[  368.756815] Call Trace:
> 	[  368.756825]  [<ffffffff814d8748>] dump_stack+0x45/0x56
> 	[  368.756833]  [<ffffffff8116d289>] print_bad_pte+0x229/0x250
> 	[  368.756837]  [<ffffffff8116eae3>] unmap_single_vma+0x583/0x890
> 	[  368.756842]  [<ffffffff8116feb5>] unmap_vmas+0x65/0x90
> 	[  368.756847]  [<ffffffff81175dac>] unmap_region+0xac/0x120
> 	[  368.756852]  [<ffffffff81176379>] ? vma_rb_erase+0x1c9/0x210
> 	[  368.756856]  [<ffffffff81177f10>] do_munmap+0x280/0x370
> 	[  368.756860]  [<ffffffff81178041>] vm_munmap+0x41/0x60
> 	[  368.756864]  [<ffffffff81178f32>] SyS_munmap+0x22/0x30
> 	[  368.756869]  [<ffffffff814e70ed>] system_call_fastpath+0x1a/0x1f
> 	[  368.756872] Disabling lock debugging due to kernel taint
> 	[  368.760084] BUG: Bad rss-counter state mm:ffff880e9d079680 idx:0 val:-1
> 	[  368.760091] BUG: Bad rss-counter state mm:ffff880e9d079680 idx:1 val:1
> 
> > 
> > Probably. I don't have a Xen PV setup to test with (and very little
> > interest in setting one up).. And I have a suspicion that it might not
> > be so much about Xen PV, as perhaps about the kind of hardware.
> > 
> > I suspect the issue has something to do with the magic _PAGE_NUMA
> > tie-in with _PAGE_PRESENT. And then mprotect(PROT_NONE) ends up
> > removing the _PAGE_PRESENT bit, and now the crazy numa code is
> > confused.
> > 
> > The whole _PAGE_NUMA thing is a f*cking horrible hack, and shares the
> > bit with _PAGE_PROTNONE, which is why it then has that tie-in to
> > _PAGE_PRESENT.
> > 
> > Adding Andrea to the Cc, because he's the author of that horridness.
> > Putting Steven's test-case here as an attachement for Andrea, maybe
> > that makes him go "Ahh, yes, silly case".
> > 
> > Also added Kirill, because he was involved the last _PAGE_NUMA debacle.
> > 
> > Andrea, you can find the thread on lkml, but it boils down to commit
> > 1667918b6483 (backported to 3.12.7 as 3d792d616ba4) breaking the
> > attached test-case (but apparently only under Xen PV). There it
> > apparently causes a "BUG: Bad page map .." error.

I *think* it is due to the fact that pmd_numa and pte_numa is getting the _raw_
value of PMDs and PTEs. That is - it does not use the pvops interface
and instead reads the values directly from the page-table. Since the
page-table is also manipulated by the hypervisor - there are certain
flags it also sets to do its business. It might be that it uses
_PAGE_GLOBAL as well - and Linux picks up on that. If it was using
pte_flags that would invoke the pvops interface.

Elena, Dariof and George, you guys had been looking at this a bit deeper
than I have. Does the Xen hypervisor use the _PAGE_GLOBAL for PV guests?

This not-compiled-totally-bad-patch might shed some light on what I was
thinking _could_ fix this issue - and IS NOT A FIX - JUST A HACK.
It does not fix it for PMDs naturally (as there are no PMD paravirt ops
for that).

The other question is - how is AutoNUMA running when it is not enabled?
Shouldn't those _PAGE_NUMA ops be nops when AutoNUMA hasn't even been
turned on?


diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ce563be..9fa7088 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -370,12 +370,15 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
 		unsigned long pfn = mfn_to_pfn(mfn);
 
 		pteval_t flags = val & PTE_FLAGS_MASK;
+		/* No AutoNUMA for PV. TODO If Linux sees the PTE having
+		 * said bit, just igore it. */
+		if (flags & _PAGE_NUMA)
+			flags = flags & ~_PAGE_NUMA;
 		if (unlikely(pfn == ~0))
 			val = flags & ~_PAGE_PRESENT;
 		else
 			val = ((pteval_t)pfn << PAGE_SHIFT) | flags;
 	}
-
 	return val;
 }
 
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index db09234..a8bc07d 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -644,7 +644,7 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
 #ifndef pte_numa
 static inline int pte_numa(pte_t pte)
 {
-	return (pte_flags(pte) &
+	return (pte_val(pte) &
 		(_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
 }
 #endif
