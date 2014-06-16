Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaFPRG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:06:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43698 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658AbaFPRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:06:57 -0400
Date: Mon, 16 Jun 2014 18:06:54 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>, sameo@linux.intel.com,
        broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: arizona: Export function to control subsystem
	DVFS
Message-ID: <20140616170654.GB26741@opensource.wolfsonmicro.com>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com> <20140609150226.GB5229@opensource.wolfsonmicro.com> <20140616164242.GB14323@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616164242.GB14323@lee--X1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 05:42:42PM +0100, Lee Jones wrote:
> On Mon, 09 Jun 2014, Richard Fitzgerald wrote:
> 
> > Moving this control from being a side-effect of the LDO1
> > regulator driver to a specific exported function.
> > 
> > Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> > ---
> >  drivers/mfd/arizona-core.c       |   84 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/arizona/core.h |   12 +++++
> >  2 files changed, 96 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > index 58e1fe5..a1b4fe6 100644
> > --- a/drivers/mfd/arizona-core.c
> > +++ b/drivers/mfd/arizona-core.c
> > @@ -94,6 +94,89 @@ int arizona_clk32k_disable(struct arizona *arizona)
> >  }
> >  EXPORT_SYMBOL_GPL(arizona_clk32k_disable);
> >  
> > +int arizona_dvfs_up(struct arizona *arizona, unsigned int mask)
> > +{
> > +	unsigned int new_flags;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&arizona->subsys_max_lock);
> > +
> > +	new_flags = arizona->subsys_max_rq | mask;
> 
> This doesn't look like a mask to me.  It looks like you're setting
> flags rather than masking out bits?

Richard is on holiday so I will fill in for him. Yeah these are
flags I think mask is just a poorly chosen variable name.

> 
> > +	if (arizona->subsys_max_rq != new_flags) {
> > +		switch (arizona->type) {
> > +		case WM5102:
> > +		case WM8997:
> > +			ret = regulator_set_voltage(arizona->dcvdd,
> > +						    1800000, 1800000);
> > +			if (ret != 0) {
> > +				dev_err(arizona->dev,
> > +					"Failed to raise dcvdd (%u)\n", ret);
> > +				goto err;
> > +			}
> > +
> > +			ret = regmap_update_bits(arizona->regmap,
> > +					ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
> > +					ARIZONA_SUBSYS_MAX_FREQ, 1);
> > +			if (ret != 0) {
> > +				dev_err(arizona->dev,
> > +					"Failed to enable subsys max (%u)\n",
> > +					ret);
> > +				regulator_set_voltage(arizona->dcvdd,
> > +						      1200000, 1800000);
> > +				goto err;
> > +			}
> > +			break;
> > +
> > +		default:
> > +			break;
> > +		}
> 
> I don't really get this.  What's the point in passing the mask
> parameter - I don't see it being used for anything in this routine? No
> matter what is passed in you always just turn on the same regulator.
> 
> What am I missing?

As Mark said each bit represents something that can require the
higher clock rate. Any of the causes being active requires the
higher clock rate.

> 
> > +	arizona->subsys_max_rq = new_flags;
> 
> This tabbing is incorrect.

Will get fixed with the other comments.

Thanks,
Charles
