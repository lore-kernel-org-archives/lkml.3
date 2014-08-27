Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934959AbaH0Ooo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:44:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:42471 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933698AbaH0Oom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:44:42 -0400
Date: Wed, 27 Aug 2014 15:44:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        Alexander Holler <holler@ahsoftware.de>,
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
Message-ID: <20140827144403.GB13850@arm.com>
References: <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
 <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
 <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826101107.GC32315@leverpostej>
 <20140827103432.64927C409CB@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827103432.64927C409CB@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:34:32AM +0100, Grant Likely wrote:
> On Tue, 26 Aug 2014 11:11:07 +0100, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Aug 26, 2014 at 10:42:04AM +0100, Alexander Holler wrote:
> > > Am 26.08.2014 10:49, schrieb Thierry Reding:
> > > > On Tue, Aug 26, 2014 at 09:42:08AM +0100, Grant Likely wrote:
> > > >> On Mon, 25 Aug 2014 15:37:16 +0200, Thierry Reding <thierry.reding@gmail.com> wrote:
> > > > [...]
> > > >>> There are somewhat standardized bindings for the above and especially
> > > >>> for bindings of the type that clocks implement this is trivial. We can
> > > >>> simply iterate over each (phandle, specifier) tuple and check that the
> > > >>> corresponding clock provider can be resolved (which typically means that
> > > >>> it's been registered with the common clock framework).
> > > >>>
> > > >>> For regulators (and regulator-like bindings) the problem is somewhat
> > > >>> more difficult because they property names are not standardized. One way
> > > >>> to solve this would be to look for property names with a -supply suffix,
> > > >>> but that could obviously lead to false positives. One alternative that I
> > > >>> think could eliminate this would be to explicitly list dependencies in
> > > >>> drivers. This would allow core code to step through such a list and
> > > >>> resolve the (phandle, specifier) tuples.
> > > >>
> > > >> False positives and negatives may not actually be a problem. It is
> > > >> suboptimal, certainly, but it shouldn't outright break the kernel.
> > > >
> > > > There could be cases where some random integer in a cell could be
> > > > interpreted as a phandle and resolve to a struct device_node. I suppose
> > > > it might be unlikely, but not impossible, that the device_node could
> > > > even match a device in the correct subsystem and you'd get a wrong
> > > > dependency. Granted, a wrong dependency may not be catastrophic in that
> > > > it won't lead to a crash, but it could lead to various kinds of
> > > > weirdness and hard to diagnose problems.
> > > 
> > > You need either the type information in the DTB (that's why I've add 
> > > those "dependencies" to identify phandles), or you need to know every 
> > > binding (at "dependency-resolve-time" to identify phandles.
> > 
> > While having type information in the DTB would be fantastic, it's not
> > something we can expect from the systems already in the wild, and I
> > worry how it would interact with bootloaders that modify the DTB (I
> > don't know if any modify properties with phandles).
> 
> Anything we do here is firmly in the realm of optimization and
> improvement. Adding data to the tree is fine as long as we don't make
> the kernel depend on it. Older platforms will continue to work without
> the optimization.

It's not just optimisation but an important feature for new arm64 SoCs.
Given some Tegra discussions recently, in many cases the machine_desc
use on arm is primarily to initialise devices in the right order. If we
can solve this in a more deterministic way (other than deferred
probing), we avoid the need for a dedicated SoC platform driver (or
machine_desc) or workarounds like different initcall levels and explicit
DT parsing.

-- 
Catalin
