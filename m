Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbbAWJLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:11:30 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57307 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbAWJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:11:19 -0500
MIME-Version: 1.0
In-Reply-To: <1421950352-26515-1-git-send-email-digetx@gmail.com>
References: <1421950352-26515-1-git-send-email-digetx@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 23 Jan 2015 18:10:58 +0900
Message-ID: <CAAVeFuLLn8L0s7_19TX+RzSY88T0tno4SRguM2ipBe6yWHrgmw@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: tegra: Maintain CPU endianness
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 3:12 AM, Dmitry Osipenko <digetx@gmail.com> wrote:
> Support CPU BE mode by adding endianness conversion for memcpy interactions.
>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
> Changelog:
> v2: For consistency cpu_to_le32() changed to le32_to_cpu() because
>     i2c_writel() takes BE value in BE CPU mode and value is in LE format.
>
>  drivers/i2c/busses/i2c-tegra.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 28b87e6..b5afb9f 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -286,6 +286,7 @@ static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
>         if (rx_fifo_avail > 0 && buf_remaining > 0) {
>                 BUG_ON(buf_remaining > 3);
>                 val = i2c_readl(i2c_dev, I2C_RX_FIFO);
> +               val = cpu_to_le32(val);
>                 memcpy(buf, &val, buf_remaining);
>                 buf_remaining = 0;
>                 rx_fifo_avail--;
> @@ -343,7 +344,9 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
>          */
>         if (tx_fifo_avail > 0 && buf_remaining > 0) {
>                 BUG_ON(buf_remaining > 3);
> +               val = 0;
>                 memcpy(&val, buf, buf_remaining);
> +               val = le32_to_cpu(val);

Ok, with le32_to_cpu() this makes sense now. memcpying part of an int
will keep the lowest byte at the lowest address, so this should work
for little-endian.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
