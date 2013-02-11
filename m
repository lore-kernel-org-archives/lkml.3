Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3BKPu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:50:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645Ab3BKPuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:50:25 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1360592538-10643-4-git-send-email-bp@alien8.de>
References: <1360592538-10643-1-git-send-email-bp@alien8.de> <1360592538-10643-4-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/4] x86, head_32: Remove second CPUID detection from default_entry
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 11 Feb 2013 07:49:14 -0800
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Message-ID: <18557aed-383a-4454-8222-3d2c0f0a78be@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about CPUs with inconsistent cpuid levels?  Yes, they can and do happen, as we discussed on IRC.

Borislav Petkov <bp@alien8.de> wrote:

>From: Borislav Petkov <bp@suse.de>
>
>We do that once earlier now and cache it into new_cpu_data.cpuid_level
>so no need for the EFLAGS.ID toggling dance anymore.
>
>Signed-off-by: Borislav Petkov <bp@suse.de>
>---
> arch/x86/kernel/head_32.S | 17 ++++-------------
> 1 file changed, 4 insertions(+), 13 deletions(-)
>
>diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>index 73e084a6d2c5..e893ac09ca03 100644
>--- a/arch/x86/kernel/head_32.S
>+++ b/arch/x86/kernel/head_32.S
>@@ -410,18 +410,7 @@ default_entry:
> /*
>  * Check if it is 486
>  */
>-	movl $-1,X86_CPUID	# -1 for no CPUID initially
>-	movb $4,X86		# at least 486
>-	pushfl			# push EFLAGS
>-	popl %eax		# get EFLAGS
>-	movl %eax,%ecx		# save original EFLAGS
>-	xorl $0x200000,%eax	# flip ID bit in EFLAGS
>-	pushl %eax		# copy to EFLAGS
>-	popfl			# set EFLAGS
>-	pushfl			# get new EFLAGS
>-	popl %eax		# put it in eax
>-	xorl %ecx,%eax		# change in flags
>-	testl $0x200000,%eax	# check if ID bit changed
>+	cmpl $-1,X86_CPUID
> 	je is486
> 
> 	/* get vendor info */
>@@ -447,7 +436,9 @@ default_entry:
> 	movb %cl,X86_MASK
> 	movl %edx,X86_CAPABILITY
> 
>-is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
>+is486:
>+	movb $4,X86
>+	movl $0x50022,%ecx	# set AM, WP, NE and MP
> 	movl %cr0,%eax
> 	andl $0x80000011,%eax	# Save PG,PE,ET
> 	orl %ecx,%eax

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
