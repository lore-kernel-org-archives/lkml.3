Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbaDHMqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:46:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaDHMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:46:09 -0400
Date: Tue, 8 Apr 2014 14:45:41 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "tthayer@altera.com" <tthayer@altera.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] edac: altera: Add SDRAM EDAC support for
 CycloneV/ArriaV
Message-ID: <20140408124541.GA16054@pengutronix.de>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
 <1396907649-20212-4-git-send-email-tthayer@altera.com>
 <20140408104525.GA11876@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408104525.GA11876@e106331-lin.cambridge.arm.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:44:34 up 226 days, 22:15, 55 users,  load average: 0,18, 0,11,
 0,11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 11:45:25AM +0100, Mark Rutland wrote:
> On Mon, Apr 07, 2014 at 10:54:09PM +0100, tthayer@altera.com wrote:
> > From: Thor Thayer <tthayer@altera.com>
> > 
> > Added EDAC support for reporting ECC errors of CycloneV
> > and ArriaV SDRAM controller.
> > - The SDRAM Controller registers are used by the FPGA bridge so
> >   these are accessed through the syscon interface.
> > - The configuration of the SDRAM memory size for the EDAC framework
> >   is discovered from the memory node of the device tree.
> > - Documentation of the bindings in devicetree/bindings/arm/altera/
> >   socfpga-sdram-edac.txt
> > - Correction of single bit errors, detection of double bit errors.
> > 
> > Signed-off-by: Thor Thayer <tthayer@altera.com>
> > To: Rob Herring <robherring2@gmail.com>
> > To: Doug Thompson <dougthompson@xmission.com>
> > To: Grant Likely <grant.likely@linaro.org>
> > Cc: Dinh Nguyen <dinguyen@altera.com>
> > Cc: devicetree@vger.kernel.org
> > Cc: linux-edac@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/edac/Kconfig          |    9 ++
> >  drivers/edac/Makefile         |    2 +
> >  drivers/edac/altera_mc_edac.c |  360 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 371 insertions(+)
> >  create mode 100644 drivers/edac/altera_mc_edac.c
> 
> [...]
> 
> > +/* Get total memory size from Open Firmware DTB */
> > +static u32 altr_sdram_get_total_mem_size(void)
> > +{
> > +       struct device_node *np;
> > +       u32 retcode, reg_array[2];
> > +
> > +       np = of_find_node_by_type(NULL, "memory");
> > +       if (!np)
> > +               return 0;
> > +
> > +       retcode = of_property_read_u32_array(np, "reg",
> > +                                            reg_array, ARRAY_SIZE(reg_array));
> 
> There's no requirement that #address-cells = <1> or #size-cells = <1>,
> even if any values in either would fit into 32 bits. If we must read
> this from the DTB rather than elsewhere, please check
> of_n_{addr,size}_cells.
> 
> Additionally, it's possible that the physical memory might be described
> over multiple reg entries, or multiple memory nodes for some arbitrary
> reason.
> 
> Can we not get this info from elsewhere rather than having to parse the
> memory node within a driver?
> 

It should be possible to calculate this from the dramaddrw register in the
SDRAM controller.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
