Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3FCXDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:03:08 -0400
Received: from mx2.parallels.com ([199.115.105.18]:48826 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab3FCXDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:03:05 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Thread-Topic: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Thread-Index: AQHOYKwt0WWCuQi7zEiY91yfnSwWB5klEP6A
Date: Mon, 3 Jun 2013 23:03:01 +0000
Message-ID: <1370300581.2013.14.camel@dabdike.int.hansenpartnership.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
	 <1370301688-27286-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1370301688-27286-1-git-send-email-kys@microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <CCA35D962D415D449099BF7AF5127F5E@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 16:21 -0700, K. Y. Srinivasan wrote:
> The standard scsi timeout is not appropriate in some of the environments where
> Hyper-V is deployed. Set this timeout appropriately for all devices managed
> by this driver. Further make this a module parameter.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 16a3a0c..8d29a95 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -221,6 +221,13 @@ static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
>  module_param(storvsc_ringbuffer_size, int, S_IRUGO);
>  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>  
> +/*
> + * Timeout in seconds for all devices managed by this driver.
> + */
> +static int storvsc_timeout = 180;
> +module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
> +MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
> +
>  #define STORVSC_MAX_IO_REQUESTS				128
>  
>  /*
> @@ -1204,6 +1211,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  
>  	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
>  
> +	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));

Why does this need to be a module parameter?  It's already a sysfs one
in the scsi_device class?  Three minutes is also a bit large.  The
default is 30s with huge cache arrays recommending upping this to
60s ... you're three times this.

James

