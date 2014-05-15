Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaEOSOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:14:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49021 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbaEOSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:14:00 -0400
Message-ID: <537503E3.6050108@wwwdotorg.org>
Date: Thu, 15 May 2014 12:13:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: thierry.reding@gmail.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        marcel@ziswiler.com
Subject: Re: [PATCH 2/2] ARM: tegra: initial add of Colibri T30
References: <107aeb48982529858267cb85c792b35e@agner.ch>
In-Reply-To: <107aeb48982529858267cb85c792b35e@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 10:16 AM, Stefan Agner wrote:
> Am 2014-05-13 21:49, schrieb Stephen Warren:
>> On 05/13/2014 11:27 AM, stefan@agner.ch wrote:
>>> +	/* SPI1: Colibri SSP */
>>> +	spi@7000d400 {
>>> +		status = "okay";
>>> +		spi-max-frequency = <25000000>;
>>> +		can0: can@0 {
>>> +			compatible = "microchip,mcp2515";
>>> +			reg = <0>;
>>> +			clocks = <&clk16m>;
>>> +			interrupt-parent = <&gpio>;
>>> +			interrupts = <TEGRA_GPIO(S, 0) GPIO_ACTIVE_LOW>;
>>> +			spi-max-frequency = <10000000>;
>>
>> So this chip doesn't get confused by a faster clock frequency when its
>> chip-select line isn't asserted? I would have expected spi-max-frequency
>> for the bus to be the minimum value that any device on the bus would
>> tolerate.
> 
> And from the other mail:
>> I'm not convinced about this. The clock signal still reaches all the
>> chips, and hence still reaches some logic inside those chips. If the
>> setup/hold timings aren't met (for internal parts of the chip's SPI
>> state machine), then presumably all bets are off re: performance of the
>> chip, irrespective of whether the CS line happens to gate how much of
>> the chip actually does anything.
> 
> SPI is by default not a multi-master Bus, hence the slaves only have to
> listen when the CS is asserted. 

That's got nothing to do with multi-master; it's got to do with the fact
that an out-of-band /CS signal is what selects devices rather than
in-band data on the bus.

> I talked with our hardware expert, and
> he told me that he would expect that the whole input stage (input
> driver) is in reset/off logic when the CS line is not asserted. IMHO,
> this makes sense, this would also save power. At least he would expect
> that the communication state machine is resetted on CS assertion, so
> that it doesn't matter what happend before. 
> 
> Wikipedia also states something similar. 

I find it much more likely that /CS would be a synchronous input to the
SPI state machine in the HW. That way, the chip designers don't have to
worry about issues with asynchronous resets.

Anyway, both our arguments are pure conjecture. The only way to tell for
sure is for you to go read the datasheets for the individual devices and
find out if they document any requirements for the clock signal when /CS
isn't active. It'd be good if you could check that.

> But, since SPI is no real standard, devices which work differently and
> claim to communicate through SPI could exist :-)
> 
> I have had not seen issues with this device when using faster clocks for
> other devices on the same bus.

... but I suppose that since in practice you're not seeing any issues,
the DT is fine for now. It's not like this can't be changed later if we
find out there is an issue.
