Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747Ab3GaStT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:49:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46435 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab3GaStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1307311043360.1546-100000@iolanthe.rowland.org>
References: <CAODwPW8ZRpVPWKp0Eda4GDhNHiBqcWECW7d69H_oi4UoFQL_NQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1307311043360.1546-100000@iolanthe.rowland.org>
Date: Wed, 31 Jul 2013 11:49:15 -0700
X-Google-Sender-Auth: AGTLw39k62NZByPFlTL5-ruZ62E
Message-ID: <CAODwPW-edQv19FS2zA7uEK6pnegfrjb+ikyb7EaFWnjBF+3O0Q@mail.gmail.com>
Subject: Re: [PATCH] usb: core: don't try to reset_device() a port that got
 just disconnected
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> An odd sort of bug.  You'd think that not getting a response back would
> be one of the first types of error the hardware designers would check
> for.

You'd think that, right? But apparently they didn't. I've now also
tried just hacking a pointless SET_INTERFACE message into the
hub_port_connect_change() handler on disconnect... stalls every time
with both 2.0 and 3.0 devices (and fails fast as expected on
PantherPoint). I have a feeling that this might not be the last
fix/workaround we will need for this PCH...

> Hmm, 5 seconds is the xHCI command timeout.  Could the driver be
> possibly issuing either a Reset Device or Address Device command that
> simply times out?

The timeout is USB_CTRL_SET_TIMEOUT from
usb_set_device_initiated_lpm() (ends up in usb_start_wait_urb()). I
have dumped all XHCI commands and events in my tests... there were no
commands enqueued or completed in that timeframe, and no transfer
events received for that endpoint. I've also checked the endpoint
context before and 200ms after enqueueing the transfer, and it was
still in the "Running" state. The xHC just seems to completely hang on
that transfer ring until the timeout hits and the kernel issues a Stop
Endpoint to abort the URB.

> Thanks Alan, I'll send this off to Greg shortly.

Thanks!
