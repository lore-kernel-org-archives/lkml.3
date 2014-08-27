Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935569AbaH0RxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:53:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27739 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750908AbaH0RxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:53:18 -0400
Date: Wed, 27 Aug 2014 18:52:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexander Holler <holler@ahsoftware.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140827175243.GJ13850@arm.com>
References: <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826101107.GC32315@leverpostej>
 <20140827103432.64927C409CB@trevor.secretlab.ca>
 <20140827144403.GB13850@arm.com>
 <53FE05AE.9000406@wwwdotorg.org>
 <53FE07BE.7000809@ahsoftware.de>
 <53FE0966.5020206@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FE0966.5020206@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 05:37:58PM +0100, Stephen Warren wrote:
> On 08/27/2014 10:30 AM, Alexander Holler wrote:
> > Am 27.08.2014 18:22, schrieb Stephen Warren:
> >> On 08/27/2014 08:44 AM, Catalin Marinas wrote:
> >
> >>> It's not just optimisation but an important feature for new arm64 SoCs.
> >>> Given some Tegra discussions recently, in many cases the machine_desc
> >>> use on arm is primarily to initialise devices in the right order. If we
> >>> can solve this in a more deterministic way (other than deferred
> >>> probing), we avoid the need for a dedicated SoC platform driver (or
> >>> machine_desc) or workarounds like different initcall levels and explicit
> >>> DT parsing.
> >>
> >> A lot of the ordering is SW driver dependencies. I'm not sure how much
> >> of that can accurately be claimed as HW dependencies. As such, I'm not
> >> sure that putting dependencies into DT would be a good idea; it doesn't
> >> feel like HW data, and might well change if we restructure SW. It'd need
> >> some detailed research though.
> >
> > Almost every phandle is a dependency, so the DT is already full with them.
> 
> That's true, but not entirely relevant.
> 
> phandles in DT should only be present where there's an obvious HW 
> dependency. It's obvious that, for example, there's a real HW dependency 
> between an IRQ controller and a device that has an IRQ signal fed into 
> the IRQ controller. It makes perfect sense to represent that as a 
> phandle (+args).

Other examples are power controllers or some MFD device (as we have on
vexpress). For these we normally have phandles.

> However, most of the ordering imposed by the Tegra machine descriptor 
> callbacks is nothing to do with this. It's more that the SW driver for 
> component X needs some low level data (e.g. SKU/fuse information) before 
> it can run. However, there's no real HW dependency between the HW 
> component X and the fuse module. As such, it doesn't make sense to 
> represent such a dependency in DT, using a phandle or by any other means.

But isn't fuse some piece of hardware? We don't have a model for it, so
I guess you just present it as a library that accesses the hardware.
Anyway, in such case something like Pawel's SoC driver proposal would
work. Now if anything inside the SoC bus (I have to re-read, I don't
fully remember the details) is probed after the SoC driver, you could
even initialise your SoC at device_initcall() level.

> Irrespective though, a new kernel needs to work against an old DT,

I fully agree. But we shouldn't really extend the "old DT" statement to
a new ARMv8 SoC ;).

-- 
Catalin
