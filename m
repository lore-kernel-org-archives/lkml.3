Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3LSOCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:02:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3LSOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:02:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Thu, 19 Dec 2013 15:01:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
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
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <20131217112914.GB32118@arm.com> <20131219113051.GL2736@xora-haswell.xora.org.uk>
In-Reply-To: <20131219113051.GL2736@xora-haswell.xora.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312191501.26362.arnd@arndb.de>
X-Provags-ID: V02:K0:9x8B1hP0xopw6iD76ic6/bMVSX+1J3S8mB3BVCjNKsz
 xilafaRgKereYnVcTRpf+jui+eq+nfiwIyXKWZdrx9VucdAQkr
 Ts+/kxz7oDC/xRtxIA1xrZ290mhQnpTm2qryQB7aElvIUZlJqq
 QG8SOjOALoUr/J27a8U3fX+aCqVVW7Oar7m1GyMlP+5VZebNC3
 g4n9mEDwcD7doXxmoY71WdY2xXqcFYu9e8jfqEDLLFdMIoprUX
 Zuntci0+Icb8Qo8XP+Hdxq/6hLjmydAIj2l0cvt6yN1I51Bmcd
 6JzdTHmt+r5jBdkW3TeHLhXgN6KhHILgbmgYaQQcNitbHp62HK
 pESVmAQc7XM/jSGEHXaY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 December 2013, Graeme Gregory wrote:
> Hopefully the documenation of what real armv8 server architecture will look
> like will come in the new year. Things like regulators and clocks I do not
> have answers to yet as obviously in Intel world these things are hidden
> from view, I do not know what the plan is for armv8 silicon/motherboards.

The clocks and regulators (and a handful of other subsystems) are
the key thing to work out IMHO. For all I know these are either completely
static (turned on by firmware at boot time) on current servers, or they
are done in a way that each device can manage itself using power states
in the PCI configuration space. If you have on-chip devices that do not
look like PCI devices to software, or that interact with other on-chip
controllers at run-time as on typical arm32 embedded SoCs, you are in
trouble to start with, and there are two possible ways to deal with this
in theory:

a) Hide all the register-level setup behind AML code and make Linux only
   aware of the possible device states that it can ask for, which would
   make this look similar to today's servers.

b) Model all the soc-internal registers as devices and write OS-specific
   SoC-specific device drivers for them, using yet-to-be-defined ACPI
   extensions to describe the interactions between devices. This would
   be modeled along the lines of what we do today with DT, and what Intel
   wants to do on their embedded SoCs with ACPI in the future.

I think anybody would agree that we should not try to mix the two models
in a single system, as that would create an endless source of bugs when
you have two drivers fighting over the same hardware. There is also a
rough consensus that we really only want a) and not b) on ARM, but there
have been indications that people are already working on b), which I
think is a bit worrying. I would argue that anyone who wants b) on 
ARM should not use ACPI at all but rather describe the hardware using
DT as we do today. This could possibly change if someone shows that a)
is actually not a realistic model at all, but I also think that doing b)
properly will depend on doing a major ACPI-6.0 or ACPI-7.0 release
to actually specify a standard model for the extra subsystems.

> On the multiple venders same hardware issue I guess Intel guys must have
> already seen this happen. We shall have to ask them what their solution was?

There is basically only one SoC vendor on x86, which makes this a lot
easier. Off-chip devices on the board are typically PCI based and
don't need any special treatment because the PCI vendor/device ID
pair is enought to identify the hardware. Anything that does not fall
into these categories (e.g. vendor specific laptop extensions) is
handled with drivers in drivers/platform/x86/. This works fine
because that code is only needed for _optional_ features such as
multimedia buttons or sensors, and the total amount of code for
all the platforms is fairly contained.

The main concern for ARM is that if we need to do the same, it ends up
as a direct replacement for the "board files" that we just spent years
on making obsolete. We can do this as a workaround for the oddball broken
firmware in shipping products, but we should not go back to having to
add platform-specific code that is only meant to interface with how
a random vendor decided to expose standard hardware in their ACPI BIOS.

	Arnd
