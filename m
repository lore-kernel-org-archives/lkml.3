Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaLXEb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 23:31:59 -0500
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:9184
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751245AbaLXEb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 23:31:58 -0500
Date: Wed, 24 Dec 2014 11:08:52 +0800
From: Peter Chen <peter.chen@freescale.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <baolu.lu@linux.intel.com>
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port
 controlled by GPIO(s)
Message-ID: <20141224030835.GA31424@shlinux2>
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141223012517.GC11551@shlinux2>
 <20141223194022.GA13792@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141223194022.GA13792@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(51914003)(24454002)(189002)(199003)(85426001)(97756001)(83506001)(105606002)(46406003)(99396003)(104016003)(6806004)(84676001)(110136001)(46102003)(107046002)(120916001)(106466001)(21056001)(86362001)(50466002)(50986999)(54356999)(76176999)(87936001)(92566001)(2950100001)(77096005)(33656002)(23726002)(4396001)(31966008)(33716001)(62966003)(64706001)(47776003)(20776003)(97736003)(77156002)(68736005)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 04:17:42.4879
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0629
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 11:40:23AM -0800, David Cohen wrote:
> Hi Peter,
> 
> Thanks for the review.
> 
> On Tue, Dec 23, 2014 at 09:25:18AM +0800, Peter Chen wrote:
> > On Mon, Dec 22, 2014 at 02:43:37PM -0800, David Cohen wrote:
> > > Some platforms have an USB OTG port fully (or partially) controlled by
> > > GPIOs:
> > > 
> > > (1) USB ID is connected directly to GPIO
> > > 
> > > Optionally:
> > > (2) VBUS is enabled by a GPIO (when ID is grounded)
> > > (3) Platform has 2 USB controllers connected to same port: one for
> > >     device and one for host role. D+/- are switched between phys
> > >     by GPIO.
> > 
> > Would you explain how it works? Choosing controller runtime?
> 
> Both controllers are (indirectly) connected to the same micro B port.
> The D+/- goes from the port to a switch operated by a GPIO. From the
> switch, D+/- may go to Host controller's phy or Device controller's phy.
> Depends on the GPIO level.
> 

Get it, why the design like that? If your controller supports both
roles, the software can do role switch by ID pin (through gpio in your
case).

> > 
> > > 
> > > As per initial version, this driver has the duty to control whether
> > > USB-Host cable is plugged in or not:
> > 
> > You mean Micro-AB cable, right?
> 
> > > +
> > > +	vup->gpio_usb_mux = devm_gpiod_get_index(dev, "usb mux",
> > > +						 VUPORT_GPIO_USB_MUX);
> > > +	if (IS_ERR(vup->gpio_usb_mux))
> > > +		dev_info(dev, "cannot request USB USB MUX, skipping it.\n");
> > 
> > Using dev_err
> 
> That's not really an error, although the IS_ERR() suggests otherwise.
> The driver works well if a board doesn't need this mux (I'll add a
> comment to state that clear). IMHO either keep dev_info or use dev_dgb
> instead?
> 

If that, dev_dbg may be suitable.


-- 

Best Regards,
Peter Chen
