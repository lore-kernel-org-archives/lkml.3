Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3KMAJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:09:07 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56947 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3KMAI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:08:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131112233911.16eba130@alan.etchedpixels.co.uk>
References: <1383943488-6537-1-git-send-email-markus.mayer@linaro.org>
	<1383943488-6537-2-git-send-email-markus.mayer@linaro.org>
	<20131112233911.16eba130@alan.etchedpixels.co.uk>
Date: Tue, 12 Nov 2013 16:08:56 -0800
Message-ID: <CAPdLdqnKvKbU_6M4uUBAwtq1YUaKMtrZcR7mzJfxjZva=duPHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2013 15:39, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>
>> +static int bcm_kona_wdt_set_resolution_reg(struct bcm_kona_wdt *wdt)
>> +{
>> +     uint32_t val;
>> +     int timeout;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     if (wdt->resolution > SECWDOG_MAX_RES)
>> +             return -EINVAL;
>> +
>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +
>> +     val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
>> +     if (!timeout) {
>> +             val &= ~SECWDOG_RES_MASK;
>> +             val |= wdt->resolution << SECWDOG_CLKS_SHIFT;
>> +             writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
>> +     } else {
>> +             ret = -EAGAIN;
>
> This is I think the wrong choice of return. If the register fails to read
> then presumably the device is b*ggered ? In which case return something
> like -EIO and log something nasty.
>
> EAGAIN has fairly specific semantics around signals and/or specific
> requests for an I/O operation not to wait.

I will change that based on Guenter's and your comments.

>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +
>> +     val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
>> +     if (!timeout) {
>> +             val &= ~SECWDOG_COUNT_MASK;
>> +             val |= SECS_TO_TICKS(wdog->timeout, wdt);
>> +             writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
>> +     } else {
>> +             ret = -EAGAIN;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>
> As an aside you could fold most of these functions into one single helper
> method that read CTRL_REG, did the and and or and wrote the result back
> rather than repeating yourself. But hey if you like typing...

I'll look into that.

>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> What if there is no resource present ?

Then devm_ioremap_resource() will print an error message and return
with ERR_PTR(-EINVAL). Subsequently probe() will fail. So it'll work
as intended.

>> +     dev_info(dev, "Broadcom Kona Watchdog Timer");
>
> The module load succeeded - the user knows it loaded from that. Likewise
> the unload spewage is unwanted and the kernel would just drown in such
> messages if we didn't keep them in check. If you need the for debug then
> mark them dev_dbg but otherwise bin them.

I already changed them all to "debug" in my local tree. For this one
message, I am feeling a bit ambivalent, though. The user only knows
loading of the module succeeded if the user manually loaded the module
-- which, I imagine, would almost never be the case. The driver is
either going to be built in or loaded automatically by some facility.
In which case it might be nice to have some confirmation of that fact
in the logs.

Regards,
-Markus

-- 
Markus Mayer
Broadcom Landing Team
