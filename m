Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaFEOSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:18:06 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:37224 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFEOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:18:05 -0400
Message-ID: <53907C23.5060404@cogentembedded.com>
Date: Thu, 05 Jun 2014 18:18:11 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>,
        Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: gadgetfs: correct dev state
References: <1401973680-18413-1-git-send-email-marcus.nutzinger@theobroma-systems.com>
In-Reply-To: <1401973680-18413-1-git-send-email-marcus.nutzinger@theobroma-systems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/05/2014 05:08 PM, Marcus Nutzinger wrote:

> Commit 1826e9b1 fixes the use after free of "dev".

    Please also specify that commit's summary line in parens.

> However if this is not the final call to dev_release()
> and the state is not reset to STATE_DEV_DISABLED and
> hence all further open() calls to the gadgetfs ep0
> device will fail with EBUSY.

> So this commit reverts 1826e9b1 and places the call
> put_dev() after setting the state.

> Signed-off-by: Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>
> Reviewed-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
> ---
>   drivers/usb/gadget/inode.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index a925d0c..6330528 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -1264,8 +1264,13 @@ dev_release (struct inode *inode, struct file *fd)
>
>   	kfree (dev->buf);
>   	dev->buf = NULL;
> -	put_dev (dev);
>
> +	/* other endpoints were all decoupled from this device */
> +	spin_lock_irq(&dev->lock);
> +	dev->state = STATE_DEV_DISABLED;
> +	spin_unlock_irq(&dev->lock);

    Not sure I understand why you need spinlock here... isn't the assignment 
atomic already?

> +
> +	put_dev (dev);
>   	return 0;
>   }

WBR, Sergei

