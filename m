Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaHADF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 23:05:26 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62388 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaHADFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 23:05:25 -0400
Date: Thu, 31 Jul 2014 20:05:20 -0700
From: Omar Sandoval <osandov@osandov.com>
To: will.deacon@arm.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Catalin.Marinas@arm.com
Subject: [PATCH] ARM: don't enter kgdb when userspace executes a kgdb break
 instruction.
Message-ID: <20140801030520.GA27665@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb breakpoint hooks (kgdb_brk_fn and kgdb_compiled_brk_fn) should only be
entered when a kgdb break instruction is executed from the kernel. Otherwise,
if kgdb is enabled, a userspace program can cause the kernel to drop into the
debugger by executing either KGDB_BREAKINST or KGDB_COMPILED_BREAK.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
On a kernel running with kgdb enabled, this program reproduces the problem:
.globl _start
_start:
	udf	#65006	@ KGDB_BREAKINST

The same problem has been fixed in ARM64.

 arch/arm/kernel/kgdb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index 778c2f7..a74b53c 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -160,12 +160,16 @@ static int kgdb_compiled_brk_fn(struct pt_regs *regs, unsigned int instr)
 static struct undef_hook kgdb_brkpt_hook = {
 	.instr_mask		= 0xffffffff,
 	.instr_val		= KGDB_BREAKINST,
+	.cpsr_mask		= MODE_MASK,
+	.cpsr_val		= SVC_MODE,
 	.fn			= kgdb_brk_fn
 };
 
 static struct undef_hook kgdb_compiled_brkpt_hook = {
 	.instr_mask		= 0xffffffff,
 	.instr_val		= KGDB_COMPILED_BREAK,
+	.cpsr_mask		= MODE_MASK,
+	.cpsr_val		= SVC_MODE,
 	.fn			= kgdb_compiled_brk_fn
 };
 
-- 
2.0.3

