Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaL3UOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 15:14:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57163 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaL3UOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 15:14:00 -0500
Message-ID: <8fc9550c96a468b3e50d51a37db68a33.squirrel@www.codeaurora.org>
In-Reply-To: <CAJ5Y-eZ5cu9_OhG24yAv+CZq7zKg0vU+eVGekyN+9dDzaz1OhQ@mail.gmail.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
    <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org>
    <CAJ5Y-eZ5cu9_OhG24yAv+CZq7zKg0vU+eVGekyN+9dDzaz1OhQ@mail.gmail.com>
Date: Tue, 30 Dec 2014 20:13:58 -0000
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
From: ashwinc@codeaurora.org
To: hanjun.guo@linaro.org, catalin.marinas@arm.com, rjw@rjwysocki.net,
        mark.rutland@arm.com, olof@lixom.net, grant.likely@linaro.org,
        will.deacon@arm.com
Cc: linaro-acpi@lists.linaro.org, Liviu.Dudau@arm.com, lv.zheng@intel.com,
        robh@kernel.org, Lorenzo.Pieralisi@arm.com, al.stone@linaro.org,
        daniel.lezcano@linaro.org, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, Charles.Garcia-Tobin@arm.com,
        rric@kernel.org, jason@lakedaemon.net, arnd@arndb.de,
        marc.zyngier@arm.com, jcm@redhat.com, broonie@kernel.org,
        "bhelgaas@google.com." <linux-arm-kernel@lists.infradead.org>,
        graeme.gregory@linaro.org, Kangkang.Shen@huawei.com,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        Sudeep.Holla@arm.com
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

Overall the document looks good to us. Some minor clarifications below.

> ---------- Forwarded message ----------
> From: Graeme Gregory <graeme.gregory@linaro.org>
>
> Add documentation for the guidelines of how to use ACPI
> on ARM64.
>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/arm64/arm-acpi.txt |  323
> ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 323 insertions(+)
>  create mode 100644 Documentation/arm64/arm-acpi.txt
>

[..]

> +Relationship with Device Tree
> +-----------------------------

[..]

> +When booting using ACPI tables, the /chosen node in DT will still be
> parsed
> +to extract the kernel command line and initrd path.  No other section of
> the
> +DT will be used.

Is this still true?


> +Programmable Power Control Resources
> +------------------------------------
> +Programmable power control resources include such resources as
> voltage/current
> +providers (regulators) and clock sources.
> +
> +The kernel assumes that power control of these resources is represented
> with
> +Power Resource Objects (ACPI section 7.1).  The ACPI core will then
> handle
> +correctly enabling and disabling resources as they are needed.  In order
> to
> +get that to work, ACPI assumes each device has defined D-states and that
> these
> +can be controlled through the optional ACPI methods _PS0, _PS1, _PS2, and
> _PS3;
> +in ACPI, _PS0 is the method to invoke to turn a device full on, and _PS3
> is for
> +turning a device full off.
> +
> +The kernel ACPI code will also assume that the _PS? methods follow the
> normal
> +ACPI rules for such methods:
> +
> +   -- If either _PS0 or _PS3 is implemented, then the other method must
> also
> +      be implemented.
> +
> +   -- If a device requires usage or setup of a power resource when on,
> the ASL
> +      should organize that it is allocated/enabled using the _PS0 method.
> +
> +   -- Resources allocated or enabled in the _PS0 method should be
> disabled
> +      or de-allocated in the _PS3 method.
> +
> +   -- Firmware will leave the resources in a reasonable state before
> handing
> +      over control to the kernel.
> +

We found this section could be improved a bit by explicitly calling out
the options for handling device PM. Platform vendor has two choices.
Resources can be managed in _PSx routine which gets called on entry to Dx.
 Or they can be declared separately as power resources with their own _ON
and _OFF methods.  They are then tied back to D-states for a particular
device via _PRx which specifies which power resources a device needs to be
on while in Dx.  Kernel then tracks number of devices using a power
resource and calls _ON/_OFF as needed.

> +Such code in _PS? methods will of course be very platform specific.  But,
> +this allows the driver to abstract out the interface for operating the
> device
> +and avoid having to read special non-standard values from ACPI tables.
> Further,
> +abstracting the use of these resources allows the hardware to change over
> time
> +without requiring updates to the driver.
> +

I think its been mentioned in the past and you planned to add it here: we
should explicitly state that with ACPI, the kernel clock/vreg framework
are not expected to be used at all.

> +
> +Clocks
> +------
> +ACPI makes the assumption that clocks are initialized by the firmware --
> +UEFI, in this case -- to some working value before control is handed over
> +to the kernel.  This has implications for devices such as UARTs, or SoC
> +driven LCD displays, for example.
> +
> +When the kernel boots, the clock is assumed to be set to reasonable
> +working value.  If for some reason the frequency needs to change -- e.g.,
> +throttling for power management -- the device driver should expect that
> +process to be abstracted out into some ACPI method that can be invoked

Exception to this is CPU clocks where CPPC provides a much richer
interface than just blindly invoking some method.

> +(please see the ACPI specification for further recommendations on
> standard
> +methods to be expected).  If is not, there is no direct way for ACPI to
> +control the clocks.
> +
> +

[..]

> +ASWG
> +----
> +The following areas are not yet fully defined for ARM in the 5.1 version
> +of the ACPI specification and are expected to be worked through in the
> +UEFI ACPI Specification Working Group (ASWG):
> +
> +   -- ACPI based CPU topology
> +   -- ACPI based Power management

Should clarify this to idle management rather than generic power management.

> +   -- CPU idle control based on PSCI
> +   -- CPU performance control (CPPC)

There is no ongoing work on CPPC. Additional enhancements may be explored
in the future, but spec is viable as is.

Regards,
Ashwin

--
Qualcomm Innovation Center, Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--

