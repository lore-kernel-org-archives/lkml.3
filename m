Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbaGXUmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:42:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:42:15 -0400
Message-ID: <53D16F98.9080107@infradead.org>
Date: Thu, 24 Jul 2014 13:42:00 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
CC: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 06:00 AM, Hanjun Guo wrote:
> From: Graeme Gregory <graeme.gregory@linaro.org>
> 
> Add documentation for the guidelines of how to use ACPI
> on ARM64.
> 
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/arm64/arm-acpi.txt |  240 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 240 insertions(+)
>  create mode 100644 Documentation/arm64/arm-acpi.txt
> 
> diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.txt
> new file mode 100644
> index 0000000..12cd550
> --- /dev/null
> +++ b/Documentation/arm64/arm-acpi.txt
> @@ -0,0 +1,240 @@
> +ACPI on ARMv8 Servers
> +---------------------
> +
> +ACPI will be used for ARMv8 general purpose servers designed to follow
> +the SBSA specification (currently available to people with an ARM login at
> +http://silver.arm.com)

                    .com).

> +
> +The implemented ACPI version is 5.1 + errata as released by the UEFI Forum,
> +which is available at <http://www.uefi.org/acpi/specs>.
> +
> +If the machine does not meet these requirements then it is likely that Device
> +Tree (DT) is more suitable for the hardware.
> +
> +Relationship with Device Tree
> +-----------------------------
> +
> +ACPI support in drivers and subsystems for ARMv8 should never be mutually
> +exclusive with DT support at compile time.
> +
> +At boot time the kernel will only use one description method depending on
> +parameters passed from the bootloader.
> +
> +Regardless of whether DT or ACPI is used, the kernel must always be capable
> +of booting with either scheme.
> +
> +When booting using ACPI tables the /chosen node in DT will still be parsed
> +to extract the kernel command line and initrd path. No other section of
> +the DT will be used.
> +
> +Booting using ACPI tables
> +-------------------------
> +
> +Currently, the only defined method to pass ACPI tables to the kernel on ARMv8
> +is via the UEFI system configuration table.
> +
> +The UEFI implementation MUST set the ACPI_20_TABLE_GUID to point to the
> +RSDP table (the table with the ACPI signature "RSD PTR ").
> +
> +The pointer to the RSDP table will be retrieved from EFI by the ACPI core.
> +
> +Processing of ACPI tables may be disabled by passing acpi=off on the kernel
> +command line.
> +
> +DO use an XSDT, RSDTs are deprecated and should not be used on arm64. They

             XSDT;

> +only allow for 32bit addresses.

                  32-bit

> +
> +DO NOT use the 32-bit address fields in the FADT, they are deprecated, the

                                               FADT; they are deprecated. The

> +64-bit alternatives MUST be used.
> +
> +The minimum set of tables MUST include RSDP, XSDT, FACS, FADT, DSDT, MADT
> +and GTDT. If PCI is used the MCFG table MUST also be present.
> +
> +ACPI Detection
> +--------------
> +
> +Drivers should determine their probe() type by checking for ACPI_HANDLE,
> +or .of_node, or other information in the device structure. This is
> +detailed further in the "Driver Recomendations" section.

                                   Recommendations

> +
> +If the presence of ACPI needs to be detected at runtime, then check the value
> +of acpi_disabled. If CONFIG_ACPI not being set acpi_disabled will always be 1.

                     If CONFIG_ACPI is not set, acpi_disabled will always be 1.

> +
> +Device Enumeration
> +------------------
> +
> +Device descriptions in ACPI should use standard recognised ACPI interfaces.
> +These are far simpler than the information provided via Device Tree. Drivers
> +should take into account this simplicity and work with sensible defaults.
> +
> +On no account should a Device Tree attempt to be replicated in ASL using such
> +constructs as Name(KEY0, "Value1") type constructs. Additional driver specific
> +data should be passed in the appropriate _DSM (ACPI Section 9.14.1) method or
> +_DSD (ACPI Section 6.2.5). This data should be rare and not OS specific.
> +
> +Common _DSD bindings should be submitted to ASWG to be included in the
> +document :-
> +
> +http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> +
> +TODO: Clarification and examples from Juno implementation.
> +
> +Programmable Power Control Resources
> +------------------------------------
> +
> +Programmable power control resources include such resources as voltage/current
> +providers (regulators) and clock sources.
> +
> +For power control of these resources they should be represented with Power
> +Resource Objects (ACPI Section 7.1). The ACPI core will then handle correctly
> +enabling/disabling of resources as they are needed.
> +
> +There exists in the ACPI 5.1 specification no standard binding for these objects
> +to enable programmable levels or rates so this should be avoid if possible and

                                                            avoided

> +the resources set to appropriate level by the firmware. If this is not possible

                                    levels

> +then any manipulation should be abstracted in ASL.
> +
> +Each device in ACPI has D-states and these can be controlled through
> +the optional methods _PS0..._PS3 where _PS0 is full on and _PS3 is full off.
> +
> +If either _PS0 or _PS3 is implemented, then the other method must also be
> +implemented.
> +
> +If a device requires usage or setup of a power resource when on, the ASL
> +should organise that it is allocated/enabled using the _PS0 method.
> +
> +Resources allocated/enabled in the _PS0 method should be disabled/de-allocated
> +in the _PS3 method.
> +
> +Such code in _PS? methods will of course be very platform specific but
> +should allow the driver to operate the device without special non standard

                                                                 non-standard

> +values being read from ASL. Further, abstracting the use of these resources
> +allows hardware revisions without requiring updates to the kernel.
> +
> +TODO: Clarification and examples from Juno implementation.
> +
> +Clocks
> +------
> +
> +Like clocks that are part of the power resources there is no standard way
> +to represent a clock tree in ACPI 5.1 in a similar manner to how it is
> +described in DT.
> +
> +Devices affected by this include things like UARTs, SoC driven LCD displays,
> +etc.
> +
> +The firmware for example UEFI should initialise these clocks to fixed working

                (for example, UEFI)

> +values before the kernel is executed. If a driver requires to know rates of
> +clocks set by firmware then they can be passed to kernel using _DSD.
> +
> +example :-
> +
> +Device (CLK0) {
> +	...
> +
> +	Name (_DSD, Package() {
> +		ToUUID("XXXXX"),
> +		Package() {
> +			Package(2) {"#clock-cells", 0},
> +			Package(2) {"clock-frequency", "10000"}
> +		}
> +	})
> +
> +	...
> +}
> +
> +Device (USR1) {
> +	...
> +
> +	Name (_DSD, Package() {
> +		ToUUID("XXXXX"),
> +		Package() {
> +			Package(2) {"clocks", Package() {1, ^CLK0}}},
> +		}
> +	})
> +
> +	...
> +}
> +			
> +Driver Recommendations
> +----------------------
> +
> +DO NOT remove any FDT handling when adding ACPI support for a driver, different

                                                                 driver. Different

> +systems may use the same device.
> +
> +DO try and keep complex sections of ACPI and DT functionality seperate. This

                                                                 separate.

> +may mean a patch to break out some complex DT to another function before
> +the patch to add ACPI. This may happen in other functions but is most likely
> +in probe function. This gives a clearer flow of data for reviewing driver
> +source.
> +
> +probe() :-
> +
> +TODO: replace this with a specific real example from Juno?
> +
> +static int device_probe_dt(struct platform_device *pdev)
> +{
> +	/* DT specific functionality */
> +	...
> +}
> +
> +static int device_probe_acpi(struct platform_device *pdev)
> +{
> +	/* ACPI specific functionality */
> +	...
> +}
> +
> +static int device_probe(stuct platform_device *pdev)
> +{
> +	...
> +	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
> +	struct device_node node = pdev->dev.of_node;
> +	...
> +
> +	if (node)
> +		ret = device_probe_dt(pdev);
> +	else if (handle)
> +		ret = device_probe_acpi(pdev);
> +	else
> +		/* other initialisation */
> +		...
> +	/* Continue with any generic probe operations */
> +	...
> +}
> +
> +DO keep the MODULE_DEVICE_TABLE entries together in the driver to make it clear
> +the different names the driver is probed for, both from DT and from ACPI.
> +
> +module device tables :-
> +
> +static struct of_device_id virtio_mmio_match[] = {
> +        { .compatible = "virtio,mmio", },
> +        {},
> +};
> +MODULE_DEVICE_TABLE(of, virtio_mmio_match);
> +
> +static const struct acpi_device_id virtio_mmio_acpi_match[] = {
> +        { "LNRO0005", },
> +        { }
> +};
> +MODULE_DEVICE_TABLE(acpi, virtio_mmio_acpi_match);
> +
> +TODO: Add any other helpful rules that develop from Juno ACPI work.
> +
> +ASWG
> +----
> +
> +The following areas are not yet well defined for ARM in the current ACPI
> +specification and are expected to be worked through in the UEFI ACPI
> +Specification Working Group (ASWG) <http://www.uefi.org/workinggroups>.
> +Participation in this group is open to all UEFI members.
> +
> +	- ACPI based CPU topology
> +	- ACPI based Power management
> +	- CPU idle control based on PSCI
> +	- CPU performance control (CPPC)
> +
> +No code shall be accepted into the kernel unless it complies with the released
> +standards from UEFI ASWG. If there are features missing from ACPI to make it
> +function on a platform ECRs should be submitted to ASWG and go through the

            on a platform, ECRs

> +approval process.
> 


-- 
~Randy
