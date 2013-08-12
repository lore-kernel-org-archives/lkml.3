Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab3HLSI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:08:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33241 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3HLSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:08:22 -0400
Message-ID: <52092491.7060605@wwwdotorg.org>
Date: Mon, 12 Aug 2013 12:08:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@kernel.org" <devicetree@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
References: <20130811190826.GH6427@sirena.org.uk> <Pine.LNX.4.44L0.1308112146410.29546-100000@netrider.rowland.org> <20130812095136.GJ6427@sirena.org.uk> <20130812110714.GA6616@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130812110714.GA6616@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 05:07 AM, Mark Rutland wrote:
> [Adding Olof]
> 
> On Mon, Aug 12, 2013 at 10:51:36AM +0100, Mark Brown wrote:
>> On Sun, Aug 11, 2013 at 09:53:01PM -0400, Alan Stern wrote:
>>> On Sun, 11 Aug 2013, Mark Brown wrote:
>>
>>>> One example that's bugging me right now is that on the Insignal Arndale
>>>> platform there's a USB hub connected to one of the USB ports on the SoC
>>>> (not as a PHY, it seems we also need the internal PHY running to talk to
>>>> the device).  The hub needs to be "plugged" into the SoC after the SoC
>>>> USB controller has started with some GPIOs so we need to tell the system
>>>> that the hub exists and needs to be synchronised with the USB controller.
...
> As I understand it, the wifi chip on the Snow Chromebook has a similar
> issue -- it hangs off of a probeable SDIO bus, but needs a regulator
> poked for it to turn on and become probeable (see
> exynos_wifi_bt_set_power in [1]).

In this case, I wonder if it makes sense to model the extra requirements
as part of the bus/socket/... itself rather than as part of the device
that's attached to the bus.

It seems quite common for SDIO-based WiFi devices to need a few things:
* Regulator
* 32KHz clock
* Enable GPIO (-> rfkill?)
* Perhaps a reset GPIO

Physically, these are provided to the socket into which the WiFi device
plugs in. Perhaps we should try to explicitly model the socket (which I
guess is really the SDIO bus in a way) rather than attaching these new
resources to the controller or the device itself.

In a similar way, I wonder if the USB case can be considered the same
way? This seems less like a good fit since I don't expect the resources
are always so similar there, and also there's the case of the bus being
potentially behind a few levels of USB hub.

And of course it all gets a little more messy when you get
board-specific logic that needs setup, rather than something more common
across multiple devices.
