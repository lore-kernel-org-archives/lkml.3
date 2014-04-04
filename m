Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaDDPjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:39:22 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:51087 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaDDPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140404141319.GB2147@redhat.com>
References: <1396536536-26423-1-git-send-email-richard.genoud@gmail.com>
 <20140404080453.GA1448@redhat.com> <533E8242.8080203@gmail.com> <20140404141319.GB2147@redhat.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 4 Apr 2014 17:38:58 +0200
Message-ID: <CACQ1gAgMNM89mM_m_=G85-DAD1xSoo0j6E8vWTZ2cYhg48zNsA@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Endless loop on hub port power down
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-04 16:13 GMT+02:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Fri, Apr 04, 2014 at 11:58:26AM +0200, Richard Genoud wrote:
>> On 04/04/2014 10:04, Stanislaw Gruszka wrote:
>> > On Thu, Apr 03, 2014 at 04:48:56PM +0200, Richard Genoud wrote:
>> >> I've met an endless (or at least very long) loop if I power down the usb
>> >> port on witch a usb wifi key is plugged.
>> >> (Ok, it's not very smart to power down a usb port when a usb key is in
>> >> used... but still, I think that should not lead to an endless loop).
>> >>
>> >> I have a lot of:
>> >> ieee80211 phy1: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71
>> >>
>> >> (-71==-EPROTO)
>> >>
>> >> How to reproduce:
>> >> - plug an usb wifi key
>> >> - ip link set wlan0 up
>> >> - hub-ctrl -b usb_bus -d usb_device -P usb_port -p 0
>> >>
>> >> hub-ctrl source: https://github.com/codazoda/hub-ctrl.c/blob/master/hub-ctrl.c
>> >>
>> >> The following patch prevents the endless loop, but I'm really not sure
>> >> that The Right Way To Do It (R)
>> >
>> > If device disappear, we should get -ENODEV status, why we get -EPROTO ?
>>
>> I trace it down, and the EPROTO status comes from ctx.status (returned from usb_start_wait_urb() in drivers/usb/core/message.c)
>> And, in my case, the ctx.status is set to EPROTO in qtd_copy_status() ( drivers/usb/host/ehci-q.c )
>> in the code:
>> } else if (token & QTD_STS_XACT) {
>>       /* timeout, bad CRC, wrong PID, etc */
>>       ehci_dbg(ehci, "devpath %s ep%d%s 3strikes\n",
>>               urb->dev->devpath,
>>               usb_pipeendpoint(urb->pipe),
>>               usb_pipein(urb->pipe) ? "in" : "out");
>>       status = -EPROTO;
>>
>> enabling this log, I get:
>> atmel-ehci 700000.ehci: devpath 2.1 ep1in 3strikes
>> atmel-ehci 700000.ehci: devpath 2.1 ep0in 3strikes
>> atmel-ehci 700000.ehci: devpath 2.1 ep1in 3strikes
>> atmel-ehci 700000.ehci: devpath 2.1 ep0in 3strikes
>> ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
>
> Thanks, ehci driver behaviour seems to be fine. Could you check if updating
> rt2800 firmware (I assume you have some RT2800 usb dongle) change the situation,
> i.e. we stop getting -EPROTO errors. To install new firmware, you can download
> rt2870.bin blob from:
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-January/005610.html
> and need to replace /lib/firmware/rt2870.bin file.
>
> Stanislaw
It's the same behaviour:

dmesg | grep firm
[   13.648437] ieee80211 phy0: rt2x00lib_request_firmware: Info -
Loading firmware file 'rt2870.bin'
[   13.656250] ieee80211 phy0: rt2x00lib_request_firmware: Info -
Firmware detected - version: 0.33
# disable_usb_port 1
# [   31.398437] ieee80211 phy0: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x1700 with error -71
[   31.804687] ieee80211 phy0: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x0438 with error -71
[   32.226562] ieee80211 phy0: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x0438 with error -71
[   32.640625] ieee80211 phy0: rt2x00usb_vendor_request: Error -
Vendor Request 0x06 failed for offset 0x0408 with error -71
[   33.062500] ieee80211 phy0: rt2x00usb_vendor_request: Error -
Vendor Request 0x06 failed for offset 0x0408 with error -71
[   33.617187] ieee80211 phy0: rt2x00usb_vendor_request: Error -
Vendor Request 0x07 failed for offset 0x1700 with error -71
