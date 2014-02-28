Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaB1Hjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:39:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40287 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaB1Hji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:39:38 -0500
Message-ID: <53103D34.8050101@ti.com>
Date: Fri, 28 Feb 2014 09:39:32 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com> <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com> <530F4A84.9070906@ti.com> <530F4CA5.6030502@ti.com> <530F5323.1020305@ti.com>
In-Reply-To: <530F5323.1020305@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 05:00 PM, Nishanth Menon wrote:
> The other option might be to blindly configure 6040 to max speed ->
> but then you do have an issue with that single register write
> operation to configure the speed?

Yes, exactly. It is unfortunate that twl6040's i2c speed is configured via i2c
write. It would have been better if we would have had pins to configure this.

> TWL6040 is by default at 100KHz, bus_speed is configured (via dts or
> otherwise) is 400KHz/3.4MHz, the register write for configuring 6040
> to max speed will occur at 400KHz/3.4MHz, which implies 6040 register
> write operation might not actually take place (as 6040 still expects
> to talk 100KHz till the mentioned register write takes place).
> 
> Ideally, the behavior you need is as follows:
> talk at 100KHz for the first register write(of configuring speed),
> followed by 400KHz/3.4 MHz for the subsequent operations on the bus
> (assuming 400KHz/3.4 is the least common denominator speed on the bus).

Yes. Or the bootloader should have been configuring the twl6040 to 3.4MHz with
a single write. When the driver comes up the i2c controller had been already
probed and it would know that the bus can be used in 3.4MHz and we would not
have issues with the speed.
Yous see: twl6030 is also on the same bus (usually). Not sure how twl6030's
i2c speed is selected but the fact that twl6040 is not alone on the bus makes
things complicated.
Also you could have more devices on the bus, wired for 3.4MHz. In that case we
would need to make sure that the first access happens with 100KHz to twl6040
to select 3.4MHz mode, switch the controller speed and allow the communication
to other chips. It is another question how the 3.4MHz clients will interpret
the 100KHz communication on the bus, I guess it is ignored by them.

> I am not sure if the i2c framework has ability to do that.

AFAIK we do not have such a thing in i2c framework. We would need client
drivers reporting what they support, notification mechanism to notify clients
on speed change and couple of other things might be needed as well. So there
are quite a number of things missing to get dynamic/adaptive i2c working where
the master configuration depends on the attached devices and not the other way
around.

I'll do some experiments with the twl6040 and i2c speeds today, but so far I
think the 400KHz change is a safe thing to do.

-- 
Péter
