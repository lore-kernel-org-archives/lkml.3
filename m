Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaLLWD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 17:03:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39861 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaLLWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 17:03:55 -0500
Message-ID: <548B6629.6050203@ti.com>
Date: Fri, 12 Dec 2014 16:03:21 -0600
From: Dave Gerlach <d-gerlach@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [RFC PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
References: <cover.1417029919.git.d-gerlach@ti.com> <3334d8483dca2d061cf43da9c047ec27f31e8719.1417029919.git.d-gerlach@ti.com> <2763467.KfXHXHxPJd@wuerfel>
In-Reply-To: <2763467.KfXHXHxPJd@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 03:51 PM, Arnd Bergmann wrote:
> On Wednesday 26 November 2014 15:38:09 Dave Gerlach wrote:
>> +
>> +static const struct wkup_m3_wakeup_src wakeups[] = {
>> +       {.irq_nr = 35,  .src = "USB0_PHY"},
>> +       {.irq_nr = 36,  .src = "USB1_PHY"},
>> +       {.irq_nr = 40,  .src = "I2C0"},
>> +       {.irq_nr = 41,  .src = "RTC Timer"},
>> +       {.irq_nr = 42,  .src = "RTC Alarm"},
>> +       {.irq_nr = 43,  .src = "Timer0"},
>> +       {.irq_nr = 44,  .src = "Timer1"},
>> +       {.irq_nr = 45,  .src = "UART"},
>> +       {.irq_nr = 46,  .src = "GPIO0"},
>> +       {.irq_nr = 48,  .src = "MPU_WAKE"},
>> +       {.irq_nr = 49,  .src = "WDT0"},
>> +       {.irq_nr = 50,  .src = "WDT1"},
>> +       {.irq_nr = 51,  .src = "ADC_TSC"},
>> +       {.irq_nr = 0,   .src = "Unknown"},
>> +};
>>
> 
> This seems awfully specific to some SoC version, and not aware of
> IRQ domains. It also seems to be only used in a dev_dbg statement,
> so I guess you could just kill this off entirely.

This is determined by the firmware in use on the remote processor and works for
both am335x and am437x. However it is not required information and I'd be fine
with taking it out.

> 
>> +static struct rproc *wkup_m3_get_rproc(struct device *dev)
>> +{
>> +       struct device_node *node;
>> +       struct rproc *rp;
>> +
>> +       node = of_parse_phandle(dev->of_node, "ti,rproc", 0);
>> +       if (!node)
>> +               return NULL;
>> +
>> +       dev = bus_find_device(&platform_bus_type, NULL, node, match);
>> +       if (!dev)
>> +               return NULL;
>> +
>> +       rp = dev_get_drvdata(dev);
>> +       return rp;
> 
> This is wrong on a number of levels. I suspect what you really want
> is an interface exported from drivers/remoteproc that looks up
> a 'struct rproc' and performs the necessary reference counting.
> 
> That one can just use of_find_node_by_phandle() to get to
> a device_node and use that to look up the rproc device in
> a linked list it maintains.

Added Ohad as I should have cc'd him in the first place..

Yes I agree that it's not the best solution. There used to be an
rproc_get/rproc_put api but that was removed, I'll look into adding
rproc_get_by_phandle into drivers/remoteproc as that would be ideal for this
situation and a cleaner way of doing it. Thanks for the comments.

Regards,
Dave

> 
> 	Arnd
> 

