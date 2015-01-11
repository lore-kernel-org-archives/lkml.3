Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbbAKOdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:33:24 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41528 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbbAKOdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:33:05 -0500
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Pen <r.peniaev@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] ARM: entry-common: fix forgotten set of thread_info->syscall
Date: Sun, 11 Jan 2015 23:32:30 +0900
Message-Id: <1420986751-30364-2-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
References: <1420986751-30364-1-git-send-email-r.peniaev@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_info->syscall is used only for ptrace, but syscall number
is also used by syscall_get_nr and returned to userspace by the
following proc file access:

 $ cat /proc/self/syscall
 0 0x3 0xbe928bd8 0x1000 0x0 0xac9e0 0x3 0xbe928bb4 0xb6f5dfbc
 ^
The first number is the syscall number, currently it is zero.
Patch fixes this:

 $ cat /proc/self/syscall
 3 0x3 0xbefc7bd8 0x1000 0x0 0xac9e0 0x3 0xbefc7bb4 0xb6e82fbc
 ^
Right, read syscall

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---
 arch/arm/kernel/asm-offsets.c  | 1 +
 arch/arm/kernel/entry-common.S | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 2d2d608..6911bad 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -70,6 +70,7 @@ int main(void)
   DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
   DEFINE(TI_CPU_DOMAIN,		offsetof(struct thread_info, cpu_domain));
   DEFINE(TI_CPU_SAVE,		offsetof(struct thread_info, cpu_context));
+  DEFINE(TI_SYSCALL,		offsetof(struct thread_info, syscall));
   DEFINE(TI_USED_CP,		offsetof(struct thread_info, used_cp));
   DEFINE(TI_TP_VALUE,		offsetof(struct thread_info, tp_value));
   DEFINE(TI_FPSTATE,		offsetof(struct thread_info, fpstate));
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index f8ccc21..89452ff 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -189,6 +189,7 @@ ENTRY(vector_swi)
 #endif
 
 local_restart:
+	str scno, [tsk, #TI_SYSCALL]		@ set syscall number
 	ldr	r10, [tsk, #TI_FLAGS]		@ check for syscall tracing
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
 
-- 
2.1.3

