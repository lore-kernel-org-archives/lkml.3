Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaBXV4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:56:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaBXV4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:56:38 -0500
Date: Mon, 24 Feb 2014 18:15:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] x86: kvm: fix unstable_tsc boot
Message-ID: <20140224211524.GC22025@amt.cnet>
References: <1393256549-7743-1-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393256549-7743-1-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:42:29PM +0100, Andrew Jones wrote:
> When the tsc is marked unstable on the host it causes global clock
> updates to be requested each time a vcpu is loaded, nearly halting
> all progress on guests with a large number of vcpus.
> 
> Fix this by only requesting a local clock update unless the vcpu
> is migrating to another cpu.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6530019116b0d..ea716a162b4a3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2781,15 +2781,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  						vcpu->arch.last_guest_tsc);
>  			kvm_x86_ops->write_tsc_offset(vcpu, offset);
>  			vcpu->arch.tsc_catchup = 1;
> +			set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
>  		}
> +	}
> +
> +	if (unlikely(vcpu->cpu != cpu)) {
>  		/*
>  		 * On a host with synchronized TSC, there is no need to update
>  		 * kvmclock on vcpu->cpu migration
>  		 */
>  		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
>  			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
> -		if (vcpu->cpu != cpu)
> -			kvm_migrate_timers(vcpu);
> +		kvm_migrate_timers(vcpu);
>  		vcpu->cpu = cpu;
>  	}
>  
> -- 
> 1.8.1.4

Consider VCPU1 not doing kvm_arch_vcpu_load (guest not executing HLT,
not switching VCPUs, no exits to QEMU).

VCPU0 doing kvm_arch_vcpu_load (guest executing HLT, say).

The updates on VCPU0 must generate updates on VCPU1 as well, otherwise
NTP correction applies to VCPU0 but not VCPU1.

