Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3JWV3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:29:33 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:59057 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3JWV3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 17:29:31 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Matt Porter <matt.porter@linaro.org>, Rob Herring <robherring2@gmail.com>
CC: Matthijs Kooijman <matthijs@stdin.nl>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC] Does PHY UTMI data width belong to DWC2 or PHY binding?
Thread-Topic: [RFC] Does PHY UTMI data width belong to DWC2 or PHY binding?
Thread-Index: AQHOzAwS6OPEcw2UMEy2WbSX6ha4XJn/XMMAgAGo+YCAAApMAIAAq2wAgAEeDgD///m1oA==
Date: Wed, 23 Oct 2013 21:29:22 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E1DB5B@US01WEMBX2.internal.synopsys.com>
References: <20131018141221.GH2721@beef> <5264F37E.9060307@ti.com>
 <20131022104829.GF15425@login.drsnuggles.stderr.nl>
 <20131022112520.GE29341@beef> <5266F06C.2080701@gmail.com>
 <20131023144242.GI29341@beef>
In-Reply-To: <20131023144242.GI29341@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Matt Porter [mailto:matt.porter@linaro.org]
> Sent: Wednesday, October 23, 2013 7:43 AM
> 
> On Tue, Oct 22, 2013 at 04:38:52PM -0500, Rob Herring wrote:
> > On 10/22/2013 06:25 AM, Matt Porter wrote:
> > > On Tue, Oct 22, 2013 at 12:48:29PM +0200, Matthijs Kooijman wrote:
> > >> Hi Kishon,
> > >>
> > >> On Mon, Oct 21, 2013 at 02:57:26PM +0530, Kishon Vijay Abraham I wrote:
> > >>> I think it makes sense to keep the data width property in the dwc2 node itself.
> > >>> I mean it describes how the dwc2 IP is configured in that particular SoC (given
> > >>> that it can be either <8> or <16>).
> > >> If I'm reading the RT3052 datasheet correctly (GHWCFG4 register), the IP
> > >> can be configured for 8, 16 or 8 _and_ 16. In the latter case, the "8
> > >> and 16 supported" would make sense as a property of dwc2 (though this
> > >> value should be autodetectable through GHWCFG4), while the actual 8 or
> > >> 16 supported by the PHY would make sense as property of a phy.
> > >
> > > There would be no value in adding a property for an already detectable
> > > value to dwc2's binding. To be honest, it's pretty much useless
> > > information due to the existence of the "8 and 16" option.
> > >
> > >> Note sure if this is really useful in practice as well, or if just
> > >> setting the actual width to use on dwc2 makes more sense...
> > >
> > > The GHWCFG4 information itself is not useful in practice, as described
> > > in the original thread: https://lkml.org/lkml/2013/10/10/477
> > >
> > > It's certainly useful in practice to have this width property in either
> > > the dwc2 or the phy binding. One can make a case for either. As I
> > > mentioned in the original post, if we put it in the phy binding we'll be
> > > updating the generic phy binding. We'll then need an api added into the
> > > generic phy framework to fetch the width of a phy.
> > >
> > > Both cases are doable and trivial, we just need the canonical decision
> > > from a DT maintainer as to where the property belongs. Given that they
> > > are in ARM ksummit, I'm not expecting to hear anything right this
> > > moment. :)
> >
> > The host can support both, so it is not a property of the host and is a
> > property of the phy. It is no different than what mode a SPI slave
> > requires or whether an i2c slave supports 8 or 10-bit addressing. Those
> > examples are all 1 to many rather than 1 to 1 where it doesn't really
> > matter, but the same logic applies.
> 
> Makes good sense, thanks.
> 
> In this case, given the PHY ownership of width, we can completely avoid
> any DT properties. The generic phy compliant BCM Kona phy driver can
> report via the generic phy framework that it is 8-bit wide. There's no
> support for this type of thing now but it's pretty trivial to add.

> I went ahead and did a quick proof-of-concept that adds a free-form
> phy attributes struct for the generic phy. Given that generic phys can
> be for any transmission technology this could be filled with a jumble
> unrelated and often unpopulated attributes over time. In any case, the
> below patch allows the phy provider to choose to specify utmi_width and
> a controller driver that cares can use phy_get_attrs() to fetch the
> optional phy attributes and use the utmi_width field if applicable.

As an alternate approach, you could add a 'utmi_width' property to the
PHY's DT node, and have the dwc2 driver scan the tree until it finds its
PHY, and then check it for that property. That would avoid the need to
add anything new to the PHY framework. I don't know if that would be
considered good practice by the DT guys, though.

-- 
Paul

