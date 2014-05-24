Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaEXHKb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:10:31 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44479 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaEXHJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:09:28 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 24/24] Add documentation about ARM64 ILP32 ABI.
Date: Sat, 24 May 2014 00:02:19 -0700
Message-Id: <1400914939-9708-25-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
To: linux-doc@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the documentation about the ILP32 ABI and what is difference between it and the normal generic 32bit ABI.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>

---
 Documentation/arm64/ilp32.txt |   57 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/arm64/ilp32.txt

diff --git a/Documentation/arm64/ilp32.txt b/Documentation/arm64/ilp32.txt
new file mode 100644
index 0000000..5be0613
--- /dev/null
+++ b/Documentation/arm64/ilp32.txt
@@ -0,0 +1,57 @@
+			ILP32 AARCH64 SYSCALL ABI
+			=====================
+
+Author: Andrew Pinski  <apinski@cavium.com>
+Date: May 23, 2014
+
+This document describes the ILP32 syscall ABI and where it differs
+from the generic linux syscall interface.  
+ILP32 sets __kernel_long_t and __kernel_ulong_t both to 64bit
+(long long).  This effects the following types:
+* time_t: unsigned long long
+* clock_t: unsigned long long
+* fsword_t: long long
+* suseconds_t: long long
+* swblk_t: long long
+* fd_mask_t: long long
+
+Some structures are changed to reduce the difference in the code path
+for both ILP32 and LP64 ABIs for signal handling.
+
+The following structures have been changed so the layout of the structures are the same between ILP32 and LP64 ABIs.
+* timespec: Uses time_t and suseconds_t
+* timeval: Uses time_t and suseconds_t
+* stat: Uses timespec/time_t.
+* semid64_ds: Uses time_t.
+* msqid64_ds: Uses time_t.
+* shmid64_ds: Uses time_t.
+* rt_sigframe: Uses siginfo and ucontext.
+* siginfo_t: Uses clock_t and sigval_t
+* ucontext: Uses stack_t and sigset_t
+* stack_t: NOTE special handling inside the kernel is done to make sure
+  the pointers are zero extended
+* sigval_t: Contains pointers
+* sigevent: Uses sigval_t which causes it to be the same.  Special
+  handing is needed for reading; in the mq_notify syscall
+* sigaction: NOTE the userland structure inside glibc does
+  not match the kernel structure here (this causes issues with LTP).
+  Uses sigset_t. 
+* fd_set: This is done to avoid endian issues between ILP32 and LP64
+  Also the syscall which uses fd_set uses timespec
+
+
+Also the syscalls which normally would pass 64bit values as two
+arguments; now pass the 64bit value as one argument.  Also they have
+been renamed (removing the 64 from the name) to avoid confusion.
+The list of these syscalls:
+* fcntl
+* statfs
+* fstatfs
+* truncate
+* ftruncate
+* lseek
+* sendfile
+* newfstatat
+* fstat
+* mmap
+* fadvise64
-- 
1.7.2.5

