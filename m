Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbbANSop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:44:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbbANSoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:44:44 -0500
Date: Wed, 14 Jan 2015 19:43:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 08/11] x86,fpu: restore user FPU state lazily after
	__kernel_fpu_end
Message-ID: <20150114184343.GA17640@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-9-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-9-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -89,13 +89,11 @@ void __kernel_fpu_end(void)
>  	if (use_eager_fpu()) {
>  		/*
>  		 * For eager fpu, most the time, tsk_used_math() is true.
> -		 * Restore the user math as we are done with the kernel usage.
> -		 * At few instances during thread exit, signal handling etc,
> -		 * tsk_used_math() is false. Those few places will take proper
> -		 * actions, so we don't need to restore the math here.
> +		 * Make sure the user math state is restored on return to
> +		 * userspace.
>  		 */
>  		if (likely(tsk_used_math(current)))
> -			math_state_restore();
> +			set_thread_flag(TIF_LOAD_FPU);

Hmm. And this looks obviously wrong if interrupted_user_mode().

Oleg.

