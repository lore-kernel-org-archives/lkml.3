Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaB1NbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:31:05 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52138 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaB1NbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:31:03 -0500
Message-ID: <53108F90.7070608@ti.com>
Date: Fri, 28 Feb 2014 07:30:56 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com> <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com> <530F4A84.9070906@ti.com> <530F4CA5.6030502@ti.com> <530F5323.1020305@ti.com> <53103D34.8050101@ti.com>
In-Reply-To: <53103D34.8050101@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 01:39 AM, Peter Ujfalusi wrote:
> On 02/27/2014 05:00 PM, Nishanth Menon wrote:
>> The other option might be to blindly configure 6040 to max speed ->
>> but then you do have an issue with that single register write
>> operation to configure the speed?
> 
> Yes, exactly. It is unfortunate that twl6040's i2c speed is configured via i2c
> write. It would have been better if we would have had pins to configure this.
> 
>> TWL6040 is by default at 100KHz, bus_speed is configured (via dts or
>> otherwise) is 400KHz/3.4MHz, the register write for configuring 6040
>> to max speed will occur at 400KHz/3.4MHz, which implies 6040 register
>> write operation might not actually take place (as 6040 still expects
>> to talk 100KHz till the mentioned register write takes place).
>>
>> Ideally, the behavior you need is as follows:
>> talk at 100KHz for the first register write(of configuring speed),
>> followed by 400KHz/3.4 MHz for the subsequent operations on the bus
>> (assuming 400KHz/3.4 is the least common denominator speed on the bus).
> 
> Yes. Or the bootloader should have been configuring the twl6040 to 3.4MHz with
> a single write. When the driver comes up the i2c controller had been already

you would not be able to do that unless you have powered on TWL6040
regulators - and the moment you power them down (example on module
removal: regulator_bulk_disable(TWL6040_NUM_SUPPLIES,
twl6040->supplies);), you are back to square 1.

> probed and it would know that the bus can be used in 3.4MHz and we would not
> have issues with the speed.
> Yous see: twl6030 is also on the same bus (usually). Not sure how twl6030's
> i2c speed is selected but the fact that twl6040 is not alone on the bus makes
> things complicated.

TWL6030 can do 3.3MHz by default and there are no speed registers to
configure.

> Also you could have more devices on the bus, wired for 3.4MHz. In that case we
> would need to make sure that the first access happens with 100KHz to twl6040
> to select 3.4MHz mode, switch the controller speed and allow the communication
> to other chips. It is another question how the 3.4MHz clients will interpret
> the 100KHz communication on the bus, I guess it is ignored by them.
As far as the i2c spec 2.1 says:
"Fast-mode devices are downward-compatible and can communicate with
Standard-mode devices in a 0 to 100 kbit/s I2C-bus system"
...
"Hs-mode devices can transfer information at bit rates of up to 3.4
Mbit/s, yet they remain fully downward compatible with Fast- or
Standard-mode (F/S-mode) devices for bi-directional communication in a
mixed-speed bus system."

So, they are backward compatible.

> 
>> I am not sure if the i2c framework has ability to do that.
> 
> AFAIK we do not have such a thing in i2c framework. We would need client
> drivers reporting what they support, notification mechanism to notify clients
> on speed change and couple of other things might be needed as well. So there
> are quite a number of things missing to get dynamic/adaptive i2c working where
> the master configuration depends on the attached devices and not the other way
> around.
> 
> I'll do some experiments with the twl6040 and i2c speeds today, but so far I
> think the 400KHz change is a safe thing to do.
> 
I dont think that is correct. The safest thing to do is to switch the
i2c bus speed to 100KHz. you are depending on emperical results and a
specification violation by expecting to let a chip default set for
100KHz to always allow for the first communication at 400KHz.

Unless ofcourse, you can confirm that the default speed register
writes are allowed at 400KHz contrary to the data sheet info you
mentioned in the patch.

-- 
Regards,
Nishanth Menon
