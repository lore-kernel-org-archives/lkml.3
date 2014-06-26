Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbaFZSHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:07:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49075 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaFZSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:07:19 -0400
Message-ID: <53AC6152.5060908@wwwdotorg.org>
Date: Thu, 26 Jun 2014 12:07:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
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
Subject: Re: [PATCH v1 6/9] usb: xhci: Add NVIDIA Tegra XHCI host-controller
 driver
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>	<1403072180-4944-7-git-send-email-abrestic@chromium.org>	<53AB4F2D.2060208@wwwdotorg.org> <CAL1qeaFhfYdW06Md10eGVYWBrRR+f1yykVYHNp5+9-t1C9joPQ@mail.gmail.com>
In-Reply-To: <CAL1qeaFhfYdW06Md10eGVYWBrRR+f1yykVYHNp5+9-t1C9joPQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 06:06 PM, Andrew Bresticker wrote:
> On Wed, Jun 25, 2014 at 3:37 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>>> Add support for the on-chip XHCI host controller present on Tegra SoCs.
>>>
>>> The driver is currently very basic: it loads the controller with its
>>> firmware, starts the controller, and is able to service messages sent
>>> by the controller's firmware.  The hardware supports device mode as
>>> well as runtime power-gating, but support for these is not yet
>>> implemented here.

>>> diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c

>>> +static int tegra_xhci_set_ss_clk(struct tegra_xhci_hcd *tegra,
>>> +                              unsigned long rate)
>>
>>> +     switch (rate) {
>>> +     case TEGRA_XHCI_SS_CLK_HIGH_SPEED:
>>> +             /* Reparent to PLLU_480M. Set div first to avoid overclocking */
>>> +             old_parent_rate = clk_get_rate(clk_get_parent(clk));
>>> +             new_parent_rate = clk_get_rate(tegra->pll_u_480m);
>>> +             div = new_parent_rate / rate;
>>> +             ret = clk_set_rate(clk, old_parent_rate / div);
>>> +             if (ret)
>>> +                     return ret;
>>> +             ret = clk_set_parent(clk, tegra->pll_u_480m);
>>> +             if (ret)
>>> +                     return ret;
>>
>> Don't you need to call clk_set_rate() again after reparenting, since the
>> divisor will be different, and the rounding too.
> 
> Nope, the divider we set before remains in-tact after clk_set_parent().

Oh I see, the clk_set_rate() call is setting up div so it's appropriate
after the new parent is selected.

Wouldn't it be better to just stop the clock, assert reset, reparent the
clock, and then set the desired rate directly?
