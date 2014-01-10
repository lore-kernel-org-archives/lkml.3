Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaAJR70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:59:26 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:56881 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaAJR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:58:46 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Jon Medhurst <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] ARM: kprobes-test: Workaround GAS .align bug
Date: Fri, 10 Jan 2014 19:58:26 +0200
Message-Id: <1389376706-30051-6-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default if no fill symbol is given to .align directive in a code
section it fills gap with NOPs. If previous fragment is not
instruction-aligned, additional pre-alignment is done by zero bytes
before NOPs. These zero bytes are marked as data by special symbol $d in
symbol table. Unfortunately GAS assumes that there is only code in the
code section so it "puts back" code symbol $a at the end of this
pre-alignment. So if there is some data after alignment it will be
interpreted as code and will be swapped back to LE for BE8 system during
a final linking.

If explicit fill value is given to .align, the NOP-padding code is
skipped and symbol table does not get messed-up.

So the workaround for this issue:
Use explicit fill value if data should be aligned in the code section.

Acked-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/kernel/kprobes-test.c |    2 +-
 arch/arm/kernel/kprobes-test.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 0850c72..d2c2174 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -113,7 +113,7 @@
  *	@ start of inline data...
  *	.ascii "mov r0, r7"	@ text title for test case
  *	.byte	0
- *	.align	2
+ *	.align	2, 0
  *
  *	@ TEST_ARG_REG
  *	.byte	ARG_TYPE_REG
diff --git a/arch/arm/kernel/kprobes-test.h b/arch/arm/kernel/kprobes-test.h
index e28a869..eecc90a 100644
--- a/arch/arm/kernel/kprobes-test.h
+++ b/arch/arm/kernel/kprobes-test.h
@@ -115,7 +115,7 @@ struct test_arg_end {
 	/* multiple strings to be concatenated.  */		\
 	".ascii "#title"				\n\t"	\
 	".byte	0					\n\t"	\
-	".align	2					\n\t"
+	".align	2, 0					\n\t"
 
 #define	TEST_ARG_REG(reg, val)					\
 	".byte	"__stringify(ARG_TYPE_REG)"		\n\t"	\
-- 
1.7.9.5

