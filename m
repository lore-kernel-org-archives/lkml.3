Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbaBUMxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:53:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbaBUMxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:53:21 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <53073962020000780011E2DE@nat28.tlf.novell.com>
References: <53073962020000780011E2DE@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/3] x86/hash: fix build failure with older binutils
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Feb 2014 04:51:53 -0800
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: davem@davemloft.net, dborkman@redhat.com, ffusco@redhat.com,
        tgraf@redhat.com, linux-kernel@vger.kernel.org
Message-ID: <68ae560f-8cf7-4083-816f-3fa78aed9a87@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How old?

On February 21, 2014 2:32:50 AM PST, Jan Beulich <JBeulich@suse.com> wrote:
>Just like for other ISA extension instruction uses we should check
>whether the assembler actually supports them. The fallback here simply
>is to encode an instruction  with fixed operands (%eax and %ecx).
>
>Signed-off-by: Jan Beulich <jbeulich@suse.com>
>Cc: Francesco Fusco <ffusco@redhat.com>
>Cc: Daniel Borkmann <dborkman@redhat.com>
>Cc: Thomas Graf <tgraf@redhat.com>
>Cc: David S. Miller <davem@davemloft.net>
>---
> arch/x86/Makefile   |    1 +
> arch/x86/lib/hash.c |    4 ++++
> 2 files changed, 5 insertions(+)
>
>--- 3.14-rc3-x86-hash-crc32.orig/arch/x86/Makefile
>+++ 3.14-rc3-x86-hash-crc32/arch/x86/Makefile
>@@ -152,6 +152,7 @@ cfi-sections := $(call as-instr,.cfi_sec
> 
> # does binutils support specific instructions?
> asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
>+asinstr += $(call as-instr,crc32l
>%eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
>avx_instr := $(call as-instr,vxorps
>%ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
>avx2_instr :=$(call as-instr,vpbroadcastb
>%xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
> 
>--- 3.14-rc3-x86-hash-crc32.orig/arch/x86/lib/hash.c
>+++ 3.14-rc3-x86-hash-crc32/arch/x86/lib/hash.c
>@@ -39,7 +39,11 @@
> 
> static inline u32 crc32_u32(u32 crc, u32 val)
> {
>+#ifdef CONFIG_AS_CRC32
> 	asm ("crc32l %1,%0\n" : "+r" (crc) : "rm" (val));
>+#else
>+	asm (".byte 0xf2, 0x0f, 0x38, 0xf1, 0xc1" : "+a" (crc) : "c" (val));
>+#endif
> 	return crc;
> }
> 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
