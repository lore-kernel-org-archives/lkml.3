Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3JVQIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:08:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:18946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3JVQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,549,1378882800"; 
   d="scan'208";a="420878745"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        jeremy@goop.org
Subject: [PATCH 3/7] x86, asmlinkage, paravirt: Don't rely on local assembler labels
Date: Tue, 22 Oct 2013 09:07:55 -0700
Message-Id: <1382458079-24450-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The paravirt patching code assumes that it can reference a
local assembler label between two different top level assembler
statements. This does not work with LTO
where the assembler code may end up in different assembler files.

Replace it with extern / global /asm linkage labels.

This also removes one redundant copy of the macro.

Cc: jeremy@goop.org
Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/paravirt_types.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index aab8f67..7549b8b 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -388,10 +388,11 @@ extern struct pv_lock_ops pv_lock_ops;
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
 /* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[] __visible,		\
-			  end_##ops##_##name[] __visible;		\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
+#define NATIVE_LABEL(a,x,b) "\n\t.globl " a #x "_" #b "\n" a #x "_" #b ":\n\t"
+
+#define DEF_NATIVE(ops, name, code)					\
+	__visible extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	asm(NATIVE_LABEL("start_", ops, name) code NATIVE_LABEL("end_", ops, name))
 
 unsigned paravirt_patch_nop(void);
 unsigned paravirt_patch_ident_32(void *insnbuf, unsigned len);
-- 
1.8.3.1

