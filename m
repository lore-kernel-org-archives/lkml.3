Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbbASUde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:33:34 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:51045 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbbASUdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:33:32 -0500
Date: Mon, 19 Jan 2015 21:33:28 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        linaro-acpi@lists.linaro.org, Marc Zyngier <marc.zyngier@arm.com>,
        Jon Masters <jcm@redhat.com>, Timur Tabi <timur@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Al Stone <al.stone@linaro.org>, linux-acpi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, suravee.suthikulpanit@amd.com,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, phoenix.liyi@huawei.com,
        linux-arm-kernel@lists.infradead.org, Charles.Garcia-Tobin@arm.com,
        Parth Dixit <parth.dixit@linaro.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@citrix.com>
Subject: Re: [PATCH v6 17/17] Documentation: ACPI for ARM64
Message-ID: <20150119203328.GB3766@cbox>
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org>
 <1420368918-5086-18-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420368918-5086-18-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jan 04, 2015 at 06:55:18PM +0800, Hanjun Guo wrote:
> From: Graeme Gregory <graeme.gregory@linaro.org>
> 
> Add documentation for the guidelines of how to use ACPI
> on ARM64.
> 
> Reviewed-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/arm64/arm-acpi.txt | 327 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 327 insertions(+)
>  create mode 100644 Documentation/arm64/arm-acpi.txt
> 
> diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.txt
> new file mode 100644
> index 0000000..21e7020
> --- /dev/null
> +++ b/Documentation/arm64/arm-acpi.txt
> @@ -0,0 +1,327 @@
> +ACPI on ARMv8 Servers
> +---------------------
> +ACPI can be used for ARMv8 general purpose servers designed to follow
> +the ARM SBSA (Server Base System Architecture) and SBBR (Server Base
> +Boot Requirements) specifications, currently available to those with
> +an ARM login at http://silver.arm.com.
> +
> +The ARMv8 kernel implements the reduced hardware model of ACPI version
> +5.1 and later.  Links to the specification and all external documents
> +it refers to are managed by the UEFI Forum.  The specification is
> +available at http://www.uefi.org/specifications and external documents
> +can be found via http://www.uefi.org/acpi.
> +
> +If an ARMv8 system does not meet the requirements of the SBSA, or cannot
> +be described using the mechanisms defined in the required ACPI specifications,
> +then it is likely that Device Tree (DT) is more suitable than ACPI for the
> +hardware.
> +
> +
> +Relationship with Device Tree
> +-----------------------------
> +ACPI support in drivers and subsystems for ARMv8 should never be mutually
> +exclusive with DT support at compile time.
> +
> +At boot time the kernel will only use one description method depending on
> +parameters passed from the bootloader (including kernel bootargs).
> +
> +Regardless of whether DT or ACPI is used, the kernel must always be capable
> +of booting with either scheme (in kernels with both schemes enabled at compile
> +time).
> +
> +
> +Booting using ACPI tables
> +-------------------------
> +The only defined method for passing ACPI tables to the kernel on ARMv8
> +is via the UEFI system configuration table.
> +

This is a bit concerning for the approach we are currently taking to
support ACPI on Xen [1].

Background: Xen is a tiny hypervisor which cannot parse the DSDT or any
other non-static table. Xen relies on Linux in Dom0 to manage most
(basically everything except the GIC, serial port, SMMU, and timers)
hardware resources and relies on Dom0 to parse the ACPI tables.

While Xen itself is typically booted by UEFI and finds RSDP through the
UEFI system table, Xen does NOT run another UEFI instance to boot Dom0
nor does it pass through the presence of UEFI to Dom0 in any way.
Instead, it just created a DT (with modifications concerning the
hardware mentioned above) and boots Linux in Dom0 directly (on x86 any
required UEFI call is performed through paravirtualized hypercalls).

In the case of ACPI, Xen adds a property to the chosen node and
populates it with the RDSP in Dom0's address space.  Patches have not
been posted yet, but we do have a working prototype of the
implementation and the Linux changes are minimal to support this
approach.  Parth Dixit (cc'ed) can provide more details on this if
needed/wanted.

With the current wording in this patch, it seems Xen is forced to
emulate EFI or run a full UEFI instance for Dom0 which results in a
really heavy boot sequnce for Xen.  Should we be concerned about this
use case at this point and does anyone have suggestions on how to solve
this?

[1]: https://wiki.linaro.org/LEG/Engineering/Virtualization/ACPI_on_Xen

Thanks,
-Christoffer
