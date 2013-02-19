Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab3BSNL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:11:26 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34349 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409Ab3BSNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:11:25 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1155h)
Message-ID: <512379AC.6010304@analog.com>
Date: Tue, 19 Feb 2013 14:10:04 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd:adp5520: Restore mode bits on resume
References: <1361271082-29905-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1361271082-29905-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:51 AM, Lars-Peter Clausen wrote:
> The adp5520 unfortunately also clears the BL_EN bit when the nSTNDBY bit is
> cleared. So we need to make sure to restore it during resume if it was set
> before suspend.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/mfd/adp5520.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index 210dd03..6b40e0c 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -36,6 +36,7 @@ struct adp5520_chip {
>   	struct blocking_notifier_head notifier_list;
>   	int irq;
>   	unsigned long id;
> +	uint8_t mode;
>   };
>   
>   static int __adp5520_read(struct i2c_client *client,
> @@ -326,7 +327,10 @@ static int adp5520_suspend(struct device *dev)
>   	struct i2c_client *client = to_i2c_client(dev);
>   	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
>   
> -	adp5520_clr_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
> +	adp5520_read(chip->dev, ADP5520_MODE_STATUS, &chip->mode);
> +	/* All other bits are W1C */
> +	chip->mode &= ADP5520_BL_EN | ADP5520_DIM_EN | ADP5520_nSTNBY;
> +	adp5520_write(chip->dev, ADP5520_MODE_STATUS, 0);
>   	return 0;
>   }
>   
> @@ -335,7 +339,7 @@ static int adp5520_resume(struct device *dev)
>   	struct i2c_client *client = to_i2c_client(dev);
>   	struct adp5520_chip *chip = dev_get_drvdata(&client->dev);
>   
> -	adp5520_set_bits(chip->dev, ADP5520_MODE_STATUS, ADP5520_nSTNBY);
> +	adp5520_write(chip->dev, ADP5520_MODE_STATUS, chip->mode);
>   	return 0;
>   }
>   #endif


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


