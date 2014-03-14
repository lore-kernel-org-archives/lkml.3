Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaCNGvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:51:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbaCNGvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:51:44 -0400
Message-ID: <5322A6FE.60209@suse.de>
Date: Fri, 14 Mar 2014 07:51:42 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
CC: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2] scsi: Change sense buffer size to 252
References: <1394776805-6784-1-git-send-email-famz@redhat.com>
In-Reply-To: <1394776805-6784-1-git-send-email-famz@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 07:00 AM, Fam Zheng wrote:
> According to SPC-4, section 4.5.2.1, 252 is the limit of sense data. So
> increase the values.
> 
> Tested by hacking QEMU to fake virtio-scsi request sense len to 252.
> Without this patch the driver stops working immediately when it gets the
> request.
> 
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  include/linux/virtio_scsi.h | 2 +-
>  include/scsi/scsi_cmnd.h    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
> index 4195b97..a437f7f 100644
> --- a/include/linux/virtio_scsi.h
> +++ b/include/linux/virtio_scsi.h
> @@ -28,7 +28,7 @@
>  #define _LINUX_VIRTIO_SCSI_H
>  
>  #define VIRTIO_SCSI_CDB_SIZE   32
> -#define VIRTIO_SCSI_SENSE_SIZE 96
> +#define VIRTIO_SCSI_SENSE_SIZE 252
>  
>  /* SCSI command request, followed by data-out */
>  struct virtio_scsi_cmd_req {
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 91558a1..a64dac03 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -104,7 +104,7 @@ struct scsi_cmnd {
>  	struct request *request;	/* The command we are
>  				   	   working on */
>  
> -#define SCSI_SENSE_BUFFERSIZE 	96
> +#define SCSI_SENSE_BUFFERSIZE 	252
>  	unsigned char *sense_buffer;
>  				/* obtained by REQUEST SENSE when
>  				 * CHECK CONDITION is received on original
> 
Not without careful review.
Blindly increasing the buffersize is not a good idea; this define is
used at several locations and even within the drivers themselves.
So we cannot just increase the define for the SCSI stack.

And, btw, so far I haven't come across any issue where a sense
buffer overflow occurred. We first need to implement a proper sense
code handling (descriptor sense parsing etc) before we need to worry
about this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
