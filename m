Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaIVQLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:11:45 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:61074 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaIVQLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:11:43 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 22 Sep 2014 18:08:44 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140922160844.GK5237@localhost>
References: <1411397212-31625-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411397212-31625-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 05:46:52PM +0300, Octavian Purdila wrote:
> Currently the I/O buffer is allocated part of the device status
> structure, potentially sharing the same cache line with other members
> in this structure.
> 
> Allocate the buffer separately, to avoid the I/O operations corrupting
> the device status structure due to cache line sharing.
> 
> Compiled tested only, as I don't have access to hardware.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---

Change itself looks sane, although the driver's use of a shared buffer
and relying on undocumented locking is a different story.

However, you do more than your commit message claims below.

>  drivers/mfd/viperboard.c       | 16 ++++++++++------
>  include/linux/mfd/viperboard.h |  2 +-
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index e00f534..d27c131 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -59,9 +59,13 @@ static int vprbrd_probe(struct usb_interface *interface,
>  
>  	/* allocate memory for our device state and initialize it */
>  	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
> -	if (vb == NULL) {
> -		dev_err(&interface->dev, "Out of memory\n");

Here you're also removing a redundant OOM message.

> +	if (vb == NULL)
>  		return -ENOMEM;
> +
> +	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
> +	if (vb->buf == NULL) {
> +		ret = -ENOMEM;
> +		goto error;
>  	}
>  
>  	mutex_init(&vb->lock);
> @@ -103,10 +107,9 @@ static int vprbrd_probe(struct usb_interface *interface,
>  	return 0;
>  
>  error:
> -	if (vb) {

And cleaning up the error path.

> -		usb_put_dev(vb->usb_dev);
> -		kfree(vb);
> -	}
> +	usb_put_dev(vb->usb_dev);
> +	kfree(vb->buf);
> +	kfree(vb);
>  
>  	return ret;
>  }

Don't mix fixes and clean ups like this, but rather submit them as
separate patches.

Johan
