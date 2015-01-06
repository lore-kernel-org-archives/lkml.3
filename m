Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbbAFPxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:53:15 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5593 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbbAFPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:53:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Jan 2015 07:46:02 -0800
Date: Tue, 6 Jan 2015 23:53:13 +0800
From: Vince Hsu <vinceh@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/11] memory: tegra: add flush operation for Tegra124
 memory clients
Message-ID: <20150106155312.GA20547@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-4-git-send-email-vinceh@nvidia.com>
 <20150106142958.GM31830@ulmo.nvidia.com> <20150106150744.GB18598@nvidia.com>
 <20150106152750.GR31830@ulmo.nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20150106152750.GR31830@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04:27:52PM Jan 06, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jan 06, 2015 at 11:07:45PM +0800, Vince Hsu wrote:
> > On 03:30:00PM Jan 06, Thierry Reding wrote:
> > > > Old Signed by an unknown key
> > > 
> > > On Tue, Dec 23, 2014 at 06:39:56PM +0800, Vince Hsu wrote:
> > > > Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> > > > ---
> > > >  drivers/memory/tegra/tegra124.c | 82 +++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 82 insertions(+)
> > > > 
> > > > diff --git a/drivers/memory/tegra/tegra124.c b/drivers/memory/tegra/tegra124.c
> > > > index 278d40b854c1..036935743a0a 100644
> > > > --- a/drivers/memory/tegra/tegra124.c
> > > > +++ b/drivers/memory/tegra/tegra124.c
> > > > @@ -6,6 +6,7 @@
> > > >   * published by the Free Software Foundation.
> > > >   */
> > > >  
> > > > +#include <linux/delay.h>
> > > >  #include <linux/of.h>
> > > >  #include <linux/mm.h>
> > > >  
> > > > @@ -959,7 +960,85 @@ static const struct tegra_smmu_swgroup tegra124_swgroups[] = {
> > > >  	{ .swgroup = TEGRA_SWGROUP_VI,        .reg = 0x280 },
> > > >  };
> > > >  
> > > > +static const struct tegra_mc_hr tegra124_mc_hr[] = {
> > > > +	{TEGRA_SWGROUP_AFI,        0x200, 0x200,  0},
> > > > +	{TEGRA_SWGROUP_AVPC,       0x200, 0x200,  1},
> > > > +	{TEGRA_SWGROUP_DC,         0x200, 0x200,  2},
> > > > +	{TEGRA_SWGROUP_DCB,        0x200, 0x200,  3},
> > > > +	{TEGRA_SWGROUP_HC,         0x200, 0x200,  6},
> > > > +	{TEGRA_SWGROUP_HDA,        0x200, 0x200,  7},
> > > > +	{TEGRA_SWGROUP_ISP2,       0x200, 0x200,  8},
> > > > +	{TEGRA_SWGROUP_MPCORE,     0x200, 0x200,  9},
> > > > +	{TEGRA_SWGROUP_MPCORELP,   0x200, 0x200, 10},
> > > > +	{TEGRA_SWGROUP_MSENC,      0x200, 0x200, 11},
> > > > +	{TEGRA_SWGROUP_PPCS,       0x200, 0x200, 14},
> > > > +	{TEGRA_SWGROUP_SATA,       0x200, 0x200, 15},
> > > > +	{TEGRA_SWGROUP_VDE,        0x200, 0x200, 16},
> > > > +	{TEGRA_SWGROUP_VI,         0x200, 0x200, 17},
> > > > +	{TEGRA_SWGROUP_VIC,        0x200, 0x200, 18},
> > > > +	{TEGRA_SWGROUP_XUSB_HOST,  0x200, 0x200, 19},
> > > > +	{TEGRA_SWGROUP_XUSB_DEV,   0x200, 0x200, 20},
> > > > +	{TEGRA_SWGROUP_TSEC,       0x200, 0x200, 22},
> > > > +	{TEGRA_SWGROUP_SDMMC1A,    0x200, 0x200, 29},
> > > > +	{TEGRA_SWGROUP_SDMMC2A,    0x200, 0x200, 30},
> > > > +	{TEGRA_SWGROUP_SDMMC3A,    0x200, 0x200, 31},
> > > 
> > > The documentation that I have says that the status register for these is
> > > 0x204.
> > Oops. Thanks for catching this. Will fix.
> > 
> > > 
> > > > +	{TEGRA_SWGROUP_SDMMC4A,    0x970, 0x974,  0},
> > > > +	{TEGRA_SWGROUP_ISP2B,      0x970, 0x974,  1},
> > > > +	{TEGRA_SWGROUP_GPU,        0x970, 0x974,  2},
> > > > +};
> > > > +
> > > >  #ifdef CONFIG_ARCH_TEGRA_124_SOC
> > > > +
> > > > +static bool tegra124_stable_hotreset_check(struct tegra_mc *mc,
> > > > +		u32 reg, u32 *stat)
> > > > +{
> > > > +	int i;
> > > > +	u32 cur_stat;
> > > > +	u32 prv_stat;
> > > > +
> > > > +	prv_stat = mc_readl(mc, reg);
> > > > +	for (i = 0; i < 5; i++) {
> > > > +		cur_stat = mc_readl(mc, reg);
> > > > +		if (cur_stat != prv_stat)
> > > > +			return false;
> > > > +	}
> > > 
> > > Why this loop? The function is already called in a polling loop below.
> > > Also why compare to the previous value of the register? Isn't the only
> > > thing we're interested in the value of the specific bit?
> > I recall it's due to a HW bug that there might be a gitch if we program
> > the ctrl reg and then read the status reg in a short window. This function
> > is to make sure we have a stable status.
> 
> This warrants a comment, then.
Okay.

> 
> > > > +	*stat = cur_stat;
> > > > +	return true;
> > > > +}
> > > > +
> > > > +static int tegra124_mc_flush(struct tegra_mc *mc,
> > > > +		const struct tegra_mc_hr *hr_client, bool enable)
> > > > +{
> > > > +	u32 val;
> > > > +
> > > > +	if (!mc || !hr_client)
> > > > +		return -EINVAL;
> > > > +
> > > > +	val = mc_readl(mc, hr_client->ctrl);
> > > > +	if (enable)
> > > > +		val |= BIT(hr_client->bit);
> > > > +	else
> > > > +		val &= ~BIT(hr_client->bit);
> > > > +	mc_writel(mc, val, hr_client->ctrl);
> > > > +	mc_readl(mc, hr_client->ctrl);
> > > > +
> > > > +	/* poll till the flush is done */
> > > > +	if (enable) {
> > > > +		do {
> > > > +			udelay(10);
> > > 
> > > This should probably be usleep_range(10, 20) or something.
> > Maybe no. We might need some spin lock here to ensure only one flushing
> > operation requested and no race could happen.
> 
> We should use a mutex, then. There's no saying how long this will take
> and busy-looping indefinitely is a bad idea. Though it seems to me like
> we don't need to lock around the polling loop here since we're merely
> reading a status register. We would only need to lock around accesses to
> the control register to make sure two processes can't step on each
> others's toes.
We can use metux definitely. If two processes touch the ctrl registers
sequentially and poll the status register in parallel, we dont' know whether
the glitch is caused by the HW bug or the concurrent ctrl register programming?
We should lock the status checking as well.

> 
> > > Would it be difficult to implement this for Tegra30 and Tegra114?
> > No. But I have to check the detail in Tegra30 and Tegra114. And the biggest
> > problem is I don't have the boards to test.
> 
> I can help with testing. Though that raises the question of how this can
> be tested. It seems like this feature is used to make sure that all
> outstanding memory requests from clients are flushed before resetting a
> module. Typically Linux assumes that devices do that anyway, so if a
> device is suspended or shut down, the corresponding function should
> ensure that all outstanding transfers have been cancelled and are
> flushed.
The flushing operation can be requested by runtime PM if the device supports
it.

> 
> Also we've managed just fine so far, so I'm beginning to wonder whether
> we actually need this feature on Linux. If not, how do we test that this
> is indeed doing what it should? How to trigger a condition that requires
> flushing and how do we determine that flushing actually fixes things?
Sorry that I can't answer how to test it because I'm not a mc expert.
What I can do is testing the power up/off sequence a lot of time and check if
the device can still work normally. We need this feature because the TRM
requires so?

Thanks,
Vince


