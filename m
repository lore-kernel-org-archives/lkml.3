Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbaHZIvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:51:39 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58572 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158AbaHZIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:51:36 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
To: Jon Loeliger <jdl@jdl.com>, Thierry Reding <thierry.reding@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <E1XLu15-0002DP-6o@jdl.com>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<20140514141914.446F7C4153D@trevor.secretlab.ca>
	<20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de>
	<20140822131919.GX21734@leverpostej> <20140825093931.GB2399@ulmo>
	<E1XLu15-0002DP-6o@jdl.com>
Date: Tue, 26 Aug 2014 09:51:28 +0100
Message-Id: <20140826085128.958A9C40989@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2014 08:08:59 -0500, Jon Loeliger <jdl@jdl.com> wrote:
> > 
> 
> > Anyway, instead of going back and forth between "deferred probe is good"
> > and "deferred probe is bad", how about we do something useful now and
> > concentrate on how to make use of the information we have in DT with the
> > goal to reduce the number of cases where deferred probing is required?
> 
> Good idea.
> 
> The proposal on the table is to allow the probe code
> to make a topological sort of the devices based on
> dependency information either implied, explicitly stated
> or both.  That is likely a fundamentally correct approach.
> 
> I believe some of the issues that need to be resolved are:
> 
>     1) What constitutes a dependency?
>     2) How is that dependency expressed?
>     3) How do we add missing dependencies?
>     4) Backward compatability problems.
> 
> There are other questions, of course.  Is it a topsort
> per bus?  Are there required "early devices"?  Should
> the inter-node dependencies be expressed at each node,
> or in a separate hierarchy within the DTS?  Others.

Getting the dependency tree I think is only half the problem. The other
have is how to get the driver model to actually order probing using that
list. That problem is hard because the order drivers are probed is
currently determined by the interaction of driver link order, driver
initcall level, and device registration order. The first devices are
registered at an early initcall, before their drivers, and therefore
bind order is primarily determined by initcall level and driver link
order. However, later devices (ie. i2c clients) are registered by the
bus driver (ie. again, i2c) and probe order may be primarily link order
(if the driver is not yet registered) or registration order (if the
driver was registered before the parent bus).

g.
