Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3KKIXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:23:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49657 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3KKIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:23:35 -0500
Date: Mon, 11 Nov 2013 09:23:30 +0100
From: Ingo Molnar <mingo@kernel.org>
To: wangbiao <biao.wang@intel.com>
Cc: oneukum@suse.de, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
        william.douglas@intel.com
Subject: Re: [PATCH] usbnet: fix race condition caused spinlock bad magic
 issue
Message-ID: <20131111082330.GA12405@gmail.com>
References: <1384139315.2179.9.camel@wangbiao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384139315.2179.9.camel@wangbiao>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* wangbiao <biao.wang@intel.com> wrote:

> @@ -1448,8 +1448,10 @@ static void usbnet_bh (unsigned long param)
>  
>  	// waiting for all pending urbs to complete?
>  	if (dev->wait) {
> +		wait_queue_head_t *wait_d = dev->wait;
>  		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0) {
> -			wake_up (dev->wait);
> +			if (wait_d)
> +				wake_up(wait_d);
>  		}
>  
>  	// or are we maybe short a few urbs?

1)

Nit: the scope of 'wait_d' is unnecessarily broad, it could be moved to 
the block that uses it.

2)

Also, the changelog mentions that dev->wait can race - it would be nice to 
add to the changelog what exact synchronization mechanism protects 
usbnet_terminate_urbs() and usbnet_bh() from seeing/modifying that value 
at once - as the code was clearly written without such interaction in 
mind.

> @@ -1602,6 +1604,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	init_timer (&dev->delay);
>  	mutex_init (&dev->phy_mutex);
>  	mutex_init(&dev->interrupt_mutex);
> +	init_waitqueue_head(&unlink_wakeup);

3)

Can that runtime initialization be avoided by using 
DECLARE_WAIT_QUEUE_HEAD()?

Thanks,

	Ingo
