Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab3GXM5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:57:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56841 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3GXM5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:57:11 -0400
Date: Wed, 24 Jul 2013 14:57:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86, microcode: Don't lose error returns in
 save_microcode_in_initrd()
Message-ID: <20130724125703.GD30777@pd.tnic>
References: <20130723225923.352bc442@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723225923.352bc442@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:59:23PM +0200, Torsten Kaiser wrote:
> Don't lose the error return.
> This was lost when early amd microcode loading was added in
> 757885e94a22bcc82beb9b1445c95218cb20ceab
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> --- a/arch/x86/kernel/microcode_core_early.c	2013-07-23 19:44:05.509516795 +0200
> +++ b/arch/x86/kernel/microcode_core_early.c	2013-07-23 19:58:34.459509474 +0200
> @@ -127,11 +127,11 @@ int __init save_microcode_in_initrd(void
>  	switch (c->x86_vendor) {
>  	case X86_VENDOR_INTEL:
>  		if (c->x86 >= 6)
> -			save_microcode_in_initrd_intel();
> +			return save_microcode_in_initrd_intel();
>  		break;
>  	case X86_VENDOR_AMD:
>  		if (c->x86 >= 0x10)
> -			save_microcode_in_initrd_amd();
> +			return save_microcode_in_initrd_amd();

This one is incomplete: if we really want to hand up the error code, we
need to add a printk to the caller free_initrd_mem() saying that saving
of microcode from the initrd failed.

However, save_microcode_in_initrd_intel() already warns about it in the
error case.

So, actually, I think the warning should be issued by
save_microcode_in_initrd() and this function itself should be made to
return void. And save_microcode_in_initrd_intel() can simply return the
error code without doing the printk.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
