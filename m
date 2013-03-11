Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3CKRKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:10:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48331 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3CKRKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:10:18 -0400
Message-ID: <513E0FF6.1050909@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:10:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, ldewangan@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: tegra: fuse: export chip id and revision
References: <1363005441-26329-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363005441-26329-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 06:37 AM, Danny Huang wrote:
> Expose tegra chip id and revision in /proc/cpu/chipinfo for user mode
> usage.

I agree with Shawn's comments, but I have a few other comments here too
for the record.

Nit: "Tegra" and "ID" above should be capitalized as I've done so in
this sentence.

> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c

> +static int __init tegra_chip_info(void)
> +{
> +	proc_entry = create_proc_entry("cpu/chipinfo", S_IRUGO, NULL);
> +	if (proc_entry)
> +		proc_entry->read_proc = show_chip_info;
> +	return 0;
> +}
> +
> +late_initcall(tegra_chip_info);

Please don't introduce any more initcalls. Especially initcalls that are
not conditional on the run-time (rather than compile-time) SoC. This
code may be compiled into a kernel that supports SoCs other than Tegra.
However, tegra_chip_info() shouldn't run on those SoCs.

It'd probably be simplest to just perform this initialization as part of
the already-existing tegra_init_fuse(). If not, please call this
initialization function from one of the initialization functions in
arch/arm/mach-tegra/common.c. Both those cases only execute on Tegra.
