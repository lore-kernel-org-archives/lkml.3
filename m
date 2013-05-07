Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab3EGE0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:26:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab3EGE0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:26:02 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=8-CMYm9u0m0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=F-_l9sjweG4A:10 a=5gWr373iAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=bV27znWfk4DAUmVXYEwA:9 a=cpbqSep1WiAA:10 a=jEp0ucaQiEUA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035850.597840180@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Josh Boyer <jwboyer@redhat.com>,
        Samu Kallio <samu.kallio@aberdeencloud.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [058/126] x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0058-x86-mm-paravirt-Fix-vmalloc_fault-oops-during-lazy-M.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Samu Kallio <samu.kallio@aberdeencloud.com>

[ Upstream commit 1160c2779b826c6f5c08e5cc542de58fd1f667d5 ]

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

Cc: <stable@vger.kernel.org>
RedHat-Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=914737
Tested-by: Josh Boyer <jwboyer@redhat.com>
Reported-and-Tested-by: Krishna Raman <kraman@redhat.com>
Signed-off-by: Samu Kallio <samu.kallio@aberdeencloud.com>
Link: http://lkml.kernel.org/r/1364045796-10720-1-git-send-email-konrad.wilk@oracle.com
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/mm/fault.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 76dcd9d..3e6b840 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -377,10 +377,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
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
1.7.10.4


