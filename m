Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3L2Cbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:31:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55435 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875Ab3L2CKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:48 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?Andreas=20Bie=C3=9Fmann?=" <andreas@biessmann.de>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        "Haavard Skinnemoen" <hskinnemoen@gmail.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.893199703@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 076/185] avr32: fix out-of-range jump in large kernels
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Bießmann <andreas@biessmann.de>

commit d617b338bbfdd77e9cbd8e7dc949cee3dd73d575 upstream.

This patch fixes following error (for big kernels):

---8<---
arch/avr32/boot/u-boot/head.o: In function `no_tag_table':
(.init.text+0x44): relocation truncated to fit: R_AVR32_22H_PCREL against symbol `panic' defined in .text.unlikely section in kernel/built-in.o
arch/avr32/kernel/built-in.o: In function `bad_return':
(.ex.text+0x236): relocation truncated to fit: R_AVR32_22H_PCREL against symbol `panic' defined in .text.unlikely section in kernel/built-in.o
--->8---

It comes up when the kernel increases and 'panic()' is too far away to fit in
the +/- 2MiB range. Which in turn issues from the 21-bit displacement in
'br{cond4}' mnemonic which is one of the two ways to do jumps (rjmp has just
10-bit displacement and therefore a way smaller range). This fact was stated
before in 8d29b7b9f81d6b83d869ff054e6c189d6da73f1f.
One solution to solve this is to add a local storage for the symbol address
and just load the $pc with that value.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/avr32/boot/u-boot/head.S    | 5 ++++-
 arch/avr32/kernel/entry-avr32b.S | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/avr32/boot/u-boot/head.S
+++ b/arch/avr32/boot/u-boot/head.S
@@ -73,8 +73,11 @@ init_sr:
 	.long	0x007f0000	/* Supervisor mode, everything masked */
 stack_addr:
 	.long	init_thread_union
+panic_addr:
+	.long	panic
 
 no_tag_table:
 	sub	r12, pc, (. - 2f)
-	bral	panic
+	/* branch to panic() which can be far away with that construct */
+	lddpc	pc, panic_addr
 2:	.asciz	"Boot loader didn't provide correct magic number\n"
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -399,9 +399,10 @@ handle_critical:
 	/* We should never get here... */
 bad_return:
 	sub	r12, pc, (. - 1f)
-	bral	panic
+	lddpc	pc, 2f
 	.align	2
 1:	.asciz	"Return from critical exception!"
+2:	.long	panic
 
 	.align	1
 do_bus_error_write:

