Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaFWSXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:23:01 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48640 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaFWSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:22:59 -0400
From: Filipe Brandenburger <filbranden@google.com>
To: Shaohua Li <shaohua.li@intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: Zhengyu He <hzy@google.com>, linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH] core: fix typo in percpu read_mostly section
Date: Mon, 23 Jun 2014 11:16:05 -0700
Message-Id: <1403547365-13428-1-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhengyu He <hzy@google.com>

This fixes a typo that named the read_mostly section of percpu as
readmostly. It works fine with SMP because the linker script specifies
.data..percpu..readmostly. However, UP kernel builds don't have percpu
sections defined and the non-percpu version of the section is called
data..read_mostly, so .data..readmostly will float around and may break
things unexpectedly.

Looking at the original change that introduced data..percpu..readmostly
(commit c957ef2c59e952803766ddc22e89981ab534606f), it looks like this
was the original intention.

Tested: Built UP kernel and confirmed the sections got merged.

- Before the patch:
$ objdump -h vmlinux.o  | grep '\.data\.\.read.*mostly'
38 .data..read_mostly 00004418  0000000000000000  0000000000000000  00431ac0  2**6
50 .data..readmostly 00000014  0000000000000000  0000000000000000  00444000  2**3

- After the patch:
$ objdump -h vmlinux.o  | grep '\.data\.\.read.*mostly'
38 .data..read_mostly 00004438  0000000000000000  0000000000000000  00431ac0  2**6

Signed-off-by: Zhengyu He <hzy@google.com>
Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 include/linux/percpu-defs.h       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 471ba48c7ae4..c1c0b0cf39b4 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -693,7 +693,7 @@
 	. = ALIGN(PAGE_SIZE);						\
 	*(.data..percpu..page_aligned)					\
 	. = ALIGN(cacheline);						\
-	*(.data..percpu..readmostly)					\
+	*(.data..percpu..read_mostly)					\
 	. = ALIGN(cacheline);						\
 	*(.data..percpu)						\
 	*(.data..percpu..shared_aligned)				\
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index a5fc7d01aad6..dec01d6c3f80 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -146,10 +146,10 @@
  * Declaration/definition used for per-CPU variables that must be read mostly.
  */
 #define DECLARE_PER_CPU_READ_MOSTLY(type, name)			\
-	DECLARE_PER_CPU_SECTION(type, name, "..readmostly")
+	DECLARE_PER_CPU_SECTION(type, name, "..read_mostly")
 
 #define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
+	DEFINE_PER_CPU_SECTION(type, name, "..read_mostly")
 
 /*
  * Intermodule exports for per-CPU variables.  sparse forgets about
-- 
2.0.0.526.g5318336

