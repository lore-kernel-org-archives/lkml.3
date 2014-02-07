Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaBGSQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:16:06 -0500
Received: from nm21-vm8.access.bullet.mail.gq1.yahoo.com ([216.39.63.229]:30385
	"EHLO nm21-vm8.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbaBGSQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:16:04 -0500
X-Yahoo-Newman-Id: 469407.39665.bm@smtp117.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y5kWQKAVM1kNkvlZ3wZrEAUE59aucAK4ma2bigu_9q5pbGE
 zkH4933LbVnaytbwyqHIq3gYlElBuQcD_975aTXtuELF9Fw1s5yu0aWVbjKw
 V.GFdn915OelpQ6w2EkaSu.VsnYgXshCFe.RU._UH_bXqcJ7C3y3G3uh3glC
 VakstGV2J89M0SP.iqQUQu03w2PQ2hY3pps4dqwtACFo6P.eVvaBeg6p2K3o
 cYPZPB3UNUFQ2p7049I2sbaYmXA63gzr3tVdYX9Lh1RRn.I_2zj8vTo9CHG8
 qbWJhkH1tKnCUfvLOOylqRvoGiXlNXn4QNtdg4TQxc9pFGpATZihhvMEesD8
 a.kOuZueSoQsP7z02yVgQHihVXeBLE4boY6glJhCT1eEB6T_74SHQrDAXL6c
 mfSXgcTmiMUb.3J6zzE3mEY0J.hgaSdT9q3EXQRVWSiB_RI242NndKOTM66I
 TyZYI2K.qBs68U2hm440tipjsaa1QIm0MaUzmwx7jIrO3dJy8jU_.dyO2vJ5
 QgVlDu0s1r2_wdD8bIh_ukTG8NPjf9JdYfx4-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain [98.138.31.74])
        by smtp117.sbc.mail.ne1.yahoo.com with SMTP; 07 Feb 2014 18:16:02 +0000 UTC
Message-ID: <52F5234B.404@att.net>
Date: Fri, 07 Feb 2014 12:17:47 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
CC: Daniel Santos <daniel.santos@pobox.com>, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 3.5 36/88] spidev: fix hang when transfer_one_message
 fails
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com> <1391772205-22239-37-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <1391772205-22239-37-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 05:22 AM, Luis Henriques wrote:
> 3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Daniel Santos <daniel.santos@pobox.com>
>
> commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d upstream.
>
> This corrects a problem in spi_pump_messages() that leads to an spi
> message hanging forever when a call to transfer_one_message() fails.
> This failure occurs in my MCP2210 driver when the cs_change bit is set
> on the last transfer in a message, an operation which the hardware does
> not support.
>
> Rationale
> Since the transfer_one_message() returns an int, we must presume that it
> may fail.  If transfer_one_message() should never fail, it should return
> void.  Thus, calls to transfer_one_message() should properly manage a
> failure.
>
> Fixes: ffbbdd21329f3 (spi: create a message queueing infrastructure)
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>   drivers/spi/spi.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 1041cb8..40f528b 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -574,7 +574,9 @@ static void spi_pump_messages(struct kthread_work *work)
>   	ret = master->transfer_one_message(master, master->cur_msg);
>   	if (ret) {
>   		dev_err(&master->dev,
> -			"failed to transfer one message from queue\n");
> +			"failed to transfer one message from queue: %d\n", ret);
> +		master->cur_msg->status = ret;
> +		spi_finalize_current_message(master);
>   		return;
>   	}
>   }

This isn't a good patch and is reverted by a later patch. I'm not sure 
what the protocol for this is, but either skip this patch or include the 
one that reverts it.

Daniel

