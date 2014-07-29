Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaG2OkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:40:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58105 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbaG2OkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:40:05 -0400
Date: Tue, 29 Jul 2014 15:39:36 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140729143936.GS2576@leverpostej>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
 <20140729093701.GJ2576@leverpostej>
 <00FC9A978A94B7418C33AFAE8A35ED49DB2AAD@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DB2AAD@DFLE09.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 02:50:48PM +0100, Murphy, Dan wrote:
> Mark
> 
> Thanks for the feedback
> 
> On 07/29/2014 04:37 AM, Mark Rutland wrote:
> > On Mon, Jul 28, 2014 at 05:53:23PM +0100, Dan Murphy wrote:
> >> Add the TI drv260x haptics/vibrator driver.
> >> This device uses the input force feedback
> >> to produce a wave form to driver an
> >> ERM or LRA actuator device.
> >>
> >> The initial driver supports the devices
> >> real time playback mode.  But the device
> >> has additional wave patterns in ROM.
> >>
> >> This functionality will be added in
> >> future patchsets.
> >>
> >> Product data sheet is located here:
> >> http://www.ti.com/product/drv2605
> >>
> >> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> >> ---
> >>
> >> v2 - Fixed binding doc and patch headline - https://patchwork.kernel.org/patch/4619641/
> >>
> >>  .../devicetree/bindings/input/ti,drv260x.txt       |   44 ++
> >>  drivers/input/misc/Kconfig                         |    9 +
> >>  drivers/input/misc/Makefile                        |    1 +
> >>  drivers/input/misc/drv260x.c                       |  537 ++++++++++++++++++++
> >>  include/dt-bindings/input/ti-drv260x.h             |   30 ++
> >>  include/linux/input/drv260x.h                      |  181 +++++++
> >>  6 files changed, 802 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/input/ti,drv260x.txt
> >>  create mode 100644 drivers/input/misc/drv260x.c
> >>  create mode 100644 include/dt-bindings/input/ti-drv260x.h
> >>  create mode 100644 include/linux/input/drv260x.h
> >>
> >> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> >> new file mode 100644
> >> index 0000000..930429b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> >> @@ -0,0 +1,44 @@
> >> +Texas Instruments - drv260x Haptics driver family
> >> +
> >> +The drv260x family serial control bus communicates through I2C protocols
> >> +
> >> +Required properties:
> >> +       - compatible - One of:
> >> +               "ti,drv2604" - DRV2604
> >> +               "ti,drv2605" - DRV2605
> >> +               "ti,drv2605l" - DRV2605L
> >> +       - reg -  I2C slave address
> >> +       - mode - Power up mode of the chip (defined in include/dt-bindings/input/ti-drv260x.h)
> >> +               DRV260X_RTP_MODE - Real time playback mode
> >> +               DRV260X_LRA_MODE - Linear Resonance Actuator mode (Piezoelectric)
> >> +               DRV260X_ERM_MODE - Eccentric Rotating Mass mode (Rotary vibrator)
> > 
> > What exactly are these, and why does the kernel not decide?
> 
> The LRA and ERM are vibrator types.  These are specific to the product and the kernel cannot decide.
> The kernel driver needs to be told what type of vibrator is connected.  The driver then
> sets the voltages and other settings to drive the vibrator type safely. All vibrators are dumb and do not
> have IDs identifying themselves so there is no self discovery here.

I see. That makes sense, thanks for the description.

It might make more sense to call this "vibrator-type", rather than
"mode", but otherwise this should be ok.

In the past I've asked for strings rather than magic numbers, but I'll
leave that choice to you.

> RTP is not a vibrator type but just a mode you can place the device into.  I can probably remove that
> and have the user space or driver take care of that setting.

Ok, that sounds good to me.

> 
> > 
> >> +       - library_sel - Library to use at power up (defined in include/dt-bindings/input/ti-drv260x.h)
> > 
> > Please s/_/-/ in all property names.
> > 
> >> +               DRV260X_LIB_A - Pre-programmed Library
> >> +               DRV260X_LIB_B - Pre-programmed Library
> >> +               DRV260X_LIB_C - Pre-programmed Library
> >> +               DRV260X_LIB_D - Pre-programmed Library
> >> +               DRV260X_LIB_E - Pre-programmed Library
> >> +               DRV260X_LIB_F - Pre-programmed Library
> > 
> > What exactly are these, and why does the kernel not decide?
> > 
> >> +
> >> +Optional properties:
> >> +       - enable-gpio - gpio pin to enable/disable the device.
> >> +       - vib_rated_voltage - The rated voltage of the actuator.  If this is not
> >> +                                                 set then the value will be defaulted to 0x90 in the
> >> +                                                 driver.
> > 
> > What units is this in?
> 
> Good catch I was thinking this when I was writing the documentation but forgot to add
> it.  I will fix the formatting here and below as well.

Cheers.

Mark.
