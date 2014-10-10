Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaJJQjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:39:04 -0400
Received: from mail-by2on0057.outbound.protection.outlook.com ([207.46.100.57]:63456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753491AbaJJQjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:39:02 -0400
Date: Fri, 10 Oct 2014 11:32:35 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Dinh Nguyen <dinguyen@opensource.altera.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, <dinh.linux@gmail.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early
 initialization
In-Reply-To: <20141009151935.GK15799@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1410101123590.11270@atx-linux-37>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com> <1412845410.6809.3.camel@pengutronix.de> <54368AA2.9000104@opensource.altera.com> <20141009132835.GI15799@pengutronix.de> <alpine.DEB.2.02.1410090950540.17462@atx-linux-37>
 <20141009151935.GK15799@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR08CA052.namprd08.prod.outlook.com (10.141.248.170) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(51704005)(24454002)(189002)(479174003)(377454003)(92566001)(80022003)(33716001)(21056001)(46102003)(105586002)(85852003)(107046002)(81156004)(86362001)(86152002)(106356001)(101416001)(97736003)(40100002)(92726001)(42186005)(50466002)(4396001)(120916001)(20776003)(23726002)(54356999)(83506001)(85306004)(15975445006)(15202345003)(93886004)(50986999)(47776003)(46406003)(69596002)(53416004)(99396003)(122386002)(87976001)(76482002)(110136001)(77096002)(76176999)(102836001)(31966008)(95666004)(19580395003)(64706001)(19580405001)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2014, Steffen Trumtrar wrote:

Hi Steffen,

> Hi!
> 
> On Thu, Oct 09, 2014 at 09:57:49AM -0500, atull wrote:
> > On Thu, 9 Oct 2014, Steffen Trumtrar wrote:
> > 
> > > On Thu, Oct 09, 2014 at 08:16:18AM -0500, Dinh Nguyen wrote:
> > > > Hi Philipp,
> > > > 
> > > > On 10/9/14, 4:03 AM, Philipp Zabel wrote:
> > > > > Am Mittwoch, den 08.10.2014, 21:44 -0500 schrieb
> > > > > dinguyen@opensource.altera.com:
> > > > >> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> > > > >>
> > > > >> There are certain drivers that are required to get loaded very early using
> > > > >> arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
> > > > >> This driver has to get loaded early because it needs to enable FPGA components
> > > > >> that are connected to the bridge.
> > > > >>
> > > > >> This FPGA bridge driver will using the reset controller API to toggle it's
> > > > >> reset bits, thus, it needs the reset driver to be loaded as early as possible
> > > > >> in order for it to get used properly.
> > > > > 
> > > > > Without knowing the details, this sounds like the wrong approach. Can't
> > > > > the bridge driver return -EPROBE_DEFER until the reset controller is
> > > > > available?
> > > > > 
> > 
> > I don't think we can do deferred probing for arch_initcall.
> > 
> > > > 
> > > > The bridge driver is also using arch_initcall, as it also needs to get
> > > > loaded early for FPGA IPs to work, and so later driver loading will work
> > > > for the FPGA IPs.
> > > > 
> > > 
> > > For the bridge driver the same is true. I guess that there *might* be
> > > IP cores where you need to be very early, but that shouldn't be the normal
> > > case. If the driver can't get loaded properly, the right thing would be to
> > > fix the driver.
> > 
> > Some fpga ip drivers will need to be early (and will assume that the fpga
> > was programmed by the bootloader).  We want to support that case.
> >
> 
> Do you have an example where this is really needed?

My last version of the fpga manager framework 
(https://lkml.org/lkml/2014/8/1/518)
added fpga_mgr_firmware_write().  This can be called from a device driver's 
probe function to request a fpga image be loaded.  I want to support FPGA 
based functionality being seen pretty similar to really hard hardware.  So 
the FPGA could have a PCI bus or something else that would want to be 
early.

> 
> > > 
> > > I have developed a bridge driver, too (which only needs the devicetree binding
> > > docu for a v1) and I have a driver+IP core that is directly connected to the
> > > bridge. I don't need any messing around with the initcalls to work properly.
> > > -EPROBE_DEFER works just fine.
> > 
> > Is this based on the "proposed fpga bridge framework" that I posted?
> > What we are trying to do is update that bridge driver to use the reset driver for 
> > submitting v2.
> 
> Are you talking about the FPGA manager patches? Then: no.
> If not, I seem to have missed the patches.
> 
> The driver just probes and then releases the resets for the according bridge.
> It shall however support the GPV configuration also (which it doesn't at the moment)
> 
> But this reminds me, why I didn't send the driver earlier. IIRC you want to reset
> the bridges after writing the bitstream to the FPGA manager.
> So, I would need to add that first so you can access that in your fpga manager
> driver.

We need to hold the bridges in reset as long as the FPGA is not programmed
or is being programmed.  We want to release the bridges from reset after
programming.  If we are going to re-program the FPGA, we will need to
unload any device drivers, set the bridges into reset, then reprogram
the FPGA, release the bridges, load the appropriate device drivers.
The latest fpga manager code also handles reprogramming the FPGA when
device tree fragments are loaded.

Alan

> 
> Regards,
> Steffen
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 
