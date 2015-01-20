Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbbATT0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:26:03 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:50810 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbATT0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:26:00 -0500
MIME-Version: 1.0
In-Reply-To: <1421775689.1112.4.camel@linux-0dmf.site>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
 <1421751814.29486.13.camel@linux-0dmf.site> <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
 <1421762788.29486.28.camel@linux-0dmf.site> <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
 <1421775689.1112.4.camel@linux-0dmf.site>
From: Kirill Elagin <kirelagin@gmail.com>
Date: Tue, 20 Jan 2015 23:25:37 +0400
Message-ID: <CABVT_geh3RjaG+zX6xUWL9RQtwoAeyuC33xf2vT2o0HPPkokcg@mail.gmail.com>
Subject: Re: USB autosuspend causing trouble with bluetooth
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 8:41 PM, Oliver Neukum <oneukum@suse.de> wrote:
> On Tue, 2015-01-20 at 18:58 +0400, Kirill Elagin wrote:
>> On Tue, Jan 20, 2015 at 5:06 PM, Oliver Neukum <oneukum@suse.de> wrote:
>> > On Tue, 2015-01-20 at 16:18 +0400, Kirill Elagin wrote:
>> >> I use a Logitech wireless keyboard (with a Unifying receiver) and it
>> >> keeps working fine even with `auto`.
>> >>
>> >> That is, everything is OK if the receiver is plugged before
>> >> `power/control` is switched to `auto`.
>> >
>> > Wait. There is no power/control file for the receiver before
>> > you plug it in. We are having a very big misunderstanding here.
>>
>> Sorry for not being clear. I was referring to `power/control` of the
>> USB-device itself except for the cases when I was talking about
>> hot-plugging issues — in those cases I was referring to the
>> `power/control` of the root hub.
>
> Please check whether you are not accidentally touching the ports
> linux-0dmf:/sys/bus/usb/devices/usb1/1-0:1.0/usb1-port1
> At paths like this you find control files for ports, not the
> root hub as a device.
>
>> In this particular case I was talking about the `power/control` of the root hub.
>
> OK, so autosuspend does work if you enable it for the device but
> not the hub?

Hm, I'm pretty sure I never touched anything with `port` in its name,
all the ports are set to `auto` (that's what laptop-mode-tools does).

Right now I think I see three possibly unrelated issues:

Issue #1. BT trackpad not working properly when connected to the
builtin bluetooth adapter.
----------

The adapter is attached to a USB1.1 hub:

~~~~
# lsusb -t
...
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
    |__ Port 2: Dev 2, If 0, Class=Wireless, Driver=btusb, 12M
    |__ Port 2: Dev 2, If 1, Class=Wireless, Driver=btusb, 12M
    |__ Port 2: Dev 2, If 2, Class=Vendor Specific Class, Driver=, 12M
    |__ Port 2: Dev 2, If 3, Class=Application Specific Interface, Driver=, 12M
...

# cat usb3/power/control
auto

# cat usb3/3-*/usb3-port*/power/control
auto
auto

# cat usb3/3-2/power/control
on
~~~~

The trackpad is working fine right now. Whenever I do

~~~~
# echo auto > usb3/3-2/power/control
~~~~

and leave it alone for 5 seconds `btmon` stops showing any activity.
As soon as I do

~~~~
# echo on > usb3/3-2/power/control
~~~~

the trackpad is alive again. As I mentioned this doesn’t happen when
the trackpad is connected to a USB BT dongle (also USB1.1, but a
different bus number).


Issue #2. No hotplug with USB1.1:
----------

To see this I pick one physical port. When I plug a USB1.1 device it
appears on bus 4 port 2; a USB2.0 device appears on bus 1 port 4.

~~~~
# cat usb4/power/control
auto
# cat usb4/4-*/usb4-port*/power/control
auto
auto
# cat usb1/power/control
auto
# cat usb1/1-*/usb1-port*/power/control
auto
auto
auto
auto

# journalctl -b -k -f -n 0 &
[1] 8390
-- Logs begin at Fri 2015-01-02 03:13:31 MSK. --

(plug USB2.0 flash drive in)

Jan 20 21:55:09 kirNote kernel: usb 4-2: USB disconnect, device number 6
Jan 20 22:00:19 kirNote kernel: usb 1-4: new high-speed USB device
number 15 using ehci-pci
Jan 20 22:00:19 kirNote kernel: usb 1-4: New USB device found,
idVendor=0951, idProduct=1623
Jan 20 22:00:19 kirNote kernel: usb 1-4: New USB device strings:
Mfr=1, Product=2, SerialNumber=3
...

(plug flash drive out)

Jan 20 22:00:35 kirNote kernel: usb 1-4: USB disconnect, device number 15

(plug USB1.1 BT dongle)
(nothing happens)

# echo on > usb4/power/control
Jan 20 22:01:09 kirNote kernel: usb 4-2: new full-speed USB device
number 7 using uhci_hcd
Jan 20 22:01:09 kirNote kernel: usb 4-2: New USB device found,
idVendor=0a12, idProduct=0001
Jan 20 22:01:09 kirNote kernel: usb 4-2: New USB device strings:
Mfr=0, Product=0, SerialNumber=0

(plug dongle out)

Jan 20 22:01:26 kirNote kernel: usb 4-2: USB disconnect, device number 7
~~~~


Issue #3. No hot-plug-out for USB1.1.
--------

This issue is somewhat harder to describe as it depends on the
combination of power/control of the hub and device. And there are
three possible outcomes: device disconnect properly detected (both
`on`), not detected at all (both `auto`), error about a port being
"disabled by hub (EMI?)" in some other cases. I'm not really sure
about this one and I'll get back about it later after some more
experiments.


I think that the first two issues are fixed by keeping all the USB1.1
hubs and the builtin BT always `on`, but I just wanted to know whether
those are hardware or software bugs.

Thanks for helping me investigate this!
