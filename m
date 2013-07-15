Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3GOUlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:41:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:8496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3GOUlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,671,1367996400"; 
   d="scan'208";a="370717013"
Message-ID: <1373920870.3475.200.camel@envy.home>
Subject: Re: [PATCH 3/3] pch_gbe: Add MinnowBoard support
From: Darren Hart <dvhart@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 15 Jul 2013 13:41:10 -0700
In-Reply-To: <1373877289.24799.242.camel@smile>
References: <1373677087-7747-1-git-send-email-dvhart@linux.intel.com>
	 <ad20133699c36bd8d183dd685f1b35f6d6b99005.1373676797.git.dvhart@linux.intel.com>
	 <1373877289.24799.242.camel@smile>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 11:34 +0300, Andy Shevchenko wrote:
> On Fri, 2013-07-12 at 17:58 -0700, Darren Hart wrote: 

... 
> > +/* The AR803X PHY on the MinnowBoard requires a physical pin to be toggled to
> > + * ensure it is awake for probe and init. Request the line and reset the PHY.
> > + */
> > +static int pch_gbe_minnow_platform_init(struct pci_dev *pdev)
> > +{
> > +	int ret = 0;
> > +	int flags = GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_EXPORT;
> > +	int gpio = MINNOW_PHY_RESET_GPIO;
> > +
> > +	ret = gpio_request_one(gpio, flags, "minnow_phy_reset");
> > +	if (ret){
> > +		dev_err(&pdev->dev,
> > +			"ERR: Can't request PHY reset GPIO line '%d'\n", gpio);
> > +		return ret;
> > +	}
> > +
> > +	gpio_set_value(gpio, 0);
> > +	usleep_range(1250, 1500);
> > +	gpio_set_value(gpio, 1);
> > +	usleep_range(1250, 1500);
> 
> First of all, who is going to release gpio? Perhaps
> devm_gpio_request_one?

Thanks for the pointer, this works and appears to be the best way to
handle this.

...
> > + */
> > +int pch_gbe_phy_tx_clk_delay(struct pch_gbe_hw *hw)
> > +{
> > +	/* The RGMII interface requires a ~2ns TX clock delay. This is typically
> > +	 * done in layout with a longer trace or via PHY strapping, but can also
> > +	 * be done via PHY configuration registers.
> > +	 */
> > +	struct pch_gbe_adapter *adapter = pch_gbe_hw_to_adapter(hw);
> > +	u16 mii_reg;
> > +	int ret = 0;
> 
> No need to assign. Are you trying to shut (sparse?) warning?

On this point, I did find one instance where I initialized init only to
have my first line of executable code assign to ret, that's obviously
silly, so I fixed that one.

Here, where the first assignment is nested inside case statements or
skipped altogether with explicit returns of error codes, I prefer to
assign it explicitly. A quick survey lists 4k initialized "int ret;"
lines and 16k uninitialized.  The latter appears to be the more common,
but there is certainly precedent for the former.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

