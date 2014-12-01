Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaLAWLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:11:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLAWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:08:35 -0500
Date: Mon, 1 Dec 2014 16:57:25 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, gleb@kernel.org,
        pbonzini@redhat.com, kvm@vger.kernel.org
Cc: bp@suse.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on
 paravirt
Message-ID: <20141201215725.GG24289@laptop.dumpdata.com>
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 04:27:44PM -0500, Boris Ostrovsky wrote:
> Paravirtual guests are not expected to load microcode into processors
> and therefore it is not necessary to initialize microcode loading
> logic.

CC-ing the KVM folks since they use the paravirt interface too.
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
>  		return 0;
>  
>  	if (c->x86_vendor == X86_VENDOR_INTEL)
> -- 
> 1.7.1
> 
