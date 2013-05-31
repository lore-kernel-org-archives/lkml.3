Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3EaRYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:24:18 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45296 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3EaRYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:24:10 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] i2c: omap: correct usage of the interrupt enable register
References: <1369929379-19165-1-git-send-email-oleksandr.dmytryshyn@ti.com>
	<1369929379-19165-2-git-send-email-oleksandr.dmytryshyn@ti.com>
	<87vc604dr9.fsf@linaro.org> <51A85CFC.2000904@ti.com>
Date: Fri, 31 May 2013 10:24:07 -0700
In-Reply-To: <51A85CFC.2000904@ti.com> (Oleksandr Dmytryshyn's message of
	"Fri, 31 May 2013 11:19:08 +0300")
Message-ID: <87txlj2hc8.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:

> On 05/30/2013 07:46 PM, Kevin Hilman wrote:
>> Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:
>>
>>> If the i2c controller during suspend will generate an interrupt, it
>>> can lead to unpredictable behaviour in the kernel.
>>>
>>> Based on the logic of the kernel code interrupts from i2c should be
>>> prohibited during suspend. Kernel writes 0 to the I2C_IE register in
>>> the omap_i2c_runtime_suspend() function. In the other side kernel
>>> writes saved interrupt flags to the I2C_IE register in
>>> omap_i2c_runtime_resume() function. I.e. interrupts should be disabled
>>> during suspend.
>>>
>>> This works for chips with version1 registers scheme. Interrupts are
>>> disabled during suspend. For chips with version2 scheme registers
>>> writting 0 to the I2C_IE register does nothing (because now the
>>> I2C_IRQENABLE_SET register is located at this address). This register
>>> is used to enable interrupts. For disabling interrupts
>>> I2C_IRQENABLE_CLR register should be used.
>>>
>>> Because the registers I2C_IRQENABLE_SET and I2C_IE have the same
>>> addresses, the interrupt enabling procedure is unchanged.
>>>
>>> Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
>> Much better, but still doesn't explain how/why this has been working up
>> until now.  Have we just been lucky?
> Yes, this has been working up until now because we've just been lucky.

What I'm trying to say is you need to describe that in the changelog,
with more details.  e.g. we've been lucky not to have any interrupts
fire during the suspend path, otherwise we would have....

Kevin


>>
>>> ---
>>>   drivers/i2c/busses/i2c-omap.c | 15 +++++++++++----
>>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
>>> index e02f9e3..2419899 100644
>>> --- a/drivers/i2c/busses/i2c-omap.c
>>> +++ b/drivers/i2c/busses/i2c-omap.c
>>> @@ -180,6 +180,8 @@ enum {
>>>   #define I2C_OMAP_ERRATA_I207		(1 << 0)
>>>   #define I2C_OMAP_ERRATA_I462		(1 << 1)
>>>   +#define OMAP_I2C_INTERRUPTS_MASK	0x6FFF
>> To be more clear, this should probably have v2 in the name.
> I'll rename this mask in the patch-set v3
>>
>> Kevin
>>
