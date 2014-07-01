Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbaGATME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:12:04 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62103 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaGATMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:12:00 -0400
From: Filipe Brandenburger <filbranden@google.com>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, Zhengyu He <hzy@google.com>,
        Greg Thelen <gthelen@google.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH] core: fix typo in percpu read_mostly section
Date: Tue,  1 Jul 2014 12:11:47 -0700
Message-Id: <1404241907-27093-1-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403547365-13428-1-git-send-email-filbranden@google.com>
References: <1403547365-13428-1-git-send-email-filbranden@google.com>
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

