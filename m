Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaKZVwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:52:00 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:55971 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaKZVv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:51:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dave Gerlach <d-gerlach@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [RFC PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
Date: Wed, 26 Nov 2014 22:51:50 +0100
Message-ID: <2763467.KfXHXHxPJd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3334d8483dca2d061cf43da9c047ec27f31e8719.1417029919.git.d-gerlach@ti.com>
References: <cover.1417029919.git.d-gerlach@ti.com> <3334d8483dca2d061cf43da9c047ec27f31e8719.1417029919.git.d-gerlach@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bxE9mIeL7jSh913fQOKjSG/+7lkWeOY94b4naVk7OFu
 CEaKGRJYeQkYres3Z9897Nq2y98Bh/P1uvnn3JSdB5dnpBrroS
 Gzyku4G3+e0IGV38jiQOHTYVGNtSSXhX/tGnzL09XHWnfN28Ya
 17RVkRoU6ig79xQ2j4DH0IU+ler1VMtpsfI3hjmgUGOkYF3EwN
 TRofcqufs7YtepzJelTRWFbqmHahFt0IIxI4Z/op4ow9I6QxVn
 0oCKjccS+dW+QahrJfLKSFq7f0OGzqlxV1Jcb0/XIVj0cRKEiD
 tncwpO4JdMVMHNIAaUtfU4vQZ9x+JRJo7y2xCXxzakFVsT9S8c
 lb+BSySKDBiI8JjvIXXs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2014 15:38:09 Dave Gerlach wrote:
> +
> +static const struct wkup_m3_wakeup_src wakeups[] = {
> +       {.irq_nr = 35,  .src = "USB0_PHY"},
> +       {.irq_nr = 36,  .src = "USB1_PHY"},
> +       {.irq_nr = 40,  .src = "I2C0"},
> +       {.irq_nr = 41,  .src = "RTC Timer"},
> +       {.irq_nr = 42,  .src = "RTC Alarm"},
> +       {.irq_nr = 43,  .src = "Timer0"},
> +       {.irq_nr = 44,  .src = "Timer1"},
> +       {.irq_nr = 45,  .src = "UART"},
> +       {.irq_nr = 46,  .src = "GPIO0"},
> +       {.irq_nr = 48,  .src = "MPU_WAKE"},
> +       {.irq_nr = 49,  .src = "WDT0"},
> +       {.irq_nr = 50,  .src = "WDT1"},
> +       {.irq_nr = 51,  .src = "ADC_TSC"},
> +       {.irq_nr = 0,   .src = "Unknown"},
> +};
> 

This seems awfully specific to some SoC version, and not aware of
IRQ domains. It also seems to be only used in a dev_dbg statement,
so I guess you could just kill this off entirely.

> +static struct rproc *wkup_m3_get_rproc(struct device *dev)
> +{
> +       struct device_node *node;
> +       struct rproc *rp;
> +
> +       node = of_parse_phandle(dev->of_node, "ti,rproc", 0);
> +       if (!node)
> +               return NULL;
> +
> +       dev = bus_find_device(&platform_bus_type, NULL, node, match);
> +       if (!dev)
> +               return NULL;
> +
> +       rp = dev_get_drvdata(dev);
> +       return rp;

This is wrong on a number of levels. I suspect what you really want
is an interface exported from drivers/remoteproc that looks up
a 'struct rproc' and performs the necessary reference counting.

That one can just use of_find_node_by_phandle() to get to
a device_node and use that to look up the rproc device in
a linked list it maintains.

	Arnd
