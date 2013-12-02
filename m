Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3LBPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:00:08 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:45844 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3LBPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:00:05 -0500
Date: Mon, 2 Dec 2013 15:00:03 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: Michael Trimarchi <michael@amarulasolutions.com>,
        Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        tomi.valkeinen@ti.com, Felipe Balbi <balbi@ti.com>,
        Stefan Roese <sr@denx.de>, ljkenny.mailinglists@gmail.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Benoit Cousson <bcousson@baylibre.com>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
In-Reply-To: <529C5537.3080300@ti.com>
Message-ID: <alpine.DEB.2.02.1312021444530.18363@utopia.booyaka.com>
References: <1385730118-26402-1-git-send-email-rogerq@ti.com> <1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwnttvOQ26USuDK1naq1nNtVbHo4c0UAfdep64bK2wyvBA@mail.gmail.com> <529C5537.3080300@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Roger Quadros wrote:

> It won't be done by omap_hwmod as we set HWMOD_INIT_NO_RESET flag in the 
> hwmod data [1].
> 
> Question is do we do it in the driver of leave it to hwmod?

It should be done by hwmod (or more broadly, some OMAP bus code).  That 
way the device can be brought to a known state even if there's no driver 
present (e.g., if the driver was built as a module).

> The other concern about i660 is in this comment [1]
> 
> 	/*
> 	 * During system boot; If the hwmod framework resets the module
> 	 * the module will have smart idle settings; which can lead to deadlock
> 	 * (above Errata Id:i660); so, dont reset the module during boot;
> 	 * Use HWMOD_INIT_NO_RESET.
> 	 */
> 
> But if you look at the errata document [2], Advisory 1.108, it doesn't 
> say that we can't be in smart-idle, but only that we should put the 
> module in force-idle, before cutting the module's functional clock.

Yes, that looks to be correct.  There shouldn't be any problem with the 
module being in smart-idle mode if the PRCM doesn't try to put it into a 
low-power mode.  It already has the HWMOD_SWSUP_SIDLE flag set, so seems 
to me it should work fine without HWMOD_INIT_NO_RESET, if i660 is the only 
issue.

Most of the IP blocks that are marked with HWMOD_INIT_NO_RESET are only 
that way due to laziness, or lack of time, etc., and should be closely 
reviewed.


- Paul
