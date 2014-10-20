Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaJTPkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:40:11 -0400
Received: from [207.46.100.112] ([207.46.100.112]:61296 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192AbaJTPkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:40:08 -0400
X-WSS-ID: 0NDR267-07-96A-02
X-M-MSG: 
Date: Mon, 20 Oct 2014 23:38:23 +0800
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
Subject: Re: [PATCH v2 00/16] usb: dwc3: add support for AMD NL SoC
Message-ID: <20141020153822.GF24357@hr-slim.amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
 <20141017151026.GN26260@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141017151026.GN26260@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(199003)(189002)(164054003)(24454002)(120916001)(85306004)(101416001)(31966008)(54356999)(19580395003)(44976005)(99396003)(97736003)(46406003)(92726001)(92566001)(50466002)(46102003)(64706001)(20776003)(84676001)(47776003)(53416004)(80022003)(23726002)(102836001)(68736004)(87936001)(85852003)(86362001)(97756001)(83506001)(76482002)(107046002)(50986999)(95666004)(106466001)(105586002)(76176999)(33656002)(21056001)(19580405001)(77096002)(4396001)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:10:26AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 17, 2014 at 04:53:25PM +0800, Huang Rui wrote:
> > The series of patches add AMD NL SoC support for DesignWare USB3 OTG
> > IP with PCI bus glue layer. This controller supported hibernation, LPM
> > erratum and used the 2.80a IP version and amd own phy. Current
> > implementation support both simulation and SoC platform. And already
> > tested with gadget zero and msc tool.  It works well on file storage
> > gadget.
> 
> patches look much, much nicer there are still a few things to fix. A
> global set of issues which I see:
> 
> 1) Let's get confirmation that all those quirks will be needed in
> production as well, I have a feeling quite a few of them won't be.
> 
> 2) All quirks should become 1-bit fields insteads of single-bits on a
> 32-bit variable.
> 
> 3) All quirks should have DeviceTree counterparts. They should all
> become boolean properties should we can:
> 
> 	dwc->tx_deemphasis_quirk = of_property_read_bool(node,
> 		"snps,tx_deemphasis_quirk");
> 

Thanks to summarize them. Will update in V3.

> > These patches are generated on balbi/testing/next
> > 
> > Changes from v1 -> v2
> > - remove dual role function temporarily
> > - add pci quirk to avoid to bind with xhci driver
> > - distinguish between simulation board and soc
> > - break down all the special quirks
> > 
> > 
> > Patch 1:
> > - add PCI device id into pci bus glue
> 
> this guy should be the last in the series, with all AMD quirks being
> enabled at once. This will avoid bisection points where AMD's platforms
> don't work.
> 

So all the AMD special configuration and device id should be in one
patch, right?

> > Patch 2:
> 
> this should become as patch one :-)
> 
> > - add PCI quirk to avoid to bind with xhci
> > 
> > Patch 3:
> > - enable hibernation
> > 
> > Patch 4:
> > - distinguish between simulation board and soc
> > 
> > Patch 5:
> > - add quirks flag to be compatible for kinds of soc
> > 
> > Patch 6 - 16:
> > - as felipe's suggestion, break down all the special quirks of amd nl
> > 
> > 
> > Patch set already passed all the MSC testing, detailed result is below:
> > 
> > root@hr-ub:/home/ray/felipe/usb-tools# ./msc.sh -o /dev/sdb1
> > test 0e: simple 64k read/write
> > test  0: sent      62.50 MB read      22.00 MB/s write      16.33 MB/s ... success
> 
> Are you still running with VERBOSE_DEBUG on USB2 ? Here's what I get on
> USB2 connected to my PC with DWC3 running on a single-core cortex-a9
> board:
> 
> $ ./msc -t0 -o /dev/sdh -s 65536 -c 5000
> test  0: sent     312.50 MB read      31.63 MB/s write      29.10 MB/s ... success
> 
> And with RAM as backend:
> 
> $ ./msc -t0 -o /dev/sdh -s 65536 -c 5000
> test  0: sent     312.50 MB read      31.64 MB/s write      29.04 MB/s ... success
> 

Yes, I will disable DEBUG option to test again.

Thanks,
Rui
