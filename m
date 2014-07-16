Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaGPL2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:28:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51380 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720AbaGPL2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:28:12 -0400
Message-ID: <53C661CB.7040306@arm.com>
Date: Wed, 16 Jul 2014 12:28:11 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: Sudeep Holla <sudeep.holla@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.brown@linaro.org" <mark.brown@linaro.org>,
        "tixy@linaro.org" <tixy@linaro.org>
Subject: Re: [PATCH] vexpress/spc: fix a build warning on array bounds
References: <1405509716-19591-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1405509716-19591-1-git-send-email-alex.shi@linaro.org>
X-OriginalArrivalTime: 16 Jul 2014 11:28:09.0832 (UTC) FILETIME=[05921E80:01CFA0E9]
X-MC-Unique: 114071612281007001
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 16/07/14 12:21, Alex Shi wrote:
> With ARCH_VEXPRESS_SPC option, kernel build has the following
> warning:
>
> arch/arm/mach-vexpress/spc.c: In function ‘ve_spc_clk_init’:
> arch/arm/mach-vexpress/spc.c:431:38: warning: array subscript is below array bounds [-Warray-bounds]
>    struct ve_spc_opp *opps = info->opps[cluster];
>                                        ^
> since 'cluster' maybe '-1' in UP system. This patch does a active
> checking to fix this issue.
>

Good catch, looks fine to me.

Acked-by: Sudeep Holla <sudeep.holla@arm.com>

> Signed-off-by: Alex Shi <alex.shi@linaro.org>
> ---
>   arch/arm/mach-vexpress/spc.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
> index c26ef5b..4833544 100644
> --- a/arch/arm/mach-vexpress/spc.c
> +++ b/arch/arm/mach-vexpress/spc.c
> @@ -426,9 +426,15 @@ static int ve_spc_populate_opps(uint32_t cluster)
>
>   static int ve_init_opp_table(struct device *cpu_dev)
>   {
> -	int cluster = topology_physical_package_id(cpu_dev->id);
> -	int idx, ret = 0, max_opp = info->num_opps[cluster];
> -	struct ve_spc_opp *opps = info->opps[cluster];
> +	int cluster;
> +	int idx, ret = 0, max_opp;
> +	struct ve_spc_opp *opps;
> +
> +	cluster = topology_physical_package_id(cpu_dev->id);
> +	cluster = cluster < 0 ? 0 : cluster;
> +
> +	max_opp = info->num_opps[cluster];
> +	opps = info->opps[cluster];
>
>   	for (idx = 0; idx < max_opp; idx++, opps++) {
>   		ret = dev_pm_opp_add(cpu_dev, opps->freq * 1000, opps->u_volt);
> @@ -537,6 +543,8 @@ static struct clk *ve_spc_clk_register(struct device *cpu_dev)
>   	spc->hw.init = &init;
>   	spc->cluster = topology_physical_package_id(cpu_dev->id);
>
> +	spc->cluster = spc->cluster < 0 ? 0 : spc->cluster;
> +
>   	init.name = dev_name(cpu_dev);
>   	init.ops = &clk_spc_ops;
>   	init.flags = CLK_IS_ROOT | CLK_GET_RATE_NOCACHE;
>

