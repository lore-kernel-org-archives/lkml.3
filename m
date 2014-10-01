Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaJAUVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:21:11 -0400
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:44096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005AbaJAUVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:21:09 -0400
X-Greylist: delayed 5874 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2014 16:21:08 EDT
Date: Wed, 1 Oct 2014 13:20:58 -0700
From: Guenter Roeck <groeck@juniper.net>
To: Danielle Costantino <danielle.costantino@gmail.com>
CC: linux-i2c <linux-i2c@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: Re: Fwd: [Proposal] PM sleep children of inactive I2C bus segments
 off Masters in multi-master systems
Message-ID: <20141001202058.GB6948@svl-evodev-groeck.juniper.net>
References: <CAAVjN7dwS62EKMnuZc_P1UjkbRVk6RXqJ91GwWZ96bbY5Ct-rg@mail.gmail.com>
 <CAAVjN7eUmBVcAGPbcn3qsJ9M9uu2nkFoKHqGhhKGekZSceGiMw@mail.gmail.com>
 <20141001184304.GA6832@svl-evodev-groeck.juniper.net>
 <CAAVjN7edpkXYMHBm+wLegA_pc0hnm_YZf_z=Ni3h=EbDTmfegQ@mail.gmail.com>
 <20141001194115.GA6948@svl-evodev-groeck.juniper.net>
 <CAAVjN7fGRzyu7gxavJUay+K_Mm-0t1T_0Bysk6-sdaqu5=5k5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAVjN7fGRzyu7gxavJUay+K_Mm-0t1T_0Bysk6-sdaqu5=5k5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [66.129.239.11]
X-ClientProxiedBy: CO1PR06CA034.namprd06.prod.outlook.com (10.242.160.24) To
 BLUPR05MB513.namprd05.prod.outlook.com (10.141.29.140)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR05MB513;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6069001)(6009001)(377454003)(24454002)(199003)(189002)(51704005)(97736003)(86362001)(99396003)(47776003)(106356001)(76506005)(92726001)(20776003)(87976001)(4396001)(107046002)(31966008)(92566001)(101416001)(85852003)(46406003)(76176999)(54356999)(85306004)(93886004)(77096002)(97756001)(50986999)(120916001)(50466002)(102836001)(64706001)(76482002)(551934003)(10300001)(561944003)(83506001)(95666004)(46102003)(42186005)(105586002)(23726002)(110136001)(80022003)(33656002)(21056001)(66066001)(19580395003)(19580405001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR05MB513;H:localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 01:03:59PM -0700, Danielle Costantino wrote:
> On Wed, Oct 1, 2014 at 12:41 PM, Guenter Roeck <groeck@juniper.net> wrote:
> > On Wed, Oct 01, 2014 at 11:44:59AM -0700, Danielle Costantino wrote:
> >> Re-sending Proposal:
> >>
> >> Currently I2C mux devices that support multiple master arbitration are
> >> the i2c-mux-pca9541 and i2c-arb-gpio-challenge drivers. I propose to
> >> add the ability to configure an interrupt pin from the Master Selector
> >> device to indicate that bus ownership has been lost. Once the device
> >> loses ownership, all of its children should enter a pm sleep mode (as
> >> you can't talk to them at this point) until master-ship has been
> >> reacquired.
> >>
> > Not sure I understand what you are proposing here.
> 
> Lets say you have a active - standby based multi-master system. If the
> other master forced arbitration (took mastership) the next transation
> on any slaves of that bus would return EAGAIN or EBUSY.
> 
> Another point is that once mastership has been lost, the configuration
> of the devices on that bus are no longer known to be valid...therefor
> a re-init of those devices may be needed.
> 
Unfortunately that is a generic problem in a multi-master system.
You never know if the other end reconfigured a device or not,
even if there was no error.

> > A typical use case would be a power supply such as the one supported by
> > drivers/hwmon/lineage-pem.c from both an active and standby system
> > controller. The power supply needs to be accessible from both controllers.
> > If one controller looses access, it can only mean that it did not follow
> > the access protocol. Similar, one controller enforcing access means that
> > it either does not follow the access protocol either, or that the other
> > end did not follow the protocol (or maybe the other end died).
> >
> > In all cases, loss of access does not mean that the end device can or should
> > be put in sleep mode, not even logically. All it means is that there was
> > an access protocol error. Not sure if there is anything that can be done
> > about that, but putting the device into sleep mode does not seem to be
> > an appropriate response to me.
> >
> >> This has come up as an issue when the master loses control over a bus
> >> the return code of all transactions to its lave devices is EIO (not
> >> very helpful).
> >>
> > But, again, doesn't that mean that there was some access protocol error ?
> > Shouldn't it try to re-acquire mastership instead, and block all accesses
> > to slaves until it acquired it ?
> 
> EIO is such a generic error it makes finding weather there was a
> problem communicating or is no longer master of the bus segment.
> 
AFAICS the only time the pca9541 driver returns -EIO is if a transaction
did not complete. Only possible improvement I could imagine would be to
check if mastership was lost if there was an error, and return something
more useful if that is the case. Both -EBUSY or -EAGAIN might make sense
here; I don't really know what would be better or more appropriate.

Guenter
