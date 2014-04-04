Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaDDJ6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:58:41 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37176 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaDDJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:58:38 -0400
Message-ID: <533E8242.8080203@gmail.com>
Date: Fri, 04 Apr 2014 11:58:26 +0200
From: Richard Genoud <richard.genoud@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Endless loop on hub port power down
References: <1396536536-26423-1-git-send-email-richard.genoud@gmail.com> <20140404080453.GA1448@redhat.com>
In-Reply-To: <20140404080453.GA1448@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 10:04, Stanislaw Gruszka wrote:
> On Thu, Apr 03, 2014 at 04:48:56PM +0200, Richard Genoud wrote:
>> I've met an endless (or at least very long) loop if I power down the usb
>> port on witch a usb wifi key is plugged.
>> (Ok, it's not very smart to power down a usb port when a usb key is in
>> used... but still, I think that should not lead to an endless loop).
>>
>> I have a lot of:
>> ieee80211 phy1: rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x0438 with error -71
>>
>> (-71==-EPROTO)
>>
>> How to reproduce:
>> - plug an usb wifi key
>> - ip link set wlan0 up
>> - hub-ctrl -b usb_bus -d usb_device -P usb_port -p 0
>>
>> hub-ctrl source: https://github.com/codazoda/hub-ctrl.c/blob/master/hub-ctrl.c
>>
>> The following patch prevents the endless loop, but I'm really not sure
>> that The Right Way To Do It (R)
> 
> If device disappear, we should get -ENODEV status, why we get -EPROTO ?

I trace it down, and the EPROTO status comes from ctx.status (returned from usb_start_wait_urb() in drivers/usb/core/message.c)
And, in my case, the ctx.status is set to EPROTO in qtd_copy_status() ( drivers/usb/host/ehci-q.c )
in the code:
} else if (token & QTD_STS_XACT) {
	/* timeout, bad CRC, wrong PID, etc */
	ehci_dbg(ehci, "devpath %s ep%d%s 3strikes\n",
		urb->dev->devpath,
		usb_pipeendpoint(urb->pipe),
		usb_pipein(urb->pipe) ? "in" : "out");
	status = -EPROTO;

enabling this log, I get:
atmel-ehci 700000.ehci: devpath 2.1 ep1in 3strikes
atmel-ehci 700000.ehci: devpath 2.1 ep0in 3strikes
atmel-ehci 700000.ehci: devpath 2.1 ep1in 3strikes
atmel-ehci 700000.ehci: devpath 2.1 ep0in 3strikes
ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71

