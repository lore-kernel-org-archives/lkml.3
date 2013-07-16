Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3GPMI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:08:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46667 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab3GPMIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:08:54 -0400
Message-ID: <51E537A4.40300@ti.com>
Date: Tue, 16 Jul 2013 15:08:04 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Hein Tibosch <hein_tibosch@yahoo.es>, Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
References: <51E50217.1000507@yahoo.es> <20130716090300.GG8880@arwen.pp.htv.fi> <51E5137B.7000302@yahoo.es> <20130716094212.GL8880@arwen.pp.htv.fi> <51E527F7.4080007@ti.com> <20130716112746.GN8880@arwen.pp.htv.fi>
In-Reply-To: <20130716112746.GN8880@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
On 07/16/2013 02:27 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jul 16, 2013 at 02:01:11PM +0300, Grygorii Strashko wrote:
>>>>>> On a OMAP4460, i2c-bus-3:
>>>>>>
>>>>>> A driver (lm75) is causing many 'timeout waiting for bus ready' errors.
>>>>>> SDA remains high (as it should), but SCL remains low after a NACK.
>>>>>> The bus becomes _unusable for other clients_.
>>>>>>
>>>>>> While probing, "lm75" writes a command, followed by a read + stop,
>>>>>> but the write command is NACK'd. The chip does accept other writes/reads,
>>>>>> it just refuses to ack invalid commands.
>>>>>>
>>>>>> Can you tell me if the patch below would make any sense? Or is it the
>>>>>> responsibility of the client to reset the i2c_smbus?
>>>>> patch below breaks repeated start.
>> Felipe, I'd very appreciate if you'd be able to provide the use case
>> which will fail with such solution?
>
> can't you see how this would fail ?
>
> assume omap_i2c_xfer() is called with its last argument (num) being
> greater than one and you get the NAK before the last transfer.
That's our case - NACK from slave before last transfer
>
> Will you not be breaking a possible repeated start for the following
> transfer ?
Sorry, but in this case omap_i2c_xfer() will be aborted and there would 
be no transfers until next call to omap_i2c_xfer().
Which, in turn, may address another device!?


>
>>>> No, after the NACK, no more commands are being processed,
>>>> including a repeated start. omap_i2c_xfer() returns -EREMOTEIO
>>>> without ever freeing the bus.
>>>>
>>>> The bus is left in an impossible state with SCL constantly low
>>>> and all next commands (to different chips) will therefore get
>>>> a -ETIMEDOUT
>>>>
>>>> With this patch, the bus will become idle again and new commands
>>>> can be processed normally
>> I think, this is valid fix, but it was done here already:)
>> http://patchwork.ozlabs.org/patch/249790/
>> "i2c: omap: query STP always when NACK is received"
>>
>> And nacked in the same way :(
>> But! I've back-ported my patch on TI Android product kernel 3.4, did
>> sanity test and I didn't see any issues with my patch :))
>
> that's because you don't care about repeated start, but that's a valid
> bus signal which needs to be supported.

>
>>> but you mentioned that if you have IGNORE_NAK set, everything is fine,
>>> since lm75 will get a return value of 0 and things will work just fine,
>>> right ?
>>>
>>> Also, you also said that the chip 'refuses to ack invalid commands', why
>>> are you sending invalid commands to start with ? This could be a bug in
>>> i2c-omap.c, sure, but let's try to figure out why IGNORE_NAK helps and
>>> why is lm75 driver sending invalid commands.
>>>
>>
>> The problem is, that lm75 device is SmBus compatible and its driver has
>> .detect() function implemented. During detection it tries to scan some
>> registers which might be not present in current device - in my case
>> it's tmp105.
>>
>> For example to read regA in tmp105 following is done:
>> 1) do write in "Index" register (val RegA index) (I2C 1st message)
>> 2) do read (I2C 2d message)
>> the message 1 is Nacked by device in case if register index is wrong,
>> but i2c-omap don't send NACK (or STP). As result, bus stack in Bus
>> Busy state.
>
> wait a minute, it's not i2c-omap which needs to send NAK, it's LM75,
> and it does the NAK. The handling for NAK in the i2c framework is to
> return -EREMOTEIO as we do. If our last message got a NAK, we send STOP
> because there will be no other transfers following this one, namely, the
> for loop in omap_i2c_xfer() will be finished.
Sorry, wrong descr, my bad - slave sends NACK (lm75), master (OMAP i2)
should send STP.
But, you *can* send STT if you wish to continue with next
message to the *same* device - which is not true for OMAP i2c, because 
OMAP I2C driver always interrupts transfer with error -EREMOTEIO!!
And, again:), next call of omap_i2c_xfer() may be *not* to the same
slave I2C device.

>
>> For SMBus devices the specification states (http://smbus.org/specs/)
>> "4.2.Acknowledge (ACK) and not acknowledge (NACK)":
>> - "The slave device detects an invalid command or invalid data. In this
>> case the slave device must not acknowledge the received byte. The
>> master upon detection of this condition must generate a STOP condition
>> and retry the transaction"
>
> hmm, but that's something that the OMAP I2C controller doesn't support
> and is emulated by the i2c framework, right ?
>
> If you look into the I2C specification, the one the OMAP controller is
> compliant to, you'll see e.g. in Figure 13 that a repeated start is a
> valid condition after a NAK.
>
> Also it states that:
>
> "This is indicated by the slave generating the not-acknowledge on the
> first byte to follow. The slave leaves the data line HIGH and the master
> generates a STOP or a repeated START condition."
>
> Because the OMAP I2C controller is compliant to the I2C specification,
> not the SMBus specification, we must follow through with the loop and
> let the next message try to send a repeated start.
>
> What you need here is a way to discriminate between SMBus message and
> normal I2C message, that way you could have something like:
I don't think that is right (my explanation above) - the same can happen 
even with pure I2C device.
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 142b694d..571b160 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -618,7 +618,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
>          if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
>                  if (msg->flags & I2C_M_IGNORE_NAK)
>                          return 0;
> -               if (stop) {
> +               if (stop || is_smbus) {
>                          w = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
>                          w |= OMAP_I2C_CON_STP;
>                          omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
>
> and, btw, this also means that I2C_M_IGNORE_NAK is invalid during SMBus
> transfers, so you might want to patch the framework to prevent that case
> altogether.
>
Regards,
-grygorii
