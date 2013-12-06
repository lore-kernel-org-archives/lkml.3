Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab3LFLhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:37:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:15156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3LFLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:37:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,840,1378882800"; 
   d="scan'208";a="326052920"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: [PATCH 1/3] x86, mpx: add documentation on Intel MPX
Date: Sat,  7 Dec 2013 02:52:54 +0800
Message-Id: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Documentation/intel_mpx.txt file with some
information about Intel MPX.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 Documentation/intel_mpx.txt |   77 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/intel_mpx.txt

diff --git a/Documentation/intel_mpx.txt b/Documentation/intel_mpx.txt
new file mode 100644
index 0000000..3d947d0
--- /dev/null
+++ b/Documentation/intel_mpx.txt
@@ -0,0 +1,77 @@
+Intel(R) MPX Overview:
+=====================
+
+Intel(R) Memory Protection Extensions (Intel(R) MPX) is a new
+capability introduced into Intel Architecture. Intel MPX can
+increase the robustness of software when it is used in conjunction
+with compiler changes to check memory references, for those
+references whose compile-time normal intentions are usurped
+at runtime due to buffer overflow or underflow.
+
+Two of the most important goals of Intel MPX are to provide
+this capability at very low performance overhead for newly
+compiled code, and to provide compatibility mechanisms with
+legacy software components. A direct benefit Intel MPX provides
+is hardening software against malicious attacks designed to
+cause or exploit buffer overruns.
+
+For details about the Intel MPX instructions, see "Intel(R)
+Architecture Instruction Set Extensions Programming Reference".
+
+Intel(R) MPX Programming Model
+------------------------------
+
+Intel MPX introduces new registers and new instructions that
+operate on these registers. Some of the registers added are
+bounds registers which store a pointer's lower bound and upper
+bound limits. Whenever the pointer is used, the requested
+reference is checked against the pointer's associated bounds,
+thereby preventing out-of-bound memory access (such as buffer
+overflows and overruns). Out-of-bounds memory references
+initiate a #BR exception which can then be handled in an
+appropriate manner.
+
+Loading and Storing Bounds using Translation
+--------------------------------------------
+
+Intel MPX defines two instructions for load/store of the linear
+address of a pointer to a buffer, along with the bounds of the
+buffer into a paging structure of extended bounds. Specifically
+when storing extended bounds, the processor will perform address
+translation of the address where the pointer is stored to an
+address in the Bound Table (BT) to determine the store location
+of extended bounds. Loading of an extended bounds performs the
+reverse sequence.
+
+The structure in memory to load/store an extended bound is a
+4-tuple consisting of lower bound, upper bound, pointer value
+and a reserved field. Bound loads and stores access 32-bit or
+64-bit operand size according to the operation mode. Thus,
+a bound table entry is 4*32 bits in 32-bit mode and 4*64 bits
+in 64-bit mode.
+
+The linear address of a bound table is stored in a Bound
+Directory (BD) entry. And the linear address of the bound
+directory is derived from either BNDCFGU or BNDCFGS registers.
+Bounds in memory are stored in Bound Tables (BT) as an extended
+bound, which are accessed via Bound Directory (BD) and address
+translation performed by BNDLDX/BNDSTX instructions.
+
+Bounds Directory (BD) and Bounds Tables (BT) are stored in
+application memory and are allocated by the application (in case
+of kernel use, the structures will be in kernel memory). The
+bound directory and each instance of bound table are in contiguous
+linear memory.
+
+XSAVE/XRESTOR Support of Intel MPX State
+----------------------------------------
+
+Enabling Intel MPX requires an OS to manage two bits in XCR0:
+  - BNDREGS for saving and restoring registers BND0-BND3,
+  - BNDCSR for saving and restoring the user-mode configuration
+(BNDCFGU) and the status register (BNDSTATUS).
+
+The reason for having two separate bits is that BND0-BND3 is
+likely to be volatile state, while BNDCFGU and BNDSTATUS are not.
+Therefore, an OS has flexibility in handling these two states
+differently in saving or restoring them.
-- 
1.7.1

