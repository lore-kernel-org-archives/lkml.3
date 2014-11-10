Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaKJJI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:08:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaKJJIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:08:25 -0500
Message-ID: <1415610506.16488.20.camel@linux-0dmf.site>
Subject: Re: [PATCH] brcmfmac: unlink URB when request timed out
From: Oliver Neukum <oneukum@suse.de>
To: Mathy Vanhoef <vanhoefm@gmail.com>
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
        meuleman@broadcom.com, linville@tuxdriver.com, pieterpg@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 10:08:26 +0100
In-Reply-To: <545FAE05.2030701@gmail.com>
References: <545FAE05.2030701@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 13:10 -0500, Mathy Vanhoef wrote:
> From: Mathy Vanhoef <vanhoefm@gmail.com>
> 
> Unlink the submitted URB in brcmf_usb_dl_cmd if the request timed out. This
> assures the URB is never submitted twice, preventing a driver crash.

Hi,

I am afrad this patch is no good. The diagnosis is good,
but the fix introduces serious problems.

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> index 5265aa7..1bc7858 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> @@ -738,10 +738,12 @@ static int brcmf_usb_dl_cmd(struct brcmf_usbdev_info *devinfo, u8 cmd,
>  		goto finalize;
>  	}
>  
> -	if (!brcmf_usb_ioctl_resp_wait(devinfo))
> +	if (!brcmf_usb_ioctl_resp_wait(devinfo)) {
> +		usb_unlink_urb(devinfo->ctl_urb);

This is the asynchronous unlink. You have no guarantee it is finished
after this point.

>  		ret = -ETIMEDOUT;
> -	else
> +	} else {
>  		memcpy(buffer, tmpbuf, buflen);
> +	}
>  
>  finalize:
>  	kfree(tmpbuf);

Which means that you are freeing memory that may still be used by DMA
at this time.
In addition you have no guarantee that the unlink is indeed finished
by the time the URB is reused.
If you wish to take this approach you better forget about this URB
and allocate a new one and free the buffer from the callback.

	Regards
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

