Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab3LIQux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:50:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57419 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933883Ab3LIQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:50:51 -0500
Date: Mon, 9 Dec 2013 16:50:04 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH V7 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131209165003.GJ13908@mudshark.cambridge.arm.com>
References: <1386151791-4881-1-git-send-email-vkale@apm.com>
 <1386151791-4881-3-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386151791-4881-3-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinayak,

On Wed, Dec 04, 2013 at 10:09:51AM +0000, Vinayak Kale wrote:
> Add support for irq registration when pmu interrupt is percpu.

Getting closer...

> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> ---
>  arch/arm64/kernel/perf_event.c |  108 +++++++++++++++++++++++++++++-----------
>  1 file changed, 78 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index cea1594..d8e6667 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/bitmap.h>
>  #include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/export.h>
>  #include <linux/perf_event.h>
> @@ -363,26 +364,52 @@ validate_group(struct perf_event *event)
>  }
>  
>  static void
> +armpmu_disable_percpu_irq(void *data)
> +{
> +	disable_percpu_irq((long)data);
> +}

Given that we wait for the CPUs to finish enabling/disabling the IRQ, I
actually meant pass the pointer to the IRQ, which removes the horrible
casts in the caller.

> +	if (irq_is_percpu(irq)) {
> +		cpumask_clear(&armpmu->active_irqs);

Thanks for moving the mask manipulation out. It now makes it obvious that we
don't care about the mask at all for PPIs, so that can be removed (the code
you have is racy against hotplug anyway).

I took the liberty of writing a fixup for you (see below). Can you test it
on your platform please?

Cheers,

Will

--->8

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 503c1eeedc1c..5b1cd792274a 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -366,7 +366,8 @@ validate_group(struct perf_event *event)
 static void
 armpmu_disable_percpu_irq(void *data)
 {
-       disable_percpu_irq((long)data);
+       unsigned int irq = *(unsigned int *)data;
+       disable_percpu_irq(irq);
 }
 
 static void
@@ -385,8 +386,7 @@ armpmu_release_hardware(struct arm_pmu *armpmu)
                return;
 
        if (irq_is_percpu(irq)) {
-               cpumask_clear(&armpmu->active_irqs);
-               on_each_cpu(armpmu_disable_percpu_irq, (void *)(long)irq, 1);
+               on_each_cpu(armpmu_disable_percpu_irq, &irq, 1);
                free_percpu_irq(irq, &cpu_hw_events);
        } else {
                for (i = 0; i < irqs; ++i) {
@@ -402,7 +402,8 @@ armpmu_release_hardware(struct arm_pmu *armpmu)
 static void
 armpmu_enable_percpu_irq(void *data)
 {
-       enable_percpu_irq((long)data, IRQ_TYPE_NONE);
+       unsigned int irq = *(unsigned int *)data;
+       enable_percpu_irq(irq, IRQ_TYPE_NONE);
 }
 
 static int
@@ -440,8 +441,7 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
                        return err;
                }
 
-               on_each_cpu(armpmu_enable_percpu_irq, (void *)(long)irq, 1);
-               cpumask_setall(&armpmu->active_irqs);
+               on_each_cpu(armpmu_enable_percpu_irq, &irq, 1);
        } else {
                for (i = 0; i < irqs; ++i) {
                        err = 0;
