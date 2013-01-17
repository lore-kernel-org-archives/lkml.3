Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3AQPV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:21:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:32864 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755930Ab3AQPVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:21:54 -0500
Date: Thu, 17 Jan 2013 10:21:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
In-Reply-To: <20130117135043.GU18978@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1301171016550.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Felipe Balbi wrote:

> > Bits 31 & 30 from PORTSC register were allocated by our SOC designers
> > to inform the host controller about the PHY type to be used. 
> 
> Wow, that's something you should never do. PORTSC register belongs to
> the EHCI controller and those bits are reserved for future use and they
> *MUST* return zero. I wouldn't be surprised if current EHCI driver
> assumes those bits will be zero and/or makes sure they're set to zero
> when writing to PORTSC register.

In fact, those bits _have_ been assigned an official purpose in the 
EHCI-1.1 addendum.  Presumably the Tegra hardware only supports 
EHCI-1.0.

> What if after configuring those two bits, ehci-hcd.ko clears them by
> accident ? Your platform won't work.

That won't happen; ehci-hcd is careful to preserve the values of PORTSC
register bits it doesn't use.  But this still isn't a good idea.

> > As type of PHY is a property related to PHY DT nodes, PHY driver will get this info.
> > (Will remove phy_type from controller DT node soon, after all patches get merged.)
> > However as PORTSC register is in controller domain, added tegra_ehci_set_pts() API
> >  to serve the purpose.
> > 
> > As per Tegra USB PHY design, need to wait for PHY clock to stabilize once we
> > set/clear PHCD bit. Hence this is being accessed from PHY driver. To serve this
> > purpose added tegra_ehci_set_phcd().
> > 
> > On further analysis, seems tegra_ehci_set_wakeon_events() can be
> > removed.
> > 
> > If you are okay with above explanation, I can send updated patch for
> > review.
> 
> not sure I want to sign-off such a patch. I understand it's how your HW
> was done, but this shouldn't have been done, really.
> 
> Alan, what do you think ? Are you ok with PHY driver overwritting PORTSC
> register ?

It's okay provided it is done correctly -- i.e., in a way that won't 
interfere with the normal EHCI operation.

Alan Stern

