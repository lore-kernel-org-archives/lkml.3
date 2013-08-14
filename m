Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab3HNVkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:40:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38167 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab3HNVkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:40:35 -0400
Message-ID: <520BF94F.60907@wwwdotorg.org>
Date: Wed, 14 Aug 2013 15:40:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        gnurou@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] ARM: tegra: set CPU reset handler with firmware
 op
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com> <1376360992-1508-5-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1376360992-1508-5-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 08:29 PM, Alexandre Courbot wrote:
> Use a firmware operation to set the CPU reset handler and only resort to
> doing it ourselves if there is none defined.
> 
> This supports the booting of secondary CPUs on devices using a TrustZone
> secure monitor.

> diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c

> +	err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
> +	switch (err) {
> +	case -ENOSYS:
> +		tegra_cpu_reset_handler_set(reset_address);
> +		/* pass-through */
> +	case 0:
> +		is_enabled = true;
> +		break;
> +	default:
> +		pr_crit("Cannot set CPU reset handler: %d\n", err);
> +		BUG();
> +	}

Instead of trying and failing, does it make sense to register
tegra_cpu_reset_handler_set() as the set_cpu_boot_addr firmware op when
there is no firmware present? That would simplify all call-sites of any
firmware op.
