Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbbA2OOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:14:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:21766 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbbA2OOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:14:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,486,1418112000"; 
   d="diff'?scan'208";a="677993456"
Date: Thu, 29 Jan 2015 16:14:12 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150129141412.GA2570@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
 <20150124235811.GA24665@psi-dev26.jf.intel.com>
 <20150126125503.GB28539@kuha.fi.intel.com>
 <20150126192337.GA13936@psi-dev26.jf.intel.com>
 <20150127092856.GD28539@kuha.fi.intel.com>
 <20150127173801.GA8441@psi-dev26.jf.intel.com>
 <20150128142024.GA2378@kuha.fi.intel.com>
 <20150128180255.GA7551@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20150128180255.GA7551@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> > > > > Can you share how tusb1210 is connected on the platform you're using as
> > > > > test for this patch? I don't think this driver would work reliably with
> > > > > this device:
> > > > > http://liliputing.com/2014/11/trekstor-launches-first-android-tablet-based-intels-irda-reference-design.html
> > > > 
> > > > The only reason why that board doesn't work is because of very much
> > > > Baytrail-CR specific problems. These are are two issues, but the first
> > > 
> > > That's not BYT-CR specific problems. That's just dwc3 and tusb1210
> > > interacting as they're expecting to.
> > > 
> > > > one is critical for getting it working. Both will be handled, but
> > > > separately from this set:
> > > > 
> > > > 1) The firmware leaves the PHY in reset, forcing us to enable it
> > > > somehow in OS before accessing ulpi. Unless we can get a firmware fix
> > > > for that (it's starting to look like it's not going to happen; please
> > > > correct me if you know something else!), we need to add a quirk for
> > > > Baytrails (attached), which is probable still OK. But IMO this really
> > > > should be fixed in the firmware.
> > > 
> > > It seems you're expecting the PHY to be fully operational in order to
> > > probe it. That's wrong assumption. BYT-CR's BIOS is doing nothing wrong
> > > by leaving PHY on reset state.
> > 
> > But it is. If we want to use ULPI as a bus like we do, then the PHY
> > will be no different then devices attached to many other buses. We
> > have made firmware fixes like that before. All the devices need to be
> > in a state, operational enough after bootup, so we can probe them in
> > OS without the need for hacks where they are separately enabled before
> > it's possible.
> 
> That makes no sense. Not only dwc3 and phy could live as modules (which
> means they may probe far away from device's boot time) but we have
> examples of buses not behaving like you said. E.g. I2C needs master to
> be probed to have bus working and no BIOS needs to make I2C controller
> functional in order to probe its controller's driver.

You can't really compare a bus like i2c, which can't enumerate devices
natively, to ULPI which can.

> > > The real problem is what I stated above.
> > > With your current logic, you'll get stuck with checking/egg problem: you
> > > need phy probed to probe dwc3, but need dwc3 probed to power on phy.
> > > You need a logic to break this circular dependency.
> > 
> > The moment we register the ulpi interface with the ulpi bus in
> > dwc3_probe(), we know dwc3 has it's PHY interface in operational mode
> > and register access to ULPI PHY is possible. And that is all dwc3
> > needs to/can do.
> > 
> > I don't think you are seeing the whole "ulpi bus" in these patches,
> > but in any case; Like I said, this problem is purely BYT-CR specific,
> > which IMO really should be fixed in the firmware.
> 
> The proposed design has a flaw that breaks products on market simply
> because they don't have BIOS (unnecessarily) powering on phy. You're
> labeling that as BYT-CR specific issue because BYT-CR needs to be PM
> efficient and then it won't power on hw components in moment they don't
> need to. FW developers won't like this suggestion and I'd have to agree
> with them.

What exactly are we breaking here? The USB on BYT-CR does not work yet
with the mainline kernel, or does it? To enable it, I already
suggested the BYT quirk (attached again).

I don't think the other boards we have which use TUSB1210, like the
BYT-I ones and I think some Merrifield based boards, expect any less
from PM efficiency then BYT-CR, but we don't need to do any tricks
with them in order to use ULPI bus. That is what I mean when I say
this is BYT-CR specific problem.

I don't agree with PM arguments if it means that we should be ready to
accept loosing possibility for a generic solution in OS with a single
device like our PHY. I seriously doubt it would prevent the products
using these boards of achieving their PM requirements. But this
conversation is outside our topic.

> > > > 2) Since the gpio resources are given to the controller device in ACPI
> > > > tables and there isn't separate device object for the PHY at all, we
> > > > need to deliver the gpios somehow separately to the phy driver. There
> > > > is a thread where we are talking about how to do that:
> > > > https://lkml.org/lkml/2014/12/18/82
> > > 
> > > How about just leave the logic the way it is:
> > > dwc3-pci.c registers platform_device with gpio as resource if the GPIOs
> > > are provided to dwc3. If not, then dwc3-pci.c will expect phy to have
> > > its own ACPI id.
> > 
> > I think you are now talking about the platform devices for the legacy
> > USB PHY framework created in dwc3-pci.c, which btw. were removed.
> > Please note that we are not using platform bus with the ULPI devices,
> > and those devices are created by the bus driver and not dwc3.
> 
> Yes, that the one. Current products' BIOS on market didn't know about new
> ULPI bus. They rely on platform devices created by pci probe. Your ULPI
> bus proposal is way better to handle that problem and got my support
> since they beginning you showed that to me, but it does not justify
> breaking current working devices. Removing the platform device
> registration for phy with firmwares that rely on that was a mistake and
> any ACPI work related to fix that is unnecessary. These legacy ACPI
> tables gave the phy-related GPIOs to dwc3. Just mark is as legacy
> situation and let the legacy hw's happy. No vendor will change their
> BIOS after market due to non-buggy situation.

Well, I'm really not expecting any BIOS updates any more. I assumed
that was clear. Why else would I have started the whole planning of
the GPIO forwarding. But if it wasn't, then sorry. Now you know.

BYT-CR's USB is not supported in mainline yet unless I'm completely
mistaken, but we have the plan for it. Instead of trying to take any
shortcuts, let's follow that plan.

Because of the need to write to the ULPI registers, I don't think we
should try anything else except to use ULPI bus straight away. We'll
start by making use of ULPI bus possible by adding the quirk for BYT
(attached), which to me is perfectly OK solution. I would appreciate
if you gave it a review.

Then we'll pass the GPIO to the PHY driver in the same quirk once we
have the support for it in gpiolib.


Thanks,

-- 
heikki

--huq684BweRXVnRxX
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

--huq684BweRXVnRxX--
