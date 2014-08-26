Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbaHZImT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:42:19 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42450 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaHZImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:42:15 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
To: Thierry Reding <thierry.reding@gmail.com>, Jon Loeliger <jdl@jdl.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20140825133714.GH4163@ulmo.nvidia.com>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<20140514141914.446F7C4153D@trevor.secretlab.ca>
	<20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de>
	<20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo>
	<E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com>
Date: Tue, 26 Aug 2014 09:42:08 +0100
Message-Id: <20140826084208.AE5F0C40989@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014 15:37:16 +0200, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Mon, Aug 25, 2014 at 08:08:59AM -0500, Jon Loeliger wrote:
> > > 
> > 
> > > Anyway, instead of going back and forth between "deferred probe is good"
> > > and "deferred probe is bad", how about we do something useful now and
> > > concentrate on how to make use of the information we have in DT with the
> > > goal to reduce the number of cases where deferred probing is required?
> > 
> > Good idea.
> > 
> > The proposal on the table is to allow the probe code
> > to make a topological sort of the devices based on
> > dependency information either implied, explicitly stated
> > or both.  That is likely a fundamentally correct approach.
> > 
> > I believe some of the issues that need to be resolved are:
> > 
> >     1) What constitutes a dependency?
> >     2) How is that dependency expressed?
> >     3) How do we add missing dependencies?
> >     4) Backward compatability problems.
> > 
> > There are other questions, of course.  Is it a topsort
> > per bus?  Are there required "early devices"?  Should
> > the inter-node dependencies be expressed at each node,
> > or in a separate hierarchy within the DTS?  Others.
> 
> I think Grant already objected to the idea of explicitly adding
> dependency information into the device tree sources. Rather, if I
> understand correctly, we should be using the information readily
> available (phandle references) as much as possible before resorting to
> additional properties.

My objection is primarily around the concern that the dependency data
will get stale if firmware modifies the tree or that the kernel will
break when by relying on incorrect dependency information.

If the kernel can handle incorrect dependencies gracefully (like falling
back to deferred probe) then we can consider additional properties.

> So far we've been operating under the assumption that a dependency is
> modeled as a phandle reference and that the dependent would contain the
> phandle reference to the dependency. That's for example how clocks and
> regulators (to name only a few) work. A simplified example would look
> like this:
> 
> 	clock: clock@... {
> 		...
> 		#clock-cells = <1>;
> 		...
> 	};
> 
> 	pmic: pmic@... {
> 		regulators {
> 			vdd_foo: ldo0 {
> 				...
> 			};
> 
> 			vdd_bar: ldo1 {
> 				...
> 			};
> 	};
> 
> 	device@... {
> 		vdd-supply = <&vdd_foo>;
> 		clocks = <&clock 0>;
> 	};
> 
> 	device@... {
> 		vdd-supply = <&vdd_bar>;
> 		clocks = <&clock 1>;
> 	};
> 
> There are somewhat standardized bindings for the above and especially
> for bindings of the type that clocks implement this is trivial. We can
> simply iterate over each (phandle, specifier) tuple and check that the
> corresponding clock provider can be resolved (which typically means that
> it's been registered with the common clock framework).
> 
> For regulators (and regulator-like bindings) the problem is somewhat
> more difficult because they property names are not standardized. One way
> to solve this would be to look for property names with a -supply suffix,
> but that could obviously lead to false positives. One alternative that I
> think could eliminate this would be to explicitly list dependencies in
> drivers. This would allow core code to step through such a list and
> resolve the (phandle, specifier) tuples.

False positives and negatives may not actually be a problem. It is
suboptimal, certainly, but it shouldn't outright break the kernel.

g.

