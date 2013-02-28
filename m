Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3B1O3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:29:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42032 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3B1O3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:29:32 -0500
Date: Thu, 28 Feb 2013 09:29:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was: Re:
 [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Message-ID: <20130228142910.GA32354@phenom.dumpdata.com>
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
 <512E8B41.8000504@zytor.com>
 <20130227230009.GA32465@kroah.com>
 <512E91B7.6060102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E91B7.6060102@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 03:07:35PM -0800, H. Peter Anvin wrote:
> On 02/27/2013 03:00 PM, Greg KH wrote:
> > 
> > "Stable" kernels are used all over the place, like in distros, which
> > might enable this.
> > 
> > I have no objection to taking this patch in a stable release, as it does
> > fix a real problem.
> > 
> 
> OK.  I will queue it up in the next fixes (tip:x86/urgent) batch to Linus.

Thank you.

Could you also consider this one (I CC-ed Ingo on it but never got any
response):


>From a6ed4a88eff4f6329bb4acae3372cccc8a8367d5 Mon Sep 17 00:00:00 2001
From: Samu Kallio <samu.kallio@aberdeencloud.com>
Date: Sun, 17 Feb 2013 02:35:52 +0000
Subject: [PATCH] x86: mm: Fix vmalloc_fault oops during lazy MMU updates.

In paravirtualized x86_64 kernels, vmalloc_fault may cause an oops
when lazy MMU updates are enabled, because set_pgd effects are being
deferred.

One instance of this problem is during process mm cleanup with memory
cgroups enabled. The chain of events is as follows:

- zap_pte_range enables lazy MMU updates
- zap_pte_range eventually calls mem_cgroup_charge_statistics,
  which accesses the vmalloc'd mem_cgroup per-cpu stat area
- vmalloc_fault is triggered which tries to sync the corresponding
  PGD entry with set_pgd, but the update is deferred
- vmalloc_fault oopses due to a mismatch in the PUD entries

The OOPs usually looks as so:

------------[ cut here ]------------
kernel BUG at arch/x86/mm/fault.c:396!
invalid opcode: 0000 [#1] SMP
.. snip ..
CPU 1
Pid: 10866, comm: httpd Not tainted 3.6.10-4.fc18.x86_64 #1
RIP: e030:[<ffffffff816271bf>]  [<ffffffff816271bf>] vmalloc_fault+0x11f/0x208
.. snip ..
Call Trace:
 [<ffffffff81627759>] do_page_fault+0x399/0x4b0
 [<ffffffff81004f4c>] ? xen_mc_extend_args+0xec/0x110
 [<ffffffff81624065>] page_fault+0x25/0x30
 [<ffffffff81184d03>] ? mem_cgroup_charge_statistics.isra.13+0x13/0x50
 [<ffffffff81186f78>] __mem_cgroup_uncharge_common+0xd8/0x350
 [<ffffffff8118aac7>] mem_cgroup_uncharge_page+0x57/0x60
 [<ffffffff8115fbc0>] page_remove_rmap+0xe0/0x150
 [<ffffffff8115311a>] ? vm_normal_page+0x1a/0x80
 [<ffffffff81153e61>] unmap_single_vma+0x531/0x870
 [<ffffffff81154962>] unmap_vmas+0x52/0xa0
 [<ffffffff81007442>] ? pte_mfn_to_pfn+0x72/0x100
 [<ffffffff8115c8f8>] exit_mmap+0x98/0x170
 [<ffffffff810050d9>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
 [<ffffffff81059ce3>] mmput+0x83/0xf0
 [<ffffffff810624c4>] exit_mm+0x104/0x130
 [<ffffffff8106264a>] do_exit+0x15a/0x8c0
 [<ffffffff810630ff>] do_group_exit+0x3f/0xa0
 [<ffffffff81063177>] sys_exit_group+0x17/0x20
 [<ffffffff8162bae9>] system_call_fastpath+0x16/0x1b

Calling arch_flush_lazy_mmu_mode immediately after set_pgd makes the
changes visible to the consistency checks.

RedHat-Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=914737
Reported-and-Tested-by: Krishna Raman <kraman@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Samu Kallio <samu.kallio@aberdeencloud.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/fault.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fb674fd..4f7d793 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -378,10 +378,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (pgd_none(*pgd_ref))
 		return -1;
 
-	if (pgd_none(*pgd))
+	if (pgd_none(*pgd)) {
 		set_pgd(pgd, *pgd_ref);
-	else
+		arch_flush_lazy_mmu_mode();
+	} else {
 		BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
+	}
 
 	/*
 	 * Below here mismatches are bugs because these lower tables
-- 
1.8.0.2

> 
> 	-hpa
> 
> 
