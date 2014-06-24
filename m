Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaFXXAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:00:21 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:59713 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaFXXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:00:19 -0400
From: Ben Chan <benchan@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Olof Johansson <olofj@chromium.org>
Subject: [PATCH] MIPS: ZBOOT: implement stack protector in compressed boot phase
Date: Tue, 24 Jun 2014 16:00:17 -0700
Message-Id: <1403650817-21641-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the stack protector code in MIPS compressed boot
phase based on the same code added to arm in commit
8779657d29c0ebcc0c94ede4df2f497baf1b563f "stackprotector: Introduce
CONFIG_CC_STACKPROTECTOR_STRONG" by Kees Cook <keescook@chromium.org>

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
---
 arch/mips/boot/compressed/decompress.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/mips/boot/compressed/decompress.c b/arch/mips/boot/compressed/decompress.c
index c00c4dd..b49c7ad 100644
--- a/arch/mips/boot/compressed/decompress.c
+++ b/arch/mips/boot/compressed/decompress.c
@@ -67,10 +67,24 @@ void error(char *x)
 #include "../../../../lib/decompress_unxz.c"
 #endif
 
+unsigned long __stack_chk_guard;
+
+void __stack_chk_guard_setup(void)
+{
+	__stack_chk_guard = 0x000a0dff;
+}
+
+void __stack_chk_fail(void)
+{
+	error("stack-protector: Kernel stack is corrupted\n");
+}
+
 void decompress_kernel(unsigned long boot_heap_start)
 {
 	unsigned long zimage_start, zimage_size;
 
+	__stack_chk_guard_setup();
+
 	zimage_start = (unsigned long)(&__image_begin);
 	zimage_size = (unsigned long)(&__image_end) -
 	    (unsigned long)(&__image_begin);
-- 
2.0.0.526.g5318336

