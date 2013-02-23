Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3BWBok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:44:40 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:37540 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab3BWBoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:44:38 -0500
Date: Sat, 23 Feb 2013 02:44:27 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130223014427.GA1709@balto.lan>
References: <20130222085954.GA4352@redhat.com>
 <20130222222304.GA19546@redhat.com>
 <20130223001055.GA1622@balto.lan>
 <8156425.nbPzS18WCu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8156425.nbPzS18WCu@vostro.rjw.lan>
X-Operating-System: Linux balto 3.8.0-06471-g2ef14f4-dirty x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 01:35:26AM +0100, Rafael J. Wysocki wrote:
> On Saturday, February 23, 2013 01:10:55 AM Fabio Baltieri wrote:
> > Well, this did the trick in my case:
> > 
> > --- >8 ---
> > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > index b820528..54175a0 100644
> > --- a/drivers/acpi/power.c
> > +++ b/drivers/acpi/power.c
> > @@ -795,7 +795,7 @@ int acpi_add_power_resource(acpi_handle handle)
> >         int state, result = -ENODEV;
> >  
> >         acpi_bus_get_device(handle, &device);
> > -       if (device)
> > +       if (!device)
> >                 return 0;
> >  
> >         resource = kzalloc(sizeof(*resource), GFP_KERNEL);
> > --- >8 ---
> > 
> > But I guess it's working as a coincidence and something else is wrong -
> > I'll not even try to make a patch out of it and will leave the dirty
> > work to the ACPI guys instead.
> 
> Well, this patch effectively disables the handling of power resources on your
> machine entirely.  The effect of which is probably that the power resources
> can't be turned off for the USB controllers, so they don't go into D3cold.

Ok, as I wrote, I suspected this was just shutting off something and not
solving the real problem.

So, I'll try to recap all the threads here:

> And the bisection found a commit that restores the handling of power resources
> for you, which is not entirely surprising, but the root cause is somewhere else
> most likely.

Indeed.

> The new sysfs interface for power resources control may be helpful here.  You
> need to use the Linus' current for it to work, though.
> 
> Can you please do
> 
> $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> and send the output?

With the acpi_add_power_resource disabled all power_state read "D0",
other attributes are not generated.

With a plain kernel that's the output:

$ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/LNXVIDEO:01/power_state
D0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_state
D0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_state
D0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_state
D0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/power_state
D0

$ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/real_power_state
D3cold
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/real_power_state
D3cold
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/real_power_state
D3cold

$ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D0
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D1
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D2
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D0
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D1
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D2
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D0
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D1
LNXPOWER:00
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D2
LNXPOWER:00

$ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/PNP0C09:00/LNXPOWER:00/resource_in_use
0

> Can you please check if the problem is still there in the master
> branch of the linux-pm.git tree alone?

Not sure if this was for me or Dave, anyway linux-pm.git master
currently points as:

10baf04 Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux

and the problem is still there.

> May I see the bisection log, BTW?

Sure, here it is:

git bisect start
# bad: [8793422fd9ac5037f5047f80473007301df3689f] Merge tag 'pm+acpi-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad 8793422fd9ac5037f5047f80473007301df3689f
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
git bisect good 19f949f52599ba7c3f67a5897ac6be14bfcb1200
# good: [8909ff652ddfc83ecdf450f96629c25489d88f77] Merge tag 'regulator-3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good 8909ff652ddfc83ecdf450f96629c25489d88f77
# good: [3aad3f03b2b6d2d977b985c49274cdb78a1593e5] Merge tag 'spi-for-linus' of git://git.secretlab.ca/git/linux
git bisect good 3aad3f03b2b6d2d977b985c49274cdb78a1593e5
# bad: [e8f71df723339b6d3861886f58c245812d1994f8] Merge branch 'acpi-cleanup'
git bisect bad e8f71df723339b6d3861886f58c245812d1994f8
# bad: [701190fd7419f6757c19cdc6473830c79debb3ae] clk: x86: add support for Lynxpoint LPSS clocks
git bisect bad 701190fd7419f6757c19cdc6473830c79debb3ae
# good: [3e5621a750e2cfb26748c34acbb67c691845494a] ACPICA: Update ACPICA initialization messages.
git bisect good 3e5621a750e2cfb26748c34acbb67c691845494a
# bad: [115c9ad854bd4c0f58ebcb967ec1b0a1c4e4b2d3] ACPI: remove unused acpi_op_bind and acpi_op_unbind
git bisect bad 115c9ad854bd4c0f58ebcb967ec1b0a1c4e4b2d3
# good: [e3863094c6f9b2f980d6e7a5cad6b4d03a4dd579] ACPI: Drop the second argument of acpi_bus_scan()
git bisect good e3863094c6f9b2f980d6e7a5cad6b4d03a4dd579
# good: [38a9a67a281eeebcd7cccf87f0e371f58ae625e3] ACPI / PCI: Move the _PRT setup and cleanup code to pci-acpi.c
git bisect good 38a9a67a281eeebcd7cccf87f0e371f58ae625e3
# good: [e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e] ACPI: Remove unused struct acpi_pci_root.id member
git bisect good e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e
# bad: [abe99210e0f624cea39f1dc375ba818b201c0d7f] ACPI / scan: Fix check of device_attach() return value.
git bisect bad abe99210e0f624cea39f1dc375ba818b201c0d7f
# bad: [f95988de06ea62ef5bd861f06e9ef56cea405ed1] ACPI / scan: Treat power resources in a special way
git bisect bad f95988de06ea62ef5bd861f06e9ef56cea405ed1

> Can you please send a dmesg boot log and the output of acpidump from the
> affected machine?

dmesg:
http://paste.ubuntu.com/5556864/

acpidump:
http://paste.ubuntu.com/5556867/

Thanks,
Fabio

-- 
Fabio Baltieri
