Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbaGKTmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:42:40 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52938 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaGKTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:42:38 -0400
Message-ID: <53C03E27.3000003@linaro.org>
Date: Fri, 11 Jul 2014 20:42:31 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 1/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org> <1828880.cILxhDlkNH@amdc1032> <53BFE8F9.7050700@linaro.org> <2632799.IFO1aEjqtg@amdc1032>
In-Reply-To: <2632799.IFO1aEjqtg@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Bartlomiej for the advice,

I will give it a try and see.

On 11/07/14 15:33, Bartlomiej Zolnierkiewicz wrote:
>>>> struct qcom_apq8064_sata_phy {
>>>> > >>+	void __iomem *mmio;
>>>> > >>+	struct clk *cfg_clk;
>>>> > >>+	struct device *dev;
>>>> > >>+};
>>>> > >>+
>>>> > >>+/* Helper function to do poll and timeout */
>>>> > >>+static int read_poll_timeout(void __iomem *addr, u32 mask)
>>>> > >>+{
>>>> > >>+	unsigned long timeout = jiffies + msecs_to_jiffies(TIMEOUT_MS);
>>>> > >>+	u32 val;
>>>> > >>+
>>>> > >>+	do {
>>>> > >>+		cpu_relax();
>>>> > >>+		val = readl_relaxed(addr);
>>>> > >>+		if (val & mask)
>>>> > >>+			break;
>>>> > >>+	} while (!time_after(jiffies, timeout));
>>> > >
>>> > >It would be better to use usleep_[range]() (or even msleep() if needed)
>>> > >instead of just using cpu_relax().
>> >
>> >We really want to poll the register here, usleep/msleep would be useful
>> >if we know already know how much delay is required, but in this case the
>> >its not true.
> I don't mean replacing the whole function, you can still do polling with
> i.e. doing usleep_range(1000, 2000) with 1000 retries.  The advantage of
> doing it this way would be that processor could do some useful work or
> sleep during wait time instead of just busy waiting.
>
> One example of many how to do it:
>
> drivers/i2c/busses/i2c-s3c2410.c:
>
> static bool is_ack(struct s3c24xx_i2c *i2c)
> {
>          int tries;
>
>          for (tries = 50; tries; --tries) {
>                  if (readl(i2c->regs + S3C2410_IICCON)
>                          & S3C2410_IICCON_IRQPEND) {
>                          if (!(readl(i2c->regs + S3C2410_IICSTAT)
>                                  & S3C2410_IICSTAT_LASTBIT))
>                                  return true;
>                  }
>                  usleep_range(1000, 2000);
>          }
>          dev_err(i2c->dev, "ack was not recieved\n");
>          return false;
> }


thanks,
srini
