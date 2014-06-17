Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaFQCEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:04:09 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:27641
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753806AbaFQCEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:04:08 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>
Subject: RE: Disable bus's drivers_autoprobe before rootfs has mounted
Thread-Topic: Disable bus's drivers_autoprobe before rootfs has mounted
Thread-Index: AQHPhSbNvHNYX7he+UqiXaXh7d5QNZtrS7gAgAB5FQCAAIJ0gIAABLyAgAE/lgD///rvAIABTkkggABF6QCABGfugIAAWoSAgAC4ztA=
Date: Tue, 17 Jun 2014 02:04:04 +0000
Message-ID: <fabdb1e3de0b49e9953bfc84bb2be946@BL2PR03MB226.namprd03.prod.outlook.com>
References: <20140616013637.GA6432@shlinux1.ap.freescale.net>
 <Pine.LNX.4.44L0.1406161047390.1292-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406161047390.1292-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0245702D7B
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(164054003)(199002)(189002)(83072002)(4396001)(76576001)(77982001)(85852003)(15202345003)(21056001)(79102001)(77096002)(15975445006)(74316001)(101416001)(50986999)(54356999)(85306003)(92566001)(99396002)(76482001)(76176999)(2656002)(64706001)(20776003)(66066001)(80022001)(87936001)(86362001)(83322001)(2171001)(105586001)(19580395003)(81542001)(74662001)(15395725005)(31966008)(46102001)(74502001)(81342001)(99286002)(33646001)(95666004)(24736002)(6606295002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB227;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > Yes, otherwise, the device which the udc is probed deferral and the
> > gadget driver is build-in will never work. If we skip fixing it, this
> > problem will exist for more than 2 years, it is too long.
> >
> > I have a support request from android team that usb peripheral
> > function never works from 3.10.x kernel at one device, I think it is a
> > common problem, no only I meet it.
> >
> > Below are links which this problem reports:
> >
> > http://marc.info/?l=linux-usb&m=139380872501745&w=2
> > http://marc.info/?l=linux-usb&m=137706435611447&w=2
> >
> > > If you do want to fix the problem, there's a much easier way than
> > > what you posted.  See below.
> > >
> > Robert Baldyga posts the similar solution, but seems Felipe doesn't
> > agree it.
> > http://www.spinics.net/lists/linux-usb/msg102795.html
> >
> > Then, you and Felipe has a discussion for this problem:
> > http://www.spinics.net/lists/linux-usb/msg106760.html
> 
> Okay, I get it.  Felipe didn't want to do this because you might end up
> loading a gadget driver that never gets bound.  There might not even be
> any UDC devices at all.
> 
> Felipe, I think the problem of having unbound gadget drivers isn't so bad.
> It's just like having unbound drivers of any sort.  For example, the
> Fedora kernels have ohci-hcd and uhci-hcd built-in.  Relatively few
> systems have both OHCI and UHCI controllers (lots of current machines
> have neither); everybody else ends up with at least one unused driver and
> no way to remove it.  If Fedora can do this, I think we can allow users
> to have unnecessary gadget drivers.
> 
> In fact, I don't know of any other kind of driver module whose init
> routine will fail if there's no hardware to bind to.
> 
> I suggest you go ahead and accept Robert Baldyga's original patch --
> except for one little problem: The patch forgets to add driver->list to
> the global driver_list if the driver gets bound immediately.  The
> 
> 	list_add_tail(&driver->list, &driver_list);
> 
> call needs to be moved up near the start of usb_gadget_probe_driver().
> 

Thanks, Alan.

The another improvement is: set driver->attached as true at udc_bind_to_driver.

Peter
