Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaK1KO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:14:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaK1KO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:14:56 -0500
Message-ID: <54784B1D.6030308@suse.de>
Date: Fri, 28 Nov 2014 11:14:53 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com,
        jbottomley@parallels.com, dan.carpenter@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1.1 1/1]  arcmsr: Notify has sense data report
References: <1417169252.25477.11.camel@Centos6.3-64>
In-Reply-To: <1417169252.25477.11.camel@Centos6.3-64>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 11:07 AM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
> 
> Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' if we have sense data.
> 
> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> ---
> 
> This patch is relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr
> 
> 
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2014-09-19 11:04:41.845100000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-11-28 10:54:30.000000000 +0800
> @@ -52,7 +52,7 @@ struct device_attribute;
>  	#define ARCMSR_MAX_FREECCB_NUM	320
>  #define ARCMSR_MAX_OUTSTANDING_CMD	255
>  #endif
> -#define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140919"
> +#define ARCMSR_DRIVER_VERSION		"v1.30.00.05-20141128"
>  #define ARCMSR_SCSI_INITIATOR_ID						255
>  #define ARCMSR_MAX_XFER_SECTORS							512
>  #define ARCMSR_MAX_XFER_SECTORS_B						4096
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-09-19 11:01:26.990090000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-11-28 17:51:04.000000000 +0800
> @@ -989,16 +989,15 @@ static void arcmsr_report_sense_info(str
>  
>  	struct scsi_cmnd *pcmd = ccb->pcmd;
>  	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
> -	pcmd->result = DID_OK << 16;
> -	if (sensebuffer) {
> -		int sense_data_length =
> +
> +	pcmd->result = (DRIVER_SENSE << 24) | (DID_OK << 16) | (CHECK_CONDITION << 1);
> +	int sense_data_length =
>  			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
>  			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
> -		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
> -		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
> -		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
> -		sensebuffer->Valid = 1;
> -	}
> +	memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
> +	memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
> +	sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
> +	sensebuffer->Valid = 1;
>  }
>  
>  static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
> 
> 
Hmm. Sorry to be picky, but:

Is there a chance the _no_ sense data will be provided?
If so we'd end up starting the error handler, calling REQUEST SENSE
(which will fail, too), and finally offlining the device.
I'd rather provide a default sense code for these cases.

Plus please use SAM_STAT_CHECK_CONDITION instead of
CHECK_CONDITION << 1.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)
