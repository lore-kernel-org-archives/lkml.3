Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3LCNun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:50:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48620 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295Ab3LCNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:50:42 -0500
Date: Tue, 3 Dec 2013 13:50:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH V6 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131203135002.GJ1169@mudshark.cambridge.arm.com>
References: <1385976843-13280-1-git-send-email-vkale@apm.com>
 <1385976843-13280-3-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385976843-13280-3-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:34:03AM +0000, Vinayak Kale wrote:
>  static void
> +armpmu_disable_percpu_irq(void *data)
> +{
> +	struct arm_pmu *armpmu = data;
> +	struct platform_device *pmu_device = armpmu->plat_device;
> +	int irq = platform_get_irq(pmu_device, 0);
> +
> +	cpumask_test_and_clear_cpu(smp_processor_id(), &armpmu->active_irqs);

Why not just cpumask_clear_cpu?

> +	disable_percpu_irq(irq);
> +}
> +
> +static void
>  armpmu_release_hardware(struct arm_pmu *armpmu)
>  {
> -	int i, irq, irqs;
> +	int irq;
> +	unsigned int i, irqs;
>  	struct platform_device *pmu_device = armpmu->plat_device;
>  
>  	irqs = min(pmu_device->num_resources, num_possible_cpus());
> +	if (!irqs)
> +		return;
>  
> -	for (i = 0; i < irqs; ++i) {
> -		if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
> -			continue;
> -		irq = platform_get_irq(pmu_device, i);
> -		if (irq >= 0)
> -			free_irq(irq, armpmu);
> +	irq = platform_get_irq(pmu_device, 0);
> +	if (irq <= 0)
> +		return;
> +
> +	if (irq_is_percpu(irq)) {
> +		on_each_cpu(armpmu_disable_percpu_irq, armpmu, 1);
> +		free_percpu_irq(irq, &cpu_hw_events);
> +	} else {
> +		for (i = 0; i < irqs; ++i) {
> +			if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
> +				continue;
> +			irq = platform_get_irq(pmu_device, i);
> +			if (irq > 0)
> +				free_irq(irq, armpmu);
> +		}
>  	}
>  }
>  
> +static void
> +armpmu_enable_percpu_irq(void *data)
> +{
> +	struct arm_pmu *armpmu = data;
> +	struct platform_device *pmu_device = armpmu->plat_device;
> +	int irq = platform_get_irq(pmu_device, 0);
> +
> +	enable_percpu_irq(irq, IRQ_TYPE_NONE);
> +	cpumask_set_cpu(smp_processor_id(), &armpmu->active_irqs);

Hmm, wouldn't it make more sense to pass the irq in data, then deal with the
mask in the caller? (since the mask will *always* be updated by each CPU).

Similarly for the disable path.

Will
