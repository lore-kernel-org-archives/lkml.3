Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbaJVLCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:02:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37687 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932458AbaJVLCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:02:12 -0400
Date: Wed, 22 Oct 2014 12:01:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "yuichi.kusakabe@jp.fujitsu.com" <yuichi.kusakabe@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] ARM: perf: armv7: wrap unsupported arch init
 functions via micro
Message-ID: <20141022110128.GE22642@leverpostej>
References: <1413966107-11881-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
 <1413966107-11881-2-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413966107-11881-2-git-send-email-chaiw.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 22, 2014 at 09:21:47AM +0100, chai wen wrote:
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
> ---
>  arch/arm/kernel/perf_event_v7.c |   52 +++++++++-----------------------------
>  1 files changed, 13 insertions(+), 39 deletions(-)

I'm currently in the process of decoupling perf_event_{xscale,v6,v7}.c,
which will result in the removal of these stubs and for the ARMv7,
ARMv6, and XScale perf backends.

I haven't yet posted all the patches, but the basic idea is to make the
arm_pmu code stateless and turn it into a library used by each of the
three backends mentioned above. Each would have their own pmu_probe_info
table (introduced in [1]), and would support the platform device IDs
introduced in commit 253d8c3d2518ca6f (arm: perf: add more specific
platform device IDs). The stubs would no longer be necessary.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/295822.html

Thanks,
Mark.

> 
> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
> index f66a9b8..6c088e8 100644
> --- a/arch/arm/kernel/perf_event_v7.c
> +++ b/arch/arm/kernel/perf_event_v7.c
> @@ -1459,43 +1459,17 @@ static int krait_pmu_init(struct arm_pmu *cpu_pmu)
>  	return 0;
>  }
>  #else
> -static inline int armv7_a8_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int armv7_a9_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int armv7_a5_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int armv7_a15_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int armv7_a7_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int armv7_a12_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int armv7_a17_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> -
> -static inline int krait_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	return -ENODEV;
> -}
> +#define WRAP_UNSUPPORTED_INIT(__FUNC)                           \
> +static inline int __FUNC(struct arm_pmu *cpu_pmu)               \
> +{                                                               \
> +        return -ENODEV;                                         \
> +}
> +WRAP_UNSUPPORTED_INIT(armv7_a8_pmu_init);
> +WRAP_UNSUPPORTED_INIT(armv7_a9_pmu_init);
> +WRAP_UNSUPPORTED_INIT(armv7_a5_pmu_init);
> +WRAP_UNSUPPORTED_INIT(armv7_a15_pmu_init);
> +WRAP_UNSUPPORTED_INIT(armv7_a7_pmu_init);
> +WRAP_UNSUPPORTED_INIT(armv7_a12_pmu_init);
> +WRAP_UNSUPPORTED_INIT(armv7_a17_pmu_init);
> +WRAP_UNSUPPORTED_INIT(krait_pmu_init);
>  #endif	/* CONFIG_CPU_V7 */
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
