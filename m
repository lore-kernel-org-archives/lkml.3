Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaI3ViJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:09 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41775 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaI3ViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:01 -0400
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <20140930211339.GA1264@katana>
References: <542A3593.4020108@gmail.com>
	<CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
	<20140930211339.GA1264@katana>
Date: Tue, 30 Sep 2014 14:37:59 -0700
Message-ID: <CAA93t1out+gJO29_0tn1zLJv_MUwJ458XKNT3Lo6WW+mH9XeRQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over I2C
From: Rajat Jain <rajatxjain@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 30, 2014 at 2:13 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> > Since this is a driver for a PCIe switch, I currently put it under /driver/pci/.
>> > I'm very open to suggestions for moving this around (Does introducing
>> > drivers/pci/switch/ seem any better?). Especially I can see that the
>> > drivers/pci/Kconfig appears under "Bus Options" in the main menu which does not
>> > look like the right place for this driver. I am looking for suggestions here.
>>
>> Definitely interesting work.  I have no idea where to put it.  It
>> doesn't have anything to do with PCI core services or structures, so
>> drivers/pci doesn't seem like the ideal place for it, but I don't have
>> any better ideas.  If it did end up under drivers/pci, I agree that a
>> drivers/pci/switch or something similar would probably be better than
>> having it directly in drivers/pci.
>>
>> Maybe Wolfram or other I2C folks will have an idea.
>
> Hmm, is this a common interface for those switches? Then a directory
> like drivers/pci/switch could make sense. Otherwise I'd suggest
> drivers/misc?
>

Yes, this (I2C) is a common (secondary) interface for most of the
modern PCIe switches from PLX and IDT. And it is often used in complex
systems to handle use cases described in the documentation being added
as part of this patch set. Excerpt (from
https://lkml.org/lkml/2014/9/30/29):

===========================================================
...<snip>...

+0. Why have an I2C interface to a PCIe switch?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Other than the regular PCI express interface, most modern PCIe switches (e.g.
+from IDT and PLX) have an I2C based secondary interface. This interface allows
+access to all the registers of the switch. Some of these registers may not even
+be accessible over the regular PCI interface. Also, there are certain registers
+that can be written to, using only the I2C interface and may only be read-only
+using the PCI interface.
+
+This I2C interface is often used in designs involving these switches, and can
+be used for a variety of use cases where the switch needs to be configured
+independent of the PCI subsystem (and likely before PCI enumeration). Some
+examples:
+
+* Dividing a PCIe switch into multiple "virtual" switches. Using this feature,
+  a switch could be connected to 2 root ports for instance, each managing its
+  own PCI hierarchy, and the traffic from one virtual switch does not leak into
+  another.
+
+* Managing Transparent / Non-transparent bridging, and changing them
on-the-fly.
+  There are ports that can be converted into "Non-transparent" bridge ports.
+  Essentially this is used to create different domains (not visible to
+  software). In a dynamic distributed system, it may be desirable to change a
+  transparent bridge to non-transparent or vice versa, for example, to handle a
+  failover situation.
+
+* Buggy hardware / Bad EEPROM configuration. There may be cases where an errata
+  involving register writes need to be applied before enumerating over PCI.
+  Also these switches are typically attached to an EEPROM that is supposed to
+  initialize the switch. If that EEPROM is not present, or contains bad
+  initialization data, this I2C interface can be used to fix that.
+
+* Changing switch configuration on the fly. In a multi-homed or complex
+  distributed systemsystem, there may be a need to change the switch
+  configuration (eg. change the upstream port, or the port or lane
+  configuration etc) to address run time scenarios (CPU plug out etc).
+

...<snip>...
===========================================================

I am myself leaning towards drivers/pci/switch/. And am wanting to
hear what other think.

Thanks,

Rajat
