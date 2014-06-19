Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbaFSLWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbaFSLWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:22:49 -0400
Message-ID: <53A2C7F9.8070700@redhat.com>
Date: Thu, 19 Jun 2014 13:22:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?gb18030?Q?=22newtongao=28=B8=DF=D0=A1=C3=F7=29=22?= 
	<gxm.linux.kernel@gmail.com>,
        gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix hyperv tsc page clear wrong address
References: <53A2BB7B.8070507@gmail.com> <53A2BC1A.4050702@gmail.com> <53A2C6B0.3090200@gmail.com>
In-Reply-To: <53A2C6B0.3090200@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=gb18030; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2014 13:17, "newtongao(¸ßÐ¡Ã÷)" ha scritto:
> This is more concisely
>
> From 6ddeb18347f9dda0fe37702e0d067a4129a89b54 Mon Sep 17 00:00:00 2001
> From: Xiaoming Gao <newtongao@tencent.com>
> Date: Thu, 19 Jun 2014 19:14:57 +0800
> Subject: [PATCH] kvm: fix hyperv tsc page clear wrong address
>
> tsc page addr need clear the low HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT bits
> before kvm_write_guest write the zero tsc_ref structure to guest, or it will lead
> guest to get wrong clocksource.
>
> windows guest will get strong impact, QueryPerformanceCounter will always return 0
> ,all things in windows rely on clock source, will in serious chaos.

Right, this can happen if Windows passes a non-zero page to KVM.

Thanks,

Paolo

> Signed-off-by: Xiaoming Gao <newtongao@tencnet.com>
> ---
>  arch/x86/kvm/x86.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f32a025..f644933 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1898,7 +1898,7 @@ static int set_msr_hyperv_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  		if (!(data & HV_X64_MSR_TSC_REFERENCE_ENABLE))
>  			break;
>  		gfn = data >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
> -		if (kvm_write_guest(kvm, data,
> +		if (kvm_write_guest(kvm, gfn << HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT,
>  			&tsc_ref, sizeof(tsc_ref)))
>  			return 1;
>  		mark_page_dirty(kvm, gfn);
>

