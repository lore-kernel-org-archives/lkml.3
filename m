Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116Ab3FSSrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:47:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44299 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095Ab3FSSrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:47:32 -0400
Message-ID: <51C1FBB8.4090600@ti.com>
Date: Wed, 19 Jun 2013 21:43:04 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 3/5] i2c: omap: handle all irqs befor unblocking omap_i2c_xfer_msg()
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com> <1370630768-4077-4-git-send-email-grygorii.strashko@ti.com> <20130607190543.GD15295@arwen.pp.htv.fi>
In-Reply-To: <20130607190543.GD15295@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
On 06/07/2013 10:05 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jun 07, 2013 at 09:46:06PM +0300, Grygorii Strashko wrote:
>> ARDY|NACK and ARDY|AL are set together in OMAP_I2C_STAT_REG, which will be
> Have you seen that happen ever ? AL is Arbitration Lost, we never put
> OMAP in a multi-master environment before.
This is an example from real life:
[    0.271942] omap_i2c omap_i2c.1: bus 1 rev2.4.0 at 400 kHz
[    1.283416] omap_i2c omap_i2c.1: timeout waiting for bus ready
[    1.300109] OMAP_I2C DEBUG: stat=1001
[    1.300140] omap_i2c omap_i2c.1: Arbitration lost
[    1.300140] OMAP_I2C DEBUG: IE=601F
[    1.300140] OMAP_I2C DEBUG: STAT=1000
[    1.300170] OMAP_I2C DEBUG: IV=636F
[    1.300170] OMAP_I2C DEBUG: WE=636F
[    1.300170] OMAP_I2C DEBUG: SYSS=1
[    1.300170] OMAP_I2C DEBUG: BUF=707
[    1.300201] OMAP_I2C DEBUG: CNT=1
[    1.300201] OMAP_I2C DEBUG: DATA=1
[    1.300201] OMAP_I2C DEBUG: SYSC=215
[    1.300201] OMAP_I2C DEBUG: CON=8200
[    1.300231] OMAP_I2C DEBUG: OA=0
[    1.300231] OMAP_I2C DEBUG: SA=49
[    1.300231] OMAP_I2C DEBUG: PSC=9
[    1.300262] OMAP_I2C DEBUG: SCLL=9
[    1.300262] OMAP_I2C DEBUG: SCLH=3
[    1.300262] OMAP_I2C DEBUG: SYSTEST=1E0
[    1.300262] OMAP_I2C DEBUG: BUFSTAT=4000

and my headache now :..(
>
> ARDY | NACK I also find it a bit hard for those two to happen together
> since ARDY will be set when you can change controller's register
> *again*, mening that a transfer has completed.
There are examples:
[    3.544952] omap_i2c 48060000.i2c: IRQ (ISR = 0x0006)

[   25.574523] omap_i2c 48350000.i2c: IRQ (ISR = 0x0014)
[   25.579925] omap_i2c 48350000.i2c: IRQ (ISR = 0x0012)

to see it - enable debug output in omap_i2c_isr_thread:
         dev_dbg(dev->dev, "IRQ (ISR = 0x%04x)\n", stat);

>
> Also, we need to follow what the programming model says. And, I don't
> have docs with me right now, but IIRC it tells us to bail out if any of
> the error conditions are met.
>
yep, but first of all - all IRQs need to be acked before exit.

Sorry, for delayed reply - I've had problems with my e-mail.

- grygorii

