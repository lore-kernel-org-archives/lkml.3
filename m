Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaBTBac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:30:32 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50437 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaBTBaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:30:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140219192646.1a62521d@alan.etchedpixels.co.uk>
References: <cover.1387588711.git.luto@amacapital.net> <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana> <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140219192646.1a62521d@alan.etchedpixels.co.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Feb 2014 17:30:09 -0800
Message-ID: <CALCETrWEexCqH5486Qfyt22i5+MZjpETJEMTyg6FO6xOwXuraQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:26 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> example, lots of graphics drivers provide i2c busses, and those busses
>> often contain eeproms, and, in theory, things should know that the
>> eeprom is associated with a particular graphics port, for example.
>> Unfortunately, the i2c core does not know that, things like
>> decode-dimms will try to decode it, sensors-detect will scan graphics
>> ports for motherboard sensors, etc.
>
> ACPI does now try to describe what is on an i²c bus. We perhaps don't use
> that information well but on a modern PC class box at least for onboard
> devices most of the info is there for the munching.

I'm discussing the in-kernel representation, not where the information
comes from.  Presumably there should be something in the kernel that
works for ACPI, DT, and directly-enumerated busses (see below).

>
>> For extra fun, there could be drivers for different types of i2c_port.
>>  One of them could be the "DIMM bus" driver, which would know how to
>> probe the i2c adapter associated with a DIMM port.  Another could be
>> the graphics port driver, which (maybe with some extra configuration
>> hints from the graphics driver) could look for EDID-related things.
>
> Busses are not necessarily that tidily organised. There isn't anything
> saying you can't sneak multiple things on the same bus. In the graphics
> case its unlikely but I wouldn't rule even that out for a display panel.
> Once you get onto phones and tablets it seems anything goes 8)
>

I'm suggesting identifying a range of addresses on a bus with a "port"
(or whatever it should be called).  Multiple ports could claim
non-overlapping ranges on the same bus.

>> I wonder if this would fit in well with the device tree stuff, too --
>> DT has ways to say "this node links to that one", right?
>
> ACPI basically tries to describe the heirarchy of devices on the bus, but
> as you say the "real" device can be a rambling mix of GPIO, I²C, SPI,
> PCI (quite probably fake PCI at that) and other resources.
>
> If there is a legitimate use case for poking around with memory dimm i2c
> on these boards then really there needs to be a proper defined interface
> for doing so that covers firmware and OS users.

The legitimate use case is NV-DIMMs.  They have control registers that
are accessed via smbus.  BIOS is likely to poke at those registers
early in boot, but the kernel and/or userspace will need them, too.
It would be nice to know which DIMM slot they map to.

In this particular case (Intel LGA2011 systems), there's only one sane
way to wire up the busses, since the memory controller *is* the smbus
master.  According to the JEDEC spec, each DIMM slot is has three pins
that indicate which slot it is on its channel, and the onboard smbus
hardware uses those pins to select its addresses.  (This maps directly
to three of the seven address bits.)  Each memory controller supports
two RAM channels and two i2c channels, and, if you wire them backwards
(or mix them up between controllers), then I would be amazed if the
system works.  So this particular driver really does know the topology
a priori.

On the other hand, nothing rules out having NV-DIMMs in non-LGA2011
systems where the smbus/i2c topology is less certain.  But I think it
would be silly for an eventual NVDIMM driver to specifically depend on
ACPI, since ACPI isn't needed for existing LGA2011 NVDIMM systems.

(Knowing which physical memory addresses map to which DIMM is a
different story.  I think that the sb-edac driver knows the mapping,
though.)

--Andy
