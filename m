Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBJL6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:58:47 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:60718 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaBJL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:58:41 -0500
Date: Mon, 10 Feb 2014 13:00:48 +0100
From: Emil Goode <emilgoode@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] usbnet: fix bad header length bug
Message-ID: <20140210115812.GA4278@lianli>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
 <1392014458.21271.6.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392014458.21271.6.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:40:58AM +0100, Oliver Neukum wrote:
> On Mon, 2014-02-10 at 00:06 +0100, Emil Goode wrote:
> > The AX88772B occasionally send rx packets that cross urb boundaries
> > and the remaining partial packet is sent with no hardware header.
> > When the buffer with a partial packet is of less number of octets
> > than the value of hard_header_len the buffer is discarded by the
> > usbnet module. This is causing dropped packages and error messages
> > in dmesg.
> > 
> > This can be reproduced by using ping with a packet size
> > between 1965-1976.
> 
> Well, then how about simply removing the check?
> It seems to have outlived its usefulness.
> 
> 	Regards
> 		Oliver
> 
>

I did consider that and I think it is probably the best thing to do.
However, I think the removal of the check could have negative effects
on the other minidrivers, at least the qmi_wwan minidriver explicitly
states that it is depending on this check to be made in rx_complete().

For safety the check could be added at the top of the rx_fixup callback
of the affected minidrivers.

There are devices that depend on the usbnet module that do not have
a rx_fixup callback assigned to it's driver_info struct, the check
could be added for these in the rx_process function.

This led me to think it would be a lot of noise about a small check :)

My conclusion is that 12 rx_fixup callbacks might need the check
to be added. There are 18 driver_info structs with no rx_fixup
callback assigned, these devices might need the check to be added
to the rx_process function.

Patches could be sent out to notify the affected minidrivers of the
change and hopefully someone has the hardware to test if it's 
necessary to add the check to the minidriver?

I'm happy to do this if it seem like a good idea.

Best regards,

Emil Goode
