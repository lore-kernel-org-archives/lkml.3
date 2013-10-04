Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3JDNgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:36:46 -0400
Received: from smtp-out-250.synserver.de ([212.40.185.250]:1085 "EHLO
	smtp-out-240.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581Ab3JDNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:36:45 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14257
Message-ID: <524EC4DC.1020708@metafoo.de>
Date: Fri, 04 Oct 2013 15:38:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Wolfram Sang <wsa@the-dreams.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        Kedareswara rao Appana <appanad@xilinx.com>,
        Jean Delvare <khali@linux-fr.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org,
        =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
        "Steven A. Falco" <sfalco@harris.com>
Subject: Re: [PATCH v2 2/3] i2c: xilinx: Set tx direction in write operation
References: <f3fd6f38d2553e59b077edff1969f4d07f8aa811.1380550490.git.michal.simek@xilinx.com> <57a4f5352ce6f03bde7aafe8b880f91b52994379.1380550490.git.michal.simek@xilinx.com> <20131004054636.GC3194@katana> <524E902D.8030809@monstr.eu> <20131004115517.GA2994@katana> <524EB090.2070708@metafoo.de> <524EBDF6.1070605@monstr.eu>
In-Reply-To: <524EBDF6.1070605@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 03:09 PM, Michal Simek wrote:
> 
> 
> On 10/04/2013 02:12 PM, Lars-Peter Clausen wrote:
>> On 10/04/2013 01:55 PM, Wolfram Sang wrote:
>>> On Fri, Oct 04, 2013 at 11:53:49AM +0200, Michal Simek wrote:
>>>> On 10/04/2013 07:46 AM, Wolfram Sang wrote:
>>>>>
>>>>>> +	cr = xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
>>>>>> +	cr |= XIIC_CR_DIR_IS_TX_MASK;
>>>>>> +	xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, cr);
>>>>>> +
>>>>>
>>>>> Is there no need to clear the bit again when receiving?
>>>>
>>>> This bit is cleared in xiic_xfer() -> xiic_start_xfer() ->xiic_reinit()
>>>>
>>>> xiic_setreg8(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);
>>>
>>> A bit implicit, but OK.
>>>
>>>>> And did
>>>>> transferring ever work if this bit was never set before?
>>>>
>>>> I really don't know. We have switched from old driver to this new mainline one
>>>> and based on our eeprom testing we have found that this bit hasn't been setup properly.
>>>>
>>>> It is described here.
>>>> http://www.xilinx.com/support/documentation/ip_documentation/axi_iic/v1_02_a/axi_iic_ds756.pdf
>>>> page 28 - step 3.
>>>>
>>>> IIC Master Transmitter with a Repeated Start
>>>> 1. Write the IIC device address to the TX_FIFO.
>>>> 2. Write data to TX_FIFO.
>>>> 3. Write to Control Register (CR) to set MSMS = 1 and TX = 1.
>>>> 4. Continue writing data to TX_FIFO.
>>>> 5. Wait for transmit FIFO empty interrupt. This implies the IIC has throttled the bus.
>>>> 6. Write to CR to set RSTA = 1.
>>>
>>> Repeated start is not happening in the driver as well, or am I
>>> overlooking something?
>>>
>>>> 7. Write IIC device address to TX_FIFO.
>>>> 8. Write all data except last byte to TX_FIFO.
>>>> 9. Wait for transmit FIFO empty interrupt. This implies the IIC has throttled the bus.
>>>> 10. Write to CR to set MSMS = 0. The IIC generates a stop condition at the end of the last byte.
>>>> 11. Write last byte of data to TX_FIFO.
>>>
>>> CCing more people who worked on the driver in the past and might have
>>> experiences
>>
>> The current version works fine here. The driver uses whats described in the
>> datasheet as "dynamic controller logic flow" and not the "standard
>> controller logic flow". The sequence Michal mentioned above is from the
>> "standard controller logic flow" section.
> 
> Does this change break "dynamic controller logic flow"?

Not sure, but I would assume that the bit is ignored in this mode. But I
don't think the patch should be applied since this step is not in the
sequence of steps that should be done.

- Lars

