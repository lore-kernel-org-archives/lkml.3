Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab3GZWCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:02:16 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:55826 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZWCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:02:14 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Thread-Topic: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Thread-Index: AQHOiVPvkmnt8PfOUEep6UDMuSIK7Jl1y1AggACJGwD//92QsIAAyPcAgAAzyoCAABfxUIAAmn4A//+c0xA=
Date: Fri, 26 Jul 2013 22:02:08 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DE18C5@US01WEMBX2.internal.synopsys.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
 <20130725205224.GA12209@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE12C9@US01WEMBX2.internal.synopsys.com>
 <1374821306.1956.34.camel@iivanov-dev.int.mm-sol.com>
 <20130726095347.GA2970@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE178C@US01WEMBX2.internal.synopsys.com>
 <20130726203226.GC14077@radagast>
In-Reply-To: <20130726203226.GC14077@radagast>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Friday, July 26, 2013 1:32 PM
> 
> On Fri, Jul 26, 2013 at 06:44:23PM +0000, Paul Zimmerman wrote:
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Friday, July 26, 2013 2:54 AM
> > > > > > Also, this is not *modifying* what was passed, just skipping the xHCI
> > > > > > address space so we don't request_mem_region() an area we won't really
> > > > > > handle and prevent xhci-hcd.ko from probing.
> > > > >
> > > > > Hmm? platform_get_resource() returns a pointer to an entry in the
> > > > > platform_device's resource[] array. And "res->start +=" modifies the
> > > > > entry pointed at. If it didn't, the bug fixed by this patch wouldn't
> > > > > have happened.
> > > > >
> > > > > Are you sure this code will work OK if you build the driver as a module,
> > > > > modprobe it, rmmod it, and then modprobe it again? Seems like it won't,
> > > > > unless the dev->resource[] array gets reinitialized in between somehow.
> > >
> > > gotta try that one... Perhaps the correct way would be to copy the
> > > resource to a private struct resource and modify that one, leaving
> > > pdev->resources untouched.
> >
> > Maybe this is a dumb question, but why can't the driver that is going
> > to use the resource after this just "know" that it has to add
> > DWC3_GLOBALS_REGS_START to the start address? Are there some versions
> > of the core where that is not the case?
> 
> that won't work, because dwc3.ko will already have request_mem_region()
> the entire region and a subsequent request_mem_region() for xHCI space
> only would fail.
> 
> > Or, maybe there should be two sets of resources?
> 
> maybe we should require two sets of resources, yes... but then there's
> no point in having any host initialization whatsoever in dwc3.ko.

Right. For a platform with a DWC3 controller, have DT or whatever set up
a second memory resource in the platform device, and have xhci_plat_probe()
look for that one first. If it finds it, it uses that resource instead
of the first one. If it doesn't find the second resource (not a DWC3
platform) then it uses the first one like it does today.

Then you don't need to have dwc3 set up the xhci resource like it does
today. Seems cleaner to me. 'Course it's incompatible with what you have
today, I guess that's the major drawback.

-- 
Paul

