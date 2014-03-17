Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaCQR2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:28:20 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49615 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaCQR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <201403160357.53858.s.L-H@gmx.de>
References: <20140314211456.GA23213@amd.pavel.ucw.cz>
	<201403150217.50526.s.L-H@gmx.de>
	<532471EC.1070107@intel.com>
	<201403160357.53858.s.L-H@gmx.de>
Date: Mon, 17 Mar 2014 13:28:17 -0400
X-Google-Sender-Auth: HhBFEyRNY_5s60CUmapPBOYpTq8
Message-ID: <CAKb7UvjeW_vKQn_WjCawD7HDe7BKMYdH_HauFxFvUySkj1yvew@mail.gmail.com>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Lan Tianyu <tianyu.lan@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 11:57 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
> Hi
>
> On Saturday 15 March 2014, Lan Tianyu wrote:
>> On 03/14/2014 10:17 PM, Stefan Lippers-Hollmann wrote:
>> > Hi
>> >
>> > On Saturday 15 March 2014, Rafael J. Wysocki wrote:
>> >> On Friday, March 14, 2014 06:14:12 PM Ilia Mirkin wrote:
>> >>> On Fri, Mar 14, 2014 at 6:11 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> >>>> On Fri 2014-03-14 17:29:41, Ilia Mirkin wrote:
>> >>>>> On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
> [...]
>> Hi Stefan:
>>       I just glance wmbattery code. I find the code in the acpi.c is already
>> using the new sysfs battery interfaces, right?
>
> By default, wmbattery appears to default to using upower as abstraction
> level, instead of querying sysfs itself directly.
>
> http://git.kitenet.net/?p=wmbattery.git;a=blob;f=autoconf/makeinfo.in;hb=HEAD
>
> which sets USE_UPOWER=1 by default.
>
> If USE_UPOWER=0 is set explicitly for the build, it reverts back to
> direct sysfs parsing - and yes, it does appear to adhere to the current
> sysfs API properly.
>
> The last remains, and the ability to parse procfs (which hasn't been
> default for quite some time already, in favour of using hal as
> abstraction layer) has finally been removed in
>
> http://git.kitenet.net/?p=wmbattery.git;a=commitdiff;h=833eb63a5ce4f2fb712a201b1db4f2db1700fddb
>
> The switch from procfs parsing to hal (by default at least) in turn
> happened with
>
> http://git.kitenet.net/?p=wmbattery.git;a=commitdiff;h=63c3d1a0b11e8ade1a5612bb5baa3d92e153bbbe
>
> in 2008 (before Debian squeeze/ oldstable). I have not investigated if
> hal then read from procfs or sysfs, but wmbattery at least didn't read
> from procfs itself, unless explicitly told to do so (USE_HAL=0) during
> the build since mid 2008.
>
> The current version of wmbattery however will never try to access
> /proc/acpi, the current version no longer knows of its existence.
>
> [Again, I'm not familiar with wmbattery myself and have never run it]

Stefan,

Thanks for looking into this. The newest wmbattery version indeed
supports upower. However, I haven't figured out how to get it to work.
That's obviously not the kernel's fault, but an unfortunate reality.
It seems to really want dbus to be running, but when I start dbus
(which nothing else on my system needs, apparently), it just hangs. My
knowledge of these things is, (un)fortunately non-existent, so I just
gave up on the upower approach. Running something as heavy as dbus
just for a silly dock app seems... silly as well.

Doing a build with USE_UPOWER=0 does indeed seem to work a little bit,
in that it notices AC plug/unplug events, but the actual battery info
isn't updated properly. Could be a wmbattery bug for all I know (quite
likely, in fact). Older versions used to work just fine. I never had
HAL enabled, so I think it used procfs. I'm guessing that they removed
the proc code in response to it being removed from the kernel... and I
guess the sysfs-handling code atrophied over time, or perhaps never
worked? With the version that's marked as 'stable' in gentoo, 2.40, it
still very much tries to access /proc/acpi:

open("/dev/apm_bios", O_WRONLY)         = -1 ENOENT (No such file or directory)
access("/proc/apm", R_OK)               = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/acpi", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 4
open("/sys/module/acpi/parameters/acpica_version", O_RDONLY) = 4
openat(AT_FDCWD, "/proc/acpi/battery",
O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file
or directory)
openat(AT_FDCWD, "/proc/acpi/ac_adapter",
O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file
or directory)
open("/dev/sonypi", O_RDWR)             = -1 ENOENT (No such file or directory)
Error: No APM, ACPI, HAL or SPIC support detected.

Other programs I've tried:

wmacpi-2.2-rc1:
open("/sys/module/acpi/parameters/acpica_version", O_RDONLY) = 3
openat(AT_FDCWD, "/proc/acpi/battery",
O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file
or directory)
No batteries or ACPI not supported

wmpower-0.4.3:
Welcome to wmpower version 0.4.3...
open("/proc/version", O_RDONLY)         = 3
open("/proc/omnibook/dmi", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/proc/i8k", O_RDONLY)             = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/proc/acpi/toshiba",
O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = -1 ENOENT (No such file
or directory)
open("/dev/toshiba", O_RDWR)            = -1 ENOENT (No such file or directory)
CPU frequency scaling NOT available
access("/proc/acpi/info", R_OK)         = -1 ENOENT (No such file or directory)
access("/proc/apm", R_OK)               = -1 ENOENT (No such file or directory)
No power management subsystem detected
No power management support...

Now, I'm in no position to say whether it's reasonable to keep the
/proc/acpi interface around, but the current situation is that what's
out there doesn't quite seem to know how to deal with /sys/.

Cheers,

  -ilia
