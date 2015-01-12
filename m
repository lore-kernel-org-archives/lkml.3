Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbbALTXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:23:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34458 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbbALTXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:23:20 -0500
Date: Mon, 12 Jan 2015 20:23:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
Message-ID: <20150112192314.GF3904@pd.tnic>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:07:35AM +0100, Denys Vlasenko wrote:
> Sequences
>         pushl_cfi %reg
>         CFI_REL_OFFSET reg, 0
> and
>         popl_cfi %reg
>         CFI_RESTORE reg
> happen quite often. This patch adds macros which generate them.
> 
> No assembly changes (verified with objdump -dr vmlinux.o).

...

> diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
> index f6f1598..de1cdaf 100644
> --- a/arch/x86/include/asm/dwarf2.h
> +++ b/arch/x86/include/asm/dwarf2.h
> @@ -86,11 +86,23 @@
>  	CFI_ADJUST_CFA_OFFSET 8
>  	.endm
>  
> +	.macro pushq_cfi_reg reg
> +	pushq %\reg
> +	CFI_ADJUST_CFA_OFFSET 8
> +	CFI_REL_OFFSET \reg, 0
> +	.endm

What's wrong with adding the CFI_REL_OFFSET to the pushl/popl_cfi macro
and not add two new _reg macros?

I.e., have the _cfi macros add all the CFI annotations needed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
