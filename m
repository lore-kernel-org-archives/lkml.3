Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab3GZUTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:19:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50606 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab3GZUTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:19:43 -0400
Message-ID: <51F2D9D2.8050405@zytor.com>
Date: Fri, 26 Jul 2013 13:19:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-stable <stable@vger.kernel.org>, stable@vger.kernel.org,
        hpa@linux.intel.com, hjl.tools@gmail.com
CC: mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        "tip-bot for H.J. Lu" <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86, fpu: correct the asm constraints for fxsave
 , unbreak mxcsr.daz
References: <tip-eaa5a990191d204ba0f9d35dbe5505ec2cdd1460@git.kernel.org>
In-Reply-To: <tip-eaa5a990191d204ba0f9d35dbe5505ec2cdd1460@git.kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I have tagged this one for -stable, but it is a definite "maybe", so I
wanted to:

a) qualify that tagging, and
b) perhaps use it as a boundary case for policy clarification.

This patch is an old bug, an incorrect assembly constraint, but as
happens with this type of bug it is being exposed by a change in gcc.
Therefore, although this is neither a regression per se in the kernel
nor in gcc, it is a regression in the combined output.

The bug is obvious; the fix at the very least *should* be obvious; the
main source of risk would appear that it might trigger bugs in very old
versions of gcc.

The gain is less inherently obvious: currently the only MXCSR bit
affected is DAZ, although this also affects any future MXCSR bits.  Most
users do not care about DAZ, but the ones that do generally care *a lot*
about it as their applications may suffer very bad performance otherwise.

There is a kernel bugzilla for this:

	https://bugzilla.kernel.org/show_bug.cgi?id=60633

... but it doesn't really add any additional information.

	-hpa

On 07/26/2013 09:19 AM, tip-bot for H.J. Lu wrote:
> Commit-ID:  eaa5a990191d204ba0f9d35dbe5505ec2cdd1460
> Gitweb:     http://git.kernel.org/tip/eaa5a990191d204ba0f9d35dbe5505ec2cdd1460
> Author:     H.J. Lu <hjl.tools@gmail.com>
> AuthorDate: Fri, 26 Jul 2013 09:11:56 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 26 Jul 2013 09:11:56 -0700
> 
> x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz
> 
> GCC will optimize mxcsr_feature_mask_init in arch/x86/kernel/i387.c:
> 
> 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
> 		asm volatile("fxsave %0" : : "m" (fx_scratch));
> 		mask = fx_scratch.mxcsr_mask;
> 		if (mask == 0)
> 			mask = 0x0000ffbf;
> 
> to
> 
> 		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
> 		asm volatile("fxsave %0" : : "m" (fx_scratch));
> 		mask = 0x0000ffbf;
> 
> since asm statement doesn’t say it will update fx_scratch.  As the
> result, the DAZ bit will be cleared.  This patch fixes it. This bug
> dates back to at least kernel 2.6.12.
> 
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/kernel/i387.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 202d24f..5d576ab 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -116,7 +116,7 @@ static void mxcsr_feature_mask_init(void)
>  
>  	if (cpu_has_fxsr) {
>  		memset(&fx_scratch, 0, sizeof(struct i387_fxsave_struct));
> -		asm volatile("fxsave %0" : : "m" (fx_scratch));
> +		asm volatile("fxsave %0" : "+m" (fx_scratch));
>  		mask = fx_scratch.mxcsr_mask;
>  		if (mask == 0)
>  			mask = 0x0000ffbf;
> 

