Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3B1IlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:41:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:26772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab3B1IlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:41:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="207221752"
Message-ID: <512F1741.60202@intel.com>
Date: Thu, 28 Feb 2013 16:37:21 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Li Fei <fei.li@intel.com>, stern@rowland.harvard.edu
CC: gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com, rjw@sisk.pl,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: [PATCH 4/5] usb: call pm_runtime_put_sync in pm_runtime_get_sync
 failed case
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>  <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>  <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
In-Reply-To: <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年02月28日 15:57, Li Fei wrote:
> 
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.

Hi Fei:
	It's not necessary. Because the did_runtime_put == true means the
port's usage count has already been decreased during
usb_port_suspend().So to keep usage count balance, we should increase
the usage count in the usb_port_resume() whatever.
	
> 
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  drivers/usb/core/hub.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 5480352..b68493b 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -3152,6 +3152,7 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
>  		if (status < 0) {
>  			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
>  					status);
> +			pm_runtime_put_sync(&port_dev->dev);
>  			return status;
>  		}
>  	}
> 
Hi Alan:
	Further thinking, the device should be disconnected since the port
can't be resumed and the device will not work normally. Something like
following. Does this make sense?
---
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d5d3de4..cf36b11 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3170,6 +3170,7 @@ int usb_port_resume(struct usb_device *udev,
pm_message_t msg)
                if (status < 0) {
                        dev_dbg(&udev->dev, "can't resume usb port,
status %d\n",
                                        status);
+                       hub_port_logical_disconnect(hub, port1);
                        return status;
                }
        }


-- 
Best regards
Tianyu Lan
