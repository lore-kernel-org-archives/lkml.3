Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3KXNlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 08:41:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58371 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3KXNk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 08:40:59 -0500
Date: Sun, 24 Nov 2013 14:40:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Fix the hw_breakpoint range check
Message-ID: <20131124134057.GA4531@pd.tnic>
References: <1385289171-3411-1-git-send-email-fweisbec@gmail.com>
 <1385289171-3411-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385289171-3411-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 11:32:49AM +0100, Frederic Weisbecker wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> arch_check_bp_in_kernelspace() tries to avoid the overflow and does 2
> TASK_SIZE checks but it needs OR, not AND. Consider va = TASK_SIZE -1
> and len = 2 case.
> 
> Note: TASK_SIZE doesn't look right at least on x86, I think it should
> be replaced by TASK_SIZE_MAX.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Fixes: 0067f1297241ea567f2b22a455519752d70fcca9
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/hw_breakpoint.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index f66ff16..1131c1f 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
>  	va = info->address;
>  	len = get_hbp_len(info->len);
>  
> -	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
> +	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);

Well, can't you simplify it even further?

	return (va + len - 1) >= TASK_SIZE;

AFAICT, the high end of the range matters, no?

Unless the original code was meant to short-circuit at the first
comparison already...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
