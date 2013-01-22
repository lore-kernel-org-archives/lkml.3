Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3AVHqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:46:13 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40548 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3AVHqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:46:07 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v5 40/45] sh: Use get/put_online_cpus_atomic() to prevent CPU
 offline
To: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org
Cc: rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2013 13:14:13 +0530
Message-ID: <20130122074409.13822.91528.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012207-8256-0000-0000-000005EE5B8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able to
depend on preempt_disable() or local_irq_disable() to prevent CPUs from
going offline from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
while invoking from atomic context.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/sh/kernel/smp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 2062aa8..232fabe 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -357,7 +357,7 @@ static void flush_tlb_mm_ipi(void *mm)
  */
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	preempt_disable();
+	get_online_cpus_atomic();
 
 	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
 		smp_call_function(flush_tlb_mm_ipi, (void *)mm, 1);
@@ -369,7 +369,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	}
 	local_flush_tlb_mm(mm);
 
-	preempt_enable();
+	put_online_cpus_atomic();
 }
 
 struct flush_tlb_data {
@@ -390,7 +390,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	preempt_disable();
+	get_online_cpus_atomic();
 	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
 		struct flush_tlb_data fd;
 
@@ -405,7 +405,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 				cpu_context(i, mm) = 0;
 	}
 	local_flush_tlb_range(vma, start, end);
-	preempt_enable();
+	put_online_cpus_atomic();
 }
 
 static void flush_tlb_kernel_range_ipi(void *info)
@@ -433,7 +433,7 @@ static void flush_tlb_page_ipi(void *info)
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 {
-	preempt_disable();
+	get_online_cpus_atomic();
 	if ((atomic_read(&vma->vm_mm->mm_users) != 1) ||
 	    (current->mm != vma->vm_mm)) {
 		struct flush_tlb_data fd;
@@ -448,7 +448,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 				cpu_context(i, vma->vm_mm) = 0;
 	}
 	local_flush_tlb_page(vma, page);
-	preempt_enable();
+	put_online_cpus_atomic();
 }
 
 static void flush_tlb_one_ipi(void *info)

