Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaKXNey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:34:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33644 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaKXNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:34:52 -0500
Message-ID: <547333EB.5050403@ti.com>
Date: Mon, 24 Nov 2014 15:34:35 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [2/5] i2c: davinci: query STP always when NACK is received
References: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com> <20141120221953.GI27002@pengutronix.de> <546F34B9.1000206@ti.com> <20141121131008.GQ27002@pengutronix.de> <546F5B51.1030006@ti.com> <20141123203314.GF4431@pengutronix.de>
In-Reply-To: <20141123203314.GF4431@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,
On 11/23/2014 10:33 PM, Uwe Kleine-König wrote:
> On Fri, Nov 21, 2014 at 05:33:37PM +0200, Grygorii Strashko wrote:
>> On 11/21/2014 03:10 PM, Uwe Kleine-König wrote:
>>> On Fri, Nov 21, 2014 at 02:48:57PM +0200, Grygorii Strashko wrote:
>>>> On 11/21/2014 12:19 AM, Uwe Kleine-König wrote:
>>>>>> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>>>>>> index 9bbfb8f..2cef115 100644
>>>>>> --- a/drivers/i2c/busses/i2c-davinci.c
>>>>>> +++ b/drivers/i2c/busses/i2c-davinci.c
>>>>>> @@ -411,11 +411,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
>>>>>>     	if (dev->cmd_err & DAVINCI_I2C_STR_NACK) {
>>>>>>     		if (msg->flags & I2C_M_IGNORE_NAK)
>>>>>>     			return msg->len;
>>>>>> -		if (stop) {
>>>>>> -			w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
>>>>>> -			w |= DAVINCI_I2C_MDR_STP;
>>>>>> -			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
>>>>>> -		}
>>>>>> +		w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
>>>>>> +		w |= DAVINCI_I2C_MDR_STP;
>>>>>> +		davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
>>>>> I think this is a good change, but I wonder if the handling of
>>>>> I2C_M_IGNORE_NAK is correct here. If the controller reports a NACK say
>>>>> for the 2nd byte of a 5-byte-message, the transfer supposed to
>>>>> continue, right? (Hmm, maybe the framework handle this and restarts the
>>>>> transfer with I2C_M_NOSTART but the davinci driver doesn't seem to
>>>>> handle this flag?)
>>>>
>>>> Have nothing to say about handling of I2C_M_IGNORE_NAK. I'm not going to
>>>> change current behavior - davinci driver will interrupt transfer of i2c_msg always
>>>>    in case of NACK and start transfer of the next i2c_msg (if exist).
>>>> In my opinion, Above question is out of scope of this patch.
>>> Yeah right, that's exactly what I thought.
>>>
>>> Thinking again I wonder if with your change handling is correct when the
>>> sender wants to do a repeated start. That would need a more detailed
>>> look into the driver.
>>
>> Davinci driver will always abort transfer with error -EREMOTEIO in case if
>> NACK received from I2C slave device. And the next omap_i2c_xfer() call may
>> be *not* targeted to the same I2C slave device.
>> ^ if !I2C_M_IGNORE_NAK
> Does this resolve my concern? I think it doesn't. Also a Sr might well
> address another device, doesn't it?
> 
> A call to .master_xfer with a message sequence implicitly expects ACKs
> from the slave and doesn't tell anything about what should be done on a
> NAK. So IMHO you must not send a P when the slave responds with a NAK,
> but error out and let the sender decide if it wants to reply with P or
> Sr.

Sry, but what should be done is defined by I2C/SMbus specs? Does it?
For SMBus devices, the specification states (http://smbus.org/specs/)
"4.2.Acknowledge (ACK) and not acknowledge (NACK)":
- "The slave device detects an invalid command or invalid data. In this 
  case the slave device must not acknowledge the received byte. The master
  upon detection of this condition must generate a STOP condition and
  retry the transaction"
For I2C devices, the specification states [http://www.nxp.com/documents/user_manual/UM10204.pdf]:
"3.1.6 Acknowledge (ACK) and Not Acknowledge (NACK)"
"When SDA remains HIGH during this ninth clock pulse, this is defined as the Not
Acknowledge signal. The master can then generate either a STOP condition to
abort the transfer, or a repeated START condition to start a new transfer."

Let take a look on i2c/smbus xfer:
i2c_lock_adapter(adap)
 adap->algo->master_xfer/smbus_xfer()
i2c_unlock_adapter(adap);
 |- rt_mutex_unlock(&adapter->bus_lock);
    |- task switch
 
So, there is no guarantee that next xfer will address the same I2C client device,
which, in turn, may lead to BB detection (will lead to BB detection if previous
transfer has been not acknowledged by SMbus client device).

Small summary, I2C core + Davinci I2C driver provide ability to use repeated
start (Sr) only within one I2C transaction - which is a number of write/read
operations specified by i2c_msg array. NACK always interrupts transaction
with -EREMOTEIO.

Also, the I2C core doesn't provide ability to manually send P.

regards,
-grygorii
