Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbaFLI2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:28:20 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:37312
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932470AbaFLI2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:28:17 -0400
Date: Thu, 12 Jun 2014 15:02:12 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Matt Porter <matt.porter@linaro.org>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140612070211.GC18009@shlinux1.ap.freescale.net>
References: <20140611021439.GA25082@shlinux1.ap.freescale.net>
 <20140611041000.GB15184@kroah.com> <20140611043507.GA30126@saruman.home>
 <20140611032956.GC25082@shlinux1.ap.freescale.net>
 <20140611193627.GA19366@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140611193627.GA19366@saruman.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(189002)(199002)(74502001)(74662001)(20776003)(47776003)(81542001)(23726002)(6806004)(15202345003)(31966008)(33656002)(84676001)(97756001)(104016001)(64706001)(97736001)(102836001)(26826002)(81342001)(4396001)(83322001)(19580395003)(44976005)(83506001)(79102001)(15975445006)(99396002)(86362001)(46102001)(93886003)(68736004)(76482001)(50986999)(92726001)(92566001)(76176999)(54356999)(77096999)(87936001)(21056001)(83072002)(80022001)(46406003)(77982001)(50466002)(85852003);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:36:27PM -0500, Felipe Balbi wrote:
> On Wed, Jun 11, 2014 at 11:29:57AM +0800, Peter Chen wrote:
> > On Tue, Jun 10, 2014 at 11:35:07PM -0500, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Tue, Jun 10, 2014 at 09:10:00PM -0700, Greg KH wrote:
> > > > > Let's take USB peripheral as an example, there is a device for
> > > > > udc, and a device driver for usb gadget driver, at default, we want
> > > > > the device to be bound to driver automatically, this is what
> > > > > we have done now. But if there are more than one udcs and gadget
> > > > > drivers (eg one B port for mass storage, another B port for usb ethernet),
> > > > > the user may want to have specific binding (eg, udc-0 -> mass storage,
> > > > > udc-1 -> usb ethernet), so the binding will be established
> > > > > after rootfs has mounted. (This feature is implementing)
> > > > 
> > > > Then there better be a way to describe this on the kernel command line
> > > > (i.e. module paramaters), right?  Which is a total mess, why not just
> > > > not bind anything in this case and let the user pick what they want?
> > > 
> > > you can also blacklist all gadget drivers and manually probe them or -
> > > get this - you can refrain from using gadget drivers and use libusbg to
> > > build the gadget drivers out of raw usb functions, then bind them to the
> > > UDC of your liking.
> > > 
> > 
> > I am just worried if we change the behaviour of using gadget driver,
> > can it be accepted by user? If you think it can be accepted if we can
> > have some docs, we can implement manually binding for gadget driver
> > from now on.
> 
> user shouldn't have to deal with direct module insertion/removal (unless
> he's a developer and actually *wants* to do that). Docs are already in
> tree. The entire configfs interface has been documented, it's based on
> those documents that Matt started writing libusbg.
> 
> -- 
> balbi

Yes, gadget-configfs is a good direction.

I would like to know your plan for other gadget drivers (g_mass_storage,
g_webcam, etc)

All functions will be supported by configfs in future, and current
driver will be deleted?
- If yes, how to cover the user who still use the old file system?
- If no, which binding way for udc and gadget driver will be used?
Current binding way for non-configfs gadgets is auto-binding, if we
don't want break user's current system, we need to keep auto-binding
as the default binding way. With more, we can support manual
binding with udc core.

I am implementing gadget bus[1], it may not be benefit for gadget-configfs,
but is benefit for other gadgets, eg, support loading gadget driver
before udc driver, manual-binding between udc and gadget drivers, etc.
So, I would like to know if you agree to keep auto-binding for
current non-configfs gadget driver as default way (in that way, we can keep
current system with no change), and manual-binding can be used
by user with module parameters and /sys entry.

[1] http://www.spinics.net/lists/linux-usb/msg109015.html

-- 

Best Regards,
Peter Chen
