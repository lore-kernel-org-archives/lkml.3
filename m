Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3ANL0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:26:09 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46004 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab3ANL0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:26:06 -0500
Date: Mon, 14 Jan 2013 11:25:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/14] usb: phy: nop: Handle power supply regulator for
	the PHY
Message-ID: <20130114112549.GY23505@n2100.arm.linux.org.uk>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com> <1357836694-30788-5-git-send-email-rogerq@ti.com> <20130111171726.GI23505@n2100.arm.linux.org.uk> <50F3D5E2.4000102@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3D5E2.4000102@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:54:42AM +0200, Roger Quadros wrote:
> On 01/11/2013 07:17 PM, Russell King - ARM Linux wrote:
> > On Thu, Jan 10, 2013 at 06:51:24PM +0200, Roger Quadros wrote:
> >> We use "vcc" as the supply name for the PHY's power supply.
> >> The power supply will be enabled during .init() and disabled
> >> during .shutdown()
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> >>  drivers/usb/otg/nop-usb-xceiv.c |   18 ++++++++++++++++++
> >>  1 files changed, 18 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
> >> index 163f972..1c6db10 100644
> >> --- a/drivers/usb/otg/nop-usb-xceiv.c
> >> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> >> @@ -33,11 +33,13 @@
> >>  #include <linux/usb/nop-usb-xceiv.h>
> >>  #include <linux/slab.h>
> >>  #include <linux/clk.h>
> >> +#include <linux/regulator/consumer.h>
> >>  
> >>  struct nop_usb_xceiv {
> >>  	struct usb_phy		phy;
> >>  	struct device		*dev;
> >>  	struct clk		*clk;
> >> +	struct regulator	*vcc;
> >>  };
> >>  
> >>  static struct platform_device *pd;
> >> @@ -70,6 +72,11 @@ static int nop_init(struct usb_phy *phy)
> >>  {
> >>  	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
> >>  
> >> +	if (nop->vcc) {
> >> +		if (regulator_enable(nop->vcc))
> >> +			dev_err(phy->dev, "Failed to enable power\n");
> >> +	}
> >> +
> >>  	if (nop->clk)
> >>  		clk_enable(nop->clk);
> >>  
> >> @@ -82,6 +89,11 @@ static void nop_shutdown(struct usb_phy *phy)
> >>  
> >>  	if (nop->clk)
> >>  		clk_disable(nop->clk);
> >> +
> >> +	if (nop->vcc) {
> >> +		if (regulator_disable(nop->vcc))
> >> +			dev_err(phy->dev, "Failed to disable power\n");
> >> +	}
> >>  }
> >>  
> >>  static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
> >> @@ -157,6 +169,12 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
> >>  		}
> >>  	}
> >>  
> >> +	nop->vcc = devm_regulator_get(&pdev->dev, "vcc");
> >> +	if (IS_ERR(nop->vcc)) {
> >> +		dev_dbg(&pdev->dev, "Error getting vcc regulator\n");
> >> +		nop->vcc = NULL;
> >> +	}
> > 
> > Is it really appropriate for drivers to do this kind of thing with
> > pointer-returning functions (I mean, setting the pointer to NULL on
> > error, rather than just using a test for IS_ERR() in the above
> > locations).  You are imposing driver-local assumptions on an API.
> > 
> > Practically it probably doesn't make much difference but given the
> > amount of mistakes that we have with IS_ERR_OR_NULL()...
> > 
> Makes sense. I'll convert it to use IS_ERR_OR_NULL() throughout.

IS_ERR_OR_NULL() is going to be deprecated and removed.  Please take a
look at how these APIs work.

If regulator support is not enabled, then devm_regulator_get() returns
NULL, and all the other regulator functions become no-ops.  This is not
an error.  Do you need the driver to error out if CONFIG_REGULATOR is
disabled?

If regulator support is enabled, then it can return a pointer-error
value (as defined when IS_ERR() is true, and _in that case only_ can it
be decoded by PTR_ERR() - PTR_ERR() is _only_ valid when IS_ERR()
returns true - it is _not_ valid for all the cases that IS_ERR_OR_NULL()
returns true.)  Otherwise, it returns a cookie as far as the driver is
concerned for the regulator suitable for passing into the other regulator
APIs.

By having the driver do something different, and make use of NULL as its
own special sentinel, it's placing additional interpretations on the API,
which can lead to bugs.  Don't do this.

If you can start making use of 'nop' vcc/clk members before they've been
"got" then initialize them to ERR_PTR(-EINVAL) first.

Also consider that when using the devm interfaces, you can do:


	nop->clk = devm_clk_get(&pdev->dev, ...);
	nop->vcc = devm_regulator_get(&pdev->dev, "vcc");

	if (IS_ERR(nop->clk))
		dev_dbg(&pdev->dev, "unable to get clock: %d\n",
			PTR_ERR(nop->clk));

	if (IS_ERR(nop->vcc))
		dev_dbg(&pdev->dev, "unable to get vcc regulator: %d\n",
			PTR_ERR(nop->vcc));
...
	if (!IS_ERR(nop->clk))
		clk_enable(nop->clk);

You may also consider that if you're going to print a warning for
regulator_enable(), that you should print the error code as well, so that
you know the reason why the failure happened.

Also consider... is dev_err() appropriate for an "error", for which you
print a message and continue as if nothing went wrong.  To me that sounds
more like a warning than an error, so maybe dev_warn() would be more
appropriate?
