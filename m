Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3AXVeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:34:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:40136 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab3AXVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 19/46] arm64: elf: fix core dumping to match what glibc expects
Date: Thu, 24 Jan 2013 13:12:57 -0800
Message-Id: <20130124211143.395523252@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 9cf2b72b25f3f6a5a1a46a4f36037e66de52465c upstream.

The kernel's internal definition of ELF_NGREG uses struct pt_regs, which
means that we disagree with userspace on the size of coredumps since
glibc correctly uses the user-visible struct user_pt_regs.

This patch fixes our ELF_NGREG definition to use struct user_pt_regs
and introduces our own ELF_CORE_COPY_REGS to convert between the user
and kernel structure definitions.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/elf.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -26,7 +26,10 @@
 
 typedef unsigned long elf_greg_t;
 
-#define ELF_NGREG (sizeof (struct pt_regs) / sizeof(elf_greg_t))
+#define ELF_NGREG (sizeof(struct user_pt_regs) / sizeof(elf_greg_t))
+#define ELF_CORE_COPY_REGS(dest, regs)	\
+	*(struct user_pt_regs *)&(dest) = (regs)->user_regs;
+
 typedef elf_greg_t elf_gregset_t[ELF_NGREG];
 typedef struct user_fpsimd_state elf_fpregset_t;
 


