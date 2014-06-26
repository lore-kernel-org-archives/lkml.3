Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbaFZSJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:09:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51046 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbaFZSJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:09:02 -0400
Message-ID: <53AC61B9.5030408@wwwdotorg.org>
Date: Thu, 26 Jun 2014 12:08:57 -0600
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
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        balbi@ti.com
Subject: Re: [PATCH v1 4/9] pinctrl: tegra-xusb: Add USB PHY support
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>	<1403072180-4944-5-git-send-email-abrestic@chromium.org>	<53AB493F.3030802@wwwdotorg.org> <CAL1qeaHhoqEPu-j+drNiRMyeutz=qqZPxSP8H+v-sgjZSfS5tQ@mail.gmail.com>
In-Reply-To: <CAL1qeaHhoqEPu-j+drNiRMyeutz=qqZPxSP8H+v-sgjZSfS5tQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 05:30 PM, Andrew Bresticker wrote:
> On Wed, Jun 25, 2014 at 3:12 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>>> In addition to the PCIe and SATA PHYs, the XUSB pad controller also
>>> supports 3 UTMI, 2 HSIC, and 2 USB3 PHYs.  Each USB3 PHY uses a single
>>> PCIe or SATA lane and is mapped to one of the three UTMI ports.
>>>
>>
>>> diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c
>>
>>> @@ -372,6 +720,193 @@ static int tegra_xusb_padctl_pinconf_group_set(struct pinctrl_dev *pinctrl,
>>>                       padctl_writel(padctl, regval, lane->offset);
>>>                       break;
>>>
>>> +             case TEGRA_XUSB_PADCTL_USB3_PORT_NUM:
>>> +                     if (value >= TEGRA_XUSB_PADCTL_USB3_PORTS) {
>>> +                             dev_err(padctl->dev, "Invalid USB3 port: %lu\n",
>>> +                                     value);
>>> +                             return -EINVAL;
>>> +                     }
>>> +                     if (!is_pcie_sata_lane(group)) {
>>> +                             dev_err(padctl->dev,
>>> +                                     "USB3 port not applicable for pin %d\n",
>>> +                                     group);
>>> +                             return -EINVAL;
>>> +                     }
>>> +                     padctl->usb3_ports[value].lane = group;
>>> +                     break;
>>
>> It feels odd to use pinctrl for a SW-only purpose. In other words, that
>> chunk of code isn't writing the pinconf data to HW, but rather some
>> internal variable.
> 
> Well the mapping of lanes to USB3 ports is a hardware property and we
> do use it when programming the hardware later to choose which set of
> lane registers to program given a USB3 port, but it's true that it's
> not some value we program into HW directly.
> 
>> Perhaps it would make more sense for the DT binding to represent this
>> data directly in a custom property that's parsed at probe() time. That
>> way, pinctrl only touches "real" HW stuff.
> 
> I'm on the fence about this.  If you or others feel strongly about
> this then I can make it a separate DT property and move it out of the
> pinctrl properties.

I'd certainly prefer to use pinctrl bindings only for things that get
directly written into HW. Other configuration data should be easy to
retrieve directly from properties.
