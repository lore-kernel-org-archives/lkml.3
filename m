Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaCZLzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:55:48 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60979 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaCZLzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:55:46 -0400
Message-ID: <5332C267.3080908@gmail.com>
Date: Wed, 26 Mar 2014 13:04:55 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] ARM: mvebu: Extend the pmsu registers
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com> <1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 11:48 PM, Gregory CLEMENT wrote:
> The initial binding for PMSU were wrong. It didn't take into account
> all the registers from the PMSU and moreover it referred to registers
> which are not part of PMSU.
>
> The Power Management Unit Service block also controls the Coherency
> Fabric subsystem. These registers are needed for the CPU idle
> implementation for the Armada 370/XP, it allows to enter a deep CPU
> idle state where the Coherency Fabric and the L2 cache are powered
> down.
>
> This commit add support for a new compatible for the PMSU node
> including the block related to the coherency fabric. It also keeps
> compatibility with the old binding
>
> This patch also adds warnings if one of the base registers set can't
> be ioremapped.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>   arch/arm/mach-mvebu/pmsu.c | 47 +++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 42 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
> index d71ef53107c4..865bcb651e01 100644
> --- a/arch/arm/mach-mvebu/pmsu.c
> +++ b/arch/arm/mach-mvebu/pmsu.c
[...]
> +static void __init armada_370_xp_pmsu_legacy_init(struct device_node *np)
> +{
> +	u32 addr;
> +	pr_warn("*** Warning ***  Using an old binding which will be deprecated\n");
> +	/* We just need the adress, we already know the size */
> +	addr = be32_to_cpu(*of_get_address(np, 0, NULL, NULL));
> +	addr -= PMSU_BASE_OFFSET;
> +	pmsu_mp_base = ioremap(addr, PMSU_REG_SIZE);
> +	of_node_put(np);

When messing with OF passed resources, I suggest to use
of_address_to_resource() and work on the struct resource
instead. The be32_to_cpu pointing to an immediate just looks
strange.

Sebastian

