Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaBSRbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:31:10 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58616 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaBSRbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:31:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140219151626.GA13973@katana>
References: <cover.1387588711.git.luto@amacapital.net> <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Feb 2014 09:30:46 -0800
Message-ID: <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 7:16 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Fri, Dec 20, 2013 at 05:45:13PM -0800, Andy Lutomirski wrote:
>> Add i2c_scan_dimm_bus to declare that a particular i2c_adapter
>> contains DIMMs.  This will probe (and autoload modules!) for useful
>> SMBUS devices that live on DIMMs.  i2c_imc calls it.
>
> Hmm, after thinking about it for a while and a couple of times, I get
> the impression that the functionality of i2c_scan_dimm_bus() should
> better be in userspace, i.e. a udev helper. I could imagine introducing
> a new functionality macro I2C_FUNC_DIMM_BUS which can be detected in
> userspace via i2c-dev. Based on that, the helper can do whatever
> necessary. What do you think?
>

Hmm.  So there would be udev rules that detect an I2C_FUNC_DIMM_BUS
driver and probe it appropriately.

I'm not sure I like it.  It would mean that any future kernel code
that wants to use things hanging off the dimm bus would need to stay
in sync with the udev rules, and it would make things like sticking
platform_data into the probed devices complicated or impossible.

This seems to be a somewhat common problem with i2c code.  For
example, lots of graphics drivers provide i2c busses, and those busses
often contain eeproms, and, in theory, things should know that the
eeprom is associated with a particular graphics port, for example.
Unfortunately, the i2c core does not know that, things like
decode-dimms will try to decode it, sensors-detect will scan graphics
ports for motherboard sensors, etc.

It would be great if there was a generic way to tag an i2c bus as
serving a particular purpose.  Code that knew the purpose could probe
appropriately, and code that wants to find things like eeproms on a
particular port could look for the i2c bus that's tagged as belonging
to the port and read its eeprom.

Is this something that could be done using something like kobject
symlinks?  For example, suppose there were a new class device
"i2c_port".  A driver could instantiate this class and tell the i2c
core (perhaps as part of i2c_register_adapter or in struct
i2c_adapter?) that a given i2c_adapter that a certain range of
addresses on the i2c_adapter belong to the port.  The i2c core could
create symlinks between the i2c_port and the i2c_adapter.

For extra fun, there could be drivers for different types of i2c_port.
 One of them could be the "DIMM bus" driver, which would know how to
probe the i2c adapter associated with a DIMM port.  Another could be
the graphics port driver, which (maybe with some extra configuration
hints from the graphics driver) could look for EDID-related things.

This could result in (after a bunch of extra code gets written) an
actual struct device for a DIMM slot, which would have a class device
for its i2c_port that claims all the the DIMM addresses with the slot
number bits set appropriately for that port.  In the even more distant
future, maybe the EDAC devices would also hang off of that DIMM slot.

I wonder if this would fit in well with the device tree stuff, too --
DT has ways to say "this node links to that one", right?

*sigh*.  The driver model wasn't really designed for a world where the
logical device topology is completely unrelated to the physical bus
topology.

OK, enough rambling for now. :)

--Andy
