Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3CYKP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:15:59 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3522 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3CYKP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:15:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 25 Mar 2013 03:15:32 -0700
Date: Mon, 25 Mar 2013 12:15:42 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Don't enable PLLs during early boot
Message-ID: <20130325101542.GB18519@tbergstrom-lnx.Nvidia.com>
References: <1363953308-28828-1-git-send-email-pdeschrijver@nvidia.com>
 <514C7D3B.40602@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <514C7D3B.40602@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 04:48:11PM +0100, Stephen Warren wrote:
> On 03/22/2013 05:54 AM, Peter De Schrijver wrote:
> > The PLL code relies on udelay() which is not available when CCF is
> > initialized. Hence we can't enable any PLL during this phase.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > 
> > --
> > 
> > Stephen,
> > 
> > Can you confirm this is ok for the audio drivers?
> > 
> > We used to be lucky that this has worked up to now, but I will introduce some
> > changes to the pll lock check code which cause this to fail due to the
> > slight differences in timing.
> 
> No, this won't work for the audio drivers; they assume the clock is
> enabled when they start.
> 
> This assumption was made long ago. I know drivers are supposed to assume
> that clocks are disabled when they're probed, but historically that
> wasn't always the case, so if the audio drivers assumed that, and then
> did clk_enable() as the first thing, they got a warning due to the
> enabling an already enabled clock and/or later attempts to disable the

That should be ok. You can enable a clock more than once.

> clocks wouldn't actually disable them. Perhaps this has changed now, but
> either way, audio driver changes would be needed to support this change.
> 

But indeed, the clock won't be disabled then when the driver does
clk_disable(). The reference count will just be decremented. That's however
not a functional problem, just not optimal from a power consumption point of
view. So we could change the drivers first and keep the clocks disabled at
boottime in a second phase.

> Perhaps this is due to initializing the Tegra clock driver in the
> machine descriptor's init_irq function, rather than in the init_machine
> function? Can this be moved?

Maybe. But we need the clockframework before the timers are initialized...
So I have to check the dependencies.

Cheers,

Peter.
