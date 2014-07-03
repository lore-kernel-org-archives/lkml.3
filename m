Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaGCCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:16:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:17535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbaGCCQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:16:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,592,1400050800"; 
   d="scan'208";a="564477430"
Date: Wed, 2 Jul 2014 19:16:06 -0700
From: Andi Kleen <ak@linux.intel.com>
To: kan.liang@intel.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [PATCH V2 1/3] perf ignore LBR and offcore_rsp.
Message-ID: <20140703021606.GT19781@tassilo.jf.intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I did not contribute to this patch, so please remove that SOB.

> Signed-off-by: Kan Liang <kan.liang@intel.com>

>  	struct extra_reg *extra_regs;
>  	unsigned int er_flags;
> +	bool		extra_msr_access;	   /* EXTRA REG MSR can be accessed */
>  

This doesn't look right, needs a flag for each extra register.

They are completely unrelated to each other.

BTW this will also cause KVM messages at each boot now.

>  		wrmsrl(hwc->extra_reg.reg, hwc->extra_reg.config);
>  	wrmsrl(hwc->config_base, (hwc->config | enable_mask) & ~disable_mask);
>  }
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index adb02aa..8011d42 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2565,6 +2565,13 @@ __init int intel_pmu_init(void)
>  		}
>  	}
>  
> +	/* Access LBR MSR may cause #GP under certain circumstances. E.g. KVM doesn't support LBR MSR */
> +	if (x86_pmu.lbr_nr)
> +		x86_pmu.lbr_msr_access = test_msr_access(x86_pmu.lbr_tos) & test_msr_access(x86_pmu.lbr_from);

s/&/&&/

And also this doesn't cover the case when someone takes over the LBRs and they start #GPing later.
So for LBR the test has to be still at each access.

-Andi
