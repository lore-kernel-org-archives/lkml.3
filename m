Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3JYLOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:14:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab3JYLOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:14:50 -0400
Date: Fri, 25 Oct 2013 13:13:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, zheng.z.yan@intel.com,
        bp@alien8.de
Subject: Re: [PATCH v3 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131025111359.GB1219@krava.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
 <1382533085-7166-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382533085-7166-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 02:58:04PM +0200, Stephane Eranian wrote:

SNIP

> +			pmu = per_cpu(rapl_pmu, i);
> +			if (pmu) {
> +				per_cpu(rapl_pmu, cpu) = pmu;
> +				atomic_inc(&pmu->refcnt);
> +			}
> +			continue;
> +		}
> +		rapl_cpu_prepare(cpu);
> +		cpumask_set_cpu(cpu, &rapl_cpu_mask);
> +	}
> +
> +	perf_cpu_notifier(rapl_cpu_notifier);

hum, this should be rather called below only if we succeed
with the perf_pmu_register

> +
> +	ret = perf_pmu_register(&rapl_pmu_class, "power", -1);
> +	WARN_ON(ret);
> +	if (!ret) {
> +		pr_info("RAPL PMU detected, registration failed, RAPL PMU disabled\n");
> +		put_online_cpus();
> +		return -1;
> +	}
> +
> +	pmu = __get_cpu_var(rapl_pmu);
> +
> +	pr_info("RAPL PMU detected, hw unit 2^-%d Joules,"
> +		" API unit is 2^-32 Joules,"
> +		" %d fixed counters\n",
> +		pmu->hw_unit,
> +		hweight32(rapl_cntr_mask));
> +
> +	put_online_cpus();
> +
> +	return 0;
> +}
> +device_initcall(rapl_pmu_init);
> -- 
> 1.7.9.5
> 
