Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3LSPnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:43:42 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41935 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753184Ab3LSPni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:43:38 -0500
Date: Thu, 19 Dec 2013 15:43:13 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Graeme Gregory <graeme.gregory@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core
 running without PCI on ARM64
Message-ID: <20131219154313.GF30398@arm.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <20131217112914.GB32118@arm.com>
 <20131219113051.GL2736@xora-haswell.xora.org.uk>
 <201312191501.26362.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312191501.26362.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 02:01:26PM +0000, Arnd Bergmann wrote:
> On Thursday 19 December 2013, Graeme Gregory wrote:
> > Hopefully the documenation of what real armv8 server architecture will look
> > like will come in the new year. Things like regulators and clocks I do not
> > have answers to yet as obviously in Intel world these things are hidden
> > from view, I do not know what the plan is for armv8 silicon/motherboards.
> 
> The clocks and regulators (and a handful of other subsystems) are
> the key thing to work out IMHO. For all I know these are either completely
> static (turned on by firmware at boot time) on current servers, or they
> are done in a way that each device can manage itself using power states
> in the PCI configuration space. If you have on-chip devices that do not
> look like PCI devices to software, or that interact with other on-chip
> controllers at run-time as on typical arm32 embedded SoCs, you are in
> trouble to start with, and there are two possible ways to deal with this
> in theory:
> 
> a) Hide all the register-level setup behind AML code and make Linux only
>    aware of the possible device states that it can ask for, which would
>    make this look similar to today's servers.
> 
> b) Model all the soc-internal registers as devices and write OS-specific
>    SoC-specific device drivers for them, using yet-to-be-defined ACPI
>    extensions to describe the interactions between devices. This would
>    be modeled along the lines of what we do today with DT, and what Intel
>    wants to do on their embedded SoCs with ACPI in the future.
> 
> I think anybody would agree that we should not try to mix the two models
> in a single system, as that would create an endless source of bugs when
> you have two drivers fighting over the same hardware. There is also a
> rough consensus that we really only want a) and not b) on ARM, but there
> have been indications that people are already working on b), which I
> think is a bit worrying. I would argue that anyone who wants b) on 
> ARM should not use ACPI at all but rather describe the hardware using
> DT as we do today. This could possibly change if someone shows that a)
> is actually not a realistic model at all, but I also think that doing b)
> properly will depend on doing a major ACPI-6.0 or ACPI-7.0 release
> to actually specify a standard model for the extra subsystems.

I'm inclined to say that (ARM) Linux should only support stuff captured
in an ACPI spec but I'm not familiar enough with this to assess its
feasibility.

Choosing between a) and b) depends when where you place the maintenance
burden. Point a) pretty much leaves this with the hw vendors. They get a
distro with a kernel supporting ACPI-x and (PCI) device drivers they
need but other SoC specific is handled by firmware or AML. It is their
responsibility to work on firmware and AML until getting it right
without changing the kernel (well, unless they find genuine bugs with
the code).

Point b) is simpler for kernel developers as we know how to debug and
maintain kernel code but I agree with you that we should rather use FDT
here than duplicate the effort just for the sake of ACPI.

Waiting for OS distros and vendors to clarify but I think RH are mainly
looking at a). My (mis)understanding is based based on pro-ACPI
arguments I heard like being able to use newer hardware with older
kernels (and b) would always require new SoC drivers and bindings).

-- 
Catalin
