Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaKFNtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:49:50 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:59493 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaKFNtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:49:24 -0500
From: Nix <nix@esperi.org.uk>
To: Johan Hovold <johan@kernel.org>
Cc: Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [3.16.1 BISECTED REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <20141012185845.GB2786@localhost>
	<878uklynq9.fsf@spindle.srvr.nix> <20141014083432.GB7958@localhost>
	<871tq04fiy.fsf@spindle.srvr.nix> <20141022101458.GK2113@localhost>
	<87y4s8yv38.fsf@spindle.srvr.nix> <20141024111442.GA19377@localhost>
	<87d298i3y9.fsf@spindle.srvr.nix> <20141105115643.GR31358@localhost>
	<87vbmtbrx2.fsf@spindle.srvr.nix> <20141105181454.GW31358@localhost>
Emacs: featuring the world's first municipal garbage collector!
Date: Thu, 06 Nov 2014 13:49:13 +0000
In-Reply-To: <20141105181454.GW31358@localhost> (Johan Hovold's message of
	"Wed, 5 Nov 2014 19:14:54 +0100")
Message-ID: <877fz8bfs6.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Nov 2014, Johan Hovold told this:

> On Wed, Nov 05, 2014 at 03:14:49PM +0000, Nix wrote:
>> >> >                                                      What if you
>> >> > physically disconnect and reconnect the device instead, or simply
>> >> 
>> >> That fixes it, in fact it's the only way to fix it once it's broken by
>> >> this bug.
>> >
>> > I didn't mean whether it would get the device working again, but rather
>> > whether you could kill it this way.
>> 
>> Never seen it fail after a physical disconnection.
>
> Ok.
>
> And it has to include an enumeration, since just opening and closing it
> (restarting the daemon) repeatedly seems to work?

Well, it's more accurate to say that restarting the daemon doesn't make
it fail, but won't make it start working if it's already gone nuts
either. It normally copes fine with the daemon stopping and starting,
yes (and the daemon copes fine with keys being connected and
disconnected).

>> > Yeah, it seems your device firmware has crashed. It stops responding to
>> > control requests.
>> 
>> Not surprising: I was fairly sure we were provoking a key firmware crash
>> or something like that. This is a device with no support for flow
>> control at all, after all, so I'm not terribly surprised that trying to
>> do flow control confuses it.
>
> Only weird thing is that it has been coping with those calls for a long
> time. Only the slightly changed timings seems to have triggered this
> issue.

Yeah. I get the strong impression from Daniel that the USB side of this
was done by taking something that worked on the kernel of the day,
adding the key-specific stuff to it, and making sure that it still
worked. i.e. this was not a from-spec reimplementation, it was using an
existing (old) stack. If that stack makes iffy assumptions, so will the
entropy key.

>> Look at it? Only Daniel Silverstone (Cc:ed) can do that. The only copy
>> of the firmware I have is baked into the sealed key. :)

As his email noted, no he can't :) but you do now have a link to the
thing it was based on.

> Ah, ok. I guess we need a new quirk then. There's already a quirk in the
> driver to suppress error from when trying to set the control lines.
>
> But that doesn't help this device, which happily accepts the requests
> and then dies at random times.

Yeah. Strange. (I thought it was it's 'right after', but you seem to
have disproved that. It's only 'sometime later'.)

> Could you try two more things (too make sure line control is really the
> culprit):
>
> 1. If you clear HUPCL in ekeyd so that the lines are never lowered, does
> that fix the stability issue?

Definitely not. I got a hang after the first reboot out of an afflicted
kernel, when using a HUPCLless ekeyd. Weird. (I guess they're lowered on
reboot anyway?)

> 2. Can you verify that the patch below works? Did I use the correct
> VID/PID? Could you provide "lsusb -v" output (for the capability flags)
> as well?

The VID/PID are right.

The patch seems to work. I tested against the usb testing tree directly,
since that was easier than adjusting it to apply against 3.16. Sixteen
reboots, no failures, looks to be fixed.

lsusb output:

Bus 002 Device 003: ID 20df:0001 Simtec Electronics Entropy Key [UDEKEY01]
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            2 Communications
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x20df Simtec Electronics
  idProduct          0x0001 Entropy Key [UDEKEY01]
  bcdDevice            2.00
  iManufacturer           1 Simtec Electronics
  iProduct                2 Entropy Key
  iSerial                 3 M/9tBjBLNzE2RSFD
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           67
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower               76mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0
      CDC Header:
        bcdCDC               1.10
      CDC Call Management:
        bmCapabilities       0x00
        bDataInterface          1
      CDC ACM:
        bmCapabilities       0x00
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval             255
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

> Note that the patch is against the usb-linus branch of the usb tree,

OK. (I presume this is gregkh's tree, not yours?)

> which also contains another fix which could affect this device
> (set_termios will now be called an extra time on every open). You also
> need this one, which have not yet been applied:
>
> 	http://marc.info/?l=linux-usb&m=141520959813505&w=2

It had been applied by the time I tested this :)

-- 
NULL && (void)
