Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaGNGQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:16:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaGNGQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:16:14 -0400
Message-ID: <53C375AC.7070609@suse.de>
Date: Mon, 14 Jul 2014 08:16:12 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH V3 3/7] Drivers: scsi: storvsc: Filter commands based
 on the storage protocol version
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-3-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-3-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Going forward it is possible that some of the commands that are not currently
> implemented will be implemented on future Windows hosts. Even if they are not
> implemented, we are told the host will corrrectly handle unsupported
> commands (by returning appropriate return code and sense information).
> Make command filtering depend on the host version.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   16 +++++++++++++---
>   1 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index cebcef7..8f8847e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1553,9 +1553,19 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
>   	struct vmscsi_request *vm_srb;
>   	struct stor_mem_pools *memp = scmnd->device->hostdata;
>
> -	if (!storvsc_scsi_cmd_ok(scmnd)) {
> -		scmnd->scsi_done(scmnd);
> -		return 0;
> +	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
> +		/*
> +		 * On legacy hosts filter unimplemented commands.
> +		 * Future hosts are expected to correctly handle
> +		 * unsupported commands. Furthermore, it is
> +		 * possible that some of the currently
> +		 * unsupported commands maybe supported in
> +		 * future versions of the host.
> +		 */
> +		if (!storvsc_scsi_cmd_ok(scmnd)) {
> +			scmnd->scsi_done(scmnd);
> +			return 0;
> +		}
>   	}
>
>   	request_size = sizeof(struct storvsc_cmd_request);
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
