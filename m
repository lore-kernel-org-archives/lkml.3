Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaFBI1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:27:32 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8075 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaFBI1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:27:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Jun 2014 01:19:42 -0700
Date: Mon, 2 Jun 2014 11:27:13 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] efuse driver for Tegra
Message-ID: <20140602082713.GZ5961@tbergstrom-lnx.Nvidia.com>
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
 <53878407.3050409@wwwdotorg.org>
 <20140530082356.GP5961@tbergstrom-lnx.Nvidia.com>
 <5388AF2D.4060909@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5388AF2D.4060909@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 06:17:49PM +0200, Stephen Warren wrote:
> On 05/30/2014 02:23 AM, Peter De Schrijver wrote:
> > On Thu, May 29, 2014 at 09:01:27PM +0200, Stephen Warren wrote:
> >> On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
> >>> This driver allows userspace to read the raw efuse data. Its userspace
> >>> interface is modelled after the sunxi_sid driver which provides similar
> >>> functionality for some Allwinner SoCs. It has been tested on
> >>> Tegra20 (ventana), Tegra30 (beaverboard), Tegra114 (dalmore) and
> >>> Tegra124 (jetson TK1).
> >>
> >>> Changes since v4:
> >>>
> >>> * Provide fallback to hardcoded 0x70000800 in case the apbmisc DT node is
> >>>   missing. This is exactly what the current code does and prevents a system
> >>>   crash in that case due to an invalid memory access by tegra_read_chipid()
> >>
> >> Wouldn't it be better to simply return an error?
> > 
> > This would mean you can't boot a system with these patches applied unless you
> > also update the device tree. The system would crash during boot because CCF
> > relies on tegra_read_chipid() as an APB barrier. Also tegra_boot_secondary()
> > relies on the chipid to select the correct method for booting secondary cores.
> 
> Is this series really backwards-compatible anyway? tegra_init_fuse()
> contains a whole bunch of places where resources are pulled out of DT,
> and only one of those has a fallback to use APBMISC_BASE if the DT entry
> isn't present.

Apart from the randomness initialization, there are no users of
tegra_read_straps(). tegra_fuse_readl() is a new API, so that doesn't pose
any backwards-compatibility problems. The only bug I noticed when rereading
the code is that tegra_get_revision() reads the fuses on an A03 Tegra20 to
findout if it's A03 or A03p. This would obviously crash if the DT entries
are missing. I think this can be worked around by claiming it's an A03
in case the DT entries are missing. I don't think that will cause any problems?

Cheers,

Peter.
