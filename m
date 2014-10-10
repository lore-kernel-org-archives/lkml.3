Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaJJX0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:26:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:14043 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaJJXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:25:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="612737919"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] x86: Use the page tables to look up kernel addresses in backtrace
Date: Fri, 10 Oct 2014 16:25:17 -0700
Message-Id: <1412983517-12419-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
References: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On my workstation which has a lot of modules loaded:

$ lsmod | wc -l
80

backtrace from the NMI for perf record -g can take a quite long time.

This leads to frequent messages like:
perf interrupt took too long (7852 > 7812), lowering kernel.perf_event_max_sample_rate to 16000

One larger part of the PMI cost is each text address check during
the backtrace taking upto to 3us, like this:

  1)               |          print_context_stack_bp() {
  1)               |            __kernel_text_address() {
  1)               |              is_module_text_address() {
  1)               |                __module_text_address() {
  1)   1.611 us    |                  __module_address();
  1)   1.939 us    |                }
  1)   2.296 us    |              }
  1)   2.659 us    |            }
  1)               |            __kernel_text_address() {
  1)               |              is_module_text_address() {
  1)               |                __module_text_address() {
  1)   0.724 us    |                  __module_address();
  1)   1.064 us    |                }
  1)   1.430 us    |              }
  1)   1.798 us    |            }
  1)               |            __kernel_text_address() {
  1)               |              is_module_text_address() {
  1)               |                __module_text_address() {
  1)   0.656 us    |                  __module_address();
  1)   1.012 us    |                }
  1)   1.356 us    |              }
  1)   1.761 us    |            }

So just with a reasonably sized backtrace easily 10-20us can be spent
on just checking the frame pointer IPs.

So essentially currently the module lookup is N-MODULES*M-length of backtrace

This patch uses the NX bits in the page tables to check for
valid kernel addresses instead. This can be done in any context
because kernel page tables are not removed (if they were it could
be handled by RCU like the user page tables)

The lookup here is 2-4 memory accesses bounded.

Anything with no NX bit set and is in kernel space is a valid
kernel executable. Unlike the previous scheme this will also
handle cases like the profiler hitting BIOS code or similar
(e.g. the PCI BIOS on 32bit)

On systems without NX we fall back to the previous scheme.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/dumpstack.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index b74ebc7..9279549 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -90,6 +90,42 @@ static inline int valid_stack_ptr(struct thread_info *tinfo,
 	return p > t && p < t + THREAD_SIZE - size;
 }
 
+/*
+ * Check if the address is in a executable page.
+ * This can be much faster than looking it up in the module
+ * table list when many modules are loaded.
+ *
+ * This is safe in any context because kernel page tables
+ * are never removed.
+ */
+static bool addr_is_executable(unsigned long addr)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return __kernel_text_address(addr);
+	if (addr < __PAGE_OFFSET)
+		return false;
+	pgd = pgd_offset_k(addr);
+	if (!pgd_present(*pgd))
+		return false;
+	pud = pud_offset(pgd, addr);
+	if (!pud_present(*pud))
+		return false;
+	if (pud_large(*pud))
+		return pte_exec(*(pte_t *)pud);
+	pmd = pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		return false;
+	if (pmd_large(*pmd))
+		return pte_exec(*(pte_t *)pmd);
+	pte = pte_offset_kernel(pmd, addr);
+	return pte_present(*pte) && pte_exec(*pte);
+}
+
 unsigned long
 print_context_stack(struct thread_info *tinfo,
 		unsigned long *stack, unsigned long bp,
@@ -102,7 +138,7 @@ print_context_stack(struct thread_info *tinfo,
 		unsigned long addr;
 
 		addr = *stack;
-		if (__kernel_text_address(addr)) {
+		if (addr_is_executable(addr)) {
 			if ((unsigned long) stack == bp + sizeof(long)) {
 				ops->address(data, addr, 1);
 				frame = frame->next_frame;
-- 
1.9.3

