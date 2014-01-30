Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaA3GWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:22:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaA3GWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:22:53 -0500
Date: Wed, 29 Jan 2014 22:21:40 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-824a2870098fa5364d49d4cd5a1f41544d9f6c65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1382458079-24450-4-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, paravirt: Don'
 t rely on local assembler labels
Git-Commit-ID: 824a2870098fa5364d49d4cd5a1f41544d9f6c65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 22:21:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  824a2870098fa5364d49d4cd5a1f41544d9f6c65
Gitweb:     http://git.kernel.org/tip/824a2870098fa5364d49d4cd5a1f41544d9f6c65
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 22 Oct 2013 09:07:55 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 22:17:17 -0800

x86, asmlinkage, paravirt: Don't rely on local assembler labels

The paravirt patching code assumes that it can reference a
local assembler label between two different top level assembler
statements. This does not work with LTO
where the assembler code may end up in different assembler files.

Replace it with extern / global /asm linkage labels.

This also removes one redundant copy of the macro.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1382458079-24450-4-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
