Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3GPQTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:19:21 -0400
Received: from bosmailout13.eigbox.net ([66.96.186.13]:45659 "EHLO
	bosmailout13.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023Ab3GPQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:19:17 -0400
X-Authority-Analysis: v=2.0 cv=dt1Z+ic4 c=1 sm=1
 a=vgGgzxEtDY8f9Bnbu8UTBg==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=OYGCgI3rE0kA:10 a=8nJEP1OIZ-IA:10 a=8Ne1j35meV0A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=Tmt0DFWaxRNA367QoYsA:9 a=wPNLvfGTeEIA:10
 a=9UqFsMnAB6EOkiq4MrOclQ==:117
X-EN-OrigOutIP: 10.20.18.19
X-EN-IMPSID: 14KF1m0080QhFXN014KF07
Message-ID: <51E57211.2040001@yahoo.es>
Date: Wed, 17 Jul 2013 00:17:21 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: balbi@ti.com, Grygorii Strashko <grygorii.strashko@ti.com>
CC: Tony Lindgren <tony@atomide.com>, linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
References: <51E50217.1000507@yahoo.es> <20130716090300.GG8880@arwen.pp.htv.fi> <51E5137B.7000302@yahoo.es> <20130716094212.GL8880@arwen.pp.htv.fi> <51E527F7.4080007@ti.com> <20130716112746.GN8880@arwen.pp.htv.fi> <51E537A4.40300@ti.com> <20130716130058.GD15036@arwen.pp.htv.fi>
In-Reply-To: <20130716130058.GD15036@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.62.249
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii, Filipe,

On 7/16/2013 9:00 PM, Felipe Balbi wrote:
> On Tue, Jul 16, 2013 at 03:08:04PM +0300, Grygorii Strashko wrote:
>> Hi Felipe,
>> On 07/16/2013 02:27 PM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Tue, Jul 16, 2013 at 02:01:11PM +0300, Grygorii Strashko wrote:
>>>>>>>> On a OMAP4460, i2c-bus-3:
>>>>>>>>
>>>>>>>> A driver (lm75) is causing many 'timeout waiting for bus ready' errors.
>>>>>>>> SDA remains high (as it should), but SCL remains low after a NACK.
>>>>>>>> The bus becomes _unusable for other clients_.
>>>>>>>>
>>>>>>>> While probing, "lm75" writes a command, followed by a read + stop,
>>>>>>>> but the write command is NACK'd. The chip does accept other writes/reads,
>>>>>>>> it just refuses to ack invalid commands.

In case the NACK may not be ignored, I believe it is correct
to break out of the loop and send a stop for 2 reasons:

1. all chips, including the target chip, will know that the
   current transaction is finished

2. to set CLK high again, which prevents numerous timeouts
   on subsequent transactions

As a test I've set 'I2C_M_IGNORE_NAK' for all .detect messages
sent by the lm75 driver.
Now the chip (tmp105) will provide read data as expected
after the _repeated start_, even though it NACK'd the preceding
WR command.
And also the detection trick does work now, addresses 4,5,6,7 return
the same read data as was returned from the last valid address 2.

Felipe:
> Which means your original patch starts to make a lot more sense. I
> wonder is this is really what we should be doing though - breaking out
> of the loop, I mean.

So yes, we have to break the loop as the caller is not interested
in processing any further commands.

In i2c/algos/i2c-algo-bit.c, bit_xfer() works exactly the same way:
break the loop (unless IGNORE_NAK) and call unconditionally i2c_stop().

It looks like TI's i2c-davinci will have the same problem as i2c-omap,
and will need the same change.

Grygorii, if you submit the patch, please add my

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

cause you were earlier to notice and fix this problem.

Hein
