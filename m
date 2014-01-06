Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaAFUur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:50:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56976 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaAFUuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:50:46 -0500
Message-ID: <52CB1722.70306@wwwdotorg.org>
Date: Mon, 06 Jan 2014 13:50:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Danny Huang <dahuang@nvidia.com>
Subject: Re: [PATCH v2 4/6] ARM: tegra: rework fuse.c
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com> <1387891931-9854-5-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1387891931-9854-5-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> Reduce fuse.c to the minimum functionality required for the early bootstages.
>
> Also export tegra_read_straps() for use by the fuse driver.

Since the fuse driver is tristate, it could be a module. Doesn't it
literally need to be EXPORT_SYMBOL'd, not simply not static?

I'm rather worried that this series isn't bisectable, since this patch
removes a bunch of code that's replaced by code in the fuse driver which
can't be built/linked at this point in the series. I'm also worried
about initialization ordering, since a lot of the fuse code could be a
module...

> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c

> -/* Tegra20 only */
>  #define FUSE_UID_LOW		0x108
>  #define FUSE_UID_HIGH		0x10c

Why remove that comment but leave the two defines it applies to?

>  #define TEGRA20_FUSE_SPARE_BIT		0x200

That define, and tegra_spare_fuse() which uses it, are no longer used
after patch 5/6, but aren't removed in patch 5/6. Perhaps it'd be better
to squash or re-order the two patches, so this dead code can be removed?

> -int tegra_sku_id;
> -int tegra_cpu_process_id;
> -int tegra_core_process_id;
>  int tegra_chip_id;
> -int tegra_cpu_speedo_id;		/* only exist in Tegra30 and later */
> -int tegra_soc_speedo_id;
>  enum tegra_revision tegra_revision;

It's a bit odd to remove most of this, but leave a few parts hanging
around. Wouldn't it be better to the drivers/misc/fuse code to export
this, so that /all/ the fuse logic was there, rather than part of it
being left over in arch/arm/? We'll need to fix that up anyway when we
start using these globals on ARMv8, so may as well get it right now.
Also, I rather think that the new drivers/misc/fuse code shouldn't be a
module or driver, so that we can guarantee it's always there to provide
the globals and that they are initialized early enough...
