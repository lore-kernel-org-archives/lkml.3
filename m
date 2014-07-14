Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaGNGRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:17:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbaGNGQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:16:57 -0400
Message-ID: <53C375D7.5080608@suse.de>
Date: Mon, 14 Jul 2014 08:16:55 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH 5/7] Drivers: scsi: storvsc: Implement a timedout handler
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-5-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-5-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> On Azure, we have seen instances of unbounded I/O latencies. To deal with
> this issue, implement handler that can reset the timeout. Note that the
> host gaurantees that it will respond to each command that has been issued.
>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   10 ++++++++++
>   1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 7e8a642..3516761 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -33,6 +33,7 @@
>   #include <linux/device.h>
>   #include <linux/hyperv.h>
>   #include <linux/mempool.h>
> +#include <linux/blkdev.h>
>   #include <scsi/scsi.h>
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_host.h>
> @@ -1518,6 +1519,14 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
>   	return SUCCESS;
>   }
>
> +static enum blk_eh_timer_return storvsc_timeout_handler(struct scsi_cmnd *scmnd)
> +{
> +	/*
> +	 * The host will respond; ask for more time.
> +	 */
> +	return BLK_EH_RESET_TIMER;
> +}
> +
>   static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
>   {
>   	bool allowed = true;
> @@ -1697,6 +1706,7 @@ static struct scsi_host_template scsi_driver = {
>   	.bios_param =		storvsc_get_chs,
>   	.queuecommand =		storvsc_queuecommand,
>   	.eh_host_reset_handler =	storvsc_host_reset_handler,
> +	.eh_timed_out =		storvsc_timeout_handler,
>   	.slave_alloc =		storvsc_device_alloc,
>   	.slave_destroy =	storvsc_device_destroy,
>   	.slave_configure =	storvsc_device_configure,
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
