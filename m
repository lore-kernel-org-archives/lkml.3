Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaLAWBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:01:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbaLAWBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:01:02 -0500
Date: Mon, 1 Dec 2014 23:00:57 +0100
From: Borislav Petkov <bp@suse.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        david.vrabel@citrix.com, konrad.wilk@oracle.com
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on
 paravirt
Message-ID: <20141201220057.GC4730@pd.tnic>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 04:27:44PM -0500, Boris Ostrovsky wrote:
> Paravirtual guests are not expected to load microcode into processors
> and therefore it is not necessary to initialize microcode loading
> logic.
> 
> In fact, under certain circumstances initializing this logic may cause
> the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
> macro which does not work in Xen (the code path that leads to this macro
> happens during resume when we call mc_bp_resume()->load_ucode_ap()
> ->check_loader_disabled_ap())
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/kernel/cpu/microcode/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
> index 2ce9051..ebd232d 100644
> --- a/arch/x86/kernel/cpu/microcode/core.c
> +++ b/arch/x86/kernel/cpu/microcode/core.c
> @@ -557,7 +557,7 @@ static int __init microcode_init(void)
>  	struct cpuinfo_x86 *c = &cpu_data(0);
>  	int error;
>  
> -	if (dis_ucode_ldr)
> +	if (paravirt_enabled() || dis_ucode_ldr)

Ok, let me make sure I understand this correctly: The early path doesn't
get executed on paravirt, i.e. the path along load_ucode_intel_ap()?

And you want to avoid loading of the microcode driver because the only
path we come to load_ucode_ap() on paravirt is the hotplug notifier?

Btw, we've applied another fix today for 3.18 final which limits the
microcode reloading to 64-bit only:

http://git.kernel.org/tip/02ecc41abcea4ff9291d548f6f846b29b354ddd2

which should accidentally fix the paravirt issue too, no?

Because if so, I'd like to delay your patch for the 3.19 merge window
unless absolutely necessary.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
