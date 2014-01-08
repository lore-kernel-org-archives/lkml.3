Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaAHOgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:36:08 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51527 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480AbaAHOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:36:06 -0500
Date: Wed, 8 Jan 2014 14:35:29 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
Message-ID: <20140108143529.GB14122@mudshark.cambridge.arm.com>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 01:33:11PM +0000, Vivek Gautam wrote:
> The erratum-773769 occurs on Arm Coretex-A15 (rev r2p0),
> when L2 Data Ram latency is set to 4 cycles or more; or
> when ACP is in use, or with L2 Data RAM slice configured.
> Therefore, the effective latency as calculated in Table 7-2 of
> Cotex-A15 (rev r2p0) trm should be 3 cycles or less.
> 
> On Exynos5250 based systems the effective data ram latency
> is 4 cycles, since we have DATA_RAM_SETUP bit enabled (L2CTRL[5]=1b'1)
> and DATA_RAM_LATENCY bits set to 0x2 (L2CTLR[2:0]=3b'010) therefore,
> the effective L2 data RAM latency becomes 4 cycles.
> So erratum '773769' occurs causing a corrupted L2 Cache.
> 
> This patch gives a workaround to the mentioned erratum, using below
> mentioned algo:
> ----------------------------------------------------------------
> if data RAM setup = 1
>   then check if effective latency i.e (latency + setup + 1) > 3
>   if 'true'
>     then clear data RAM setup
>       goto branch 'a'
> if data RAM setup = 0
>   a: then check if data RAM latency > 0x10
>     if true then force data RAM latency = 0x10
> ----------------------------------------------------------------
> so that the effective data RAM latency reduces to 3 cycles or less
> and hence prevent hitting the erratum.
> 
> NOTE: The Exynos5250 based products have already been shipped, which
>       makes it impossible to add the change in bootloader, so we are
>       adding the required change in kernel.

NAK. Whilst I appreciate that you may not be able to fix your bootloader,
this isn't the right change to make in the kernel. Blindly changing memory
latencies is likely to do more harm than good for a multi-platform kernel,
even if it works for exynos 5250. The only alternative I can think of (if you
have to make a mainline kernel change) is to restrict the clock frequencies at
which the CPU is allowed to run, although that obviously requires some
investigation in order to determine how viable it is for your SoC.

Will
