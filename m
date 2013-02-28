Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479Ab3B1PRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:17:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38776 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760458Ab3B1PRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:17:03 -0500
Date: Thu, 28 Feb 2013 10:17:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Li Fei <fei.li@intel.com>
cc: gregkh@linuxfoundation.org, <tianyu.lan@intel.com>,
        <sarah.a.sharp@linux.intel.com>, <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chuansheng.liu@intel.com>
Subject: Re: [PATCH 4/5 V2] usb: call pm_runtime_put_sync in pm_runtime_get_sync
 failed case
In-Reply-To: <1362042384.6212.25.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Message-ID: <Pine.LNX.4.44L0.1302281015330.1352-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Li Fei wrote:

> 
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.
> 
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  drivers/usb/core/hub.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 5480352..f72dede 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3148,12 +3148,13 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
>  
>  	if (port_dev->did_runtime_put) {
>  		status = pm_runtime_get_sync(&port_dev->dev);
> -		port_dev->did_runtime_put = false;
>  		if (status < 0) {
>  			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
>  					status);
> +			pm_runtime_put_sync(&port_dev->dev);
>  			return status;
>  		}
> +		port_dev->did_runtime_put = false;
>  	}

I don't see much point in this.  After a failed resume, the port's 
runtime PM status is undefined.  Whether or not you do a 
pm_runtime_put_sync won't make any difference.

Alan Stern

