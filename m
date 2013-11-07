Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3KGHw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:52:56 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:51739 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KGHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:52:48 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
References: <20131029145139.GA2788@hercules>
	<alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
Date: Thu, 7 Nov 2013 15:52:47 +0800
X-Google-Sender-Auth: yUTXN6re8c45IZdr30ncI18tSLE
Message-ID: <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer dereference
From: James Henstridge <james.henstridge@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        =?ISO-8859-1?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:38 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 29 Oct 2013, Luis Henriques wrote:
>
>> James has reported a NULL pointer dereference[1] on the appleir
>> driver.  From the bug report[2] it looks like it is 100%
>> reproducible using a 3.12-rc6 kernel simply by pressing any button on
>> the IR remote.
>>
>> >From the stack trace, it looks like input_event is invoked with the
>> input_dev parameter set to NULL, which seems to indicate that
>> appleir_input_configured is never invoked.
>>
>> Any ideas?
>>
>> [1] https://launchpadlibrarian.net/154942024/macmini-oops.jpg
>> [2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1244505
>
> [ adding some more CCs ]
>
> Okay, so apparently we didn't register with input, but only hiddev /
> hidraw.
>
> appleir 0003:05AC:8240.0005: hiddev0,hidraw4: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
>
> Therefore ->input_configured() callback has never been called, and thus we
> oops due to appleir->input_dev being NULL when the first raw event is
> reported.
>
> Could you please provide report descriptor of the device?
>
> The driver apparently relies on it being registered with hid-input, but
> for some reason that doesn't happen.

Here is the relevant lsusb output that I think contains what you're
asking for (I had to unbind usbhid for it to include the descriptor):

Bus 005 Device 003: ID 05ac:8240 Apple, Inc. Built-in IR Receiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x05ac Apple, Inc.
  idProduct          0x8240 Built-in IR Receiver
  bcdDevice            1.10
  iManufacturer           1 Apple Computer, Inc.
  iProduct                2 IR Receiver
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      41
          Report Descriptor: (length is 41)
            Item(Global): Usage Page, data= [ 0x00 0xff ] 65280
                            (null)
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff 0x00 ] 255
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Global): Report ID, data= [ 0x24 ] 36
            Item(Local ): Usage, data= [ 0x00 ] 0
                            (null)
            Item(Main  ): Input, data= [ 0x22 ] 34
                            Data Variable Absolute No_Wrap Linear
                            No_Preferred_State No_Null_Position
Non_Volatile Bitfield
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Global): Report ID, data= [ 0x25 ] 37
            Item(Local ): Usage, data= [ 0x00 ] 0
                            (null)
            Item(Main  ): Input, data= [ 0x22 ] 34
                            Data Variable Absolute No_Wrap Linear
                            No_Preferred_State No_Null_Position
Non_Volatile Bitfield
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x04 ] 4
            Item(Global): Report ID, data= [ 0x26 ] 38
            Item(Local ): Usage, data= [ 0x00 ] 0
                            (null)
            Item(Main  ): Input, data= [ 0x22 ] 34
                            Data Variable Absolute No_Wrap Linear
                            No_Preferred_State No_Null_Position
Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)


James.
