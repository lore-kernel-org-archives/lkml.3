Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3A2AWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:22:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3A2AWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:22:40 -0500
Date: Mon, 28 Jan 2013 16:22:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
Message-Id: <20130128162238.7fba92fe.akpm@linux-foundation.org>
In-Reply-To: <1359139768-32294-2-git-send-email-holler@ahsoftware.de>
References: <50F2A310.5010006@ahsoftware.de>
	<1359139768-32294-1-git-send-email-holler@ahsoftware.de>
	<1359139768-32294-2-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 19:49:27 +0100
Alexander Holler <holler@ahsoftware.de> wrote:

> When a device was disconnected the driver may hang at waiting for urbs it never
> will get. Fix this by using a timeout while waiting for the used semaphore.
> 
> There is still a memory leak if a timeout happens, but at least the driver
> now continues his disconnect routine.
> 
> ...
>
> --- a/drivers/video/udlfb.c
> +++ b/drivers/video/udlfb.c
> @@ -1832,8 +1832,9 @@ static void dlfb_free_urb_list(struct dlfb_data *dev)
>  	/* keep waiting and freeing, until we've got 'em all */
>  	while (count--) {
>  
> -		/* Getting interrupted means a leak, but ok at disconnect */
> -		ret = down_interruptible(&dev->urbs.limit_sem);
> +		/* Timeout likely occurs at disconnect (resulting in a leak) */
> +		ret = down_timeout_killable(&dev->urbs.limit_sem,
> +						FREE_URB_TIMEOUT);
>  		if (ret)
>  			break;

This is rather a hack.  Do you have an understanding of the underlying
bug?  Why is the driver waiting for things which will never happen?

