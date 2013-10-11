Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3JKGHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:07:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38785 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3JKGHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:07:35 -0400
Message-ID: <52579592.1020209@ti.com>
Date: Fri, 11 Oct 2013 11:37:14 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arokux X <arokux@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: When USB PHY framework should be used?
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
In-Reply-To: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 October 2013 12:51 AM, Arokux X wrote:
> Hi,
> 
> recently I have been working on mainlining a simple bus glue driver
> for the USB EHCI for the Allwinner family of the ARM SoCs aka sunxi.
> The patches are almost ready and can be found at [1] and will be
> submitted once completely ready. The most interesting patch is [2]
> which is a driver itself.
> 
> Currently everything works. Recently Maxime Ripard brought the reset
> framework to my attention which I am going to use, since each of the
> PHYs has a reset bit. Right now those bits are treated as clocks.
> 
> Later I am going to add the OHCI support. OHCI and EHCI will be
> different drivers in different modules but they will share the same
> PHY. I do not quite understand how can I correctly use reset framework
> in the case of the common PHY. Imagine a situation if EHCI and OHCI
> drivers got loaded and deassert the (same) reset bit. Then a user
> decides to rmmod one of the drivers. This will cause it to assert the
> reset bit, which will make the other driver to fail. So it is clear
> there is a need for some central manager for the reset bit which is
> going to be poked by both EHCI and OHCI.

Looks like the reset should be done in a wrapper driver. Do you have a wrapper
driver for EHCI/OHCI?
> 
> Maxime Ripard also brought to my attention the new USB phy framework
> which was merged into usb-next. However I'm not sure it should be used
> in my driver since as far as I understand a PHY of a USB Host
> Controller I'm dealing with is built into the controller itself. The
> only parts of the driver that touche a PHY are reset bits (different
> for each controller) and some initialization bits [3]. In addition the
> in the doc file phy.txt I read
> 
> "This framework will be of use only to devices that use external PHY
> (PHY functionality is not embedded within the controller)."

right. PHY framework is used when you have a separate IP for PHY. Generally in
cases where you have the PHY built in the controller, you can handle the PHY
programming in your controller driver itself.
> 
> So can you please give me some hints about the possibilities to share
> single reset bit? Should I use PHY framework, or create some kind of a
> common module that is going to be used by EHCI and OHCI. In addition I

I think you should have a wrapper driver to EHCI/OHCI to handle this reset.

Thanks
Kishon

> wanted to ask where I should normally put a common code like [4].
> 
> Thank you in advance,
> Arokux
> 
> 
> 
> 
> [1] https://github.com/arokux/linux/commits/sunxi-next-usb
> [2] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be
> [3] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be#diff-2fdea331a4331eca7c86f18cd2d87e72R89
> [4] https://github.com/arokux/linux/commit/1f271d01b8138d5a593df18a80b4129a08eac1be#diff-2fdea331a4331eca7c86f18cd2d87e72R104
> 

