Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaKEVel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:34:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50912 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751133AbaKEVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:34:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, wsa@the-dreams.de, robert.moore@intel.com,
        lv.zheng@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [RFC PATCH V2] ACPI: Add _DEP(Operation Region Dependencies) support to fix battery issue on the Asus T100TA
Date: Wed, 05 Nov 2014 22:55:23 +0100
Message-ID: <7320898.JB9z5hUzdG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141105085414.GV1618@lahna.fi.intel.com>
References: <1414422584-2638-1-git-send-email-tianyu.lan@intel.com> <20141105085414.GV1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 10:54:14 AM Mika Westerberg wrote:
> On Mon, Oct 27, 2014 at 11:09:44PM +0800, Lan Tianyu wrote:
> > ACPI 5.0 introduces _DEP to designate device objects that OSPM should
> > assign a higher priority in start ordering due to future operation region
> > accesses.
> > 
> > On Asus T100TA, ACPI battery info are read from a I2C slave device via
> > I2C operation region. Before I2C operation region handler is installed,
> > battery _STA always returns 0. There is a _DEP method of designating
> > start order under battery device node.
> > 
> > This patch is to implement _DEP feature to fix battery issue on the Asus T100TA.
> > Introducing acpi_dep_list and adding dep_unmet count in the struct
> > acpi_device. During ACPI namespace scan, create struct acpi_dep_data for a
> > valid pair of master (device pointed to by _DEP)/slave(device with _DEP), record
> > master's and slave's ACPI handle in it and put it into acpi_dep_list. The dep_unmet
> > count will increase by one if there is a device under its _DEP. Driver's probe() should
> > return EPROBE_DEFER when find dep_unmet larger than 0. When I2C operation
> > region handler is installed, remove all struct acpi_dep_data on the acpi_dep_list
> > whose master is pointed to I2C host controller and decrease slave's dep_unmet.
> > When dep_unmet decreases to 0, all _DEP conditions are met and then do acpi_bus_attach()
> > for the device in order to resolve battery _STA issue on the Asus T100TA.
> 
> Is there a reason why the driver core can't handle this automatically in
> such way that when there are unmet dependencies, it will not probe the
> device? Or am I missing something?

Yes, there is a reason: There's no way to represent such dependencies in the
driver core. :-)

That's been discussed for several times (and I've even mentioned _DEP in one
of those discussions) and it's always ended up being seen as "complexity
nightmare".

> Now it looks like the driver itself needs to know about these and handle
> them somehow.

The patch is missing the user of it which is going to be the battery driver
only for the time being.  Tianyu, can you please include the battery changes
into the patch at least for now?

> I'm asking this because there are other things like devices using GPIOs
> that also take advantage of _DEP, like this on Asus T100:
> 
>         Device (SDHB)
>         {
>             Name (_ADR, Zero)  // _ADR: Address
>             Name (_HID, "INT33BB")  // _HID: Hardware ID
>             ...
>             Name (_DEP, Package (0x02)  // _DEP: Dependencies
>             {
>                 PEPD,
>                 GPO2
>             })
> 
> I don't know what PEPD is but GPO2 is the GPIO controller.

Well, if you read the definition of _DEP in ACPI 5.1, it is all about operation
regions, so this smells like abuse of sorts.  In any case, it is hard to argue
that _DEP is not internal to ACPI because of that definition.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
