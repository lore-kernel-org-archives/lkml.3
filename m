Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbbAXJ4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 04:56:07 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56167 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAXJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 04:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <1421790436.1112.14.camel@linux-0dmf.site>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
 <1421751814.29486.13.camel@linux-0dmf.site> <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
 <1421762788.29486.28.camel@linux-0dmf.site> <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
 <1421775689.1112.4.camel@linux-0dmf.site> <CABVT_geh3RjaG+zX6xUWL9RQtwoAeyuC33xf2vT2o0HPPkokcg@mail.gmail.com>
 <1421790436.1112.14.camel@linux-0dmf.site>
From: Kirill Elagin <kirelagin@gmail.com>
Date: Sat, 24 Jan 2015 13:55:39 +0400
Message-ID: <CABVT_geRjB12v8XnRvNbf_2h6-hQJwgxuFkqxBhwQv2nrZ-w9A@mail.gmail.com>
Subject: Re: USB autosuspend causing trouble with bluetooth
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:47 AM, Oliver Neukum <oneukum@suse.de> wrote:
> On Tue, 2015-01-20 at 23:25 +0400, Kirill Elagin wrote:
>
>> Hm, I'm pretty sure I never touched anything with `port` in its name,
>> all the ports are set to `auto` (that's what laptop-mode-tools does).
>
> Here we go.
>
>> Right now I think I see three possibly unrelated issues:
>>
>> Issue #1. BT trackpad not working properly when connected to the
>> builtin bluetooth adapter.
>> ----------
>>
>> The adapter is attached to a USB1.1 hub:
>>
>> ~~~~
>> # lsusb -t
>> ...
>> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
>>     |__ Port 2: Dev 2, If 0, Class=Wireless, Driver=btusb, 12M
>>     |__ Port 2: Dev 2, If 1, Class=Wireless, Driver=btusb, 12M
>>     |__ Port 2: Dev 2, If 2, Class=Vendor Specific Class, Driver=, 12M
>>     |__ Port 2: Dev 2, If 3, Class=Application Specific Interface, Driver=, 12M
>> ...
>>
>> # cat usb3/power/control
>> auto
>>
>> # cat usb3/3-*/usb3-port*/power/control
>> auto
>> auto
>
> Try setting this to on.
>
>> # cat usb3/3-2/power/control
>> on
>
> Here "auto" should work. Please try.
> [..]
>> Issue #2. No hotplug with USB1.1:
>> ----------
>>
>> To see this I pick one physical port. When I plug a USB1.1 device it
>> appears on bus 4 port 2; a USB2.0 device appears on bus 1 port 4.
>>
>> ~~~~
>> # cat usb4/power/control
>> auto
>> # cat usb4/4-*/usb4-port*/power/control
>> auto
>> auto
>
> Please set this to "on"
>
>> # cat usb1/power/control
>> auto
>> # cat usb1/1-*/usb1-port*/power/control
>
> Please set this to "on"

I started with the defaults (`auto` everywhere) and did:

~~~~
for f in /sys/bus/usb/devices/usb*/*-*/*-port*/power/control; do echo
on > $f; done
~~~~

This had absolutely _no_ effect on hotplug. As before, when I insert
the keyboard receiver nothing happens until I echo `on` to
`usb6/power/control`.

>
> [..]
>>
>> Issue #3. No hot-plug-out for USB1.1.
>> --------
>
>> I think that the first two issues are fixed by keeping all the USB1.1
>> hubs and the builtin BT always `on`, but I just wanted to know whether
>> those are hardware or software bugs.
>
> I suspect this is caused by outdated laptop-mode-tools.

I have laptop-mode-tools-1.66 and actually I initially blamed the new
runtime-pm module. But it turns out, `laptop_mode` doesn't touch the
ports at all.

>
> Basically setting the port controls (as opposed to hub and device
> controls) to "auto" tells the kernel that it may disable hotplugging
> to save energy. Hotunplug for devices that need remote wakeup will
> still work. Likewise if you disable autosuspend of the attached devices.
>
>         Regards
>                 Oliver
>
>
