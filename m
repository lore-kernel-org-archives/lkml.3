Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaI1AlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 20:41:07 -0400
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:30030
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbaI1AlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 20:41:05 -0400
Date: Sun, 28 Sep 2014 08:40:52 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <sebastian.hesselbarth@gmail.com>, <p.zabel@pengutronix.de>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <jszhang@marvell.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140928004049.GA3667@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <2923729.dtX0WmHSV0@wuerfel> <20140924112902.GA23331@peterchendt>
 <2786668.t3YLqX5enD@wuerfel> <20140925141553.GC28045@saruman>
 <20140925233932.GA3026@peterchendt> <20140926003750.GA12770@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140926003750.GA12770@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(51704005)(189002)(76176999)(107046002)(50986999)(81156004)(106466001)(54356999)(47776003)(20776003)(64706001)(83506001)(23726002)(104016003)(21056001)(97736003)(10300001)(95666004)(90102001)(79102003)(33716001)(105606002)(74502003)(85306004)(74662003)(77982003)(46102003)(80022003)(81342003)(81542003)(120916001)(93886004)(99396003)(31966008)(19580395003)(19580405001)(83322001)(69596002)(68736004)(33656002)(87936001)(102836001)(6806004)(44976005)(4396001)(76482002)(83072002)(85852003)(92566001)(86362001)(92726001)(26826002)(84676001)(110136001)(46406003)(57986006)(97756001)(50466002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0631;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 07:37:50PM -0500, Felipe Balbi wrote:
> HI,
> 
> On Fri, Sep 26, 2014 at 07:39:34AM +0800, Peter Chen wrote:
> > On Thu, Sep 25, 2014 at 09:15:53AM -0500, Felipe Balbi wrote:
> > > On Wed, Sep 24, 2014 at 02:23:38PM +0200, Arnd Bergmann wrote:
> > > > On Wednesday 24 September 2014 19:29:05 Peter Chen wrote:
> > > > > 
> > > > > So, it is IP CORE LIB (you suggest) vs IP CORE Platform Driver
> > > > > (dwc3, musb, chipidea) you are talking about, right? Except for
> > > > > creating another platform driver as well as related DT node (optional),
> > > > > are there any advantages compared to current IP core driver structure?
> > > > 
> > > > Having a library module usually requires less code, and is more
> > > > consistent with other drivers, which helps new developers understand
> > > > what the driver is doing.
> > > 
> > > I beg to differ. You end-up having to pass function pointers through
> > > platform_data to handle differences which could be handled by the core
> > > IP.
> > > 
> > > > The most important aspect though is the DT binding: once the structure
> > > > with separate kernel drivers leaks out into the DT format, you can't
> > > > easily change the driver any more, e.g. to make a property that was
> > > > introduced for one glue driver more general so it can get handled by
> > > > the common part. Having a single node lets us convert to the library
> > > > model later, so that would be a strong reason to keep the DT binding
> > > > simple, without child nodes.
> > > > 
> > > > Following that logic, it turns into another reason for using the library
> > > > model to start with, because otherwise the child device does not have
> > > > any DT properties itself and has to rely on the parent device properties,
> > > > which somewhat complicates the driver structure.
> > > 
> > > this is bullcrap. Take a look at
> > > Documentation/devicetree/bindings/usb/dwc3.txt:
> > > 
> > > synopsys DWC3 CORE
> > > 
> > > DWC3- USB3 CONTROLLER
> > > 
> > > Required properties:
> > >  - compatible: must be "snps,dwc3"
> > >  - reg : Address and length of the register set for the device
> > >  - interrupts: Interrupts used by the dwc3 controller.
> > > 
> > > Optional properties:
> > >  - usb-phy : array of phandle for the PHY device.  The first element
> > >    in the array is expected to be a handle to the USB2/HS PHY and
> > >    the second element is expected to be a handle to the USB3/SS PHY
> > >  - phys: from the *Generic PHY* bindings
> > >  - phy-names: from the *Generic PHY* bindings
> > >  - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
> > > 
> > > This is usually a subnode to DWC3 glue to which it is connected.
> > > 
> > > dwc3@4a030000 {
> > > 	compatible = "snps,dwc3";
> > > 	reg = <0x4a030000 0xcfff>;
> > > 	interrupts = <0 92 4>
> > > 	usb-phy = <&usb2_phy>, <&usb3,phy>;
> > > 	tx-fifo-resize;
> > > };
> > > 
> > > This contains all the attributes it needs to work. In fact, this could
> > > be used without any glue.
> > > 
> > 
> > If you want to add "vbus-supply" core node to support ID switch, what's
> > the plan for that?
> 
> send a patch ? Just make sure it's optional because not everybody needs
> a vbus-supply. Also, DRD will still take a few merge windows to become a
> reality. I don't want to merge something before considering it carefuly,
> otherwise we will having which is broken and doesn't work for everybody
> ;-)
> 
> > Is it possible that the glue layer needs to access core register
> > (eg, portsc.phcd during suspend)? The wrapper IP may wait some signals
> > at core IP to change.
> 
> why would a glue layer need to access registers from the core ? That
> sounds very odd. I haven't seen that and will, definitely, NACK such a
> patch :-)
> 
> can you further describe why you think a glue layer might need to access
> core IP's registers ?
> 

My mistake, we can just wait core layer for finishing before doing PHY
and wrapper operation.

-- 
Best Regards,
Peter Chen
