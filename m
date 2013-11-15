Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3KOE4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:56:11 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41343 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab3KOEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:55:45 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-ee-5285a8e634e1
Subject: [PATCH -tip RFC v2 14/22] x86/fault: Use NOKPROBE_SYMBOL macro in
 fault.c
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:53:57 +0000
Message-ID: <20131115045357.27580.92965.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from kprobes
instead of __kprobes annotation in fault.c.
This applies __always_inline annotation for some cases,
because NOKPROBE_SYMBOL() will inhibit inlining by
referring the symbol address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/mm/fault.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9ff85bb..7c9305c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -8,7 +8,7 @@
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/module.h>		/* search_exception_table	*/
 #include <linux/bootmem.h>		/* max_low_pfn			*/
-#include <linux/kprobes.h>		/* __kprobes, ...		*/
+#include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
 #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
@@ -45,7 +45,7 @@ enum x86_pf_error_code {
  * Returns 0 if mmiotrace is disabled, or if the fault is not
  * handled by mmiotrace:
  */
-static inline int __kprobes
+static __always_inline int
 kmmio_fault(struct pt_regs *regs, unsigned long addr)
 {
 	if (unlikely(is_kmmio_active()))
@@ -54,7 +54,7 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
 	return 0;
 }
 
-static inline int __kprobes kprobes_fault(struct pt_regs *regs)
+static __always_inline int kprobes_fault(struct pt_regs *regs)
 {
 	int ret = 0;
 
@@ -261,7 +261,7 @@ void vmalloc_sync_all(void)
  *
  *   Handle a fault on the vmalloc or module mapping area
  */
-static noinline __kprobes int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 	unsigned long pgd_paddr;
 	pmd_t *pmd_k;
@@ -291,6 +291,7 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(vmalloc_fault);
 
 /*
  * Did it hit the DOS screen memory VA from vm86 mode?
@@ -358,7 +359,7 @@ void vmalloc_sync_all(void)
  *
  * This assumes no large pages in there.
  */
-static noinline __kprobes int vmalloc_fault(unsigned long address)
+static noinline int vmalloc_fault(unsigned long address)
 {
 	pgd_t *pgd, *pgd_ref;
 	pud_t *pud, *pud_ref;
@@ -425,6 +426,7 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 
 	return 0;
 }
+NOKPROBE_SYMBOL(vmalloc_fault);
 
 #ifdef CONFIG_CPU_SUP_AMD
 static const char errata93_warning[] =
@@ -904,7 +906,7 @@ static int spurious_fault_check(unsigned long error_code, pte_t *pte)
  * There are no security implications to leaving a stale TLB when
  * increasing the permissions on a page.
  */
-static noinline __kprobes int
+static noinline int
 spurious_fault(unsigned long error_code, unsigned long address)
 {
 	pgd_t *pgd;
@@ -952,6 +954,7 @@ spurious_fault(unsigned long error_code, unsigned long address)
 
 	return ret;
 }
+NOKPROBE_SYMBOL(spurious_fault);
 
 int show_unhandled_signals = 1;
 
@@ -997,7 +1000,7 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
  * and the problem, and then passes it off to one of the appropriate
  * routines.
  */
-static void __kprobes
+static void
 __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	struct vm_area_struct *vma;
@@ -1225,8 +1228,9 @@ good_area:
 
 	up_read(&mm->mmap_sem);
 }
+NOKPROBE_SYMBOL(__do_page_fault);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -1235,9 +1239,10 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(do_page_fault);
 
-static void trace_page_fault_entries(struct pt_regs *regs,
-				     unsigned long error_code)
+static __always_inline void
+trace_page_fault_entries(struct pt_regs *regs, unsigned long error_code)
 {
 	if (user_mode(regs))
 		trace_page_fault_user(read_cr2(), regs, error_code);
@@ -1245,7 +1250,7 @@ static void trace_page_fault_entries(struct pt_regs *regs,
 		trace_page_fault_kernel(read_cr2(), regs, error_code);
 }
 
-dotraplinkage void __kprobes
+dotraplinkage void
 trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -1255,3 +1260,4 @@ trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+NOKPROBE_SYMBOL(trace_do_page_fault);

