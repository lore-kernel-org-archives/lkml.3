Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbaKUMtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:49:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54912 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaKUMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:49:19 -0500
Message-ID: <546F34B9.1000206@ti.com>
Date: Fri, 21 Nov 2014 14:48:57 +0200
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
References: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com> <20141120221953.GI27002@pengutronix.de>
In-Reply-To: <20141120221953.GI27002@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On 11/21/2014 12:19 AM, Uwe Kleine-König wrote:
> On Thu, Nov 20, 2014 at 12:03:05PM +0200, Grygorii Strashko wrote:
>> According to I2C specification the NACK should be handled as folowing:
> s/folowing/follows/
> 
>> "When SDA remains HIGH during this ninth clock pulse, this is defined as the Not
>> Acknowledge signal. The master can then gene rate either a STOP condition to
> s/gene rate/generate/
> 
>> abort the transfer, or a repeated START condition to start a new transfer."
>> [http://www.nxp.com/documents/user_manual/UM10204.pdf]
> The link is nice, but pointing out that this is the i2c spec would be
> nice.
> 
>> The same is recomened by TI I2C wiki:
> s/recomened/recommended/
> 
>>   http://processors.wiki.ti.com/index.php/I2C_Tips
> If the specification tells what to do, there is no need to further
> support your claim.
> 
>> Currently, the Davinci I2C driver interrupts I2C trunsfer in case of NACK, but
> s/trunsfer/transfer/
> 
>> It queries Stop condition DAVINCI_I2C_MDR_REG.STP=1 only if NACK has been received
> s/It/it/
> 
>> during the last message transmitting/recieving.
> s/transmitting/transmitted/; s/recieving/received/
> 
> I think I don't understand this sentence even with the typos corrected.
> Do you want to say:
> 
> Currently the Davinci i2c driver interrupts the transfer on receipt of a
> NACK but fails to send a STOP in some situations and so makes the bus
> stuck.
> 
>> This may lead to Bus stuck in "Bus Busy" until I2C IP reset (idle/enable) if
>> during SMBus reading transaction the first I2C message is NACKed.
> Did you hit this problem, or is this a theoretical issue?

I've hit this issue on OMAP board and the Davinci I2C driver is implemented in a similar way.
Now I've no HW which would allow me to reproduce it on Davinci.
quotes from https://lkml.org/lkml/2013/7/16/235:
>>>
The problem is, that lm75 device is SmBus compatible and its driver has
.detect() function implemented. During detection it tries to scan some
registers which might be not present in current device - in my case
it's tmp105.

For example to read regA in tmp105 following is done:
1) do write in "Index" register (val RegA index) (I2C 1st message)
2) do read (I2C 2d message)
the message 1 is Nacked by lm75 type of device in case if register index is wrong, 
but i2c-omap don't send NACK (or STP). As result, bus stack in Bus Busy 
state.

For SMBus devices the specification states (http://smbus.org/specs/)
"4.2.Acknowledge (ACK) and not acknowledge (NACK)":
- "The slave device detects an invalid command or invalid data. In this
case the slave device must not acknowledge the received byte. The
master upon detection of this condition must generate a STOP condition
and retry the transaction"
<<<

> 
> Assuming this is a candidate for stable, adding a Fixes:-footer would be
> nice.
> 
>> Hence, fix it by querying Stop condition (STP) always when NACK is received.
>>
>> This patch fixes Davinci I2C in the same way it was done for OMAP I2C
>> commit cda2109a26eb ("i2c: omap: query STP always when NACK is received").
>>
>> More info can be found at:
>> https://lkml.org/lkml/2013/7/16/159
>> http://patchwork.ozlabs.org/patch/249790/
> I'd drop this "more info" paragraph.
> 
>> CC: Sekhar Nori <nsekhar@ti.com>
>> CC: Kevin Hilman <khilman@deeprootsystems.com>
>> CC: Santosh Shilimkar <ssantosh@kernel.org>
>> CC: Murali Karicheri <m-karicheri2@ti.com>
>> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
> Is this Reported-by tag reused from the omap issue?
> 
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/i2c/busses/i2c-davinci.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>> index 9bbfb8f..2cef115 100644
>> --- a/drivers/i2c/busses/i2c-davinci.c
>> +++ b/drivers/i2c/busses/i2c-davinci.c
>> @@ -411,11 +411,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
>>   	if (dev->cmd_err & DAVINCI_I2C_STR_NACK) {
>>   		if (msg->flags & I2C_M_IGNORE_NAK)
>>   			return msg->len;
>> -		if (stop) {
>> -			w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
>> -			w |= DAVINCI_I2C_MDR_STP;
>> -			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
>> -		}
>> +		w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
>> +		w |= DAVINCI_I2C_MDR_STP;
>> +		davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
> I think this is a good change, but I wonder if the handling of
> I2C_M_IGNORE_NAK is correct here. If the controller reports a NACK say
> for the 2nd byte of a 5-byte-message, the transfer supposed to
> continue, right? (Hmm, maybe the framework handle this and restarts the
> transfer with I2C_M_NOSTART but the davinci driver doesn't seem to
> handle this flag?)

Have nothing to say about handling of I2C_M_IGNORE_NAK. I'm not going to
change current behavior - davinci driver will interrupt transfer of i2c_msg always
 in case of NACK and start transfer of the next i2c_msg (if exist).
In my opinion, Above question is out of scope of this patch.

Thanks for your comments.

Regards,
-grygorii
