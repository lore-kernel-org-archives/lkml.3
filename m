Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaJAVck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:32:40 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:34611 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaJAVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:32:38 -0400
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <20141001072949.GA1322@katana>
References: <542A3593.4020108@gmail.com>
	<CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
	<20140930211339.GA1264@katana>
	<CAA93t1out+gJO29_0tn1zLJv_MUwJ458XKNT3Lo6WW+mH9XeRQ@mail.gmail.com>
	<20141001072949.GA1322@katana>
Date: Wed, 1 Oct 2014 14:32:37 -0700
Message-ID: <CAA93t1qjzAWQqkZQcJYFZxvuhy6o1N2gJ+j=AKgcqE=zup=BJw@mail.gmail.com>
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

On Wed, Oct 1, 2014 at 12:29 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> ===========================================================
>> ...<snip>...
>>
>> +0. Why have an I2C interface to a PCIe switch?
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> +Other than the regular PCI express interface, most modern PCIe switches (e.g.
>> +from IDT and PLX) have an I2C based secondary interface. This interface allows
>> +access to all the registers of the switch. Some of these registers may not even
>> +be accessible over the regular PCI interface. Also, there are certain registers
>> +that can be written to, using only the I2C interface and may only be read-only
>> +using the PCI interface.
>> +
>> +This I2C interface is often used in designs involving these switches, and can
>> +be used for a variety of use cases where the switch needs to be configured
>> +independent of the PCI subsystem (and likely before PCI enumeration). Some
>> +examples:
>> +
>> +* Dividing a PCIe switch into multiple "virtual" switches. Using this feature,
>> +  a switch could be connected to 2 root ports for instance, each managing its
>> +  own PCI hierarchy, and the traffic from one virtual switch does not leak into
>> +  another.
>> +
>> +* Managing Transparent / Non-transparent bridging, and changing them
>> on-the-fly.
>> +  There are ports that can be converted into "Non-transparent" bridge ports.
>> +  Essentially this is used to create different domains (not visible to
>> +  software). In a dynamic distributed system, it may be desirable to change a
>> +  transparent bridge to non-transparent or vice versa, for example, to handle a
>> +  failover situation.
>> +
>> +* Buggy hardware / Bad EEPROM configuration. There may be cases where an errata
>> +  involving register writes need to be applied before enumerating over PCI.
>> +  Also these switches are typically attached to an EEPROM that is supposed to
>> +  initialize the switch. If that EEPROM is not present, or contains bad
>> +  initialization data, this I2C interface can be used to fix that.
>> +
>> +* Changing switch configuration on the fly. In a multi-homed or complex
>> +  distributed systemsystem, there may be a need to change the switch
>> +  configuration (eg. change the upstream port, or the port or lane
>> +  configuration etc) to address run time scenarios (CPU plug out etc).
>> +
>>
>> ...<snip>...
>> ===========================================================
>>
>> I am myself leaning towards drivers/pci/switch/. And am wanting to
>> hear what other think.
>
> I had a closer look and my first question is now if we really need a
> kernel driver for this?
>
> The sysfs interface is basically to PEEK/POKE registers of the switch.
> How registers get accessed is part of userspace. Well, then it might
> even be easier to construct the proper i2c messages in userspace, too,
> and send them via i2c-dev (instead of writing to various files in
> sysfs).
>
> The Kernel API is also PEEK/POKE register. I am not an PCI expert, but I
> can't see a user in this form. What I'd expect would be more like
>
> pci_switch_set_mode(some_device, PCI_BRIDGE_MODE_TRANSPARENT);

I understand and agree. In fact in the internal version of this driver
(that I have not yet sent out for review), we do have APIs added
similar to what you mention above. Currently I have APIs that:
- Enable / Disable PCIe links.
- Change the upstream port.
- Enable / Disable Non-transparent mode etc.

However, I did not send them all out for review because I don't have
the hardware to try and test them out on ALL the supported devices
(also would require considerable amount of time). I have tested those
APIs on PEX8713 only, because for e.g.I only have PEX8713 in a HW that
connects to 2 CPUs at the same time.

>
> and then a shim layer would make sure the proper driver for the switch
> sends the proper commands. Again, I don't know if the decision of
> setting a mode/creating virtual switches... is even desirable in kernel
> space. If so, then this is probably a sub-subsystem
> drivers/pci/switches, but needs way more abstraction. Otherwise,
> userspace will currently do IMO.

You are right, what this basic driver abstracts is the I2C interface
(i.e. the command format and response format etc) of the PCIe switch,
and not really the PCIe switch itself (Hence I was calling it PEX8xxx
I2C driver. I think that is still a useful abstraction to have,
because that can be used to build the actual logic code that program
the switch. Yes, I agree that we can have another layer of abstraction
so that we have:

- The Core logic code (that knows "How do we want the switch to behave")
- A PEX8xxx driver (that knows "which registers to program")
- A PEX8xxx I2C driver ("How to program those registers") - this driver.

I do understand that your suggestion is to include and bundle the
latter two into this same driver. However since the possibilities
(about which APIs to provide) are too much and not enough hardware to
test it, would it be acceptable if I include those APIs, but support
them for only 1 device (and return error for others)? Note that even
with those APIs, I feel exposing the Read/Write APIs will be useful -
because what core logic wants to achieve can be highly device and
platform specific. Also, a sysfs interface for this switch is proving
to be a very helpful development aid :-) (personal experience :-))

Thanks & Best Regards,

Rajat Jain
