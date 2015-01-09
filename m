Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbbAIKkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43129 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766AbbAIKki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:40:38 -0500
Date: Fri, 9 Jan 2015 11:40:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86_64,entry: Use sysret to return to userspace when
 possible
Message-ID: <20150109104035.GA13637@pd.tnic>
References: <cover.1415403984.git.luto@amacapital.net>
 <49394403b8b12486a6b9c9c70b72bd9f5dce7364.1415403984.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49394403b8b12486a6b9c9c70b72bd9f5dce7364.1415403984.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 03:58:18PM -0800, Andy Lutomirski wrote:
> +	/*
> +	 * Try to use SYSRET instead of IRET if we're returning to
> +	 * a completely clean 64-bit userspace context.
> +	 */
> +	movq (RCX-R11)(%rsp), %rcx
> +	cmpq %rcx,(RIP-R11)(%rsp)		/* RCX == RIP */
> +	jne opportunistic_sysret_failed
> +
> +	/*
> +	 * On Intel CPUs, sysret with non-canonical RCX/RIP will #GP
> +	 * in kernel space.  This essentially lets the user take over
> +	 * the kernel, since userspace controls RSP.  It's not worth
> +	 * testing for canonicalness exactly -- this check detects any
> +	 * of the 17 high bits set, which is true for non-canonical
> +	 * or kernel addresses.  (This will pessimize vsyscall=native.
> +	 * Big deal.)
> +	 */
> +	shr $47, %rcx
> +	jnz opportunistic_sysret_failed
> +
> +	cmpq $__USER_CS,(CS-R11)(%rsp)		/* CS must match SYSRET */
> +	jne opportunistic_sysret_failed
> +
> +	movq (R11-R11)(%rsp), %r11
> +	cmpq %r11,(EFLAGS-R11)(%rsp)		/* R11 == RFLAGS */
> +	jne opportunistic_sysret_failed
> +
> +	testq $X86_EFLAGS_RF,%r11		/* sysret can't restore RF */
> +	jnz opportunistic_sysret_failed
> +
> +	/* nothing to check for RSP */
> +
> +	cmpq $__USER_DS,(SS-R11)(%rsp)		/* SS must match SYSRET */
> +	jne opportunistic_sysret_failed

Btw, Denys' R11->ARGOFFSET fix makes sense here too - using ARGOFFSET
instead of R11 would make this here clearer.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
