Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaKEIyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:54:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:18488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaKEIy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:54:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411700986"
Date: Wed, 5 Nov 2014 10:54:14 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, wsa@the-dreams.de,
        robert.moore@intel.com, lv.zheng@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [RFC PATCH V2] ACPI: Add _DEP(Operation Region Dependencies)
 support to fix battery issue on the Asus T100TA
Message-ID: <20141105085414.GV1618@lahna.fi.intel.com>
References: <1414422584-2638-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414422584-2638-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 11:09:44PM +0800, Lan Tianyu wrote:
> ACPI 5.0 introduces _DEP to designate device objects that OSPM should
> assign a higher priority in start ordering due to future operation region
> accesses.
> 
> On Asus T100TA, ACPI battery info are read from a I2C slave device via
> I2C operation region. Before I2C operation region handler is installed,
> battery _STA always returns 0. There is a _DEP method of designating
> start order under battery device node.
> 
> This patch is to implement _DEP feature to fix battery issue on the Asus T100TA.
> Introducing acpi_dep_list and adding dep_unmet count in the struct
> acpi_device. During ACPI namespace scan, create struct acpi_dep_data for a
> valid pair of master (device pointed to by _DEP)/slave(device with _DEP), record
> master's and slave's ACPI handle in it and put it into acpi_dep_list. The dep_unmet
> count will increase by one if there is a device under its _DEP. Driver's probe() should
> return EPROBE_DEFER when find dep_unmet larger than 0. When I2C operation
> region handler is installed, remove all struct acpi_dep_data on the acpi_dep_list
> whose master is pointed to I2C host controller and decrease slave's dep_unmet.
> When dep_unmet decreases to 0, all _DEP conditions are met and then do acpi_bus_attach()
> for the device in order to resolve battery _STA issue on the Asus T100TA.

Is there a reason why the driver core can't handle this automatically in
such way that when there are unmet dependencies, it will not probe the
device? Or am I missing something?

Now it looks like the driver itself needs to know about these and handle
them somehow.

I'm asking this because there are other things like devices using GPIOs
that also take advantage of _DEP, like this on Asus T100:

        Device (SDHB)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_HID, "INT33BB")  // _HID: Hardware ID
            ...
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                PEPD,
                GPO2
            })

I don't know what PEPD is but GPO2 is the GPIO controller.
