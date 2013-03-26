Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759895Ab3CZTE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:04:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48894 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754160Ab3CZTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:04:57 -0400
Date: Tue, 26 Mar 2013 15:04:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-kernel@vger.kernel.org, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [RFC PATCH 1/5] USB: drop depends on USB and enclose everything
 into an if USB block
In-Reply-To: <1364321177-12146-2-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1303261456400.999-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Florian Fainelli wrote:

> This patch removes the depends on USB from all config symbols in
> drivers/usb/host/Kconfig and replace that with an if USB / endif block
> as suggested by Alan Stern.

I'm afraid this patch is filled with errors.

For one thing, it doesn't appreciate the difference between host-side
USB and device-side USB.  CONFIG_USB describes support for the
host-side part of the stack, whereas CONFIG_USB_GADGET describes
support for the device-side (or gadget-side) part.  This means you must
not make things like drivers/usb/gadget/Kconfig dependent on 
CONFIG_USB.

For another, the patch doesn't understand the difference between && and 
||.  As an example, putting chipidea/Kconfig inside "if USB" and then 
doing this:

> --- a/drivers/usb/chipidea/Kconfig
> +++ b/drivers/usb/chipidea/Kconfig
> @@ -1,6 +1,6 @@
>  config USB_CHIPIDEA
>  	tristate "ChipIdea Highspeed Dual Role Controller"
> -	depends on USB || USB_GADGET
> +	depends on USB_GADGET
>  	help
>  	  Say Y here if your system has a dual role high speed USB
>  	  controller based on ChipIdea silicon IP. Currently, only the

effectively changes the || to an &&.  This is not what we want.

You need to be a lot more careful about the distinction between hosts
and gadgets.  The situation becomes even more complicated when you
realize that some of the code applies to Dual-Role Devices, which can
be either hosts or gadgets (this includes OTG).  In addition, there are
a few things (such as gadget/dummy_hcd.c) which require _both_
host-side and device-side support.

Alan Stern

