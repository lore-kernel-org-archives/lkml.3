Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3LBJvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:51:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52998 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3LBJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:51:04 -0500
Message-ID: <529C5804.2020501@gmail.com>
Date: Mon, 02 Dec 2013 10:51:00 +0100
From: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] mfd: mc13xxx: Remove unneeded mc13xxx_lock/unlock
References: <1385787681-7736-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1385787681-7736-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/11/2013 06:01, Alexander Shiyan a écrit :
> Locking is performed by regmap API so no additional locking is
> needed. Nevertheless, keep locking in the ADC conversion routine.
> This need for keep proper read ADC sequence when calling from adc &
> touchscreen drivers.

You can't do that so easily !
Regmap only protect against concurrent access to the SPI/I2C bus, but do
not protect the driver's internal data.
And it does not protect against a race between concurrent access at a
higher level :

reg = regmap_read();
(modify reg)
regmap_write(reg);

And we do have such behavior:
* The mc13xxx->irqhandler/irqdata array is
   protected by this mutex.

* And we also have non-atomic RMW in mc13xxx_irq_unmask():

ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
if (ret)
	return ret;
if (!(mask & irqbit))
	return 0;
return mc13xxx_reg_write(mc13xxx, offmask, mask & ~irqbit);

It's OK to do this if you are protected by a mutex, but as soon as you
remove it you will have concurrency between two irq_unmask/irq_mask.

So you can remove the lock from trivial function like:
	mc13xxx_lock(led->master);
  	mc13xxx_reg_rmw(led->master, reg, mask << shift, value << shift);
	mc13xxx_unlock(led->master);

Which protect only a single access to regmap.

But we need to keep it for more complex behavior.

Regards,

Philippe
