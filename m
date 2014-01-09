Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaAIKuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:50:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42778 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbaAIKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:50:14 -0500
Date: Thu, 9 Jan 2014 10:49:43 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/7] ARM: perf_event: Support percpu irqs for the CPU PMU
Message-ID: <20140109104943.GB17838@mudshark.cambridge.arm.com>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389221984-10973-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 08, 2014 at 10:59:39PM +0000, Stephen Boyd wrote:
> Some CPU PMUs are wired up with one PPI for all the CPUs instead
> of with a different SPI for each CPU. Add support for these
> devices.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/kernel/perf_event_cpu.c | 107 +++++++++++++++++++++++++++++----------
>  1 file changed, 79 insertions(+), 28 deletions(-)

[...]

> +static irq_handler_t cpu_handler;
> +
> +static irqreturn_t cpu_pmu_dispatch_irq(int irq, void *dev)
> +{
> +	struct arm_pmu *arm_pmu = *(struct arm_pmu **)dev;
> +	return cpu_handler(irq, arm_pmu);
> +}

I don't like this bit -- having a global cpu_handler field is going to
interfere with the big.LITTLE work and casting the per-cpu dev token is also
pretty hacky.

However, you're forced down this route by the need to invoke the armpmu IRQ
dispatcher. Now, that only exists as a workaround for the braindead
interrupt routing on the u8500 (they OR'd all the PMU SPIs together) -- it's
not a problem that will affect a system using PPIs. If you look, there is
only one use of the thing in: arch/arm/mach-ux500/cpu-db8500.c.

So, we could rename that callback to make it clear that it's not so much an
IRQ handler wrapper as a specific hack to deal with broken SPIs. Then the
cpu_pmu code can neglect to make the callback if it's using PPI.

What do you think?

Will
