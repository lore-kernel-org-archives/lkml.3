Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaF3JBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:01:20 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaF3JBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:01:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Zhou Wang <wangzhou.bry@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Pekon Gupta <pekon@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Joern Engel <joern@logfs.org>, Randy Dunlap <rdunlap@infradead.org>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        caizhiyong@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH 2/3] mtd: hisilicon: add a new nand controller driver for hisilicon hip04 Soc
Date: Mon, 30 Jun 2014 11:00:41 +0200
Message-ID: <6920327.DpBe6vKVPa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404115409-20200-3-git-send-email-wangzhou.bry@gmail.com>
References: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com> <1404115409-20200-3-git-send-email-wangzhou.bry@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U6MkAndA9baTwEJkZsSS4UKajQq3iSYFB1xll7MBj/c
 B/DCQHHTNsF3Z+hnCjw80nnj+K38ng1Hc2ZnspQZ3gc/kmp4A5
 /CTWUcXWLF5JuFqctDeiq4fIMbHiNYdDhRg3rmX9ztzHKkYxks
 Iu4MddoQXf65hVIgqnKNQ2ggqfX0opnd8rYyb6qpwSJo7qWMnu
 RfmMSfvXFMP8z9SFcUQr8VTNmXCS0iYoNviK07Anui4b9r7sDR
 9YKevsdmLW/NbSMrsIMrf06R1yRJJoxneXp1XgWKN7oD+mqDeF
 u1S1LP8tNy56SULCaGIt2UcfTzcyqUPJE6WXTxxB5/UdJXP5H/
 ImpsTQhLLkmtUtZCMxEE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall a very nice driver. I didn't find any real bugs, but a few things
that could be changed for readability and micro-optimizations:

On Monday 30 June 2014 16:03:28 Zhou Wang wrote:

> +#define hinfc_read(_host, _reg)	readl(_host->iobase + (_reg))
> +#define hinfc_write(_host, _value, _reg)\
> +	writel((_value), _host->iobase + (_reg))

I'd recommend making these inline functions rather than macros.

> +struct hinfc_host {
> +	struct nand_chip	*chip;
> +	struct mtd_info		*mtd;

I notice that you allocate the nand_chip and mtd_info together
with the hinfc_host and then assign these pointers. A preferred
method is normally to just embed the structures in this case:

struct hinfc_host {
	struct nand_chip	chip;
	struct mtd_info		mtd;

so you avoid the pointer overhead, and can go back from these
two structures to the hinfc_host using container_of().

> +	struct device		*dev;
> +	void __iomem		*iobase;
> +	struct completion       cmd_complete;
> +	unsigned int		offset;
> +	unsigned int		command;
> +	int			chipselect;
> +	unsigned int		addr_cycle;
> +	unsigned int		addr_value[2];
> +	unsigned int		cache_addr_value[2];
> +	char			*buffer;
> +	dma_addr_t		dma_buffer;
> +	dma_addr_t		dma_oob;
> +	int			version;
> +	unsigned int            ecc_bits;
> +	unsigned int            irq_status; /* interrupt status */
> +
> +	int (*send_cmd_pageprog)(struct hinfc_host *host);
> +	int (*send_cmd_status)(struct hinfc_host *host);
> +	int (*send_cmd_readstart)(struct hinfc_host *host);
> +	int (*send_cmd_erase)(struct hinfc_host *host);
> +	int (*send_cmd_readid)(struct hinfc_host *host);
> +	int (*send_cmd_reset)(struct hinfc_host *host, int chipselect);
> +};

Why do you need function pointers here? The current version of the
driver you posted always assigns these to the same functions, so
it would be more efficient to just call those directly.

If you plan to add another variant later that uses a different set
of functions here, you can add the function pointers then, in a
separate patch. Also, a common style element is to have a separate
constant structure with the function pointers:

const struct hinfc_host_ops ops = {
	.send_cmd_pageprog = hisi_nfc_send_cmd_pageprog,
	...
};

if you actually end up needing function pointers. That simplifies
the code a bit and is slightly more robust to attacks overwriting
the function pointers.

> +
> +void wait_controller_finished(struct hinfc_host *host)
> +{
> +	unsigned long timeout = jiffies + HINFC504_NFC_TIMEOUT;
> +	int val;
> +
> +	while (time_before(jiffies, timeout)) {
> +		val = hinfc_read(host, HINFC504_STATUS);
> +		if (host->command == NAND_CMD_ERASE2) {
> +			/* nfc is ready */
> +			while (!(val & HINFC504_READY))	{
> +				usleep_range(500, 1000);
> +				val = hinfc_read(host, HINFC504_STATUS);
> +			}
> +			return;
> +		} else {
> +			if (val & HINFC504_READY)
> +				return;
> +		}
> +	}
> +
> +	/* wait cmd timeout */
> +	dev_err(host->dev, "Wait NAND controller exec cmd timeout.\n");
> +}

Since the timeout is much bigger than the wait time here, I guess you
can use a wider range for the usleep_range(), e.g.

	usleep_range(500, 50000);

which is nicer to other tasks. You will normally be woken up much earlier.

	Arnd
