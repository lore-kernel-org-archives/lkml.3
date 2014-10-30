Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbaJ3R0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:26:52 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61549 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760772AbaJ3R0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <20141030172432.GA8944@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-6-git-send-email-abrestic@chromium.org>
	<20141029094338.GA28356@ulmo.nvidia.com>
	<CAL1qeaEf0mTQfMgnY8jHGDBvbQ7ivtzAQRWaE9K24TJ86hWYMg@mail.gmail.com>
	<20141030135500.GC19802@ulmo.nvidia.com>
	<CAL1qeaG701hKtcUL5a67b=X38hbcYunUOUBziZMpxemvhhAayA@mail.gmail.com>
	<20141030172432.GA8944@ulmo.nvidia.com>
Date: Thu, 30 Oct 2014 10:26:47 -0700
X-Google-Sender-Auth: 69cqk-nPc8if1N7cuHtrd80HApc
Message-ID: <CAL1qeaEbRkOQApyjkpwxBd3mGkQ3JuXNiar1MbBd844NWe5h9g@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 5/9] of: Add NVIDIA Tegra xHCI controller binding
From: Andrew Bresticker <abrestic@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:24 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Thu, Oct 30, 2014 at 10:19:21AM -0700, Andrew Bresticker wrote:
>> On Thu, Oct 30, 2014 at 6:55 AM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > On Wed, Oct 29, 2014 at 09:37:14AM -0700, Andrew Bresticker wrote:
>> >> On Wed, Oct 29, 2014 at 2:43 AM, Thierry Reding
>> >> <thierry.reding@gmail.com> wrote:
>> >> > On Tue, Oct 28, 2014 at 03:27:50PM -0700, Andrew Bresticker wrote:
>> >> > [...]
>> >> >> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt
>> >> > [...]
>> >> >> +Optional properties:
>> >> >> +-------------------
>> >> >> +- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
>> >> >> +- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
>> >> >> +- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the corresponding USB3
>> >> >> +  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the list
>> >> >> +  of valid values.
>> >> >
>> >> > I dislike how we now need to provide a list of all pins in the header
>> >> > file, where previously we used strings for this. This could become very
>> >> > ugly if the set of pins changes in future generations of this IP block.
>> >> >
>> >> > Could we instead derive this from the pinmux nodes? For example you have
>> >> > this in the example below:
>> >> >
>> >> >         usb3p0 {
>> >> >                 nvidia,lanes = "pcie-0";
>> >> >                 ...
>> >> >         };
>> >> >
>> >> > Perhaps what we need is to either key off the node name or add another
>> >> > property, such as:
>> >> >
>> >> >         nvidia,usb3-port = <0>;
>> >> >
>> >> > This would match the nvidia,usb2-port property that you've added below.
>> >>
>> >> That is actually how I described the USB3 port to SS lane mapping
>> >> originally, but in review of an earlier version of this series,
>> >> Stephen suggested that I make it a separate, not pinconfig property
>> >> since it wasn't a value written directly to the hardware.  I'm fine
>> >> with changing it back as the pinconfig property makes more sense to me
>> >> as well.
>> >
>> > Hmm... I had considered it a mux option of the specific lane. If the
>> > function is usb3, it'd still need to be muxed to one of the ports. So
>> > it's additional information associated with the usb3 function.
>> >
>> > I did look through the driver changes and can't really make out which
>> > part of the code actually performs this assignment. Can you point me to
>> > it?
>>
>> There's not really an assignment.  The property is used to map between
>> a lane (e.g. PCIe-0 or SATA) and the USB3.0 port it's mapped to.  For
>> an example of where it's used, take a look at usb3_phy_power_on().
>> There are certain per-lane registers which need to be programmed in
>> addition to the per-USB3.0 port pad registers.  This mapping is used
>> to determine which lane needs to be programmed.
>
> Are you saying the mapping of lane to USB port is fixed? That is, PCIe-0
> lane is always used for USB port X and SATA always for USB port Y?

No, sorry if that was unclear, it's not fixed - it's a board specific property.
