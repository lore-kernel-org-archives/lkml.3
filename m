Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaGNGP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:15:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaGNGPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:15:20 -0400
Message-ID: <53C37575.5030808@suse.de>
Date: Mon, 14 Jul 2014 08:15:17 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH V3 1/7] Drivers: scsi: storvsc: Change the limits to reflect
 the values on the host
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> Hyper-V hosts can support multiple targets and multiple channels and larger number of
> LUNs per target. Update the code to reflect this. With this patch we can correctly
> enumerate all the paths in a multi-path storage environment.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |   47 +++++++++++++++++++++++++++++---------------
>   1 files changed, 31 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 9969fa1..8938b13 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -330,17 +330,17 @@ static int storvsc_timeout = 180;
>
>   static void storvsc_on_channel_callback(void *context);
>
> -/*
> - * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
> - * reality, the path/target is not used (ie always set to 0) so our
> - * scsi host adapter essentially has 1 bus with 1 target that contains
> - * up to 256 luns.
> - */
> -#define STORVSC_MAX_LUNS_PER_TARGET			64
> -#define STORVSC_MAX_TARGETS				1
> -#define STORVSC_MAX_CHANNELS				1
> +#define STORVSC_MAX_LUNS_PER_TARGET			255
> +#define STORVSC_MAX_TARGETS				2
> +#define STORVSC_MAX_CHANNELS				8
>
> +#define STORVSC_FC_MAX_LUNS_PER_TARGET			255
> +#define STORVSC_FC_MAX_TARGETS				128
> +#define STORVSC_FC_MAX_CHANNELS				8
>
> +#define STORVSC_IDE_MAX_LUNS_PER_TARGET			64
> +#define STORVSC_IDE_MAX_TARGETS				1
> +#define STORVSC_IDE_MAX_CHANNELS			1
>
>   struct storvsc_cmd_request {
>   	struct list_head entry;
Limiting max_lun to 255 will make the driver to _not_ respond to 
LUNs higher than that; ie Well-known LUN won't work here.
Also the SCSI stack will be using REPORT LUNS anyway since you're 
advertising SPC-2 compliance. So your driver runs into issues if 
Hyper-V would ever return more than 256 LUNs with the REPORT LUN 
command or if any of the LUNs has an addressing scheme other than
'0x00'.
I would suggest to raise this to the technical limit (ie the largest 
LUN which the _protocol_ supports) and let REPORT LUNS deal with the 
actual LUNs.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
