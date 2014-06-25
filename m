Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbaFYWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:25:58 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:42610 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaFYWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <53AB432A.7010400@wwwdotorg.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
	<1403072180-4944-4-git-send-email-abrestic@chromium.org>
	<53AB432A.7010400@wwwdotorg.org>
Date: Wed, 25 Jun 2014 15:25:54 -0700
X-Google-Sender-Auth: O_X59Y9nSk6XMUFOu2YuahOrv0o
Message-ID: <CAL1qeaEnOEgdNp8F1YyUAeco6WVY0XffpiEDsPGdcCQL62sw3Q@mail.gmail.com>
Subject: Re: [PATCH v1 3/9] of: Update Tegra XUSB pad controller binding for USB
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

Thanks for the review Stephen!

On Wed, Jun 25, 2014 at 2:46 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>> Add new bindings used for USB support by the Tegra XUSB pad controller.
>> This includes additional PHY types, USB-specific pinconfig properties, etc.
>
>> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
>
>> @@ -21,6 +21,12 @@ Required properties:
>>    - padctl
>>  - #phy-cells: Should be 1. The specifier is the index of the PHY to reference.
>>    See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list of valid values.
>> +- nvidia,xusb-mbox: Handle to the Tegra XUSB mailbox node.
>
> Why does the padctrl code need access to the XUSB mailbox?

The XUSB firmware sends messages which make requests of the PHY (XUSB
pad controller), such as idling/un-idling the HSIC PHYs or saving USB3
PHY context.

> Isn't the padctrl HW module something that provides services to the XUSB
> code. I would have expected the XUSB node to reference the padctrl node.

The XUSB padctrl HW does provide services to the XUSB host in the form
of PHYs and it is through the PHY bindings that the host references
the padctrl node.

> If notifications need to be sent back from XUSB padctrl to XUSB, then that
> seems like an internal SW detail that doesn't need to be represented in DT.

I think you mean notifications need to be sent back from the XUSB host
to the XUSB padctrl?  This is what the mailbox is for and I chose to
have the padctrl refer to the mailbox since messages are sent from the
mailbox which make requests to the PHY specifically and not the host
(see above).

>> +Optional properties:
>> +-------------------
>> +- vbus-otg-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
>
> Isn't VBUS something that's controlled by the USB PHY? I think the PHYs
> are part of the XUSB controller, whereas the XUSB pad control is just
> the low level IO pad HW.

In the next patch in the series I extend the XUSB padctrl driver to
provide USB PHY support as it already does for SATA and PCIe.  Since
XUSB padctrl is also the PHY provider, I put the USB PHY properties
here.

>> +- nvidia,usb3-port-num: USB3 port (0 or 1) to which the lane is mapped.
>> +- nvidia,usb2-port-num: USB2 port (0, 1, or 2) to which the lane is mapped.
>> +- nvidia,hsic-strobe-trim: HSIC strobe trimmer value.
>> +- nvidia,hsic-rx-strobe-trim: HSIC RX strobe trimmer value.
>> +- nvidia,hsic-rx-data-trim: HSIC RX data trimmer value.
>> +- nvidia,hsic-tx-rtune-n: HSIC TX RTUNEN value.
>> +- nvidia,hsic-tx-rtune-p: HSIC TX RTUNEP value.
>> +- nvidia,hsic-tx-slew-n: HSIC TX SLEWN value.
>> +- nvidia,hsic-tx-slew-p: HSIC TX SLEWP value.
>> +- nvidia,hsic-auto-term: Enables HSIC AUTO_TERM. (0: no, 1: yes)
>
> I wonder if some of that isn't part of the PHY not the pads?

See above.
