Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3BALuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:50:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:37571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab3BALuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:50:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="279681693"
Message-ID: <510BAC49.7000709@intel.com>
Date: Fri, 01 Feb 2013 19:51:37 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Derek Basehore <dbasehore@chromium.org>
CC: JBottomley@parallels.com, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
In-Reply-To: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Derek,

On 12/21/2012 12:35 PM, Derek Basehore wrote:
> We no longer wait for the disk to spin up in sd_resume. It now enters the
> request to spinup the disk into the elevator and returns.
> 
> A function is scheduled under the scsi_sd_probe_domain to wait for the command
> to spinup the disk to complete. This function then checks for errors and cleans
> up after the sd resume function.
> 
> This allows system resume to complete much faster on systems with an HDD since
> spinning up the disk is a significant portion of resume time.

An alternative way of possibly solving this problem from PM's point of
view might be:
1 Set both ata port and scsi device's runtime status to RPM_SUSPENDED
  in their system suspend callback;
2 On resume, do nothing in their system resume callback;
3 With request based runtime PM introduced here:
  http://thread.gmane.org/gmane.linux.power-management.general/30405
  When a request comes for the HDD after system resume, both the ata
  port and the scsi device will be runtime resumed, which involves
  re-initialize the ata link(in ata port's runtime resume callback) and
  spin up the HDD(in sd's runtime resume callback).

To make HDD un-affetcted by runtime PM during normal use, a large enough
autosuspend_delay can be set for it.

Just my 2 cents, I've not verified or tried in any way yet :-)

Thanks,
Aaron

> 
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> ---
>  drivers/scsi/sd.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/sd.h |    9 ++++
>  2 files changed, 108 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7992635..2fe051f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3045,6 +3045,7 @@ static void sd_shutdown(struct device *dev)
>  	if (!sdkp)
>  		return;         /* this can happen */
>  
> +	async_synchronize_full_domain(&scsi_sd_probe_domain);
>  	if (pm_runtime_suspended(dev))
>  		goto exit;
>  
> @@ -3070,6 +3071,7 @@ static int sd_suspend(struct device *dev)
>  	if (!sdkp)
>  		return 0;	/* this can happen */
>  
> +	async_synchronize_full_domain(&scsi_sd_probe_domain);
>  	if (sdkp->WCE) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
>  		ret = sd_sync_cache(sdkp);
> @@ -3087,20 +3089,110 @@ done:
>  	return ret;
>  }
>  
> +/*
> + * Callback function for when the request that starts the disk completes. Passed
> + * into blk_execute_rq_nowait in sd_resume.
> + */
> +static void sd_end_start_rq(struct request *rq, int error)
> +{
> +	struct completion *waiting = rq->end_io_data;
> +
> +	rq->end_io_data = NULL;
> +	/*
> +	 * Set the end_io_data to NULL before calling complete. This (with
> +	 * sd_resume async) ensures that it is set to NULL before we call
> +	 * blk_put_request.
> +	 */
> +	complete(waiting);
> +}
> +
> +/*
> + * Asynchronous part of sd_resume. This is separate from sd_end_start_rq since
> + * we need to block on resume for suspend and shutdown. We already do this by
> + * synchronizing on the scsi_sd_probe_domain, so use that.
> + */
> +static void sd_resume_async(void *data, async_cookie_t cookie)
> +{
> +	struct scsi_sense_hdr sshdr;
> +	struct resume_async_struct *resume = data;
> +	struct scsi_disk *sdkp = resume->sdkp;
> +	struct request *req = resume->req;
> +
> +	wait_for_completion(&resume->wait);
> +
> +	if (req->errors) {
> +		scsi_normalize_sense(resume->sense,
> +				     SCSI_SENSE_BUFFERSIZE,
> +				     &sshdr);
> +		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
> +		sd_print_result(sdkp, req->errors);
> +		if (driver_byte(req->errors) & DRIVER_SENSE)
> +			sd_print_sense_hdr(sdkp, &sshdr);
> +	}
> +	kfree(resume);
> +	scsi_disk_put(sdkp);
> +	blk_put_request(req);
> +}
> +
> +/*
> + * This does not wait for the disk to spin up. This function enters the request
> + * to spinup the disk and schedules a function, sd_resume_async, that waits for
> + * that request to complete.
> + */
>  static int sd_resume(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
> -	int ret = 0;
> +	struct scsi_device *sdp = sdkp->device;
> +	struct resume_async_struct *resume = NULL;
> +	struct request *req;
> +	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
>  
> -	if (!sdkp->device->manage_start_stop)
> -		goto done;
> +	if (!sdkp->device->manage_start_stop) {
> +		scsi_disk_put(sdkp);
> +		return 0;
> +	}
>  
>  	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> -	ret = sd_start_stop_device(sdkp, 1);
>  
> -done:
> -	scsi_disk_put(sdkp);
> -	return ret;
> +	cmd[4] |= 1;	/* START */
> +
> +	if (sdp->start_stop_pwr_cond)
> +		cmd[4] |= 1 << 4;	/* Active */
> +
> +	if (!scsi_device_online(sdp))
> +		return -ENODEV;
> +
> +	resume = kzalloc(sizeof(struct resume_async_struct), GFP_NOIO);
> +	if (!resume)
> +		return DRIVER_ERROR << 24;
> +
> +	req = blk_get_request(sdp->request_queue, 0, __GFP_WAIT);
> +	if (!req)
> +		return DRIVER_ERROR << 24;
> +
> +	resume->req = req;
> +	resume->sdkp = sdkp;
> +	init_completion(&resume->wait);
> +
> +	req->cmd_len = COMMAND_SIZE(cmd[0]);
> +	memcpy(req->cmd, cmd, req->cmd_len);
> +	req->sense = resume->sense;
> +	req->sense_len = 0;
> +	req->retries = SD_MAX_RETRIES;
> +	req->timeout = SD_TIMEOUT;
> +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> +	req->cmd_flags |= REQ_QUIET | REQ_PREEMPT;
> +	req->end_io_data = &resume->wait;
> +
> +	async_schedule_domain(sd_resume_async, resume, &scsi_sd_probe_domain);
> +	/*
> +	 * don't wait here for the disk to spin up, since we can resume faster
> +	 * if we don't. Cleanup and checking for errors is done the the
> +	 * previously scheduled sd_resume_async function
> +	 */
> +	blk_execute_rq_nowait(req->q, NULL, req, 1, sd_end_start_rq);
> +
> +	return 0;
>  }
>  
>  /**
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 74a1e4c..b09f255 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -1,6 +1,8 @@
>  #ifndef _SCSI_DISK_H
>  #define _SCSI_DISK_H
>  
> +#include <scsi/scsi_cmnd.h>
> +
>  /*
>   * More than enough for everybody ;)  The huge number of majors
>   * is a leftover from 16bit dev_t days, we don't really need that
> @@ -87,6 +89,13 @@ struct scsi_disk {
>  };
>  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
>  
> +struct resume_async_struct {
> +	struct scsi_disk *sdkp;
> +	struct request *req;
> +	struct completion wait;
> +	char sense[SCSI_SENSE_BUFFERSIZE];
> +};
> +
>  static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
>  {
>  	return container_of(disk->private_data, struct scsi_disk, driver);
> 

