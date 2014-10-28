Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaJ1R5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:57:45 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36177 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaJ1R5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:57:44 -0400
X-Originating-IP: 173.246.103.110
Date: Tue, 28 Oct 2014 10:57:38 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [PATCH 3/3] x86_64,vsyscall: Make vsyscall emulation configurable
Message-ID: <20141028174629.GA2150@jtriplet-mobl1>
References: <cover.1414516558.git.luto@amacapital.net>
 <6b0c9b0fc128de68634c730a5b1a80e1d085ad02.1414516558.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b0c9b0fc128de68634c730a5b1a80e1d085ad02.1414516558.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:22:28AM -0700, Andy Lutomirski wrote:
> This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
> Turning it off completely disables vsyscall emulation, saving ~3.5k
> for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
> page), some tiny amount of core mm code that supports a gate area,
> and possibly 4k for a wasted pagetable.  The latter is because the
> vsyscall addresses are misaligned and fit poorly in the fixmap.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

One minor nit below, but with or without that change,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1456,11 +1456,13 @@ static int xen_pgd_alloc(struct mm_struct *mm)
>  		user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
>  		page->private = (unsigned long)user_pgd;
>  
> +#ifdef CONFIG_X86_VSYSCALL_EMULATION
>  		if (user_pgd != NULL) {
>  			user_pgd[pgd_index(VSYSCALL_ADDR)] =
>  				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
>  			ret = 0;
>  		}
> +#endif

Could you instead make the if use IS_ENABLED?

		if (IS_ENABLED(CONFIG_X86_VSYSCALL_EMULATION) && user_pgd != NULL)

That has the advantage of ensuring that the code continues to compile.
(Given that you haven't removed level3_user_vsyscall, that should work.)

- Josh Triplett
