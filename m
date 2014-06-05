Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaFEQZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:25:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34534 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaFEQZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:25:18 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: linux-next crash in xhci_add_ep_to_interval
In-Reply-To: Your message of "Thu, 05 Jun 2014 08:55:07 -0700."
             <CAA9_cmfje+8qAh7NqjHi1zcRAPZgJ0xdOK2nM7TKN9NRgqcRfw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <18529.1401981749@turing-police.cc.vt.edu>
            <CAA9_cmfje+8qAh7NqjHi1zcRAPZgJ0xdOK2nM7TKN9NRgqcRfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401985468_1971P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Jun 2014 12:24:28 -0400
Message-ID: <23223.1401985468@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401985468_1971P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Jun 2014 08:55:07 -0700, Dan Williams said:

> > On a working boot, it progresses:
>
> Is a working boot after reverting that change, or it intermittently
> works?  If it's the latter I'm not sure I trust the bisect result,
> yet.

Oh, it's a 100% guaranteed crash.  The following is from a good kernel:

> > [    3.823139] usb 3-4.1: New USB device found, idVendor=0e8f, idProduct=0020
> > [    3.823160] usb 3-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> > [    3.823174] usb 3-4.1: Product: PS2toUSB Adapter
> > [    3.823187] usb 3-4.1: Manufacturer: GASIA
> > [    3.842836] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1:1.0/0003:0E8F:0020.0001/input/input14
> > [    3.848598] hid-generic 0003:0E8F:0020.0001: input,hidraw0: USB HID v1.10 Keyboard [GASIA PS2toUSB Adapter] on usb-0000:00:14.0-4.1/input0
> > [    3.863592] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1:1.1/0003:0E8F:0020.0002/input/input15
> > [    3.878608] hid-generic 0003:0E8F:0020.0002: input,hidraw1: USB HID v1.10 Mouse [GASIA PS2toUSB Adapter] on usb-0000:00:14.0-4.1/input1

I'm booted on next-20140519


> It's a really odd place to crash relative to the peer port changes
> since those do not affect any xhci internals.  At first glance this
> also does not look related to the command queue changes.  Mathias, any
> ideas?
>
> Valdis, can you get me the output of:
>
> $ gdb drivers/usb/host/xhci-hcd.ko
> (gdb) li *(xhci_add_ep_to_interval_table+0xc8)

(gdb) li *(xhci_add_ep_to_interval_table+0xc8)
0x10c9 is in xhci_add_ep_to_interval_table (drivers/usb/host/xhci.c:2446).
2441                    normalized_interval = ep_bw->ep_interval - 3;
2442
2443            if (normalized_interval == 0)
2444                    bw_table->interval0_esit_payload += ep_bw->max_esit_payload;
2445            interval_bw = &bw_table->interval_bw[normalized_interval];
2446            interval_bw->num_packets += ep_bw->num_packets;
2447            switch (udev->speed) {
2448            case USB_SPEED_LOW:
2449                    interval_bw->overhead[LS_OVERHEAD_TYPE] += 1;
2450                    break;

Note that's as of the end of the git bisect.  Looks like it picked up
a duff value for interval_bw somehow, but I have no idea why.

Yeah, you're right, the bisected commit doesn't seem to have anything
to do with it.  Weird. ;)

--==_Exmh_1401985468_1971P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU5CZvAdmEQWDXROgAQJIzw/+LoV1Rx2K26uI0HNijifVrPhDooKjNCxh
KAvb9hv3fFBAgXgwQLY8qgJ3LxqF6x+jU6A62qr4I095gqGsA6GiQPPfddGvTPqd
ETQUF1vRrYvIcHBqjoqSu8/K+WM2u8EIz6wRSQJ8TGLHGKi2pfIEn1T/7JGwOVq/
jqMBusfKp26leKbeM2Xd5jnZyFddy3nCi99hpIPttepgXEykIkjDuGYKElTu7e9a
P1W3imIJo5EgCwYOWYeRHZ0XQy+fK0t6ZnM7Z7AoSGuIY6ksHcYMZbYXen/luQLK
k4B5d6RrcCQYR+mEcNuIV8Twm0g670N1XV9i39AdkW0pBOP1wFGqB4/q2aDjfR5T
K/2mjJ0XlIZB3yznWBN3wHIo5GY6unbHBSOoscx53AXqkga2V1s+XSKQiW0ZVswD
Jo3pgAj6qY+QrKdjBdEV7zMQ474BR+vGOf/JdzIdljjmBsPd38oN6EhMIegIf5sp
ogjdJV5FbtfmaCSqt2ymj38p9SfwpumGWth3CBSrapjciRKp0m7X/3qA4sR2oDlS
KOmgSMziNQhi6aa5L5jkFNaLme7h4pZzLMGiTtBhpS2bKJMI1CZEcKcVVoXj+v9j
uXyhqVNhd2nbUXnLHtNR+V5+p/pvUqj0JB0UTl2cPi7yjwCqNY7euaNuOsY4nO8w
JssnmNL5fHs=
=rQB8
-----END PGP SIGNATURE-----

--==_Exmh_1401985468_1971P--
