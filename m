Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3BJAOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:14:45 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45989 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab3BJAOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:14:43 -0500
Date: Sun, 10 Feb 2013 01:14:42 +0100
From: Andreas Mohr <andi@lisas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: [REGRESSION] -rc7/-rc4+: unable to USB boot - enumeration partially
 broken (was: Linux v3.8-rc7)
Message-ID: <20130210001442.GA5744@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hate having to report a suspected regression this late in the cycle
again (last time it turned out to be a false alarm due to .config issue,
ouch)...

In the previous life of this Aspire One machine
(prior to a grave reboot sync issue corrupting my system unrecoverably,
i.e. only 3 hours reinstall for *full* config, minor loss fortunately)
I had a working 3.7.0 kernel.

After the reinstall I tried to get a current -rc (-rc4+) working.
To my surprise initramfs USB boot failed, completely.
(the tell-tale sign that it likely is a regression was that the same 3.7.0
kernel that had been working previously, built via make oldconfig of
the **-rc** .config and with identical commands as -rc - using make install -
was then again found to be booting fine!)

The initramfs symptoms were that (in initramfs rescue shell) /dev/disk/by-uuid/
failed to contain the entry for my USB boot SSD.

Turned out that cat /sys/bus/usb/devices/*/product failed to list
several of my devices. What's worse, hotplug of any additional devices
(USB stick, USBHID gamepad) ought to have managed to successfully show up,
due to the udev setup of my initrd.

On a successful boot (to desktop), I have:
# lsusb -tv
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
    |__ Port 2: Dev 2, If 0, Class='bInterfaceClass 0xe0 not yet
handled', Driver=btusb, 12M
    |__ Port 2: Dev 2, If 1, Class='bInterfaceClass 0xe0 not yet
handled', Driver=btusb, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M
    |__ Port 2: Dev 2, If 0, Class=stor., Driver=usb-storage, 480M
    |__ Port 5: Dev 4, If 0, Class='bInterfaceClass 0x0e not yet
handled', Driver=uvcvideo, 480M
    |__ Port 5: Dev 4, If 1, Class='bInterfaceClass 0x0e not yet
handled', Driver=uvcvideo, 480M

# lsusb
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 152d:0601 JMicron Technology Corp. / JMicron USA
Technology Corp. 
Bus 001 Device 004: ID 064e:d101 Suyin Corp. Acer CrystalEye Webcam
Bus 003 Device 002: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth
Dongle (HCI mode)


Removing "quiet" boot parm and adding "debug", I noticed that a working
kernel (default 3.2.0 package) properly discovered all USB devices,
thus was able to continue with root filesystem activation.
Newer -rc (tested 3.8-rc4+, 3.8-rc7) got stuck on the line of discovery of the
BT2.0 device ID, with both JMicron and Suyin camera not getting discovered.

However, this observed behaviour should perhaps more correctly be interpreted
as enumeration *ending* at Bus 003 rather than the kernel getting stuck
there, and thus *only* Bus 001 simply *not* having gotten enumerated
(perhaps due to newly introduced BIOS handoff issues of the
*active BIOS boot device* at this bus???).

OTOH only some of my external ports are Bus 001 (some are 003),
thus if only Bus 001 was unavailable, devices should have shown up
when plugging into 003. I think I did try all ports, but unsure,
will have to retest shortly (this is important to distinguish Port 001
suspected handoff issue vs. all-busses-stuck issue).

I've even gone to the pain of using scripts/diffconfig, without fruitful
results (hrmm, now I remember that I did change CONFIG_CONNECTOR from m
to y - there's a tiny chance that this might have fixed it, but then
the faxt that it discovered *one* device - BT2.0 - should of course then
have successfully followed through with discovering all others, too).

So, did anyone observe similar behaviour in USB enumeration (known issues?),
or any hints/ideas about changes to blame [USB handoff?],
or anything that's missing here?

I might choose to go the bisection route :(

Experiencing too many grave issues even with recent kernels somehow
(which obviously leads me to rather liking the more recent
strictly-fixes-only policy).

Thanks,

Andreas Mohr
