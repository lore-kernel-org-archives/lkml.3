Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaKRCBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:01:48 -0500
Received: from [140.232.255.14] ([140.232.255.14]:53468 "EHLO mail.abrij.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbaKRCBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:01:46 -0500
Date: Mon, 17 Nov 2014 21:01:44 -0500
From: bri <bri@abrij.org>
To: Antonio Ospite <ao2@ao2.it>
Cc: Frank Praznik <frank.praznik@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 001/001] hid-sony.c: add sysfs provisioning
Message-ID: <20141118020144.GB32256@abrij.org>
References: <20141116181846.GA31516@abrij.org>
 <20141117133518.ee306b3b35a0e0566a255b14@ao2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117133518.ee306b3b35a0e0566a255b14@ao2.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 01:35:18PM +0100, Antonio Ospite wrote:
> I had tried doing something similar in the past (the parsing was just a
> sscanf): http://thread.gmane.org/gmane.linux.bluez.kernel/5261 but then
> we deliberately decided against exposing specific sysfs interfaces for
> device/master_bdaddr, you can just use generic HID feature reports from
> userspace to get/set these, write a simple program reusing the code in
> the BlueZ sixaxis plugin, using the ioclts
> HIDIOCGFEATURE/HIDIOCSFEATURE, this way you don't depend on libusb. As
> an historical note, the BlueZ sixaxis plugin was one of the first user
> of these ioctls.

...

> That said I still don't think the changes you are proposing are strictly
> necessary in the kernel driver, but let's see what the others have to
> say about that.

On Mon, Nov 17, 2014 at 02:39:35PM -0500, Frank Praznik wrote:
> Agreed, I don't see a need for exposing this as a sysfs entry since it's
> easy enough to use hidraw and an ioctl call to set/get the master address.

For this argument I would offer that "easy" is different for you or I
working on a development system than for a less versed person working
to personally customize an appliance that didn't come with a gcc package,
but probably did come with /bin/sh.

(That it is no longer necessary to detach the kernel driver and go
through another enumeration cycle as it was with libusb is a definite
improvement.)

Frank, still:
> What happened when plugging in a DS3 or DS4 via USB when it was already
> connected via Bluetooth was that you ended up with a duplicate device.  In
> the case of the DS3 the extra controller entry was basically a
> non-functional "zombie" since the controller itself didn't send any events
> over USB if it was already running over Bluetooth.  If you want to switch
> from wireless to wired you just have to disconnect first.  I don't think
> it's possible to get around this, at least not in a way that is as seamless
> as the current solution.

Is that a limitation of the device, in your assessment, or a shortcoming
of the driver code/hid-core?  I know the PS3 can at least sleep the
dualshocks while they are on BT, so could a disconnect not be sent by bluez
upon sensing the USB connection?  At that point the problem boils down to
descriptor churn, which is entirely an artifact of the driver model, and
maybe it is time to challenge that model a tiny bit.

>From an end-user perspective, with USB "disconnecting" is something as
easy and self-explanatory as pulling a wire.  With bluetooth not so much,
so your average console user is going to be without a UI-less recourse
if they want to go back to wired operation hastily during play, unless
we make connecting USB a surrogate for disconnecting BT.

> Just one code comment to add to what Antonio already said:
>
> >
> >+
> >+    ret = device_create_file(&hdev->dev, &dev_attr_master_bdaddr);
> >+    if (ret) {
> >+            hid_err(hdev, "failed to create master_bdaddr sysfs file\n");
> >+            goto err_nosysfs1;

> >     }

> Why even expose this on the DS4 or the Sixaxis when in Bluetooth mode?  Put
> it behind if (sc->quirks & SIXAXIS_CONTROLLER_USB)

I figured it would be easier for shell scripts if the fd always exists.  Also
if you had multiple bluetooth hosts and were using it to figure out which
one a controller was currently attached to you would not have to do anything
additional.  But, as Antonio points out:

On Mon, Nov 17, 2014 at 01:35:18PM +0100, Antonio Ospite wrote:
> > +#include <net/bluetooth/bluetooth.h>
> > +#include <net/bluetooth/hci_core.h>
> 
> A HID driver should not need to depend on bluetooth, no other HID
> driver does. Layer violations should be avoided as much as possible.

...so yeah that was probably a bad idea, though it does make me wonder
if there is a proper way for a device hid driver to query properties
of its host.

Continuing on with Antonio's comments:
> I'd also try to avoid custom parsing routines in kernel code as much as
> possible.

Sorry, I work as a network administrator and lose a minimum of 10 minutes
of productivity a day massaging pasted MAC addresses between different
formats, and that adds up over time.  So, I just could not bring myself
to become part of that problem.

> You know you can build Debian packages from the official git kernel
> repository, don't you?
>       make LOCALVERSION=-brian INSTALL_MOD_STRIP=1 deb-pkg

I had in fact missed that development, thank you.

> > On the other hand this is not the behavior gamers expect and will not
> > help matters if the reason for plugging the pad in was to decrease
> > latency due to RF contention.
>
> This is an interesting point, can you show numbers about these latency
> problems?

Personally, no, not being a gadgeteer, I don't own enough RF devices to
test that.  Also I'm an old caffeine-damaged fogey who doesn't have the
steady hand to play twitch games anymore so I cannot say I have experienced
it personally.

In lieu of that I can offer that a google search of "ps4 controller wired"
shows evidence that a lack of wired fallback functionality earns brickbats
from the gamer community.  I'd also point out that SteamOS is certainly going
to find itself in tournament and LAN-party situations where many systems
are crammed in close quarters.

