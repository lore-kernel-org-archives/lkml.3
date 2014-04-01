Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaDAHf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:35:57 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:56142 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDAHfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <533A0937.9030505@roeck-us.net>
References: <1396002720-7105-1-git-send-email-harinik@xilinx.com>
	<533A0937.9030505@roeck-us.net>
Date: Tue, 1 Apr 2014 13:05:53 +0530
Message-ID: <CAFcVECKpcduwJtq7X06NakL8P-aYYoHjS-_nwg+WqF1du7Y8yA@mail.gmail.com>
Subject: Re: [PATCH 1/2] watchdog: Add Cadence WDT driver
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        michals@xilinx.com, linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinik@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 1, 2014 at 6:02 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 03/28/2014 03:31 AM, Harini Katakam wrote:
>>
>> Add Cadence WDT driver. This is used by Xilinx Zynq.
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> ---
>>   drivers/watchdog/Kconfig       |    7 +
>>   drivers/watchdog/Makefile      |    1 +
>>   drivers/watchdog/cadence_wdt.c |  530
>> ++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 538 insertions(+)
>>   create mode 100644 drivers/watchdog/cadence_wdt.c
>>

<snip>

>> +
>> +       spin_lock(&wdt->io_lock);
>> +       cdns_wdt_writereg(wdt->regs + CDNS_WDT_ZMR_OFFSET,
>> +                         CDNS_WDT_ZMR_ZKEY_VAL);
>> +
>> +       /* Shift the count value to correct bit positions */
>> +       count = (count << 2) & CDNS_WDT_CCR_CRV_MASK;
>> +
>> +       /* Write counter access key first to be able write to register */
>> +       data = count | CDNS_WDT_REGISTER_ACCESS_KEY | wdt->ctrl_clksel;
>> +       cdns_wdt_writereg(wdt->regs + CDNS_WDT_CCR_OFFSET, data);
>> +       data = CDNS_WDT_ZMR_WDEN_MASK | CDNS_WDT_ZMR_RSTLEN_16 |
>> +              CDNS_WDT_ZMR_ZKEY_VAL;
>> +
>> +       /* Reset on timeout if specified in device tree. */
>> +       if (wdt->rst) {
>> +               data |= CDNS_WDT_ZMR_RSTEN_MASK;
>> +               data &= ~CDNS_WDT_ZMR_IRQEN_MASK;
>> +       } else {
>> +               data &= ~CDNS_WDT_ZMR_RSTEN_MASK;
>> +               data |= CDNS_WDT_ZMR_IRQEN_MASK;
>> +       }
>> +       cdns_wdt_writereg(wdt->regs + CDNS_WDT_ZMR_OFFSET, data);
>> +       spin_unlock(&wdt->io_lock);
>> +       cdns_wdt_writereg(wdt->regs + CDNS_WDT_RESTART_OFFSET,
>> +                         CDNS_WDT_RESTART_KEY);
>> +
>
> Sometimes you write into this register with lock protection, here without.
>
> How comes (or, in other words, why does the write have to be spinlock
> protected above but not here) ?
>

CDNS_WDT_RESTART_OFFSET needs to be written here with lock protection.
I missed it because it is in wdt_start, but i realise it should be protected.
Will correct that.

<snip>

>> +       /* Initialize the members of cdns_wdt structure */
>> +       cdns_wdt_device->parent = &pdev->dev;
>> +       of_get_property(pdev->dev.of_node, "timeout-sec",
>> +                       &cdns_wdt_device->timeout);
>> +       if (wdt_timeout < CDNS_WDT_MAX_TIMEOUT &&
>> +           wdt_timeout > CDNS_WDT_MIN_TIMEOUT)
>
>
> Why are CDNS_WDT_MAX_TIMEOUT and CDNS_WDT_MIN_TIMEOUT not acceptable ?
> Why don't you use watchdog_init_timeout() anyway ?
>

I'll use watchdog_init_timeout.

>
>> +               cdns_wdt_device->timeout = wdt_timeout;
>> +       else
>> +               dev_info(&pdev->dev,
>> +                        "timeout limited to 1 - %d sec, using
>> default=%d\n",
>> +                        CDNS_WDT_MAX_TIMEOUT, CDNS_WDT_DEFAULT_TIMEOUT);
>> +
>> +       watchdog_set_nowayout(cdns_wdt_device, nowayout);
>> +       watchdog_set_drvdata(cdns_wdt_device, wdt);
>> +
>
>
> Set too late (see other e-mail)
>

Will correct order in probe as pointed in other mails.

Regards,
Harini
