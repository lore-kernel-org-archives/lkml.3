Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbbA0KQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:16:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:24833 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbbA0KQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:16:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,474,1418112000"; 
   d="scan'208";a="676628159"
Date: Tue, 27 Jan 2015 12:16:10 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: i2c-hid: Add support for GPIO interrupts
Message-ID: <20150127101610.GK1451@lahna.fi.intel.com>
References: <1422282573-18215-1-git-send-email-mika.westerberg@linux.intel.com>
 <1422282573-18215-2-git-send-email-mika.westerberg@linux.intel.com>
 <20150126143723.GI23313@leverpostej>
 <20150126144729.GG1451@lahna.fi.intel.com>
 <20150126145000.GJ23313@leverpostej>
 <20150126151637.GH1451@lahna.fi.intel.com>
 <20150126160044.GK23313@leverpostej>
 <20150126161356.GJ1451@lahna.fi.intel.com>
 <20150126163929.GL23313@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126163929.GL23313@leverpostej>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 04:39:30PM +0000, Mark Rutland wrote:
> What I don't follow is why GpioInt seems to be translated as a GPIO
> rather than as an interrupt which happens to be backed by a GPIO. Were
> it not for that, the DT and ACPI cases would align better.

Because it *is* a GPIO.

In my experience we have had two kinds of interrupts that the devices
are connected to: pins connected directly to the interrupt controller
(IO-APIC or whatever), and pins connected to the GPIO controller. This
is the later.

Now, the device in question has following resources:

	Name (_CRS, ResourceTemplate () {
		I2cSerialBus (0x004C, ControllerInitiated, 0x00061A80,
		    AddressingMode7Bit, "\\_SB.PCI0.I2C6",
		    0x00, ResourceConsumer,,)
		GpioInt (Level, ActiveLow, Shared, PullDefault, 0x0000,
		    "\\_SB.GPO0", 0x00, ResourceConsumer,,)
		    {
			0x004C
		    }
	})

The GpioInt() above refers to GPIO controller ("\_SB.GPO0") and its pin
number 0x4c.

Normally I would do this in the driver regardless of where it is
described (DT, ACPI, whatnot):

	desc = gpiod_get(dev, NULL);
	gpiod_direction_input(desc);
	irq = gpiod_to_irq(desc);

Then the "irq" can be used for request_irq() and friends.

Note how both DT and ACPI cases align just fine.

If the above is not the right way to use GPIOs as interrupt, can you
please tell me how it is done then?

BTW, passing NULL to gpiod_get() implies property named "gpios" in DT
(which is why I added it to the documentation).
