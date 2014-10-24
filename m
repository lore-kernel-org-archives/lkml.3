Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaJXRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:16:59 -0400
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:45286
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756592AbaJXRQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:16:57 -0400
X-WSS-ID: 0NDYLC2-08-CT3-02
X-M-MSG: 
Date: Sat, 25 Oct 2014 01:01:28 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul Zimmerman" <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/16] usb: dwc3: add lpm erratum support
Message-ID: <20141024170128.GA5149@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-8-git-send-email-ray.huang@amd.com>
 <20141017144859.GC26260@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141017144859.GC26260@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(24454002)(51704005)(479174003)(189002)(164054003)(19580405001)(84676001)(83506001)(19580395003)(44976005)(77096002)(107046002)(50466002)(87936001)(68736004)(85852003)(92726001)(92566001)(97756001)(76176999)(50986999)(54356999)(21056001)(46102003)(80022003)(4396001)(53416004)(95666004)(106466001)(110136001)(105586002)(97736003)(85306004)(33656002)(101416001)(102836001)(120916001)(99396003)(76482002)(23726002)(86362001)(575784001)(31966008)(64706001)(46406003)(20776003)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:48:59AM -0500, Felipe Balbi wrote:
> On Fri, Oct 17, 2014 at 04:53:32PM +0800, Huang Rui wrote:
> > When parameter DWC_USB3_LPM_ERRATA_ENABLE is enabled in Andvanced Configuration
> > of coreConsultant, it supports of xHCI BESL Errata Dated 10/19/2011 is enabled
> > in host mode. In device mode it adds the capability to send NYET response based
> > on the BESL value received in the LPM token.
> > 
> > This patch add an entry that soc platform is able to define the lpm capacity
> > with their own device tree or bus glue layer.
> > 
> > Suggested-by: Felipe Balbi <balbi@ti.com>
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/usb/dwc3/core.c          |  2 ++
> >  drivers/usb/dwc3/core.h          | 24 +++++++++++++++---------
> >  drivers/usb/dwc3/dwc3-pci.c      |  1 +
> >  drivers/usb/dwc3/gadget.c        |  7 +++++++
> >  drivers/usb/dwc3/platform_data.h |  1 +
> >  5 files changed, 26 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index 819e501..25db533 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -708,11 +708,13 @@ static int dwc3_probe(struct platform_device *pdev)
> >  
> >  	if (node) {
> >  		dwc->maximum_speed = of_usb_get_maximum_speed(node);
> > +		dwc->has_lpm_erratum = of_property_read_bool(node, "snps,has-lpm-erratum");
> >  
> >  		dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
> >  		dwc->dr_mode = of_usb_get_dr_mode(node);
> >  	} else if (pdata) {
> >  		dwc->maximum_speed = pdata->maximum_speed;
> > +		dwc->has_lpm_erratum = pdata->has_lpm_erratum;
> >  
> >  		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
> >  		dwc->dr_mode = pdata->dr_mode;
> > diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> > index cfe0d57..d58479e 100644
> > --- a/drivers/usb/dwc3/core.h
> > +++ b/drivers/usb/dwc3/core.h
> > @@ -246,16 +246,19 @@
> >  #define DWC3_DCTL_TRGTULST_SS_INACT	(DWC3_DCTL_TRGTULST(6))
> >  
> >  /* These apply for core versions 1.94a and later */
> > -#define DWC3_DCTL_KEEP_CONNECT	(1 << 19)
> > -#define DWC3_DCTL_L1_HIBER_EN	(1 << 18)
> > -#define DWC3_DCTL_CRS		(1 << 17)
> > -#define DWC3_DCTL_CSS		(1 << 16)
> > +#define DWC3_DCTL_LPM_ERRATA_MASK	DWC3_DCTL_LPM_ERRATA(0xf)
> > +#define DWC3_DCTL_LPM_ERRATA(n)		((n) << 20)
> > -#define DWC3_DCTL_INITU2ENA	(1 << 12)
> > -#define DWC3_DCTL_ACCEPTU2ENA	(1 << 11)
> > -#define DWC3_DCTL_INITU1ENA	(1 << 10)
> > -#define DWC3_DCTL_ACCEPTU1ENA	(1 << 9)
> > -#define DWC3_DCTL_TSTCTRL_MASK	(0xf << 1)
> > +#define DWC3_DCTL_KEEP_CONNECT		(1 << 19)
> > +#define DWC3_DCTL_L1_HIBER_EN		(1 << 18)
> > +#define DWC3_DCTL_CRS			(1 << 17)
> > +#define DWC3_DCTL_CSS			(1 << 16)
> > +
> > +#define DWC3_DCTL_INITU2ENA		(1 << 12)
> > +#define DWC3_DCTL_ACCEPTU2ENA		(1 << 11)
> > +#define DWC3_DCTL_INITU1ENA		(1 << 10)
> > +#define DWC3_DCTL_ACCEPTU1ENA		(1 << 9)
> > +#define DWC3_DCTL_TSTCTRL_MASK		(0xf << 1)
> >  
> >  #define DWC3_DCTL_ULSTCHNGREQ_MASK	(0x0f << 5)
> >  #define DWC3_DCTL_ULSTCHNGREQ(n) (((n) << 5) & DWC3_DCTL_ULSTCHNGREQ_MASK)
> > @@ -665,6 +668,8 @@ struct dwc3_scratchpad_array {
> >   * @ep0_bounced: true when we used bounce buffer
> >   * @ep0_expect_in: true when we expect a DATA IN transfer
> >   * @has_hibernation: true when dwc3 was configured with Hibernation
> > + * @has_lpm_erratum: true when core was configured with LPM Erratum. Note that
> > + *			there's now way for software to detect this in runtime.
> >   * @is_selfpowered: true when we are selfpowered
> >   * @is_fpga: true when we are using the FPGA board
> >   * @needs_fifo_resize: not all users might want fifo resizing, flag it
> > @@ -771,6 +776,7 @@ struct dwc3 {
> >  	unsigned		ep0_bounced:1;
> >  	unsigned		ep0_expect_in:1;
> >  	unsigned		has_hibernation:1;
> > +	unsigned		has_lpm_erratum:1;
> >  	unsigned		is_selfpowered:1;
> >  	unsigned		is_fpga:1;
> >  	unsigned		needs_fifo_resize:1;
> > diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> > index a89db6c..bbe946c 100644
> > --- a/drivers/usb/dwc3/dwc3-pci.c
> > +++ b/drivers/usb/dwc3/dwc3-pci.c
> > @@ -148,6 +148,7 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> >  
> >  	if (pci->vendor == PCI_VENDOR_ID_AMD && pci->device ==
> >  			PCI_DEVICE_ID_AMD_NL) {
> > +		dwc3_pdata.has_lpm_erratum = true;
> >  		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL;
> >  	}
> >  
> 
> let's combine all AMD patches as the last patch in the series so we add
> AMD support with all quirks in one place.
> 
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 1f2a719..33bfc70 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -1581,6 +1581,13 @@ static int dwc3_gadget_start(struct usb_gadget *g,
> >  	}
> >  	dwc3_writel(dwc->regs, DWC3_DCFG, reg);
> >  
> > +	if (dwc->has_lpm_erratum) {
> > +		reg = dwc3_readl(dwc->regs, DWC3_DCTL);
> > +		/* REVISIT should this be configurable ? */
> > +		reg |= DWC3_DCTL_LPM_ERRATA(0xf);
> 
> as Paul mentioned, this should definitely be configurable. So we need to
> discuss how to make that configurable too.
> 

Can I define a 4-bits variable (lpm_nyet_thres) to let platform vendor able to configure
the besl value at DT or glue layer?

struct dwc3_platform_data {
        ...
        unsigned has_lpm_erratum:1;
        unsigned lpm_nyet_thres:4;
}

Then put the value at probe like:

dwc->has_lpm_erratum = of_property_read_u8(node, "snps,lpm-nyet-thres");

I don't find a 4-bit "Find from a property" interface, so can I use
of_property_read_u8 instead for ARM platforms?

Then do:
if (dwc->has_lpm_erratum)
        reg |= DWC3_DCTL_LPM_ERRATA(dwc->lpm_nyet_thres);

Thanks,
Rui
