Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbaICOaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:30:11 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:42744 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbaICOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:30:09 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 10:30:08 EDT
Date: Wed, 3 Sep 2014 16:22:50 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Imre Palik <imrep.amz@gmail.com>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH] drbd: fix throttling on newly created DM backing devices
Message-ID: <20140903142250.GE2958@soda.linbit>
Mail-Followup-To: Imre Palik <imrep.amz@gmail.com>,
	drbd-dev@lists.linbit.com,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
	Matt Wilson <msw@amazon.com>
References: <1409749356-5450-1-git-send-email-imrep.amz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409749356-5450-1-git-send-email-imrep.amz@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 03:02:36PM +0200, Imre Palik wrote:
> From: "Palik, Imre" <imrep@amazon.de>
> 
> If the drbd backing device is a new device mapper device (e.g., a
> dm-linear mapping of an existing block device that contains data), the
> counters are initially 0 even though the device contains useful
> data. This causes throttling until something accesses the drbd device
> or the backing device.
> 
> The patch disables throttling, as long as only resync is responsible
> for disk activity on a freshly created device.

You are right, the !device->rs_last_events was supposed to be an
indicator of "just started resync, please call once to initialize".
But if curr_events stays 0, which is quite possible given the bursty
nature of the DRBD resync, that will stay 0, and keep throttling.

I'm not sure I like your patch, though.
We may want to properly initialize rs_last_events instead.

I'll think about that...

	Lars Ellenberg

> Reported-by: Mikhail Sugakov <msugakov@amazon.de>
> Cc: Matt Wilson <msw@amazon.com>
> Signed-off-by: Imre Palik <imrep@amazon.de>
> ---
>  drivers/block/drbd/drbd_receiver.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
> index 9342b8d..511d2eb 100644
> --- a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -2482,7 +2482,8 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
>  			atomic_read(&device->rs_sect_ev);
>  
>  	if (atomic_read(&device->ap_actlog_cnt)
> -	    || !device->rs_last_events || curr_events - device->rs_last_events > 64) {
> +		|| (curr_events && (!device->rs_last_events
> +					|| curr_events - device->rs_last_events > 64))) {
>  		unsigned long rs_left;
>  		int i;
>  
> -- 
> 1.7.9.5
> 
