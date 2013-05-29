Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123Ab3E2IZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:25:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:33370 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964992Ab3E2IZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,763,1363158000"; 
   d="scan'208";a="309389741"
Date: Wed, 29 May 2013 11:29:59 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper
 routine
Message-ID: <20130529082959.GW11878@intel.com>
References: <1463685.qFyr66vqF2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1463685.qFyr66vqF2@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 01:29:06AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The "runtime idle" helper routine, rpm_idle(), currently ignores
> return values from .runtime_idle() callbacks executed by it.
> 
> However, it turns out that many subsystems use the generic idle
> callback routine pm_generic_runtime_idle() which checks the return
> value of the driver's callback and executes pm_runtime_suspend() for
> the device unless that value is different from 0.  If that logic is
> moved to rpm_idle() instead, pm_generic_runtime_idle() can be dropped
> and its users will not need any .runtime_idle() callbacks any more.
> 
> Moreover, the PCI subsystem's .runtime_idle() routine,
> pci_pm_runtime_idle(), works in analogy with the generic one and if
> rpm_idle() calls rpm_suspend() after 0 has been returned by the
> .runtime_idle() callback executed by it, that routine will not be
> necessary any more and may be dropped.
> 
> To reduce overall code duplication make the changes described above.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> The patch doesn't break compilation for me, but it hasn't been tested
> otherwise.  It applies on top of the linux-pm.git tree's linux-next branch.
> 
> Thanks,
> Rafael
> 
> ---
>  Documentation/power/runtime_pm.txt |    5 -----
>  arch/arm/mach-omap2/omap_device.c  |    7 +------
>  drivers/acpi/device_pm.c           |    1 -
>  drivers/amba/bus.c                 |    2 +-
>  drivers/base/platform.c            |    1 -
>  drivers/base/power/domain.c        |    1 -
>  drivers/base/power/generic_ops.c   |   23 -----------------------
>  drivers/base/power/runtime.c       |   12 +++++-------
>  drivers/i2c/i2c-core.c             |    2 +-

i2c-core runtime PM idle still works with this patch :-)

You can add my

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

for the i2c parts if you like.

>  drivers/mmc/core/sdio_bus.c        |    2 +-
>  drivers/pci/pci-driver.c           |   27 ---------------------------
>  drivers/spi/spi.c                  |    2 +-
>  drivers/usb/core/port.c            |    1 -
>  include/linux/pm_runtime.h         |    2 --
>  14 files changed, 10 insertions(+), 78 deletions(-)
