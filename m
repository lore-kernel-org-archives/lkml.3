Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbbALQzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:55:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbbALQzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:55:49 -0500
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] arm64: allow late use of early_ioremap
Date: Mon, 12 Jan 2015 11:55:11 -0500
Message-Id: <1421081711-1128-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0e63ea48b4d8 (arm64/efi: add missing call to early_ioremap_reset())
added a missing call to early_ioremap_reset(). This triggers a BUG if code
tries using early_ioremap() after the early_ioremap_reset(). This is a
problem for some ACPI code which needs short-lived temporary mappings
after paging_init() but before mm_init(). This patch adds definitions for
the __late_set_fixmap() and __late_clear_fixmap() which avoids the BUG
by allowing later use of early_ioremap().

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Leif Lindholm <leif.lindholm@linaro.org>
CC: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/fixmap.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 9ef6eca..e629c70 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -61,6 +61,9 @@ void __init early_fixmap_init(void);
 
 #define __early_set_fixmap __set_fixmap
 
+#define __late_set_fixmap __set_fixmap
+#define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
+
 extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
 #include <asm-generic/fixmap.h>
-- 
1.8.3.1

