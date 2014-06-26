Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaFZUAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:00:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41532 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaFZUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:00:20 -0400
Message-ID: <53AC7BCE.4030604@wwwdotorg.org>
Date: Thu, 26 Jun 2014 14:00:14 -0600
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
Subject: Re: [PATCH v1 3/9] of: Update Tegra XUSB pad controller binding for
 USB
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>	<1403072180-4944-4-git-send-email-abrestic@chromium.org>	<53AB432A.7010400@wwwdotorg.org> <CAL1qeaEnOEgdNp8F1YyUAeco6WVY0XffpiEDsPGdcCQL62sw3Q@mail.gmail.com>
In-Reply-To: <CAL1qeaEnOEgdNp8F1YyUAeco6WVY0XffpiEDsPGdcCQL62sw3Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 04:25 PM, Andrew Bresticker wrote:
> Thanks for the review Stephen!
> 
> On Wed, Jun 25, 2014 at 2:46 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
>>> Add new bindings used for USB support by the Tegra XUSB pad controller.
>>> This includes additional PHY types, USB-specific pinconfig properties, etc.
>>
>>> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
>>
>>> @@ -21,6 +21,12 @@ Required properties:
>>>    - padctl
>>>  - #phy-cells: Should be 1. The specifier is the index of the PHY to reference.
>>>    See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list of valid values.
>>> +- nvidia,xusb-mbox: Handle to the Tegra XUSB mailbox node.
>>
>> Why does the padctrl code need access to the XUSB mailbox?
> 
> The XUSB firmware sends messages which make requests of the PHY (XUSB
> pad controller), such as idling/un-idling the HSIC PHYs or saving USB3
> PHY context.
> 
>> Isn't the padctrl HW module something that provides services to the XUSB
>> code. I would have expected the XUSB node to reference the padctrl node.
> 
> The XUSB padctrl HW does provide services to the XUSB host in the form
> of PHYs and it is through the PHY bindings that the host references
> the padctrl node.
> 
>> If notifications need to be sent back from XUSB padctrl to XUSB, then that
>> seems like an internal SW detail that doesn't need to be represented in DT.
> 
> I think you mean notifications need to be sent back from the XUSB host
> to the XUSB padctrl?  This is what the mailbox is for and I chose to
> have the padctrl refer to the mailbox since messages are sent from the
> mailbox which make requests to the PHY specifically and not the host
> (see above).

I've looked at the details of the mailbox messages a bit more now. It
seems that the firmware running on the XUSB controller sends a variety
of different messages, some of which are relevant to the XHCI controller
driver and some relevant to the PHY/PAD driver. It's a pity these
different message streams are intermixed, but I guess that's not changing.

As such, I think at this stage it does make sense for the mailbox to be
represented as a separate node, with each of the XHCI controller and USB
PADCTL nodes referring to the mailbox node by phandle.

I'm still not 100% sure about whether the PHY driver is the same level
of abstraction intended by the Linux kernel's PHY layer. Pending that
discussion's results, the "PHY" message from the firmware may not go to
a Linux kernel PHY but some layer above which might get subsumed into
the overall XHCI controller driver, which would change my argument above
a bit.
