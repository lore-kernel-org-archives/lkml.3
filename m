Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936776Ab3DKA3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:29:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934952Ab3DKA3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:29:44 -0400
Date: Wed, 10 Apr 2013 17:29:20 -0700
From: tip-bot for Samu Kallio <tipbot@zytor.com>
Message-ID: <tip-1160c2779b826c6f5c08e5cc542de58fd1f667d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, samu.kallio@aberdeencloud.com,
        stable@vger.kernel.org, jwboyer@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, kraman@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, samu.kallio@aberdeencloud.com,
        stable@vger.kernel.org, jwboyer@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, kraman@redhat.com
In-Reply-To: <1364045796-10720-1-git-send-email-konrad.wilk@oracle.com>
References: <1364045796-10720-1-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mm, paravirt:
  Fix vmalloc_fault oops during lazy MMU updates
Git-Commit-ID: 1160c2779b826c6f5c08e5cc542de58fd1f667d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 17:29:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1160c2779b826c6f5c08e5cc542de58fd1f667d5
Gitweb:     http://git.kernel.org/tip/1160c2779b826c6f5c08e5cc542de58fd1f667d5
Author:     Samu Kallio <samu.kallio@aberdeencloud.com>
AuthorDate: Sat, 23 Mar 2013 09:36:35 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 10 Apr 2013 11:25:07 -0700

x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

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
---
 arch/x86/mm/fault.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 2b97525..0e88336 100644
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
