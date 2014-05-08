Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaEHSm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:42:58 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:27474
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754772AbaEHSm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:42:56 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: Paul Fertser <fercerpav@gmail.com>, "balbi@ti.com" <balbi@ti.com>
CC: "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: check vbus presence on probe
Thread-Topic: [PATCH] usb: gadget: fsl: check vbus presence on probe
Thread-Index: AQHPX6Pn9DI4D60kV0aDe0wVb6zR3psqXP2AgAA4QYCAAAxfAIABL2ZggAsBoqCAABVEgIAAIdvg
Date: Thu, 8 May 2014 18:42:53 +0000
Message-ID: <2d0cb4d1c8d7499ea6382cbb4c34c8d8@BL2PR03MB579.namprd03.prod.outlook.com>
References: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
 <20140430160625.GF23679@saruman.home> <20140430192745.GI3876@home.lan>
 <20140430201202.GF3839@saruman.home>
 <2cd9b3e31cce467e9a79d7aabd63604b@BL2PR03MB579.namprd03.prod.outlook.com>
 <59ef67eabf72450f988638edbbe1cd47@BL2PR03MB579.namprd03.prod.outlook.com>
 <20140508153845.GA3876@home.lan>
In-Reply-To: <20140508153845.GA3876@home.lan>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(377454003)(24454002)(51704005)(189002)(199002)(31966008)(76176999)(21056001)(77982001)(74662001)(74502001)(77096999)(54356999)(64706001)(92566001)(50986999)(20776003)(76482001)(76576001)(101416001)(19580395003)(46102001)(4396001)(33646001)(15975445006)(19580405001)(83322001)(86362001)(66066001)(80022001)(99396002)(2656002)(81542001)(15202345003)(74316001)(85852003)(79102001)(83072002)(81342001)(99286001)(87936001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB385;H:BL2PR03MB579.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=suresh.gupta@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Paul Fertser [mailto:fercerpav@gmail.com]
> Sent: Thursday, May 08, 2014 9:09 PM
> To: Gupta Suresh-B42813
> Cc: balbi@ti.com; Li Yang-Leo-R58472; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: gadget: fsl: check vbus presence on probe
> 
> Hi,
> 
> On Thu, May 08, 2014 at 02:30:39PM +0000, suresh.gupta@freescale.com
> wrote:
> > As per my limited knowledge, the purpose of OTGSC_STS_B_SESSION_VALID
> > bit is to tell either VBUS is above the B session valid threshold and
> > which comes only Host is attached.
> 
> Yes, that matches the datasheet I've read.
> 
> > And Host might be attach after system bootup or after driver
> > initialization. So putting this check in probe will not help much.
> 
> If the host is attached after the driver was initialised, the interrupt
> will trigger and the driver will get notified that VBUS appeared and
> everything will go smooth, at least that's how it should work (I do not
> have any board handy to real-life check that, but AFAICT that's the
> intent of the current code).

If is go through the code flow starting from usb_composite_probe the sequence is
usb_composite_probe->usb_gadget_probe_driver->udc_bind_to_driver->
udc_bind_to_driver->usb_gadget_udc_start->fsl_udc_start->usbcmd=RUN
udc_bind_to_driver->usb_gadget_connect->fsl_pullup

The function fsl_pullup make usbcmd=STOP if my fix is not there and if controller 
is stopped we do not get any interrupt. 
 
> 
> I actually do not have any iMX demoboards at all, I've only got some
> custom-designed i.MX25 boards where I can't control VBUS, it's
> permanently pulled up.
> 
> But I was fixing the problem that was clearly, 100% reproducibly
> happening when VBUS was applied before the interrupt was configured. So

Wait a minute, are you using OTG. If your VBUS is permanently pulled up, that 
means you are only Gadget(I might miss something) then why you use OTG mode.

> what exactly do you mean here? Do you mean this check I've added doesn't
> fix the bug? Or do you mean this bug should be fixed somehow else? Or do

What expertly my concern is, probe is not proper place to check VBUS valid.
I think we should wait to hear what Balbi has to say. 

> you mean there's no bug in the first place and my board doesn't work
> because of something else?
> 
> --
> Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
> mailto:fercerpav@gmail.com
