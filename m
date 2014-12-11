Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965249AbaLKVkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:40:00 -0500
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:64832
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934082AbaLKVj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:39:58 -0500
X-Greylist: delayed 2417 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2014 16:39:57 EST
Date: Thu, 11 Dec 2014 13:39:50 -0800
From: Guenter Roeck <groeck@juniper.net>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Rajat Jain <rajatxjain@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Subject: Re: [PATCH v2] PCI: pciehp: Check link state before accessing device
 during removal
Message-ID: <20141211213950.GA22334@svl-evodev-groeck.juniper.net>
References: <546E7120.5080505@gmail.com>
 <20141211002630.GC22886@google.com>
 <20141211163831.GA2845@svl-evodev-groeck.juniper.net>
 <CAErSpo62wQ6g74wNYYumgbAVJ3Mneu_dmWOhLBE6NWqQTXsvVQ@mail.gmail.com>
 <20141211204515.GA4472@svl-evodev-groeck.juniper.net>
 <CAErSpo4WAbb=n+cNARRgKWPhbn6LZqwL-htB_Uv2OWB9BwTXpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAErSpo4WAbb=n+cNARRgKWPhbn6LZqwL-htB_Uv2OWB9BwTXpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [66.129.239.11]
X-ClientProxiedBy: CO2PR04CA042.namprd04.prod.outlook.com (10.141.240.170) To
 BN1PR05MB520.namprd05.prod.outlook.com (10.141.65.151)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB520;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:BN1PR05MB520;
X-Forefront-PRVS: 0422860ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6069001)(199003)(51704005)(24454002)(57704003)(377454003)(189002)(86362001)(46102003)(105586002)(50466002)(92566001)(19580395003)(46406003)(120916001)(99396003)(122386002)(83506001)(40100003)(20776003)(97756001)(76176999)(54356999)(47776003)(50986999)(66066001)(87976001)(42186005)(33656002)(19580405001)(64706001)(21056001)(4396001)(93886004)(31966008)(106356001)(76506005)(97736003)(101416001)(107046002)(23726002)(68736005)(110136001)(77096005)(77156002)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB520;H:localhost;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB520;
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 02:00:06PM -0700, Bjorn Helgaas wrote:
> On Thu, Dec 11, 2014 at 1:45 PM, Guenter Roeck <groeck@juniper.net> wrote:
> > On Thu, Dec 11, 2014 at 01:26:47PM -0700, Bjorn Helgaas wrote:
> >> On Thu, Dec 11, 2014 at 9:38 AM, Guenter Roeck <groeck@juniper.net> wrote:
> >> > On Wed, Dec 10, 2014 at 05:26:30PM -0700, Bjorn Helgaas wrote:
> >> >> On Thu, Nov 20, 2014 at 02:54:24PM -0800, Rajat Jain wrote:
> 
> >> >> If we do need it (and it looks like most or all hotplug drivers copied it),
> >> >> isn't there still a race?  Can't we have the following sequence?
> >> >>
> >> >>   - pciehp_check_link_active()                # returns true
> >> >>   - Link goes down
> >> >>   - pci_read_config_byte()            # fails because link is down
> >> >>
> >> > I would guess so. Question is how to address it. Read the configuration byte
> >> > first, then check if the link is down ? Check if link is still up after reading
> >> > the configuration byte ? Add a note that there may be a potential race condition
> >> > and do nothing until it is actually seen ?
> >>
> >> I think we should just read PCI_BRIDGE_CONTROL and look for a 0xff
> >> value.  That's not a legal value for the register, so if we see it, it
> >> should be pretty safe to assume the link is down or the device is not
> >> present at all.
> >>
> > Something like
> >         if (bctl != 0xff && (bctl & PCI_BRIDGE_CTL_VGA)) {
> > in addition to Rajat's changes ?
> >
> > I think it would be good to keep the change Rajat proposed, ie to check
> > the link state instead of presence. Question then is if you'd want a new
> > revision of Rajat's patch or another patch on top of it with the bctl
> > related change.
> 
> Why do we need the link state or the presence check?  It seems like
> those are sort of a 90% solution, and doing them provides the illusion
> of value but without real value.  If we think that checking for 0xff
> is a 100% solution, we should rely on that and not bother with
> anything else.
> 
Interesting thought. Let me play with that.

Guenter
