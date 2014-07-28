Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaG1OUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:20:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39427 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaG1OUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:20:09 -0400
Message-ID: <53D65C16.2050202@arm.com>
Date: Mon, 28 Jul 2014 15:20:06 +0100
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Graeme Gregory <graeme.gregory@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <5014834.k6eecMddPC@wuerfel> <53D616AD.2090501@linaro.org> <5959830.lpqeqL7HbK@wuerfel>
In-Reply-To: <5959830.lpqeqL7HbK@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/14 11:46, Arnd Bergmann wrote:
> On Monday 28 July 2014 10:23:57 Graeme Gregory wrote:
>> The PL011 UART is the use-case I keep hitting, that IP block has a 
>> variable input clock on pretty much everything I have seen in the wild. 
> 
> Ok, I see. What does ACPI-5.1 say about pl011?
> 
> Interestingly, the subset of pl011 that is specified by SBSA does not
> contain the IBRD/FBRD registers, effectively making it a fixed-rated
> UART (I guess that would be a ART, without the U then), and you
> consequently don't even need to know the clock rate.

The idea of this was probably to let the baudrate set by some firmware
code to the "right" value and the spec just didn't want to expose the
details for the generic UART:
"This specification does not cover registers needed to configure the
UART as these are considered hardware-specific and will be set up by
hardware-specific software."
To me that reads like the SBSA UART is just for debugging, and you are
expected just to access the data register.

> However, my guess is that most hardware in the real world contains
> an actual pl011 and it does make a lot of sense to allow setting
> the baud rate on it, which then requires knowing the input clock.
> 
> If there is any hardware that implements just the SBSA-mandated subset
> rather than the full pl011, we should probably implement both
> in the kernel: a dumb driver that can only send and receive, and the
> more complex one that can set the bit rates and flow-control but that
> requires a standardized ACPI table with the input clock rate.

The fast model I use can be switched to use the SBSA restricted PL011,
and as expected the Linux kernel crashes at the device doesn't support
DMA (and a lot more stuff) - but the current code requires it.
So I am about to implement a new driver for that SBSA subset. So far
this will be a separate driver, starting from a copy of amba-pl011.c,
but removing most of the code ;-)

> Whether the two would belong into one file or two separate driver
> modules is something I can't tell, it would be up to the serial
> maintainers to decide.

Sharing support for both devices in the same file doesn't seem to make
too much sense to me so far (but I may amend this later).
Will post a version as soon as I have it finished.

Cheers,
Andre.
