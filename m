Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaJTGni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:43:38 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:18861
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455AbaJTGnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:43:35 -0400
X-WSS-ID: 0NDQDCG-08-KS6-02
X-M-MSG: 
Date: Mon, 20 Oct 2014 14:43:31 +0800
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
Subject: Re: [PATCH v2 08/16] usb: dwc3: add u2exit lfps quirk
Message-ID: <20141020064331.GC24357@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <1413536021-4886-9-git-send-email-ray.huang@amd.com>
 <20141017145000.GD26260@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141017145000.GD26260@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(428002)(51704005)(189002)(199003)(24454002)(164054003)(84676001)(85306004)(86362001)(31966008)(44976005)(54356999)(76176999)(50986999)(87936001)(97756001)(68736004)(83506001)(85852003)(92726001)(92566001)(102836001)(101416001)(33656002)(19580395003)(19580405001)(110136001)(23726002)(4396001)(95666004)(97736003)(77096002)(50466002)(21056001)(120916001)(64706001)(20776003)(107046002)(46406003)(47776003)(76482002)(99396003)(80022003)(46102003)(53416004)(105586002)(106466001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:50:00AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 17, 2014 at 04:53:33PM +0800, Huang Rui wrote:
> > AMD NL needs to enable u2exit lfps quirk.
> > 
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > ---
> >  drivers/usb/dwc3/core.c          | 4 ++++
> >  drivers/usb/dwc3/core.h          | 1 +
> >  drivers/usb/dwc3/dwc3-pci.c      | 3 ++-
> >  drivers/usb/dwc3/platform_data.h | 1 +
> >  4 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index 25db533..7322d85 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -467,6 +467,10 @@ static int dwc3_core_init(struct dwc3 *dwc)
> >  		reg |= DWC3_GCTL_DISSCRAMBLE;
> >  	else
> >  		reg &= ~DWC3_GCTL_DISSCRAMBLE;
> > +
> > +	if (dwc->quirks & DWC3_QUIRK_U2EXIT_LFPS)
> 
> this should be:
> 
> 	if (dwc->u2_exit_lfps_quirk)
> 

OK, will update it in V3.

> > +		reg |= DWC3_GCTL_U2EXIT_LFPS;
> > +
> >  	/*
> >  	 * WORKAROUND: DWC3 revisions <1.90a have a bug
> >  	 * where the device can fail to connect at SuperSpeed
> > diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> > index d58479e..3d27f10 100644
> > --- a/drivers/usb/dwc3/core.h
> > +++ b/drivers/usb/dwc3/core.h
> > @@ -166,6 +166,7 @@
> >  #define DWC3_GCTL_SCALEDOWN(n)		((n) << 4)
> >  #define DWC3_GCTL_SCALEDOWN_MASK	DWC3_GCTL_SCALEDOWN(3)
> >  #define DWC3_GCTL_DISSCRAMBLE		(1 << 3)
> > +#define DWC3_GCTL_U2EXIT_LFPS		(1 << 2)
> >  #define DWC3_GCTL_GBLHIBERNATIONEN	(1 << 1)
> >  #define DWC3_GCTL_DSBLCLKGTNG		(1 << 0)
> >  
> > diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
> > index bbe946c..cdb9b04 100644
> > --- a/drivers/usb/dwc3/dwc3-pci.c
> > +++ b/drivers/usb/dwc3/dwc3-pci.c
> > @@ -149,7 +149,8 @@ static int dwc3_pci_probe(struct pci_dev *pci,
> >  	if (pci->vendor == PCI_VENDOR_ID_AMD && pci->device ==
> >  			PCI_DEVICE_ID_AMD_NL) {
> >  		dwc3_pdata.has_lpm_erratum = true;
> > -		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL;
> > +		dwc3_pdata.quirks |= DWC3_QUIRK_AMD_NL
> > +			| DWC3_QUIRK_U2EXIT_LFPS;
> >  	}
> 
> should be combined and the last patch in the series.
> 

You want to make all the AMD quirks enablement info and device id at
last patch, right?

Thanks,
Rui
