Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaJPPtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:49:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60608 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaJPPtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:49:11 -0400
Date: Thu, 16 Oct 2014 17:49:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 3/5] x86: Add a comment clarifying LDT context switching
Message-ID: <20141016154914.GD30314@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net>
 <93ffc13d9e829f3ded9776fec62385bccb7439e1.1413323612.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <93ffc13d9e829f3ded9776fec62385bccb7439e1.1413323612.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:57:37PM -0700, Andy Lutomirski wrote:
> The code is correct, but only for a rather subtle reason.  This
> confused me for quite a while when I read switch_mm, so clarify the
> code to avoid confusing other people, too.
> 
> TBH, I wouldn't be surprised if this code was only correct by
> accident.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/include/asm/mmu_context.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> index 166af2a8e865..04478103df37 100644
> --- a/arch/x86/include/asm/mmu_context.h
> +++ b/arch/x86/include/asm/mmu_context.h
> @@ -53,7 +53,16 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>  		/* Stop flush ipis for the previous mm */
>  		cpumask_clear_cpu(cpu, mm_cpumask(prev));
>  
> -		/* Load the LDT, if the LDT is different: */
> +		/*
> +		 * Load the LDT, if the LDT is different.
> +		 *
> +		 * It's possible leave_mm(prev) has been called.  If so,
> +		 * then prev->context.ldt could be out of sync with the
> +		 * LDT descriptor or the LDT register.  This can only happen

I'm staring at the code and trying to figure out where on the leave_mm()
path this could happen. Got any code pointers?

:-)

> +		 * if prev->context.ldt is non-null, since we never free
> +		 * an LDT.  But LDTs can't be shared across mms, so
> +		 * prev->context.ldt won't be equal to next->context.ldt.
> +		 */
>  		if (unlikely(prev->context.ldt != next->context.ldt))
>  			load_LDT_nolock(&next->context);
>  	}
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.
--
