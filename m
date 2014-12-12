Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030707AbaLLPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:34:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaLLPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:34:04 -0500
Date: Fri, 12 Dec 2014 10:34:02 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@linaro.org>, Bill Huang <bilhuang@nvidia.com>
Cc: vinceh@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] driver core: re-order dpm_list after a succussful probe
Message-ID: <20141212153402.GA4746@kroah.com>
References: <1418385015-26811-1-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418385015-26811-1-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 03:50:15AM -0800, Bill Huang wrote:
> The dpm_list was added in the call "device_add" and when we do defer
> probe we'll explicitly move the probed device to be the last in the
> dpm_list, we should do the same for the normal probe since there are
> cases that we won't have chance to do defer probe to change the PM order
> as the below example.
> 
> If we would like the device driver A to be suspended earlier than the
> device driver B, we won't have chance to do defer probe to fix the
> suspend dependency since at the time device driver A is probed, device B
> was up and running.
> 
> Device A was added
> Device B was added
> Driver for device B was binded
> Driver for device A was binded
> 
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> ---
> 
> It seems to me this is a bug in the core driver, but I'm not sure how should
> we fix it.
> 
> - Do we have better fix?
> - This proposed fix or any other fix might introduces side effect that breaks
>   existing working suspend dependencies which happen to work based on the
>   existing wrong suspend order.
> 
> Any thoughts? Thanks.
> 
>  drivers/base/dd.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index cdc779c..54886d2 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -308,6 +308,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  			goto probe_failed;
>  	}
>  
> +	device_pm_lock();
> +	device_pm_move_last(dev);
> +	device_pm_unlock();
> +
>  	driver_bound(dev);
>  	ret = 1;
>  	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",


Adding Grant, as he did the deferred probe stuff...

And it's the middle of the merge window, I'll not have time to look at
this for a few weeks at the earliest, sorry.

thanks,

greg k-h
