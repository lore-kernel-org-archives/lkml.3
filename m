Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaIZXbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:31:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:37102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbaIZXbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:31:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,606,1406617200"; 
   d="scan'208";a="597491070"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] Use faster check for modules in backtrace on 64bit
Date: Fri, 26 Sep 2014 16:31:16 -0700
Message-Id: <1411774277-4198-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
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

The main cost is simply walking this long list of modules and checking it.

On 64bit kernels we can do a short cut. All modules are in a special reserved
virtual address space area. So only check for that range, which is much cheaper.

This has the (small) potential to get a false positive on a pointer to a
data segment in a module.  However since we also use the frame pointer
chain as initial sanity check I think the danger of this is very low.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/dumpstack.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index b74ebc7..b7cbae3 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -130,8 +130,20 @@ print_context_stack_bp(struct thread_info *tinfo,
 	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
 		unsigned long addr = *ret_addr;
 
+#ifdef CONFIG_64BIT
+		/*
+		 * On 64 bit the modules are in a special reserved
+		 * area, so we can just check the range.
+		 * It is not as exact as a full lookup, but together
+		 * with the frame pointer it is good enough.
+		 */
+		if (!core_kernel_text(addr) &&
+		    !(addr >= MODULES_VADDR && addr < MODULES_END))
+			break;
+#else
 		if (!__kernel_text_address(addr))
 			break;
+#endif
 
 		ops->address(data, addr, 1);
 		frame = frame->next_frame;
-- 
1.9.3

