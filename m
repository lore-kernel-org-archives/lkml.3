Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab3BWALK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:11:10 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:57192 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab3BWALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:11:07 -0500
Date: Sat, 23 Feb 2013 01:10:55 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Dave Jones <davej@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Message-ID: <20130223001055.GA1622@balto.lan>
References: <20130222085954.GA4352@redhat.com>
 <20130222215158.GA4723@balto.lan>
 <20130222222304.GA19546@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222222304.GA19546@redhat.com>
X-Operating-System: Linux balto 3.8.0-06471-g2ef14f4-dirty x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 05:23:04PM -0500, Dave Jones wrote:
> On Fri, Feb 22, 2013 at 10:51:58PM +0100, Fabio Baltieri wrote:
>  > On Fri, Feb 22, 2013 at 03:59:54AM -0500, Dave Jones wrote:
>  > > On Thu, Feb 21, 2013 at 10:40:10AM -0800, Greg KH wrote:
>  > > 
>  > > It looks like every port on my laptop is powered down, as I can't
>  > > even charge devices with it.
>  > 
>  > I have the same problem (and almost the same laptop, Thinkpad T430
>  > here), all external USB ports without power - even the always-on one
>  > :-).
>  > 
>  > The bug seems to be ACPI related, I bisected it down to this patch:
>  > 
>  > f95988d ACPI / scan: Treat power resources in a special way
>  > 
>  > In the dmesg I have some error like these:
>  > 
>  > ACPI: Power Resource [PUBS] (on)
>  > ...
>  > pci 0000:00:14.0: System wakeup disabled by ACPI
>  > 
>  > for the USB controllers in the broken kernel, there are some in your
>  > dmesg too.  I'll try to come up with a fix for current mainline, but all
>  > the acpi stuff is quite obscure to me and the patch does not revert
>  > cleanly, maybe Rafael (in CC) has some idea!
> 
> Good find. I see the same thing.
> 
> [    0.930283] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.933527] pci 0000:00:14.0: System wakeup disabled by ACPI
> [    0.935982] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.937898] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.939835] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.940700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> [    0.942195] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
> [    0.943737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
> [    0.944564] pci 0000:00:1c.2: System wakeup disabled by ACPI
> [    0.966491] pci 0000:00:1d.0: System wakeup disabled by ACPI
> 
> I must have pulled in the acpi bits the same time as the usb pull,
> because I don't recall seeing this problem before last night.

Definitely.

Well, this did the trick in my case:

--- >8 ---
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index b820528..54175a0 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -795,7 +795,7 @@ int acpi_add_power_resource(acpi_handle handle)
        int state, result = -ENODEV;
 
        acpi_bus_get_device(handle, &device);
-       if (device)
+       if (!device)
                return 0;
 
        resource = kzalloc(sizeof(*resource), GFP_KERNEL);
--- >8 ---

But I guess it's working as a coincidence and something else is wrong -
I'll not even try to make a patch out of it and will leave the dirty
work to the ACPI guys instead.

Fabio

-- 
Fabio Baltieri
