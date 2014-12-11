Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbaLKT5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:57:04 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:14509
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758765AbaLKT5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:57:03 -0500
Date: Thu, 11 Dec 2014 11:56:50 -0800
From: Guenter Roeck <groeck@juniper.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Dely Sy <dely.l.sy@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatxjain@gmail.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Special handling of display/VGA devices in hotplug drivers
Message-ID: <20141211195650.GA4295@svl-evodev-groeck.juniper.net>
References: <CAErSpo4iZCUZgqNi-fX+YX=sKV=Ae5z8kn8-++E0Cgft9unmBg@mail.gmail.com>
 <20141211181136.GA11367@kroah.com>
 <20141211113243.3f21551e@jbarnes-t420>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141211113243.3f21551e@jbarnes-t420>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [66.129.239.11]
X-ClientProxiedBy: BY1PR10CA0010.namprd10.prod.outlook.com (25.160.197.20) To
 CO1PR05MB521.namprd05.prod.outlook.com (10.141.72.13)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR05MB521;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:CO1PR05MB521;
X-Forefront-PRVS: 0422860ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6069001)(189002)(51704005)(24454002)(199003)(83506001)(92566001)(87976001)(19580395003)(21056001)(42186005)(19580405001)(107046002)(76506005)(33656002)(106356001)(110136001)(101416001)(86362001)(77156002)(62966003)(4396001)(122386002)(46406003)(97736003)(40100003)(47776003)(20776003)(64706001)(120916001)(99396003)(15975445007)(50986999)(54356999)(77096005)(97756001)(31966008)(50466002)(46102003)(76176999)(23726002)(66066001)(105586002)(68736005);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR05MB521;H:localhost;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR05MB521;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR05MB538;
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:32:43AM -0800, Jesse Barnes wrote:
> On Thu, 11 Dec 2014 13:11:36 -0500
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Thu, Dec 11, 2014 at 10:34:30AM -0700, Bjorn Helgaas wrote:
> > > It looks like you added the initial pciehp driver [1], which
> > > includes the following code in pciehp_disable_slot():
> > > 
> > > + if (class_code == PCI_BASE_CLASS_DISPLAY) {
> > > + /* Display/Video adapter (not supported) */
> > > + rc = REMOVE_NOT_SUPPORTED;
> > > 
> > > + /* If it's a bridge, check the VGA Enable bit */
> > > + if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
> > > + rc = pci_bus_read_config_byte (pci_bus, devfn,
> > > PCI_BRIDGE_CONTROL, &BCR);
> > > + if (rc)
> > > + return rc;
> > > +
> > > + /* If the VGA Enable bit is set, remove isn't supported */
> > > + if (BCR & PCI_BRIDGE_CTL_VGA) {
> > > + rc = REMOVE_NOT_SUPPORTED;
> > > 
> > > I'm trying to figure out why VGA devices are handled specially.  I
> > > can't find anything in the PCI specs that mentions this.  Most of
> > > the other PCI hotplug drivers have similar code.  Do you remember
> > > anything about this?
> > 
> > The PCI spec said that you were not allowed to hotplug VGA drivers.
> > The big issue is that POST usually needs to run on those things, and
> > there is no way to POST a PCI hotplugged device.
> > 
> > Does the spec not say that anymore?  I haven't looked in years at
> > it...
> > 
> > Do you want to hot-add a VGA device?  Are these lines causing a
> > problem with something?
> 
> Yeah, the legacy I/O regions get routed through the bridge with the VGA
> bit set, and most legacy code probably can't handle that (whether POST,
> VBIOS, or VGA drivers).
> 
> There is some code for moving the VGA routing around, so that might be
> an option if you wanted to remove such a bridge.  You'd have to find a
> VGA device under another bridge, and enable routing to that first, then
> you could do the remove.
> 

The problem at hand though is that the current code may mis-detect a device as
VGA device after it was removed. In that case, reading a configuration register
returns 0xff, meaning the VGA bit is set, and the kernel refuses to remove it.

See [1] for a description of the problem and its impact.

Guenter
---
[1] https://lkml.org/lkml/2014/11/20/714
