Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbaGANep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:34:45 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:46632 "EHLO
	mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbaGANeo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:34:44 -0400
X-Greylist: delayed 2010 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2014 09:34:43 EDT
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH 15/24] ARM64:ILP32: Use the non compat HWCAP for ILP32.
From: "Dr. Philipp Tomsich" <philipp.tomsich@theobroma-systems.com>
In-Reply-To: <1400914939-9708-16-git-send-email-apinski@cavium.com>
Date: Tue, 1 Jul 2014 15:01:06 +0200
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6E65D0A3-E36A-4A34-8CD0-258964FA623A@theobroma-systems.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com> <1400914939-9708-16-git-send-email-apinski@cavium.com>
To: Andrew Pinski <apinski@cavium.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 May 2014, at 09:02 , Andrew Pinski <apinski@cavium.com> wrote:

> #ifdef CONFIG_COMPAT
> -#define COMPAT_ELF_HWCAP	(compat_elf_hwcap)
> -#define COMPAT_ELF_HWCAP2	(compat_elf_hwcap2)
> extern unsigned int compat_elf_hwcap, compat_elf_hwcap2;
> +#define COMPAT_ELF_HWCAP	\
> +	(is_a32_compat_task()	\
> +	  ? compat_elf_hwcap	\
> +	  : elf_hwcap)
> +
> +#define COMPAT_ELF_HWCAP2	\
> +	(is_a32_compat_task()	\
> +	  ? compat_elf_hwcap2	\
> +	  : 0)
> +
> #endif

You missed the COMPAT_ELF_PLATFORM (in arm64/include/asm/elf.h), which is used to setup AT_PLATFORM in the auxilary vectors. I’d suggest to use a similar naming convention to what will be used in gdb (i.e. appending a “:ilp32” to the base architecture.

The proposed change would thus be:
---
 arch/arm64/include/asm/elf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 3f979b5..6d38edc 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -168,9 +168,9 @@ extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #ifdef CONFIG_COMPAT
 
 #ifdef __AARCH64EB__
-#define COMPAT_ELF_PLATFORM            ("v8b")
+#define COMPAT_ELF_PLATFORM            (is_ilp32_compat_task() ? "aarch64_be:ilp32" : "v8b")
 #else
-#define COMPAT_ELF_PLATFORM            ("v8l")
+#define COMPAT_ELF_PLATFORM            (is_ilp32_compat_task() ? "aarch64:ilp32" : "v8l")
 #endif
 
 #define COMPAT_ELF_ET_DYN_BASE         (randomize_et_dyn(2 * TASK_SIZE_32 / 3))
-- 
1.9.0


Best,
Philipp.