Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbaISNx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:53:58 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:35828 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbaISNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:53:56 -0400
Message-ID: <541C3545.3090700@roeck-us.net>
Date: Fri, 19 Sep 2014 06:53:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
CC: Josh Cartwright <joshc@codeaurora.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] power: reset: use restart_notifier mechanism for msm
 poweroff
References: <1411128415-20381-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1411128415-20381-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.541C3574.0067,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 05:06 AM, Pramod Gurav wrote:
> This change uses replaces use of arm_pm_restart with recently introduced
> reset mechanism in Linux kernel called restart_notifier.
>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Josh Cartwright <joshc@codeaurora.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-pm@vger.kernel.org
>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>
> ---
>
> This patch is tested on DB8074 Target and are based on patchset [1]
> by Guenter Roeck.
>
> [1]: https://patchwork.kernel.org/patch/4746721/
>
>   drivers/power/reset/msm-poweroff.c |   18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
> index 774f9a3..59b368c 100644
> --- a/drivers/power/reset/msm-poweroff.c
> +++ b/drivers/power/reset/msm-poweroff.c
> @@ -24,17 +24,21 @@
>   #include <asm/system_misc.h>
>
>   static void __iomem *msm_ps_hold;
> +static struct notifier_block restart_nb;
>
> -static void do_msm_restart(enum reboot_mode reboot_mode, const char *cmd)
> +static int do_msm_restart(struct notifier_block *nb, unsigned long action,
> +			   void *data)
>   {
>   	writel(0, msm_ps_hold);
>   	mdelay(10000);
> +
> +	return NOTIFY_DONE;
>   }
>
>   static void do_msm_poweroff(void)
>   {
>   	/* TODO: Add poweroff capability */
> -	do_msm_restart(REBOOT_HARD, NULL);
> +	do_msm_restart(&restart_nb, 0, NULL);
>   }
>
>   static int msm_restart_probe(struct platform_device *pdev)
> @@ -47,8 +51,16 @@ static int msm_restart_probe(struct platform_device *pdev)
>   	if (IS_ERR(msm_ps_hold))
>   		return PTR_ERR(msm_ps_hold);
>
> +	restart_nb.notifier_call = do_msm_restart;
> +	restart_nb.priority = 128;

Since the structure is static, you might as well initialize it there
and save a few bytes of code.

> +	if (register_restart_handler(&restart_nb)) {
> +		dev_err(&pdev->dev,
> +			"failed to setup restart handler.\n");

'failed to register ...' might be a bit better wording.

> +			restart_nb.notifier_call = NULL;

No need to set notifier_call to NULL.

> +	}
> +
>   	pm_power_off = do_msm_poweroff;
> -	arm_pm_restart = do_msm_restart;
> +
>   	return 0;
>   }
>
>

