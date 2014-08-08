Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaHHMAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:00:01 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57142 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbaHHMAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:00:00 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ca-53e4bbbd4da0
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] arm: module: add support for R_ARM_TARGET1 relocations
Date: Fri, 08 Aug 2014 15:53:56 +0400
Message-id: <1407498836-2797-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t/xq7p7dz8JNuhayWax7dcjNov3y3oY
	LTY9vsZqcXnXHDaL25d5HVg91sxbw+jR0tzD5rF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp
	2yVwZTzpOcdW0MBb8WfzN7YGxmtcXYycHBICJhLbXj5lhrDFJC7cW88GYgsJLGWUuNob3sXI
	BWT3MUm0vV3DDpJgE9CT+DdrO1iRiICmxKnFF5lBipgF5jNKzF7UzNjFyMEhLOAucetoAUgN
	i4CqxPzf28DCvAKuEh9v60LsUpBYtnwm6wRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLz
	czcxQkLhyw7GxcesDjEKcDAq8fAanL4bLMSaWFZcmXuIUYKDWUmE9/LyJ8FCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGMX+yKyQsbaV2br77IF5HZZT/+7m+ymubuUo3rGtwODT/KvvmW0nZ2ke
	rZ4lfmyF3d6psacuzuE8Me/K7Ilsgg5noj5FPWwy542axLErdc9iU9b/c/Yu2KBiviRCjkVC
	5NrSmUovr51b3LHR5NfiPwKatRHbIruPNxwM8HgqrlMc/nGW5vTj1g5KLMUZiYZazEXFiQDI
	IwGE4wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel module build with GCOV profiling fails to load with the
following error:

 $ insmod test_module.ko
   test_module: unknown relocation: 38
   insmod: can't insert 'test_module.ko': invalid module format

This happens because constructor pointers in the .init_array section
have not supported R_ARM_TARGET1 relocation type.

Documentation (ELF for the ARM Architecture) says:
    "The relocation must be processed either in the same way as R_ARM_REL32 or
     as R_ARM_ABS32: a virtual platform must specify which method is used."

Since kernel expects to see absolute addresses in .init_array R_ARM_TARGET1
relocation type should be treated the same way as R_ARM_ABS32.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/include/asm/elf.h | 1 +
 arch/arm/kernel/module.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index f4b46d3..afb9caf 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -50,6 +50,7 @@ typedef struct user_fp elf_fpregset_t;
 #define R_ARM_ABS32		2
 #define R_ARM_CALL		28
 #define R_ARM_JUMP24		29
+#define R_ARM_TARGET1		38
 #define R_ARM_V4BX		40
 #define R_ARM_PREL31		42
 #define R_ARM_MOVW_ABS_NC	43
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 45e4781..6a4dffe 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -91,6 +91,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			break;
 
 		case R_ARM_ABS32:
+		case R_ARM_TARGET1:
 			*(u32 *)loc += sym->st_value;
 			break;
 
-- 
1.8.5.5

