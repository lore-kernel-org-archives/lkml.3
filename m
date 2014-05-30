Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaE3Er5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:47:57 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37215 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaE3Erx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:47:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, "Thierry Reding" <thierry.reding@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5387C145.8050609@ti.com>
Cc: "Stephen Warren" <swarren@wwwdotorg.org>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, "Arnd Bergmann" <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
 <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
 <53725FED.7050303@wwwdotorg.org> <20140514142739.GA8612@ulmo>
 <20140514193518.19795.64334@quantum> <20140526130725.GA1594@ulmo>
 <5387C145.8050609@ti.com>
Message-ID: <20140530044749.10062.16436@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
Date: Thu, 29 May 2014 21:47:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2014-05-29 16:22:45)
> On 05/26/2014 08:07 AM, Thierry Reding wrote:
> > On Wed, May 14, 2014 at 12:35:18PM -0700, Mike Turquette wrote:
> >> Quoting Thierry Reding (2014-05-14 07:27:40)
> > [...]
> >>> As for shared clocks I'm only aware of one use-case, namely EMC scaling.
> >>> Using clocks for that doesn't seem like the best option to me. While it
> >>> can probably fix the immediate issue of choosing an appropriate
> >>> frequency for the EMC clock it isn't a complete solution for the problem
> >>> that we're trying to solve. From what I understand EMC scaling is one
> >>> part of ensuring quality of service. The current implementations of that
> >>> seems to abuse clocks (essentially one X.emc clock per X clock) to
> >>> signal the amount of memory bandwidth required by any given device. But
> >>> there are other parts to the puzzle. Latency allowance is one. The value
> >>> programmed to the latency allowance registers for example depends on the
> >>> EMC frequency.
> >>>
> >>> Has anyone ever looked into using a different framework to model all of
> >>> these requirements? PM QoS looks like it might fit, but if none of the
> >>> existing frameworks have what we need, perhaps something new can be
> >>> created.
> >>
> >> It has been discussed. Using a QoS throughput constraint could help
> >> scale frequency. But this deserves a wider discussion and starts to
> >> stray into both PM QoS territory and also into "should we have a DVFS
> >> framework" territory.
> > 
> > I've looked into this for a bit and it doesn't look like PM QoS is going
> > to be a good match after all. One of the issues I found was that PM QoS
> > deals with individual devices and there's no builtin way to collect the
> > requests from multiple devices to produce a global constraint. So if we
> > want to add something like that either the API would need to be extended
> > or it would need to be tacked on using the notifier mechanism and some
> > way of tracking (and filtering) the individual devices.
> > 
> > Looking at devfreq it seems to be the DVFS framework that you mentioned,
> > but from what I can tell it suffers from mostly the same problems. The
> > governor applies some frequency scaling policy to a single device and
> > does not allow multiple devices to register constraints against a single
> > (global) constraint so that the result can be accumulated.
> > 
> > For Tegra EMC scaling what we need is something more along the lines of
> > this: we have a resource (external memory) that is shared by multiple
> > devices in the system. Each of those devices requires a certain amount
> > of that resource (memory bandwidth). The resource driver will need to
> > accumulate all requests for the resource and apply the resulting
> > constraint so that all requests can be satisfied.
> > 
> > One solution I could imagine to make this work with PM QoS would be to
> > add the concept of a pm_qos_group to manage a set of pm_qos_requests,
> > but that will require a bunch of extra checks to make sure that requests
> > are of the correct type and so on. In other words it would still be
> > tacked on.
> 
> just a minor note from previous experience: We(at TI) had attempted in
> our product kernel[1] to use QoS constraint for certain SoCs for
> rather unspectacular results.
> 
> Our use case was similar: devices -> L3(core bus)->memory. We had the
> following intent:
> a) wanted to scale L3 based on QoS requests coming in from various
> device drivers. intent was to scale either to 133MHz or 266MHz (two
> OPPs we supported on our devices) based on performance needs -> So we
> asked drivers to report QoS requirements using an standard function -
> except drivers cannot always report it satisfactorily - example bursty
> transfer devices - ended up with consolidated requests > total
> bandwidth possible on the bus -> (and never in practise hitting the
> lower frequency).

My opinion on why L3 QoS failed on OMAP is that we only used it for
DVFS. The voltage domain corresponding to the L3 interconnect had only
two OPPs, which meant that drivers submitting their constraints only had
two options: slow vs fast in the best case, or non-functional vs
functional in the worst case (some IPs simply did not work at the lower
OPP).

But the big failure in my opinion was that we did not use any of the
traffic-shaping or priority handling features of the L3 NoC. OMAP4 used
the Arteris NoC[1] which has plenty of capabilities for setting
initiator priorities and bandwidth-throttling on a point-to-point basis,
which is exactly that QoS is for. If these had been exposed a bit more
in software then I imagine some of the constraints that always resulted
in running at the fast OPP might have instead resulted in running at the
slow OPP, but with a fine-grained mixture of varying bandwidth
allocations and access priorities.

All of the hardware in the world doesn't do any good if we don't have
software that uses it. Anyways, just my $0.02.

Regards,
Mike

[1] http://www.arteris.com/OMAP4_QoS_security_NoC

> b) timing closure issues on certain devices such as USB - which can
> only function based on async bridge closure requirements on the core
> bus etc.. these would require bus to be at higher frequency - QoS
> model was "misused" in such requirements.
> b.1) a variation: interdependent constraints -> if MPU is > freq X,
> timing closure required L3 to be at 266MHz. again - it is not a QoS
> requirement perse, just a dependency requirement that cannot easily be
> addressed doing a pure QoS like framework solution.
> 
> Even though EMC does sound like (a) - I suspect you might want to be
> 100% sure that you dont have variations of (b) in the SoC as well and
> betting completely on QoS approach might not actually work in practice.
> 
> > 
> > Adding the linux-pm mailing list for more visibility. Perhaps somebody
> For folks new on the discussion: complete thread:
> http://thread.gmane.org/gmane.linux.drivers.devicetree/73967
> 
> > has some ideas on how to extend any of the existing frameworks to make
> > it work for Tegra's EMC scaling (or how to implement the requirements of
> > Tegra's EMC scaling within the existing frameworks).
> > 
> 
> 
> [1]
> https://android.googlesource.com/kernel/omap.git/+/android-omap-panda-3.0/arch/arm/plat-omap/omap-pm-helper.c
> 
> -- 
> Regards,
> Nishanth Menon
