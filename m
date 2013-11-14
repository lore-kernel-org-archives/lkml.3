Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3KNH6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 02:58:50 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41545 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3KNH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 02:58:41 -0500
Date: Thu, 14 Nov 2013 08:58:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: wangbiao <biao.wang@intel.com>
Cc: oneukum@suse.de, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com, di.zhang@intel.com
Subject: Re: [PATCH V3] usbnet: fix race condition caused spinlock bad magic
 issue
Message-ID: <20131114075837.GA7292@gmail.com>
References: <1384394595.4229.24.camel@wangbiao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384394595.4229.24.camel@wangbiao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* wangbiao <biao.wang@intel.com> wrote:

> @@ -86,6 +86,7 @@ static const char driver_name [] = "usbnet";
>  
>  /* use ethtool to change the level for any given device */
>  static int msg_level = -1;
> +static spinlock_t dev_wait_lock = __SPIN_LOCK_UNLOCKED(dev_wait_lock);
>  module_param (msg_level, int, 0);
>  MODULE_PARM_DESC (msg_level, "Override default message level");
>  

> @@ -1447,13 +1454,18 @@ static void usbnet_bh (unsigned long param)
>  	clear_bit(EVENT_RX_KILL, &dev->flags);
>  
>  	// waiting for all pending urbs to complete?

Please escape this code from the clutches of C++ style!

> +	spin_lock_irqsave(&dev_wait_lock, flags);
>  	if (dev->wait) {
>  		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0) {
> -			wake_up (dev->wait);
> +			wake_up(dev->wait);
>  		}
> +		spin_unlock_irqrestore(&dev_wait_lock, flags);
> +		return;
> +	}
> +	spin_unlock_irqrestore(&dev_wait_lock, flags);

The extra locking and the naked return from the middle of the 
control flow is a bit sad.

>  
>  	// or are we maybe short a few urbs?
> -	} else if (netif_running (dev->net) &&
> +	if (netif_running(dev->net) &&
>  		   netif_device_present (dev->net) &&
>  		   netif_carrier_ok(dev->net) &&
>  		   !timer_pending (&dev->delay) &&

While using a global spinlock from the probe/teardown methods is 
probably not a big deal, using it in usbnet_bh() looks rather 
unfortunate for performance and scalability of this driver.

I don't know the usbnet code at all, but is there really no 
natural per device synchronization method available for such 
cases? Could the race be avoided some other way? How do other 
drivers implement such kind of dev->wait handling?

Thanks,

	Ingo
