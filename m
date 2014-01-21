Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaAUWXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:23:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:32795 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaAUWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:23:28 -0500
Message-ID: <52DEF366.6030105@windriver.com>
Date: Tue, 21 Jan 2014 17:23:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <kvm@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 12/73] powerpc: kvm e500/44x is not modular, so don't
 use module_init
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-13-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1390339396-3479-13-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-21 04:22 PM, Paul Gortmaker wrote:
> In powerpc, CONFIG_KVM is bool, and  so are these three subarch
> options, for the 44x and e500 variants.  This means that any
> module_exit() calls and functions used by them such as the
> kvmppc_booke_exit() are dead code.  Here we remove them.
> 
> In addition, rather than use module_init, which is just
> __initcall for non-modules, we update those as well.
> 
> Note that direct use of __initcall is discouraged, vs. one
> of the priority categorized subgroups.  As __initcall gets
> mapped onto device_initcall, our use of subsys_initcall (which
> seems to make sense for netfilter code) will thus change this

I've fixed the above --  s/netfilter/PPC KVM/

The risks of recycling commit logs...

Paul.
--

> registration from level 6-device to level 4-subsys (i.e. slightly
> earlier).
> 
> However no impact of that small difference is expected,
> since the arch independent kvm code doesn't trigger any init;
> it is the arch initcalls here which actually call kvm_init.
> 
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: kvm@vger.kernel.org
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  arch/powerpc/include/asm/kvm_ppc.h |  1 -
>  arch/powerpc/kvm/44x.c             | 10 +---------
>  arch/powerpc/kvm/booke.c           |  6 ------
>  arch/powerpc/kvm/e500.c            | 10 +---------
>  arch/powerpc/kvm/e500mc.c          | 10 +---------
>  5 files changed, 3 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index c8317fb..8466df5 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -109,7 +109,6 @@ extern void kvmppc_core_flush_tlb(struct kvm_vcpu *vcpu);
>  extern int kvmppc_core_check_requests(struct kvm_vcpu *vcpu);
>  
>  extern int kvmppc_booke_init(void);
> -extern void kvmppc_booke_exit(void);
>  
>  extern void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu);
>  extern int kvmppc_kvm_pv(struct kvm_vcpu *vcpu);
> diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
> index 93221e8..2129fc1 100644
> --- a/arch/powerpc/kvm/44x.c
> +++ b/arch/powerpc/kvm/44x.c
> @@ -222,12 +222,4 @@ static int __init kvmppc_44x_init(void)
>  err_out:
>  	return r;
>  }
> -
> -static void __exit kvmppc_44x_exit(void)
> -{
> -	kvmppc_pr_ops = NULL;
> -	kvmppc_booke_exit();
> -}
> -
> -module_init(kvmppc_44x_init);
> -module_exit(kvmppc_44x_exit);
> +subsys_initcall(kvmppc_44x_init);
> diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
> index 0591e05..49dffa2 100644
> --- a/arch/powerpc/kvm/booke.c
> +++ b/arch/powerpc/kvm/booke.c
> @@ -1995,9 +1995,3 @@ int __init kvmppc_booke_init(void)
>  #endif /* !BOOKE_HV */
>  	return 0;
>  }
> -
> -void __exit kvmppc_booke_exit(void)
> -{
> -	free_pages(kvmppc_booke_handlers, VCPU_SIZE_ORDER);
> -	kvm_exit();
> -}
> diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
> index 497b142..115ef12 100644
> --- a/arch/powerpc/kvm/e500.c
> +++ b/arch/powerpc/kvm/e500.c
> @@ -564,12 +564,4 @@ static int __init kvmppc_e500_init(void)
>  err_out:
>  	return r;
>  }
> -
> -static void __exit kvmppc_e500_exit(void)
> -{
> -	kvmppc_pr_ops = NULL;
> -	kvmppc_booke_exit();
> -}
> -
> -module_init(kvmppc_e500_init);
> -module_exit(kvmppc_e500_exit);
> +subsys_initcall(kvmppc_e500_init);
> diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
> index 4132cd2..612c216 100644
> --- a/arch/powerpc/kvm/e500mc.c
> +++ b/arch/powerpc/kvm/e500mc.c
> @@ -382,12 +382,4 @@ static int __init kvmppc_e500mc_init(void)
>  err_out:
>  	return r;
>  }
> -
> -static void __exit kvmppc_e500mc_exit(void)
> -{
> -	kvmppc_pr_ops = NULL;
> -	kvmppc_booke_exit();
> -}
> -
> -module_init(kvmppc_e500mc_init);
> -module_exit(kvmppc_e500mc_exit);
> +subsys_initcall(kvmppc_e500mc_init);
> 
