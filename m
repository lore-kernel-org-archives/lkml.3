Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaHVNqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:46:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12271 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaHVNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:46:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Aug 2014 06:32:36 -0700
Message-ID: <53F7499D.7070103@nvidia.com>
Date: Fri, 22 Aug 2014 19:16:05 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] tps65910: Work around silicon erratum SWCZ010
References: <1408709666-5927-1-git-send-email-arnout@mind.be>
In-Reply-To: <1408709666-5927-1-git-send-email-arnout@mind.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2014 05:44 PM, Arnout Vandecappelle (Essensium/Mind) 
wrote:
>  From http://www.ti.com/lit/pdf/SWCZ010 :
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
> The first access to the tps65910 that we do is when loading the regmap
> in the probe function. If there has been a glitch during boot and the
> erratum is triggered, then the regmap loading will fail with -REMOTEIO
> since the I2C transfer is not ACKed by the tps65910.
>
> A simple retry will work around it, because a subsequent I2C start
> condition is detected properly by the tps65910.
>
> Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
> ---
> This patch is based on v3.17-rc1.
> Build-tested with omap2plus_defconfig.
> Runtime tested based on v3.4.97 with a custom config.
> ---
>   drivers/mfd/tps65910.c | 12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index f243e75..cc1ca33 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -487,8 +487,18 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>   	tps65910->id = chip_id;
>   

I think one dummy read of any register unconditionally before regmap 
init will resolve this issue.
Similar issue we face with Palmas TPS65913 and TI recommended to use 
dummy read before any valid transfer.

