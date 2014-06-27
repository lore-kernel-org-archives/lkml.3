Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaF0VT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:19:58 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44242 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaF0VTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <53AC6152.5060908@wwwdotorg.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-7-git-send-email-abrestic@chromium.org>
	<53AB4F2D.2060208@wwwdotorg.org>
	<CAL1qeaFhfYdW06Md10eGVYWBrRR+f1yykVYHNp5+9-t1C9joPQ@mail.gmail.com>
	<53AC6152.5060908@wwwdotorg.org>
Date: Fri, 27 Jun 2014 14:19:54 -0700
X-Google-Sender-Auth: vZv9EjVoHlBxNdWv_xV12_F3lgk
Message-ID: <CAL1qeaEb2aV16F+sXWZ=FtEFW2rcGHhqVJk7+OmU5AtjZiHBDQ@mail.gmail.com>
Subject: Re: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-usb@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 11:07 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/25/2014 06:06 PM, Andrew Bresticker wrote:
>> On Wed, Jun 25, 2014 at 3:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>>>> Add support for the on-chip XHCI host controller present on Tegra SoCs.
>>>>
>>>> The driver is currently very basic: it loads the controller with its
>>>> firmware, starts the controller, and is able to service messages sent
>>>> by the controller's firmware.  The hardware supports device mode as
>>>> well as runtime power-gating, but support for these is not yet
>>>> implemented here.

>>>> diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c

>>>> +static int tegra_xhci_set_ss_clk(struct tegra_xhci_hcd *tegra,
>>>> +                              unsigned long rate)
>>>
>>>> +     switch (rate) {
>>>> +     case TEGRA_XHCI_SS_CLK_HIGH_SPEED:
>>>> +             /* Reparent to PLLU_480M. Set div first to avoid overclocking */
>>>> +             old_parent_rate = clk_get_rate(clk_get_parent(clk));
>>>> +             new_parent_rate = clk_get_rate(tegra->pll_u_480m);
>>>> +             div = new_parent_rate / rate;
>>>> +             ret = clk_set_rate(clk, old_parent_rate / div);
>>>> +             if (ret)
>>>> +                     return ret;
>>>> +             ret = clk_set_parent(clk, tegra->pll_u_480m);
>>>> +             if (ret)
>>>> +                     return ret;
>>>
>>> Don't you need to call clk_set_rate() again after reparenting, since the
>>> divisor will be different, and the rounding too.
>>
>> Nope, the divider we set before remains in-tact after clk_set_parent().
>
> Oh I see, the clk_set_rate() call is setting up div so it's appropriate
> after the new parent is selected.
>
> Wouldn't it be better to just stop the clock, assert reset, reparent the
> clock, and then set the desired rate directly?

I'm not sure how that would be better than making it more obvious as
to how we arrive at the final rate.  Keep in mind that the XHCI host
is running at this point (we usually get the scale-up message as a
USB3 device is being enumerated) and that disabling the clock and/or
asserting reset to the SS partition clock may not be the best idea...
