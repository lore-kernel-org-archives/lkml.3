Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaKJXzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:55:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:53714 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaKJXzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,356,1413270000"; 
   d="scan'208";a="620256078"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 7/8] x86: Add documentation for rd/wr fs/gs base
Date: Mon, 10 Nov 2014 15:55:38 -0800
Message-Id: <1415663739-25525-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

v2: Minor updates to documentation requested in review.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/x86/fsgs.txt | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/x86/fsgs.txt

diff --git a/Documentation/x86/fsgs.txt b/Documentation/x86/fsgs.txt
new file mode 100644
index 0000000..26a1e29
--- /dev/null
+++ b/Documentation/x86/fsgs.txt
@@ -0,0 +1,76 @@
+
+Using FS and GS prefixes on x86_64-linux
+
+The x86 architecture supports segment prefixes per instruction to add an
+offset to an address.  On 64bit x86, these are mostly nops, except for FS
+and GS.
+
+This offers an efficient way to reference a global pointer.
+
+The compiler has to generate special code to use these base registers,
+or they can be accessed with inline assembler.
+
+	mov %gs:offset,%reg
+	mov %fs:offset,%reg
+
+FS is used to address the thread local segment (TLS), declared using
+__thread.  The compiler then automatically generates the correct prefixes and
+relocations to access these values.
+
+FS is normally managed by the runtime code or the threading library.
+
+GS is freely available, but may need special (compiler or inline assembler)
+code to use.
+
+Traditionally 64bit FS and GS could be set by the arch_prctl system call
+
+	arch_prctl(ARCH_SET_GS, value)
+	arch_prctl(ARCH_SET_FS, value)
+
+[There was also an older method using modify_ldt(), inherited from 32bit,
+but this is not discussed here.]
+
+However using a syscall is problematic for user space threading libraries
+that want to context switch in user space. The whole point of them
+is avoiding the overhead of a syscall. It's also cleaner for compilers
+wanting to use the extra register to use instructions to write
+it, or read it directly to compute addresses and offsets.
+
+Newer Intel CPUs (Ivy Bridge and later) added new instructions to directly
+access these registers quickly from user context
+
+	RDFSBASE %reg	read the FS base	(or _readfsbase_u64)
+	RDGSBASE %reg	read the GS base	(or _readgsbase_u64)
+
+	WRFSBASE %reg	write the FS base	(or _writefsbase_u64)
+	WRGSBASE %reg	write the GS base	(or _writegsbase_u64)
+
+The instructions are supported by the CPU when the "fsgsbase" string is shown in
+/proc/cpuinfo (or directly retrieved through the CPUID instruction).
+The instructions are only available to 64bit binaries.
+
+However the kernel needs to explicitly enable these instructions, as it
+may otherwise not correctly context switch the state. Newer Linux
+kernels enable this. When the kernel did not enable the instruction
+they will fault with an #UD exception.
+
+An FSGSBASE enabled kernel can be detected by checking the AT_HWCAP2
+bitmask in the aux vector. When the HWCAP2_FSGSBASE bit is set the
+kernel supports RDFSGSBASE.
+
+	#include <sys/auxv.h>
+	#include <elf.h>
+
+	/* Will be eventually in asm/hwcap.h */
+	#define HWCAP2_FSGSBASE        (1 << 0)
+
+        unsigned val = getauxval(AT_HWCAP2);
+        if (val & HWCAP2_FSGSBASE) {
+                asm("wrgsbase %0" :: "r" (ptr));
+        }
+
+Another requirement is that the FS or GS selector has to be zero
+(is normally true unless changed explicitly)
+
+
+Andi Kleen
-- 
1.9.3

