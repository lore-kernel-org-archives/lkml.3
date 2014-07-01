Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaGAKMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:12:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbaGAKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:12:19 -0400
Message-ID: <53B2893E.5020306@ti.com>
Date: Tue, 1 Jul 2014 13:11:10 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Mark Brown <broonie@kernel.org>
CC: "Gupta, Pekon" <pekon@ti.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "javier@dowhile0.org" <javier@dowhile0.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <ivan.khoronzhuk@ti.com>, Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH 05/36] mtd: nand: omap: Move IRQ handling from GPMC to
 NAND driver
References: <1402477001-31132-1-git-send-email-rogerq@ti.com> <1402477001-31132-6-git-send-email-rogerq@ti.com> <20140613071820.GI17845@atomide.com> <539AAA8C.2070709@ti.com> <20140613075856.GQ17845@atomide.com> <20980858CB6D3A4BAE95CA194937D5E73EAF51DB@DBDE04.ent.ti.com> <539AB4E4.6050408@ti.com> <20140613104610.GS17845@atomide.com> <539AE390.4080504@ti.com> <20140613120839.GV17845@atomide.com>
In-Reply-To: <20140613120839.GV17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Mark, Alexander, Ivan

Hi Tony,

On 06/13/2014 03:08 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140613 04:43]:
>> On 06/13/2014 01:46 PM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [140613 01:24]:
>>>> On 06/13/2014 11:13 AM, Gupta, Pekon wrote:
>>>>>> From: Tony Lindgren [mailto:tony@atomide.com]
>>>>>>> * Roger Quadros <rogerq@ti.com> [140613 00:40]:
>>>>>>>> On 06/13/2014 10:18 AM, Tony Lindgren wrote:
>>>>>>>>> * Roger Quadros <rogerq@ti.com> [140611 01:58]:
>>>>>>>
>>>>>>> OK. But wait pin edge detection was not yet being used and I couldn't
>>>>>>> think of how it would ever be used. Any ideas?
>>>>>>
>>>>>> Maybe to wake-up the system on bus activity or something?
>>>>>>
>>>>> Sorry, I wasn't able to review this series.
>>>>> But just as pointer, GPMC driver was used for interfacing many
>>>>> non-memory devices like Ethernet (smc91x) and in past GPMC has been
>>>>> proved to work with camera devices too, but that's wasn't mainlined.
>>>>> So keeping IRQ and few other things in GPMC driver is helpful.
>>>>>
>>>>
>>>> On further study it seems that the wait pin edge detection is only used in the NAND controller use case.
>>>> see section 10.1.5.14.2.2 Ready Pin Monitored by Hardware Interrupt
>>>
>>> It seems they can be used for anything slow like NOR and NAND.
>>
>> But NOR driver never requests for any IRQ.
>>
>> We should not confuse this wait pin edge interrupt with NOR bus cycle WAIT pin mechanism.
>> That is configured using GPMC_CONFIG1 register via WAITPINSELECT and WAITREAD/WRITEMONITORING bits.
>> That wait pin handling is done completely in hardware and doesn't need any software intervention.
>> Imagine using it for interrupt for every bus cycle wait. It will be dead slow and unusable.
>>
>> The WAIT edge interrupt mechanism is exclusively for NAND use case to notify the status of READY pin after a block/page operation.
> 
> OK thanks for clarifying it. 
>  
>>>> For memory devices, no software wait pin intervention is necessary and doesn't even make sense.
>>>
>>> Still seems that it's use can be generic though, not limited
>>> to NAND.
>>>  
>>>> So I don't agree on managing the IRQSTATUS and IRQENABLE register in the GPMC driver. It is adding unnecessary complexity. I don't mind having a wrapper around it though like the other nand registers.
>>>
>>> But all the consumer driver should need to do is request_irq()
>>> on it? That's pretty much the most common interface we have
>>> for drivers :)
>>
>> the client driver side is easy, but it adds unnecessary complication to model it as IRQ chip and assign a line for each event. Since it is going to be used exclusively by NAND we should avoid IRQ chip modeling.
> 
> OK up to you if there are no other users for it. 
>  
>>>> To be frank, I think it is cleaner if the NAND driver directly accesses the NAND registers.
>>>> I don't see why we should make things complicated just because the hardware designers didn't create a clear register split between GPMC and NAND.
>>>
>>> Because they are in separate hardware modules :)
>>>
>>> Who knows why it was set up this way. Maybe the plan was to have
>>> the common features in GPMC that then can be used by various MTD
>>> devices.
>>>  
>>>> Only the GPMC_CONFIG register needs to remain with the GPMC driver.
>>>
>>> And managing clocks and runtime PM in general. In any case, let's
>>> not let drivers tinker with the GPMC registers directly though.
>>> Some kind of abstraction via existing frameworks or with regmap
>>> is needed.
>>
>> OK. I agree about using some kind of abstraction instead of direct access.
> 
> Yes and like we chatted on irc, adding a syscon mapping for for
> the NAND specific registers might do the trick here.

After looking at the syscon driver, which relies on regmap, it seems that regmap was designed for slow control busses like I2C/SPI and using it for NAND controller register access will have a significant negative impact on performance. In the NAND case the register writes are used for each NAND command cycle and the reads for ECC checks (every page).

See how much code regmap_read and regmap_mmio_read() translates to for a simple register read i.e. readl().
http://lxr.free-electrons.com/source/drivers/base/regmap/regmap.c#L1944
http://lxr.free-electrons.com/source/drivers/base/regmap/regmap-mmio.c#L129

So I'm not so sure of using regmap/syscon for NAND controller register access.

Could there be any other abstraction method of sharing the register space between GPMC and NAND driver?
I've also added Ivan to the thread, the author of memory/ti-aemif.c driver, to check if he faced any issues with shared register access of the AEMIF/NAND registers.

cheers,
-roger

