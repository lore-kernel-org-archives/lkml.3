Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbaJaUMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:12:20 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52304 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbaJaUMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:12:18 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>
CC: "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv6 4/8] usb: dwc2: Update common interrupt handler to
 call gadget interrupt handler
Thread-Topic: [PATCHv6 4/8] usb: dwc2: Update common interrupt handler to
 call gadget interrupt handler
Thread-Index: AQHP8wcSEUOdbHcc+EmRFDJLGsTWRZxJIxSAgAGBy1A=
Date: Fri, 31 Oct 2014 20:12:14 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E8042@US01WEMBX2.internal.synopsys.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-5-git-send-email-dinguyen@opensource.altera.com>
 <20141030140043.GD6482@saruman>
In-Reply-To: <20141030140043.GD6482@saruman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Thursday, October 30, 2014 7:01 AM
> 
> On Tue, Oct 28, 2014 at 06:25:45PM -0500, dinguyen@opensource.altera.com wrote:
> > From: Dinh Nguyen <dinguyen@opensource.altera.com>
> >
> > Make dwc2_handle_common_intr call the gadget interrupt function when operating
> > in peripheral mode. Remove the spinlock functions in s3c_hsotg_irq as
> > dwc2_handle_common_intr() already has the spinlocks.
> >
> > Move the registeration of the IRQ to common code for platform and PCI.
> >
> > Remove duplicate interrupt conditions that was in gadget, as those are handled
> > by dwc2 common interrupt handler.
> >
> > Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> > Acked-by: Paul Zimmerman <paulz@synopsys.com>
> > ---
> > v5: remove individual devm_request_irq from gadget and hcd, and place a
> >     single devm_request_irq in platform and pci.
> > v2: Keep interrupt handler for host and peripheral modes separate
> > ---
> >  drivers/usb/dwc2/core.c      | 10 --------
> >  drivers/usb/dwc2/core.h      |  3 +++
> >  drivers/usb/dwc2/core_intr.c |  3 +++
> >  drivers/usb/dwc2/gadget.c    | 57 ++------------------------------------------
> >  drivers/usb/dwc2/pci.c       |  6 +++++
> >  drivers/usb/dwc2/platform.c  |  9 +++++++
> >  6 files changed, 23 insertions(+), 65 deletions(-)
> >
> > diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> > index d926945..7605850b 100644
> > --- a/drivers/usb/dwc2/core.c
> > +++ b/drivers/usb/dwc2/core.c
> > @@ -458,16 +458,6 @@ int dwc2_core_init(struct dwc2_hsotg *hsotg, bool select_phy, int irq)
> >  	/* Clear the SRP success bit for FS-I2c */
> >  	hsotg->srp_success = 0;
> >
> > -	if (irq >= 0) {
> > -		dev_dbg(hsotg->dev, "registering common handler for irq%d\n",
> > -			irq);
> > -		retval = devm_request_irq(hsotg->dev, irq,
> > -					  dwc2_handle_common_intr, IRQF_SHARED,
> > -					  dev_name(hsotg->dev), hsotg);
> > -		if (retval)
> > -			return retval;
> > -	}
> > -
> >  	/* Enable common interrupts */
> >  	dwc2_enable_common_interrupts(hsotg);
> >
> > diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> > index 80d29c7..ec70862 100644
> > --- a/drivers/usb/dwc2/core.h
> > +++ b/drivers/usb/dwc2/core.h
> > @@ -967,6 +967,7 @@ extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
> >  extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
> >  extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
> >  extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
> > +irqreturn_t s3c_hsotg_irq(int irq, void *pw);
> >  #else
> >  static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
> >  { return 0; }
> > @@ -977,6 +978,8 @@ static inline int s3c_hsotg_resume(struct dwc2_hsotg *dwc2)
> >  static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
> >  { return 0; }
> >  static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
> > +static inline irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> > +{ return IRQ_HANDLED; }
> >  #endif
> >
> >  #if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
> > diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> > index b176c2f..b0c14e0 100644
> > --- a/drivers/usb/dwc2/core_intr.c
> > +++ b/drivers/usb/dwc2/core_intr.c
> > @@ -474,6 +474,9 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
> >
> >  	spin_lock(&hsotg->lock);
> >
> > +	if (dwc2_is_device_mode(hsotg))
> > +		retval = s3c_hsotg_irq(irq, dev);
> > +
> >  	gintsts = dwc2_read_common_intr(hsotg);
> >  	if (gintsts & ~GINTSTS_PRTINT)
> >  		retval = IRQ_HANDLED;
> > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > index 19d1b03..202f8cc 100644
> > --- a/drivers/usb/dwc2/gadget.c
> > +++ b/drivers/usb/dwc2/gadget.c
> > @@ -2257,14 +2257,13 @@ void s3c_hsotg_core_init(struct dwc2_hsotg *hsotg)
> >   * @irq: The IRQ number triggered
> >   * @pw: The pw value when registered the handler.
> >   */
> > -static irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> > +irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> 
> why ? It would've been a lot easier to just make the IRQ line shared.

Actually, I would prefer to keep the common interrupt handler. Reason
being, the HSOTG core can spew a *lot* of interrupts when in host mode,
and the driver already struggles to keep up with them on some platforms.
We see this problem especially on the Raspberry Pi.

So I think adding the overhead of an additional interrupt handling
path is a bad idea. Unless the peripheral-mode interrupt handler can
somehow be disabled when the controller is in host mode.

Maybe we could delay registering the gadget interrupt handler until
the controller switches to peripheral mode, and unregister it when it
switches back to host mode? But that seems pretty "odd" to me.

Felipe, what do you think?

-- 
Paul

