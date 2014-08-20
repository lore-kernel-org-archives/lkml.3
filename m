Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaHTQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:16:26 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39213 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHTQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:16:24 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 07/19] ARM64 / ACPI: Parse MADT to map logical cpu to
 MPIDR and get cpu_possible/present_map
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
In-Reply-To: <1406206825-15590-8-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
	<1406206825-15590-8-git-send-email-hanjun.guo@linaro.org>
Date: Wed, 20 Aug 2014 10:14:37 -0500
Message-Id: <20140820151437.91964C41290@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014 21:00:13 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> MADT contains the information for MPIDR which is essential for
> SMP initialization, parse the GIC cpu interface structures to
> get the MPIDR value and map it to cpu_logical_map(), and add
> enabled cpu with valid MPIDR into cpu_possible_map and
> cpu_present_map.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
> +	/* If it is the first CPU, no need to check duplicate MPIDRs */
> +	if (!enabled_cpus)
> +		goto skip_mpidr_check;
> +
> +	/*
> +	 * Duplicate MPIDRs are a recipe for disaster. Scan
> +	 * all initialized entries and check for
> +	 * duplicates. If any is found just ignore the CPU.
> +	 */
> +	for_each_present_cpu(cpu) {
> +		if (cpu_logical_map(cpu) == mpidr) {
> +			pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
> +			       mpidr);
> +			return -EINVAL;
> +		}
> +	}
> +
> +skip_mpidr_check:
> +	enabled_cpus++;

So, this hunk is embarrasing. The goto is completely unnecessary and the
whole for_each_present_cpu() block can be inside an
"if (enabled_cpus) { ... }" block. A goto is just nasty.

That said, is the if even necessary? Will for_each_present_cpu() iterate
over anything if it is processing the first cpu? (I don't actually know
the answer here, I did a quick look but not enough to get an
authoritative answer).

g.
