Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaH2Hbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:31:52 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34532 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaH2Hbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:31:51 -0400
Date: Fri, 29 Aug 2014 08:31:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
Message-ID: <20140829073145.GC24579@lee--X1>
References: <1408709666-5927-1-git-send-email-arnout@mind.be>
 <1408721456-8101-1-git-send-email-arnout@mind.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408721456-8101-1-git-send-email-arnout@mind.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Arnout Vandecappelle (Essensium/Mind) wrote:

> From http://www.ti.com/lit/pdf/SWCZ010 :
> 
> Glitch on SDA-SCL not managed correctly by the I2C IP
> 
> Impact:
> The standard specifies that the I2C transfer should restart on a start
> event in all cases. The current design does not support two consecutive
> Start conditions. This can cause the first real access after such a
> glitch to be corrupted.
> 
> Description:
> An unexpected glitch on SDA and SCL can generate a wrong start event.
> In the current design, the SCL line must toggle two times to detect a
> new start event and completely restart the I2C access; hence the real
> start event is not detected in the case of a single SCL toggle.
> 
> Workaround:
> Repeat I2C access.
> 
> A simpler workaround is to make a dummy transfer just before the first
> access to the tps65910 chip. This can be done unconditionally.
> 
> Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
> ---
> This patch is based on v3.17-rc1.
> Build-tested with omap2plus_defconfig.
> Runtime tested based on v3.4.97 with a custom config.
> 
> v2: use dummy transfer instead of retrying (Laxman Dewangan)
> ---
>  drivers/mfd/tps65910.c | 5 +++++
>  1 file changed, 5 insertions(+)

Applied with Mark's Ack.

> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index f243e75..7612d89 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -486,6 +486,11 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	tps65910->i2c_client = i2c;
>  	tps65910->id = chip_id;
>  
> +	/* Work around silicon erratum SWCZ010: the tps65910 may miss the
> +	 * first I2C transfer. So issue a dummy transfer before the first
> +	 * real transfer.
> +	 */
> +	i2c_master_send(i2c, "", 1);
>  	tps65910->regmap = devm_regmap_init_i2c(i2c, &tps65910_regmap_config);
>  	if (IS_ERR(tps65910->regmap)) {
>  		ret = PTR_ERR(tps65910->regmap);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
