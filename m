Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaILOCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:02:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48257 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaILOCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:02:19 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 18/18] Documentation: ACPI for ARM64
Date: Fri, 12 Sep 2014 22:00:16 +0800
Message-Id: <1410530416-30200-19-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

Add documentation for the guidelines of how to use ACPI
on ARM64.

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 Documentation/arm64/arm-acpi.txt |  218 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 218 insertions(+)
 create mode 100644 Documentation/arm64/arm-acpi.txt

diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.txt
new file mode 100644
index 0000000..704a9e0
--- /dev/null
+++ b/Documentation/arm64/arm-acpi.txt
@@ -0,0 +1,218 @@
+ACPI on ARMv8 Servers
+---------------------
+
+ACPI can be used for ARMv8 general purpose servers designed to follow
+the SBSA specification (currently available to people with an ARM login at
+http://silver.arm.com).
+
+The kernel will implement minimum ACPI version is 5.1 + errata as released by
+the UEFI Forum, which is available at <http://www.uefi.org/acpi/specs>.
+
+If the machine does not meet the requirements of the SBSA, or cannot be
+described in the required ACPI specifications then it is likely that Device Tree
+(DT) is more suitable for the hardware.
+
+Relationship with Device Tree
+-----------------------------
+
+ACPI support in drivers and subsystems for ARMv8 should never be mutually
+exclusive with DT support at compile time.
+
+At boot time the kernel will only use one description method depending on
+parameters passed from the bootloader (including kernel bootargs).
+
+Regardless of whether DT or ACPI is used, the kernel must always be capable
+of booting with either scheme (in kernels with both schemes enabled at compile
+time).
+
+When booting using ACPI tables the /chosen node in DT will still be parsed
+to extract the kernel command line and initrd path. No other section of
+the DT will be used.
+
+Booting using ACPI tables
+-------------------------
+
+Currently, the only defined method to pass ACPI tables to the kernel on ARMv8
+is via the UEFI system configuration table.
+
+The UEFI implementation MUST set the ACPI_20_TABLE_GUID to point to the
+RSDP table (the table with the ACPI signature "RSD PTR ").
+
+The pointer to the RSDP table will be retrieved from EFI by the ACPI core.
+
+Processing of ACPI tables may be disabled by passing acpi=off on the kernel
+command line.
+
+DO use an XSDT; RSDTs are deprecated and should not be used on arm64. They
+only allow for 32-bit addresses.
+
+DO NOT use the 32-bit address fields in the FADT; they are deprecated. The
+64-bit alternatives MUST be used.
+
+The minimum set of tables MUST include RSDP, XSDT, FACS, FADT, DSDT, MADT
+and GTDT. If PCI is used the MCFG table MUST also be present.
+
+ACPI Detection
+--------------
+
+Drivers should determine their probe() type by checking for ACPI_HANDLE,
+or .of_node, or other information in the device structure. This is
+detailed further in the "Driver Recommendations" section.
+
+In non-driver code If the presence of ACPI needs to be detected at runtime,
+then check the value of acpi_disabled. If CONFIG_ACPI is not set,
+acpi_disabled will always be 1.
+
+Device Enumeration
+------------------
+
+Device descriptions in ACPI should use standard recognized ACPI interfaces.
+These are far simpler than the information provided via Device Tree. Drivers
+should take into account this simplicity and work with sensible defaults.
+
+On no account should a Device Tree attempt to be replicated in ASL using such
+constructs as Name(KEY0, "Value1") type constructs. Additional driver specific
+data should be represented with the appropriate _DSD (ACPI Section 6.2.5)
+structure. _DSM (ACPI Section 9.14.1) should only be used if _DSD cannot
+represent the data required.
+
+This data should be rare and not OS specific. For x86 ACPI has taken to
+identifying itself as Windows because it was found that only one path was
+routinely tested. For ARMv8 it would be preferable to have only one well
+tested path.
+
+_DSD covers more than the generic server case and care should be taken not to
+replicate highly specific embedded behaviour from DT into generic servers.
+
+Common _DSD bindings should be submitted to ASWG to be included in the
+document :-
+
+http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
+
+If these bindings are mirrored from DT care should be taken to ensure they are
+reviewed as DT bindings before submission to limit divergance in bindings.
+
+Programmable Power Control Resources
+------------------------------------
+
+Programmable power control resources include such resources as voltage/current
+providers (regulators) and clock sources.
+
+For power control of these resources they should be represented with Power
+Resource Objects (ACPI Section 7.1). The ACPI core will then handle correctly
+enabling/disabling of resources as they are needed.
+
+The ACPI 5.1 specification does not contain any standard binding for these
+objects to enable programmable levels or rates so this should be avoided if
+possible and the resources set to appropriate levels by the firmware. If this is
+not possible then any manipulation should be abstracted in ASL.
+
+Each device in ACPI has D-states and these can be controlled through
+the optional methods _PS0..._PS3 where _PS0 is full on and _PS3 is full off.
+
+If either _PS0 or _PS3 is implemented, then the other method must also be
+implemented.
+
+If a device requires usage or setup of a power resource when on, the ASL
+should organize that it is allocated/enabled using the _PS0 method.
+
+Resources allocated/enabled in the _PS0 method should be disabled/de-allocated
+in the _PS3 method.
+
+Such code in _PS? methods will of course be very platform specific but
+should allow the driver to operate the device without special non-standard
+values being read from ASL. Further, abstracting the use of these resources
+allows hardware revisions without requiring updates to the kernel.
+
+Clocks
+------
+
+Like clocks that are part of the power resources there is no standard way
+to represent a clock tree in ACPI 5.1 in a similar manner to how it is
+described in DT.
+
+Devices affected by this include things like UARTs, SoC driven LCD displays,
+etc.
+
+The firmware (for example, UEFI) should initialize these clocks to fixed working
+values before the kernel is executed.
+
+Driver Recommendations
+----------------------
+
+DO NOT remove any FDT handling when adding ACPI support for a driver. Different
+systems may use the same device.
+
+DO try and keep complex sections of ACPI and DT functionality separate. This
+may mean a patch to break out some complex DT to another function before
+the patch to add ACPI. This may happen in other functions but is most likely
+in probe function. This gives a clearer flow of data for reviewing driver
+source.
+
+probe() :-
+
+static int device_probe_dt(struct platform_device *pdev)
+{
+	/* DT specific functionality */
+	...
+}
+
+static int device_probe_acpi(struct platform_device *pdev)
+{
+	/* ACPI specific functionality */
+	...
+}
+
+static int device_probe(stuct platform_device *pdev)
+{
+	...
+	struct device_node node = pdev->dev.of_node;
+	...
+
+	if (node)
+		ret = device_probe_dt(pdev);
+	else if (ACPI_HANDLE(&pdev->dev))
+		ret = device_probe_acpi(pdev);
+	else
+		/* other initialization */
+		...
+	/* Continue with any generic probe operations */
+	...
+}
+
+DO keep the MODULE_DEVICE_TABLE entries together in the driver to make it clear
+the different names the driver is probed for, both from DT and from ACPI.
+
+module device tables :-
+
+static struct of_device_id virtio_mmio_match[] = {
+        { .compatible = "virtio,mmio", },
+        { }
+};
+MODULE_DEVICE_TABLE(of, virtio_mmio_match);
+
+static const struct acpi_device_id virtio_mmio_acpi_match[] = {
+        { "LNRO0005", },
+        { }
+};
+MODULE_DEVICE_TABLE(acpi, virtio_mmio_acpi_match);
+
+ASWG
+----
+
+The following areas are not yet well defined for ARM in the current ACPI
+specification and are expected to be worked through in the UEFI ACPI
+Specification Working Group (ASWG) <http://www.uefi.org/workinggroups>.
+Participation in this group is open to all UEFI members.
+
+	- ACPI based CPU topology
+	- ACPI based Power management
+	- CPU idle control based on PSCI
+	- CPU performance control (CPPC)
+	- ACPI based SMMU
+	- ITS support for GIC in MADT
+
+No code shall be accepted into the kernel unless it complies with the released
+standards from UEFI ASWG. If there are features missing from ACPI to make it
+function on a platform, ECRs should be submitted to ASWG and go through the
+approval process.
-- 
1.7.9.5

