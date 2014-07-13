Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaGMLA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 07:00:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37013 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752277AbaGMLAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 07:00:47 -0400
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: avoid ARM binutils leaking ELF local symbols
Message-Id: <E1X6HWN-0006io-Od@rmk-PC.arm.linux.org.uk>
Date: Sun, 13 Jul 2014 12:00:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Symbols starting with .L are ELF local symbols and should not appear
in ELF symbol tables.  However, unfortunately ARM binutils leaks the
.LANCHOR symbols into the symbol table, which leads kallsyms to report
these symbols rather than the real name.  It is not very useful when
%pf reports symbols against these leaked .LANCHOR symbols.

Arrange for kallsyms to ignore these symbols using the same mechanism
that is used for the ARM mapping symbols.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 kernel/module.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 81e727cf6df9..cecd78d06025 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3385,6 +3385,8 @@ static inline int within(unsigned long addr, void *start, unsigned long size)
  */
 static inline int is_arm_mapping_symbol(const char *str)
 {
+	if (str[0] == '.' && str[1] == 'L')
+		return true;
 	return str[0] == '$' && strchr("atd", str[1])
 	       && (str[2] == '\0' || str[2] == '.');
 }
-- 
1.8.3.1

