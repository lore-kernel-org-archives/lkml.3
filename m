Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab3CVPsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:48:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47387 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933488Ab3CVPsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:48:14 -0400
Message-ID: <514C7D3B.40602@wwwdotorg.org>
Date: Fri, 22 Mar 2013 09:48:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Don't enable PLLs during early boot
References: <1363953308-28828-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1363953308-28828-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 05:54 AM, Peter De Schrijver wrote:
> The PLL code relies on udelay() which is not available when CCF is
> initialized. Hence we can't enable any PLL during this phase.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> --
> 
> Stephen,
> 
> Can you confirm this is ok for the audio drivers?
> 
> We used to be lucky that this has worked up to now, but I will introduce some
> changes to the pll lock check code which cause this to fail due to the
> slight differences in timing.

No, this won't work for the audio drivers; they assume the clock is
enabled when they start.

This assumption was made long ago. I know drivers are supposed to assume
that clocks are disabled when they're probed, but historically that
wasn't always the case, so if the audio drivers assumed that, and then
did clk_enable() as the first thing, they got a warning due to the
enabling an already enabled clock and/or later attempts to disable the
clocks wouldn't actually disable them. Perhaps this has changed now, but
either way, audio driver changes would be needed to support this change.

Perhaps this is due to initializing the Tegra clock driver in the
machine descriptor's init_irq function, rather than in the init_machine
function? Can this be moved?
