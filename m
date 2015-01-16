Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbbAPSOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:14:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47705 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbAPSN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:13:59 -0500
Date: Fri, 16 Jan 2015 13:13:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-pci@vger.kernel.org
Subject: Re: [Bugfix v4 1/2] xen/pci: Fix xen IRQ allocation failure caused
 by commit b81975eade8c
Message-ID: <20150116181318.GA22690@l.oracle.com>
References: <1421204979-30619-1-git-send-email-jiang.liu@linux.intel.com>
 <1421327077-19894-1-git-send-email-jiang.liu@linux.intel.com>
 <1421327077-19894-2-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421327077-19894-2-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:04:35PM +0800, Jiang Liu wrote:
> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
> setup_IO_APIC(), so no irqdomains created for IOAPICs and
> mp_map_pin_to_irq() fails at the very beginning.
> 
> Currently Xen Domain0 has special treatment for ACPI SCI interrupt,
> that is initialize irq for ACPI SCI at early stage in a special way as:
> xen_init_IRQ()
> 	->pci_xen_initial_domain()
> 		->xen_setup_acpi_sci()
> 			Allocate and initialize irq for ACPI SCI
> 
> Function xen_setup_acpi_sci() calls acpi_gsi_to_irq() to get an irq
> number for ACPI SCI. But unfortunately acpi_gsi_to_irq() depends on
> IOAPIC irqdomains through following path
> acpi_gsi_to_irq()
> 	->mp_map_gsi_to_irq()
> 		->mp_map_pin_to_irq()
> 			->check IOAPIC irqdomain
> 
> For PV domains, it uses Xen event based interrupt manangement and
> doesn't make uses of native IOAPIC, so no irqdomains created for IOAPIC.
> This causes Xen domain0 fails to install interrupt handler for ACPI SCI
> and all ACPI events will be lost. Please refer to:
> https://lkml.org/lkml/2014/12/19/178
> 
> So the fix is to get rid of special treatment for ACPI SCI, just treat
> ACPI SCI as normal GSI interrupt as:
> acpi_gsi_to_irq()
> 	->acpi_register_gsi()
> 		->acpi_register_gsi_xen()
> 			->xen_register_gsi()
> 
> With above change, there's no need for xen_setup_acpi_sci() anymore.
> The above change also works with bare metal kernel too.
> 
> Note: we need to test this patch on those special AMD systems which
> override normal SCI GSI (9) with strange GSI (20).

[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 2.1c       10/28/2011
..
     0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
[    0.000000] ACPI: IRQ0 used by override.
..
    6.358737] xen: registering gsi 20 triggering 0 polarity 1
[    6.358756] xen: --> pirq=20 -> irq=20 (gsi=20)
...
-bash-4.1# cat /proc/interrupts |grep acpi
 20:          0          0          0  xen-pirq-ioapic-level  acpi


