Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3ATM02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:26:28 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64414 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3ATM00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:26:26 -0500
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Woody Suwalski <terraluna977@gmail.com>
Subject: Re: 3.7.3, ttyUSB0 serial problem - devices stop working and only reboot helps (Inappropriate ioctl for device)
Date: Sun, 20 Jan 2013 13:26:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.3; KDE/4.9.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        Alan Cox <alan@linux.intel.com>,
        Preston Fick <preston.fick@silabs.com>
References: <201301182328.43455.a.miskiewicz@gmail.com> <50FB544B.6090308@gmail.com> <201301201004.02599.a.miskiewicz@gmail.com>
In-Reply-To: <201301201004.02599.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301201326.20814.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 of January 2013, Arkadiusz Miskiewicz wrote:
> On Sunday 20 of January 2013, Woody Suwalski wrote:
> > Arkadiusz Miskiewicz wrote:
> > > On Saturday 19 of January 2013, Arkadiusz Miskiewicz wrote:
> > >> On Saturday 19 of January 2013, Greg Kroah-Hartman wrote:
> > >>> On Fri, Jan 18, 2013 at 11:28:43PM +0100, Arkadiusz Miskiewicz wrote:
> > >>>> Hi.
> > >>>> 
> > >>>> Using 3.7.3 kernel and connecting two rs232 usb adapters, CP2102 and
> > >>>> FT232RL, one after disconnecting another.
> > >>>> 
> > >>>> After few cycles of reconnecting and using socat (below) I'm getting
> > >>>> problems accessing ttyUSB0:
> > >>>> ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
> > >>>> TCGETS, 0x7fffb70c6ae0) = -1 ENOTTY (Inappropriate ioctl for device)
> > >>>> 
> > >>>> Unloading and reloading (by udev) modules ftdio_sio, cp210x,
> > >>>> usbserial doesn't help. I have to reboot to get ttyUSB0 working
> > >>>> (regardless of which driver, ftdio_sio or cp210x is handling
> > >>>> ttyUSB0 - both stop working).
> > >>>> 
> > >>>> Any clues?
> > >>> 
> > >>> The kernel log shows the device getting removed a bunch and then
> > >>> coming back, which implies electrical issues (flaky connection, low
> > >>> power, etc.)  Are you really removing it and plugging it back in? 
> > >>> Or is it doing it all by itself?
> > >> 
> > >> I was doing plug in CP2102, remove it, plug in FT232RL after few
> > >> seconds, remove it, plug in CP... (and various variations, several
> > >> times) and testing with socat before removing devices. After some
> > >> iteration the problem appears and only reboot helps.
> > > 
> > > The issue is really weird. Machine is Thinkpad T400 2764CTO (latest
> > > bios). When the problem happened on 3.7.3 today I rebooted into 3.8rc4
> > > and ... freshly after reboot and plugging in PL2303 adapter the problem
> > > was already there. Didn't have to do unplug/plug cycle to make it
> > > happen.
> > > 
> > > Looks like sometimes reboot cures the problem, sometimes it doesn't.
> > > Now powered off laptop and powered it on - problem gone.
> > > 
> > > Connected PL2303, ran socat, disconnected PL2303 (while socat was
> > > running) -> problem happened again. Looks like it doesn't depend on
> > > adapter chip type.
> > > 
> > > So to reproduce here:
> > > - boot fresh 3.8rc4
> > > - plug in some adapter (PL2303 for example)
> > > - run "socat -ddd -s -u
> > > /dev/ttyUSB0,raw,echo=0,b115200,crnl,noctty,nonblock -
> > > 
> > > | logger" - it should run fine, without any error
> > > 
> > > - disconnect adapter; socat should exit with error "W cannot restore
> > > terminal settings on fd 3: Input/output error"
> > > - plug in adapter again
> > > - run socat again -> this time error "E tcgetattr(3, 0x7fff21411780):
> > > Inappropriate ioctl for device" immediately always; regardless which
> > > adapter is used and if kernel module drivers for these adapters were
> > > reloaded
> > > 
> > > dmesg:
> > > http://pastebin.com/r1Q5mmgt
> > > 
> > > config:
> > > http://pastebin.com/8dpFFzuU
> > > 
> > > lspci:
> > > http://pastebin.com/TBtUg1tW
> > > 
> > > lsusb:
> > > http://pastebin.com/SueVw9CD
> > > 
> > > [   53.776047] usb 4-1: new full-speed USB device number 2 using
> > > uhci_hcd [   53.938053] usb 4-1: New USB device found, idVendor=067b,
> > > idProduct=2303 [   53.938060] usb 4-1: New USB device strings: Mfr=1,
> > > Product=2, SerialNumber=0
> > > [   53.938065] usb 4-1: Product: USB-Serial Controller
> > > [   53.938068] usb 4-1: Manufacturer: Prolific Technology Inc.
> > > [   53.949924] usbcore: registered new interface driver usbserial
> > > [   53.950364] usbcore: registered new interface driver
> > > usbserial_generic [   53.951147] usbserial: USB Serial support
> > > registered for generic [   53.954268] usbcore: registered new
> > > interface driver pl2303 [   53.955009] usbserial: USB Serial support
> > > registered for pl2303 [   53.955039] pl2303 4-1:1.0: pl2303 converter
> > > detected
> > > [   53.967394] usb 4-1: pl2303 converter now attached to ttyUSB0
> > > [   64.492122] usb 4-1: USB disconnect, device number 2
> > > [   64.501748] pl2303 ttyUSB0: pl2303 converter now disconnected from
> > > ttyUSB0 [   64.502343] pl2303 4-1:1.0: device disconnected
> > > [   66.494930] usb 4-1: new full-speed USB device number 3 using
> > > uhci_hcd [   66.654247] usb 4-1: New USB device found, idVendor=067b,
> > > idProduct=2303 [   66.654261] usb 4-1: New USB device strings: Mfr=1,
> > > Product=2, SerialNumber=0
> > > [   66.654269] usb 4-1: Product: USB-Serial Controller
> > > [   66.654276] usb 4-1: Manufacturer: Prolific Technology Inc.
> > > [   66.659661] pl2303 4-1:1.0: pl2303 converter detected
> > > [   66.671587] usb 4-1: pl2303 converter now attached to ttyUSB0
> > > 
> > > 5722  munmap(0x7f1bfc0d7000, 4096)      = 0
> > > 5722  write(2, "2013/01/19 09:36:38 socat[5722] E tcgetattr(3,
> > > 0x7fffeff64020): Inappropriate ioctl for device\n", 95) = 95
> > > 5722  ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
> > > TCGETS, 0x7fffeff63e50) = -1 ENOTTY (Inappropriate ioctl for device)
> > > 5722  write(2, "2013/01/19 09:36:38 socat[5722] E tcgetattr(3,
> > > 0x7fffeff63f90): Inappropriate ioctl for device\n", 95) = 95
> > > 5722  ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
> > > TCGETS, 0x7fffeff63ec0) = -1 ENOTTY (Inappropriate ioctl for device)
> > > 5722  write(2, "2013/01/19 09:36:38 socat[5722] E tcgetattr(3,
> > > 0x7fffeff64160): Inappropriate ioctl for device\n", 95) = 95
> > > 5722  fcntl(3, F_SETFD, FD_CLOEXEC)     = 0
> > > 5722  ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
> > > TCGETS, 0x7fffeff64330) = -1 ENOTTY (Inappropriate ioctl for device)
> > > 5722  select(4, [3], [1], [], NULL)     = 2 (in [3], out [1])
> > 
> > If I unplug the USB device while tty session is running, I will get on
> > next plugin a new devnode ttyUSB1. It seems that you are trying to reuse
> > an old "dead" connection? Could it be rather a udev problem?
> 
> After plugging back in kernel says ttyUSB0 in dmesg ("usb 4-1: pl2303
> converter now attached to ttyUSB0"), not ttyUSB1, so it's not udev problem.
> 
> Also socat exits with error after unplugging (""W cannot restore
> terminal settings on fd 3: Input/output error"") releasing ttyUSB0, so next
> plug in should still use ttyUSB0.
> 
> Tried to reproduce the same problem on my PC and failed. On Thinkpad T400
> I'm reproducing without any problem.

Was able to reproduce on different machine, Asus E35M1-I DELUXE based PC, 3.7.3 kernel,
required few socat + disconnect + replug iterations.

Here it even reads some data all the time "sssATZATZ". ATZ came from minicom,
sss from my keyboard pressing but no clue where it got buffered now. Minicom is turned off,
not pressing "s" anymore, yet I can read that all the time using socat like this:

[root@serarm ~]# socat -ddd -s -u /dev/ttyUSB2,raw,echo=0,b115200,crnl,noctty,nonblock - 
2013/01/20 13:19:10 socat[20565] E tcgetattr(3, 0x7fffca638660): Inappropriate ioctl for device
2013/01/20 13:19:10 socat[20565] E tcgetattr(3, 0x7fffca6385d0): Inappropriate ioctl for device
2013/01/20 13:19:10 socat[20565] E tcgetattr(3, 0x7fffca6387a0): Inappropriate ioctl for device
sssATZATZ#                                                                                                                                                   [root@serarm ~]# socat -ddd -s -u 
/dev/ttyUSB2,raw,echo=0,b115200,crnl,noctty,nonblock - 
2013/01/20 13:19:10 socat[20569] E tcgetattr(3, 0x7fffadc7cd20): Inappropriate ioctl for device
2013/01/20 13:19:10 socat[20569] E tcgetattr(3, 0x7fffadc7cc90): Inappropriate ioctl for device
2013/01/20 13:19:10 socat[20569] E tcgetattr(3, 0x7fffadc7ce60): Inappropriate ioctl for device
sssATZATZ#                                                                                                                                                   [root@serarm ~]# socat -ddd -s -u 
/dev/ttyUSB2,raw,echo=0,b115200,crnl,noctty,nonblock - 
2013/01/20 13:19:11 socat[20570] E tcgetattr(3, 0x7ffffafe2fd0): Inappropriate ioctl for device
2013/01/20 13:19:11 socat[20570] E tcgetattr(3, 0x7ffffafe2f40): Inappropriate ioctl for device
2013/01/20 13:19:11 socat[20570] E tcgetattr(3, 0x7ffffafe3110): Inappropriate ioctl for device
sssATZATZ#     

dmesg:
[606931.578062] usb 4-4: new full-speed USB device number 51 using ohci_hcd
[606931.735206] usb 4-4: New USB device found, idVendor=067b, idProduct=2303
[606931.735223] usb 4-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[606931.735233] usb 4-4: Product: USB-Serial Controller
[606931.735241] usb 4-4: Manufacturer: Prolific Technology Inc.
[606931.738598] pl2303 4-4:1.0: pl2303 converter detected
[606931.759588] usb 4-4: pl2303 converter now attached to ttyUSB2

strace:
http://pastebin.com/wWq7EFkJ

(had 3 adapters in that E35MI system)


Tried to reproduce on third machine (Asus F2J notebook) but wasn't that lucky.

-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
