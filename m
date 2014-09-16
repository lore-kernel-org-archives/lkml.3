Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaIPMNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:13:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:30687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbaIPMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="600322819"
Date: Tue, 16 Sep 2014 15:13:14 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 6/6] usb: dwc3: host: convey the PHYs to xhci
Message-ID: <20140916121314.GD16653@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-7-git-send-email-heikki.krogerus@linux.intel.com>
 <5411B93F.3030405@ti.com>
 <20140912134911.GA30816@xps8300>
 <5412FF2C.5020600@ti.com>
 <20140915120654.GA31453@xps8300>
 <5417DA8C.1080301@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5417DA8C.1080301@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 12:07:00PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Monday 15 September 2014 05:36 PM, Heikki Krogerus wrote:
> > On Fri, Sep 12, 2014 at 07:41:56PM +0530, Kishon Vijay Abraham I wrote:
> >>>> I don't think create lookup should be in host init. If it's dt boot, the
> >>>> binding should be in dt data or for other boot modes the bindig should be done
> >>>> in the board file. This just seems hacky to me.
> >>>
> >>> So are you now suggesting that instead of using platform independent
> >>> solution of sharing the PHYs here, you would have us add platform
> >>> specific quirks? That would be totally wrong!
> >>
> >> No. The binding between the controller and the PHY is done in hardware design
> >> and it would be wrong to create such a binding in drivers/* IMO.
> > 
> > And kernel of course always knows the hardware design when it's being
> > booted, wrong!
> 
> Exactly my point. By creating the binding in drivers/*, you are directly
> telling the driver of the hardware design whereas it should have come from dt
> or platform data or .. (ACPI?).

Man, you are not getting this... We want to avoid the damn platform
data!!! If you are not using devicetree it doesn't mean the same as
something like board files or some other platform specific quirks are
suddenly acceptable.

I'm giving you a way of avoiding those things, basically a way
ignoring the platform completely in this case, but you are saying no
no no, we need to have "board files". C'mon!

And I'm pretty sure you misspelled this sentence "..you are directly
telling the driver of the hardware design..". I believe you meant to
say "Wau! With this we newer have to care about the hardware design
with this driver!".

Note. That and some other things that we can always simply ignore here
with this approach include:
- How were we enumerated (DT, ACPI, PCI...)
- Do some other bindings exist (DT)
- Do we even have PHYs to convey
- Does xHCI have any use for the PHYs
- What is the platform we are running on in general

> > Firstly, don't assume this kind of controllers are always part of some
> > SoC or chip set. They could easily be on a PCI card for example.
> 
> Agreed. Not convinced the current phy-core could handle it well.

If there is ever a PHY that needs OS control in this case, it will
almost certainly be possible to runtime detected somehow like ULPI
PHYs can be.

> > Secondly, don't assume we could tell all the details about the board
> > based on some identifiers. Fox example, at least with our SoCs we
> > won't be able to differentiate the boards. And it's not like every
> > board using the same SoC uses the same USB2 PHY for example. That kind
> > of things are up to the manufacturers.
> 
> right. In dt, generally we have different dt files for different boards,
> similarly we have different board files for different boards where those
> bindings can be created. Again not sure about ACPI.

I'll repeat what I said below - If we don't have description of the
hardware from something like DT or ACPI, and that includes the
bindings, or we can't runtime detect the underlying hardware, by
default it means we live without PHYs. Quirks you add only in case of
exceptions, but I actually think there will never be need for them...

If we are not using ACPI, we are using devicetree and otherwise we can
runtime detect the PHYs one way or the other. And again, if no PHY is
found it simply means the PHYs are autonomous.

So as you can see, it's possible we will newer need any kind of
"platform data" in order to provide dwc3 the correct PHYs, no matter
what kind of platform we are running on, so it makes no sense of
having them just for dwc3 host. Do you not agree?

> > I don't know how dt works, but at least in case of ACPI we still need
> > to deliver the PHY to xHCI here, even when dwc3 is provided bindings
> > to a PHY(s).
> 
> Agreed. But can't we have the bindings for xHCI in ACPI itself?

No. ACPI will never provide separate object for the xHCI that is part
of DWC3. There is nothing the PHYs could be bound to.


-- 
heikki
