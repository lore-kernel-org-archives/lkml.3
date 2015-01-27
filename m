Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbbA0J3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:29:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:29413 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486AbbA0J3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:29:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,473,1418112000"; 
   d="diff'?scan'208";a="643124788"
Date: Tue, 27 Jan 2015 11:28:56 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150127092856.GD28539@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
 <20150124235811.GA24665@psi-dev26.jf.intel.com>
 <20150126125503.GB28539@kuha.fi.intel.com>
 <20150126192337.GA13936@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20150126192337.GA13936@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 26, 2015 at 11:23:37AM -0800, David Cohen wrote:
> On Mon, Jan 26, 2015 at 02:55:03PM +0200, Heikki Krogerus wrote:
> > On Sat, Jan 24, 2015 at 03:58:11PM -0800, David Cohen wrote:
> > > > +static int tusb1210_power_on(struct phy *phy)
> > > > +{
> > > > +	struct tusb1210 *tusb = phy_get_drvdata(phy);
> > > > +
> > > > +	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
> > > > +	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
> > > > +
> > > > +	/* Restore eye diagram optimisation value */
> > > > +	ulpi_write(tusb->ulpi, TUSB1210_VENDOR_SPECIFIC2,
> > > > +		   tusb->eye_diagram_tuning);
> > > 
> > > After you power on phy, ulpi bus may not be available right away. In
> > > intel case, phy power on happens during dwc3 power on. ULPI bus is not
> > > available until OTG controller and phy are in sync.
> > > 
> > > In resume, you can't restore eye diagram from here.
> > 
> > I'm sorry but I don't think I understand? Where do we power on the phy
> > before dwc3 is powered on? Or is this a Baytrail-CR specific problem?
> > I can't see any problems with the hardware I have.
> 
> You can't see in single accesses. But you may see when running stability
> tests overnight.
> 
> Anyway, look for dwc3_core_soft_reset() function:
> - dwc3 goes to reset state
> - phy is initialized (or at least gets ready to sync clocks)
> - dwc3 goes out or reset state

And if you look at dwc3_probe, you'll notice that it calls
phy_power_on after that, and ulpi will most definitely be accessible
at that point.

I'm only using the init and exit hooks instead of just
power_on/power_off because I'm not sure which the controllers will
use. For example, now dwc3 calls phy_init() in it's resume routine and
not phy_power_on() like I would expect. I know the problem has been
pointed out by others, so I'm expecting we'll get guidelines for it
later. But before we do, I see no harm in having both init and
power_on hooks in this driver.

> During tusb1210 phy init from dwc3, you shouldn't access ulpi bus.

We will end up executing one failed write followed by write that we
know will succeed. Ideally we didn't have to do the first one at all,
but I don't see any risk here.

> > > > +	gpio = devm_gpiod_get(&ulpi->dev, "cs");
> > > > +	if (!IS_ERR(gpio)) {
> > > > +		ret = gpiod_direction_output(gpio, 0);
> > > > +		if (ret)
> > > > +			return ret;
> > > > +		tusb->gpio_cs = gpio;
> > > > +	}
> > > > +
> > > > +	/* Store initial eye diagram optimisation value */
> > > > +	ret = ulpi_read(ulpi, TUSB1210_VENDOR_SPECIFIC2);
> > > 
> > > It's unclear if ulpi is accessible at this point. You can't read it at
> > > this point.
> > 
> > We wouldn't have reached this point if ulpi wasn't accessible.
> > Registering the ulpi interface would have already failed so no driver
> > would have been probed.
> 
> You have a chicken/egg problem here:
> - dwc3 needs phy to complete soft reset during probe
> - tusb1210 needs dwc3 soft reset completed to be accessible via ULPI
> 
> Can you share how tusb1210 is connected on the platform you're using as
> test for this patch? I don't think this driver would work reliably with
> this device:
> http://liliputing.com/2014/11/trekstor-launches-first-android-tablet-based-intels-irda-reference-design.html

The only reason why that board doesn't work is because of very much
Baytrail-CR specific problems. These are are two issues, but the first
one is critical for getting it working. Both will be handled, but
separately from this set:

1) The firmware leaves the PHY in reset, forcing us to enable it
somehow in OS before accessing ulpi. Unless we can get a firmware fix
for that (it's starting to look like it's not going to happen; please
correct me if you know something else!), we need to add a quirk for
Baytrails (attached), which is probable still OK. But IMO this really
should be fixed in the firmware.

2) Since the gpio resources are given to the controller device in ACPI
tables and there isn't separate device object for the PHY at all, we
need to deliver the gpios somehow separately to the phy driver. There
is a thread where we are talking about how to do that:
https://lkml.org/lkml/2014/12/18/82


Thanks,

-- 
heikki

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="baytrail_quirk.diff"

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 8d95056..53902ea 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
 
 #include "platform_data.h"
 
@@ -35,6 +36,24 @@
 
 static int dwc3_pci_quirks(struct pci_dev *pdev)
 {
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    pdev->device == PCI_DEVICE_ID_INTEL_BYT) {
+		struct gpio_desc *gpio;
+
+		gpio = gpiod_get_index(&pdev->dev, "reset", 0);
+		if (!IS_ERR(gpio)) {
+			gpiod_direction_output(gpio, 0);
+			gpiod_set_value_cansleep(gpio, 1);
+			gpiod_put(gpio);
+		}
+		gpio = gpiod_get_index(&pdev->dev, "cs", 1);
+		if (!IS_ERR(gpio)) {
+			gpiod_direction_output(gpio, 0);
+			gpiod_set_value_cansleep(gpio, 1);
+			gpiod_put(gpio);
+		}
+	}
+
 	if (pdev->vendor == PCI_VENDOR_ID_AMD &&
 	    pdev->device == PCI_DEVICE_ID_AMD_NL_USB) {
 		struct dwc3_platform_data pdata;

--8t9RHnE3ZwKMSgU+--
