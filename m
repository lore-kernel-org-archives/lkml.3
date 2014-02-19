Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaBSKQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:16:04 -0500
Received: from multi.imgtec.com ([194.200.65.239]:43765 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbaBSKPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:15:03 -0500
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Markos Chandras <markos.chandras@imgtec.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] samples/seccomp/Makefile: Do not build tests if cross-compiling for MIPS
Date: Wed, 19 Feb 2014 10:15:17 +0000
Message-ID: <1392804917-29789-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <52FD0131.9040304@imgtec.com>
References: <52FD0131.9040304@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.47]
X-SEF-Processed: 7_3_0_01192__2014_02_19_10_14_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile is designed to use the host toolchain so it may be
unsafe to build the tests if the kernel has been configured and built
for another architecture. This fixes a build problem when the kernel has
been configured and built for the MIPS architecture but the host is
not MIPS (cross-compiled). The MIPS syscalls are only defined
if one of the following is true:

1) _MIPS_SIM == _MIPS_SIM_ABI64
2) _MIPS_SIM == _MIPS_SIM_ABI32
3) _MIPS_SIM == _MIPS_SIM_NABI32

Of course, none of these make sense on a non-MIPS toolchain and the
following build problem occurs when building on a non-MIPS host.

linux/usr/include/linux/kexec.h:50:
userspace cannot reference function or variable defined in the kernel
samples/seccomp/bpf-direct.c: In function ‘emulator’:
samples/seccomp/bpf-direct.c:76:17: error:
‘__NR_write’ undeclared (first use in this function)

Cc: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
This build problem is only reproducible on the linux-next tree at the moment

Changes since v1:
- Rework code so native builds are allowed on MIPS
---
 samples/seccomp/Makefile | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 7203e66..855051b 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -18,8 +18,8 @@ HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
 bpf-direct-objs := bpf-direct.o
 
 # Try to match the kernel target.
-ifndef CONFIG_64BIT
 ifndef CROSS_COMPILE
+ifndef CONFIG_64BIT
 
 # s390 has -m31 flag to build 31 bit binaries
 ifndef CONFIG_S390
@@ -36,7 +36,13 @@ HOSTLOADLIBES_bpf-direct += $(MFLAG)
 HOSTLOADLIBES_bpf-fancy += $(MFLAG)
 HOSTLOADLIBES_dropper += $(MFLAG)
 endif
-endif
-
-# Tell kbuild to always build the programs
 always := $(hostprogs-y)
+else
+# MIPS system calls are defined based on the -mabi that is passed
+# to the toolchain which may or may not be a valid option
+# for the host toolchain. So disable tests if target architecture
+# is MIPS but the host isn't.
+ifndef CONFIG_MIPS
+always := $(hostprogs-y)
+endif
+endif
-- 
1.9.0


