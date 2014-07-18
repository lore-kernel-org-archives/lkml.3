Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbaGRWwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:52:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52172 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbaGRWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:52:12 -0400
Date: Fri, 18 Jul 2014 15:51:31 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Don't oops when userspace executes kgdb break
 instructions.
Message-ID: <20140718225049.GA11937@mew.guest.dropbox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't break into kgdb when userspace executes the kernel break instructions
(KGDB_BREAKINST and KGDB_COMPILED_BREAK). The kernel will oops in
kgdb_handle_exception.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
The following program will immediately cause a kernel oops:
.globl _start
_start:
	udf	#65006	@ KGDB_BREAKINST

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
2.0.1
