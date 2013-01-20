Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3ATCTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 21:19:46 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:44932 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab3ATCTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 21:19:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0GAG6Zu08Y1OVO/2dsb2JhbABEgXuDMq5kgQiCFQEBBSMEER4GHAEQCwsDCgICBRYEBwICCQMCAQIBERYeBg0BBwKHewENAacOUIgCChmBC4h7gSaJYxmEDoEUA4hCghaKQ4EPhECFK4R2gweBQQ
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="213065368"
Message-ID: <50FB544B.6090308@gmail.com>
Date: Sat, 19 Jan 2013 21:19:55 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0 SeaMonkey/2.15
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        Alan Cox <alan@linux.intel.com>,
        Preston Fick <preston.fick@silabs.com>
Subject: Re: 3.7.3, ttyUSB0 serial problem - devices stop working and only
 reboot helps (Inappropriate ioctl for device)
References: <201301182328.43455.a.miskiewicz@gmail.com> <20130119004732.GA32311@kroah.com> <201301190918.37001.a.miskiewicz@gmail.com> <201301190948.02115.a.miskiewicz@gmail.com>
In-Reply-To: <201301190948.02115.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz wrote:
> On Saturday 19 of January 2013, Arkadiusz Miskiewicz wrote:
>> On Saturday 19 of January 2013, Greg Kroah-Hartman wrote:
>>> On Fri, Jan 18, 2013 at 11:28:43PM +0100, Arkadiusz Miskiewicz wrote:
>>>> Hi.
>>>>
>>>> Using 3.7.3 kernel and connecting two rs232 usb adapters, CP2102 and
>>>> FT232RL, one after disconnecting another.
>>>>
>>>> After few cycles of reconnecting and using socat (below) I'm getting
>>>> problems accessing ttyUSB0:
>>>> ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
>>>> TCGETS, 0x7fffb70c6ae0) = -1 ENOTTY (Inappropriate ioctl for device)
>>>>
>>>> Unloading and reloading (by udev) modules ftdio_sio, cp210x, usbserial
>>>> doesn't help. I have to reboot to get ttyUSB0 working (regardless of
>>>> which driver, ftdio_sio or cp210x is handling ttyUSB0 - both stop
>>>> working).
>>>>
>>>> Any clues?
>>> The kernel log shows the device getting removed a bunch and then coming
>>> back, which implies electrical issues (flaky connection, low power,
>>> etc.)  Are you really removing it and plugging it back in?  Or is it
>>> doing it all by itself?
>> I was doing plug in CP2102, remove it, plug in FT232RL after few seconds,
>> remove it, plug in CP... (and various variations, several times) and
>> testing with socat before removing devices. After some iteration the
>> problem appears and only reboot helps.
> The issue is really weird. Machine is Thinkpad T400 2764CTO (latest bios).
> When the problem happened on 3.7.3 today I rebooted into 3.8rc4 and ...
> freshly after reboot and plugging in PL2303 adapter the problem was already
> there. Didn't have to do unplug/plug cycle to make it happen.
>
> Looks like sometimes reboot cures the problem, sometimes it doesn't. Now
> powered off laptop and powered it on - problem gone.
>
> Connected PL2303, ran socat, disconnected PL2303 (while socat was running) ->
> problem happened again. Looks like it doesn't depend on adapter chip type.
>
> So to reproduce here:
> - boot fresh 3.8rc4
> - plug in some adapter (PL2303 for example)
> - run "socat -ddd -s -u /dev/ttyUSB0,raw,echo=0,b115200,crnl,noctty,nonblock -
> | logger" - it should run fine, without any error
> - disconnect adapter; socat should exit with error "W cannot restore terminal
> settings on fd 3: Input/output error"
> - plug in adapter again
> - run socat again -> this time error "E tcgetattr(3, 0x7fff21411780):
> Inappropriate ioctl for device" immediately always; regardless which adapter
> is used and if kernel module drivers for these adapters were reloaded
>
> dmesg:
> http://pastebin.com/r1Q5mmgt
>
> config:
> http://pastebin.com/8dpFFzuU
>
> lspci:
> http://pastebin.com/TBtUg1tW
>
> lsusb:
> http://pastebin.com/SueVw9CD
>
> [   53.776047] usb 4-1: new full-speed USB device number 2 using uhci_hcd
> [   53.938053] usb 4-1: New USB device found, idVendor=067b, idProduct=2303
> [   53.938060] usb 4-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [   53.938065] usb 4-1: Product: USB-Serial Controller
> [   53.938068] usb 4-1: Manufacturer: Prolific Technology Inc.
> [   53.949924] usbcore: registered new interface driver usbserial
> [   53.950364] usbcore: registered new interface driver usbserial_generic
> [   53.951147] usbserial: USB Serial support registered for generic
> [   53.954268] usbcore: registered new interface driver pl2303
> [   53.955009] usbserial: USB Serial support registered for pl2303
> [   53.955039] pl2303 4-1:1.0: pl2303 converter detected
> [   53.967394] usb 4-1: pl2303 converter now attached to ttyUSB0
> [   64.492122] usb 4-1: USB disconnect, device number 2
> [   64.501748] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> [   64.502343] pl2303 4-1:1.0: device disconnected
> [   66.494930] usb 4-1: new full-speed USB device number 3 using uhci_hcd
> [   66.654247] usb 4-1: New USB device found, idVendor=067b, idProduct=2303
> [   66.654261] usb 4-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [   66.654269] usb 4-1: Product: USB-Serial Controller
> [   66.654276] usb 4-1: Manufacturer: Prolific Technology Inc.
> [   66.659661] pl2303 4-1:1.0: pl2303 converter detected
> [   66.671587] usb 4-1: pl2303 converter now attached to ttyUSB0
>
> 5722  munmap(0x7f1bfc0d7000, 4096)      = 0
> 5722  write(2, "2013/01/19 09:36:38 socat[5722] E tcgetattr(3,
> 0x7fffeff64020): Inappropriate ioctl for device\n", 95) = 95
> 5722  ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS,
> 0x7fffeff63e50) = -1 ENOTTY (Inappropriate ioctl for device)
> 5722  write(2, "2013/01/19 09:36:38 socat[5722] E tcgetattr(3,
> 0x7fffeff63f90): Inappropriate ioctl for device\n", 95) = 95
> 5722  ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS,
> 0x7fffeff63ec0) = -1 ENOTTY (Inappropriate ioctl for device)
> 5722  write(2, "2013/01/19 09:36:38 socat[5722] E tcgetattr(3,
> 0x7fffeff64160): Inappropriate ioctl for device\n", 95) = 95
> 5722  fcntl(3, F_SETFD, FD_CLOEXEC)     = 0
> 5722  ioctl(1, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or TCGETS,
> 0x7fffeff64330) = -1 ENOTTY (Inappropriate ioctl for device)
> 5722  select(4, [3], [1], [], NULL)     = 2 (in [3], out [1])
>
If I unplug the USB device while tty session is running, I will get on 
next plugin a new devnode ttyUSB1. It seems that you are trying to reuse 
an old "dead" connection? Could it be rather a udev problem?

Woody

