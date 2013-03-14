Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab3CNCq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:46:26 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:44929 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3CNCqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:46:23 -0400
Date: Wed, 13 Mar 2013 19:47:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sergey Yanovich <ynvich@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] wait while adding MMC host to ensure root mounts
Message-ID: <20130314024719.GA9342@kroah.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 05:06:23AM +0400, Sergey Yanovich wrote:
> MMC hosts are added asynchronously. We need to wait until detect returns to
> avoid failed root filesystem mounts.
> ---8<---
> VFS: Cannot open root device "mmcblk0p1" or unknown-block(0,0): error -6
> Please append a correct "root=" boot option; here are the available partitions:
> mmc0: host does not support reading read-only switch. assuming write-enable.
> 1f00             256 mtdblock0  (driver?)
> 1f01             256 mtdblock1  (driver?)
> 1f02            2560 mtdblock2 mmc0: new SDHC card at address b368
>  (driver?)
> 1f03           29696 mtdblock3  (driver?)
> 1f04           16384 mtdblock4 mmcblk0: mmc0:b368 USD   3.72 GiB
>  (driver?)
>  mmcblk0: p1
> b300         3910656 mmcblk0  driver: mmcblk
>   b301         3906560 mmcblk0p1 00000000-01
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> ---8<---
> 
> Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
> ---
>  drivers/base/dd.c       |    1 -
>  drivers/mmc/core/core.c |    4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 218f1e6..61d3e1b 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -345,7 +345,6 @@ int driver_probe_done(void)
>  void wait_for_device_probe(void)
>  {
>  	/* wait for the known devices to complete their probing */
> -
>  	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
>  	async_synchronize_full();
>  }

You didn't need to change this file, please don't.


> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index aaed768..9790323 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -91,10 +91,11 @@ static int mmc_schedule_delayed_work(struct delayed_work *work,
>  /*
>   * Internal function. Flush all scheduled work from the MMC work queue.
>   */
> -static void mmc_flush_scheduled_work(void)
> +void mmc_flush_scheduled_work(void)
>  {
>  	flush_workqueue(workqueue);
>  }
> +EXPORT_SYMBOL(mmc_flush_scheduled_work);

EXPORT_SYMBOL_GPL()?

Wait, why are you exporting it at all?

>  #ifdef CONFIG_FAIL_MMC_REQUEST
>  
> @@ -2225,6 +2226,7 @@ void mmc_start_host(struct mmc_host *host)
>  	host->rescan_disable = 0;
>  	mmc_power_up(host);
>  	mmc_detect_change(host, 0);
> +	mmc_flush_scheduled_work();

If this is the only fix, then you don't need to change it from being
static or need to export it.

Please be more careful when making kernel patches.

greg k-h
