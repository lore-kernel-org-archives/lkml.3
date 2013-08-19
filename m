Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3HSNLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:11:18 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:54138 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3HSNLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:11:16 -0400
Message-ID: <5212196F.4060708@gmail.com>
Date: Mon, 19 Aug 2013 08:11:11 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Jonas Bonn <jonas@southpole.se>,
        Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH v2 4/4] of: move of_get_cpu_node implementation to
 DT core library
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376674791-28244-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1376674791-28244-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 12:39 PM, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This patch moves the generalized implementation of of_get_cpu_node from
> PowerPC to DT core library, thereby adding support for retrieving cpu
> node for a given logical cpu index on any architecture.
> 
> The CPU subsystem can now use this function to assign of_node in the
> cpu device while registering CPUs.
> 
> It is recommended to use these helper function only in pre-SMP/early
> initialisation stages to retrieve CPU device node pointers in logical
> ordering. Once the cpu devices are registered, it can be retrieved easily
> from cpu device of_node which avoids unnecessary parsing and matching.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

[snip]

> +/**
> + * of_get_cpu_node - Get device node associated with the given logical CPU
> + *
> + * @cpu: CPU number(logical index) for which device node is required
> + * @thread: if not NULL, local thread number within the physical core is
> + *          returned
> + *
> + * The main purpose of this function is to retrieve the device node for the
> + * given logical CPU index. It should be used to initialize the of_node in
> + * cpu device. Once of_node in cpu device is populated, all the further
> + * references can use that instead.
> + *
> + * CPU logical to physical index mapping is architecture specific and is built
> + * before booting secondary cores. This function uses arch_match_cpu_phys_id
> + * which can be overridden by architecture specific implementation.
> + *
> + * Returns a node pointer for the logical cpu if found, else NULL.
> + */
> +struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
> +{
> +	struct device_node *cpun, *cpus;
> +
> +	cpus = of_find_node_by_path("/cpus");
> +	if (!cpus) {
> +		pr_warn("Missing cpus node, bailing out\n");
> +		return NULL;
> +	}
> +
> +	for_each_child_of_node(cpus, cpun) {
> +		if (of_node_cmp(cpun->type, "cpu"))
> +			continue;
> +#ifdef CONFIG_PPC

You don't really need this ifdef as this function should never succeed
on other arches. Alternatively, you can use "IS_ENABLED(CONFIG_PPC)"
instead.

Otherwise,

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

