Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3BDSQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:16:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54566 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3BDSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:15:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 4 Feb 2013 19:15:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 12.5/62] firewire: add minor number range check to
 fw_device_init()
Message-ID: <20130204191515.4f629dd6@stein>
In-Reply-To: <20130204165732.GG27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<1359854463-2538-14-git-send-email-tj@kernel.org>
	<20130204165732.GG27963@mtj.dyndns.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 04 Tejun Heo wrote:
> fw_device_init() didn't check whether the allocated minor number isn't
> too large.  Fail if it goes overflows MINORBITS.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Suggested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/firewire/core-device.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/drivers/firewire/core-device.c
> +++ b/drivers/firewire/core-device.c
> @@ -1020,6 +1020,10 @@ static void fw_device_init(struct work_s
>  	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
>  	      idr_get_new(&fw_device_idr, device, &minor) :
>  	      -ENOMEM;
> +	if (minor >= 1 << MINORBITS) {
> +		idr_remove(&fw_device_idr, minor);
> +		minor = -ENOSPC;
> +	}
>  	up_write(&fw_device_rwsem);
>  
>  	if (ret < 0)

Thanks; routing together with the other idr patches through mm Acked-by:
Stefan Richter <stefanr@s5r6.in-berlin.de>

Not totally sure whether to bother -stable with this, as this condition is
rather difficult to provoke.  But since the fix is small and "obvious",
why not.
-- 
Stefan Richter
-=====-===-= --=- --=--
http://arcgraph.de/sr/
