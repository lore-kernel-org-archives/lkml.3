Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaGNGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:16:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaGNGQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:16:40 -0400
Message-ID: <53C375C6.8060703@suse.de>
Date: Mon, 14 Jul 2014 08:16:38 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH V3 4/7] Drivers: scsi: storvsc: Fix a bug in handling
 VMBUS protocol version
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-4-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-4-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Based on the negotiated VMBUS protocol version, we adjust the size of the storage
> protocol messages. The two sizes we currently handle are pre-win8 and post-win8.
> In WS2012 R2, we are negotiating higher VMBUS protocol version than the win8
> version. Make adjustments to correctly handle this.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   17 ++++++++++-------
>   1 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8f8847e..7e8a642 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1752,19 +1752,22 @@ static int storvsc_probe(struct hv_device *device,
>   	 * set state to properly communicate with the host.
>   	 */
>
> -	if (vmbus_proto_version == VERSION_WIN8) {
> -		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
> -		vmscsi_size_delta = 0;
> -		vmstor_current_major = VMSTOR_WIN8_MAJOR;
> -		vmstor_current_minor = VMSTOR_WIN8_MINOR;
> -	} else {
> +	switch (vmbus_proto_version) {
> +	case VERSION_WS2008:
> +	case VERSION_WIN7:
>   		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
>   		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
>   		vmstor_current_major = VMSTOR_WIN7_MAJOR;
>   		vmstor_current_minor = VMSTOR_WIN7_MINOR;
> +		break;
> +	default:
> +		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
> +		vmscsi_size_delta = 0;
> +		vmstor_current_major = VMSTOR_WIN8_MAJOR;
> +		vmstor_current_minor = VMSTOR_WIN8_MINOR;
> +		break;
>   	}
>
> -
>   	if (dev_id->driver_data == SFC_GUID)
>   		scsi_driver.can_queue = (STORVSC_MAX_IO_REQUESTS *
>   					 STORVSC_FC_MAX_TARGETS);
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
