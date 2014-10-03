Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaJCHpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 03:45:38 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18961 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaJCHpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 03:45:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 03 Oct 2014 00:44:20 -0700
Message-ID: <542E5421.5070708@nvidia.com>
Date: Fri, 3 Oct 2014 15:45:37 +0800
From: Joseph Lo <josephl@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] serial: of-serial: add PM suspend/resume support
References: <1411461252-8730-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1411461252-8730-1-git-send-email-jingchang.lu@freescale.com>
X-Originating-IP: [10.19.108.115]
X-ClientProxiedBy: HKMAIL103.nvidia.com (10.18.16.12) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch might have a potential issue that cause system hard hung 
immediately when it accesses to registers with no clock. This could 
happen on many chips that mainline kernel supporting with the setting 
"no_console_suspend=1" during suspend time.

On 09/23/2014 04:34 PM, Jingchang Lu wrote:
> This adds PM suspend/resume support for the of-serial driver
> to provide power management support on devices attatched to it.
>
> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
>   drivers/tty/serial/of_serial.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
> index 27981e2..8bc2563 100644
> --- a/drivers/tty/serial/of_serial.c
> +++ b/drivers/tty/serial/of_serial.c
> @@ -240,6 +240,32 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
>   	return 0;
>   }
>
> +#ifdef CONFIG_PM_SLEEP
> +static int of_serial_suspend(struct device *dev)
> +{
> +	struct of_serial_info *info = dev_get_drvdata(dev);
> +
> +	serial8250_suspend_port(info->line);
> +	if (info->clk)
The fix would be something like this.
	if (info->clk && console_suspend_enabled)

> +		clk_disable_unprepare(info->clk);
> +
> +	return 0;
> +}
> +
> +static int of_serial_resume(struct device *dev)
> +{
> +	struct of_serial_info *info = dev_get_drvdata(dev);
> +
> +	if (info->clk)
Ditto.

Thanks,
-Joseph
> +		clk_prepare_enable(info->clk);
> +
> +	serial8250_resume_port(info->line);
> +
> +	return 0;
> +}
> +#endif
> +static SIMPLE_DEV_PM_OPS(of_serial_pm_ops, of_serial_suspend, of_serial_resume);
> +
>   /*
>    * A few common types, add more as needed.
>    */
> @@ -271,6 +297,7 @@ static struct platform_driver of_platform_serial_driver = {
>   		.name = "of_serial",
>   		.owner = THIS_MODULE,
>   		.of_match_table = of_platform_serial_table,
> +		.pm = &of_serial_pm_ops,
>   	},
>   	.probe = of_platform_serial_probe,
>   	.remove = of_platform_serial_remove,
>
