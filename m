Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaDDOOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaDDOOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:14:38 -0400
Date: Fri, 4 Apr 2014 16:13:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Endless loop on hub port power down
Message-ID: <20140404141319.GB2147@redhat.com>
References: <1396536536-26423-1-git-send-email-richard.genoud@gmail.com>
 <20140404080453.GA1448@redhat.com>
 <533E8242.8080203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533E8242.8080203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 11:58:26AM +0200, Richard Genoud wrote:
> On 04/04/2014 10:04, Stanislaw Gruszka wrote:
> > On Thu, Apr 03, 2014 at 04:48:56PM +0200, Richard Genoud wrote:
> >> I've met an endless (or at least very long) loop if I power down the usb
> >> port on witch a usb wifi key is plugged.
> >> (Ok, it's not very smart to power down a usb port when a usb key is in
> >> used... but still, I think that should not lead to an endless loop).
> >>
> >> I have a lot of:
> >> ieee80211 phy1: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71
> >>
> >> (-71==-EPROTO)
> >>
> >> How to reproduce:
> >> - plug an usb wifi key
> >> - ip link set wlan0 up
> >> - hub-ctrl -b usb_bus -d usb_device -P usb_port -p 0
> >>
> >> hub-ctrl source: https://github.com/codazoda/hub-ctrl.c/blob/master/hub-ctrl.c
> >>
> >> The following patch prevents the endless loop, but I'm really not sure
> >> that The Right Way To Do It (R)
> > 
> > If device disappear, we should get -ENODEV status, why we get -EPROTO ?
> 
> I trace it down, and the EPROTO status comes from ctx.status (returned from usb_start_wait_urb() in drivers/usb/core/message.c)
> And, in my case, the ctx.status is set to EPROTO in qtd_copy_status() ( drivers/usb/host/ehci-q.c )
> in the code:
> } else if (token & QTD_STS_XACT) {
> 	/* timeout, bad CRC, wrong PID, etc */
> 	ehci_dbg(ehci, "devpath %s ep%d%s 3strikes\n",
> 		urb->dev->devpath,
> 		usb_pipeendpoint(urb->pipe),
> 		usb_pipein(urb->pipe) ? "in" : "out");
> 	status = -EPROTO;
> 
> enabling this log, I get:
> atmel-ehci 700000.ehci: devpath 2.1 ep1in 3strikes
> atmel-ehci 700000.ehci: devpath 2.1 ep0in 3strikes
> atmel-ehci 700000.ehci: devpath 2.1 ep1in 3strikes
> atmel-ehci 700000.ehci: devpath 2.1 ep0in 3strikes
> ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71

Thanks, ehci driver behaviour seems to be fine. Could you check if updating
rt2800 firmware (I assume you have some RT2800 usb dongle) change the situation,
i.e. we stop getting -EPROTO errors. To install new firmware, you can download
rt2870.bin blob from:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-January/005610.html
and need to replace /lib/firmware/rt2870.bin file.

Stanislaw
