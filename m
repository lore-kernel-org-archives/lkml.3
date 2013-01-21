Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3AULjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:39:08 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:43425 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab3AULjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:39:06 -0500
Message-ID: <50FD28D3.5070107@compulab.co.il>
Date: Mon, 21 Jan 2013 13:38:59 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121218 Thunderbird/10.0.11
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH] usb: musb: fix context save over suspend.
References: <20130121202831.40a09bbc@notabene.brown>
In-Reply-To: <20130121202831.40a09bbc@notabene.brown>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Neil,

On 01/21/13 11:28, NeilBrown wrote:
> 
> 
> The standard suspend sequence involves runtime_resuming
> devices before suspending the system.
> So just saving context in runtime_suspend and restoring it
> in runtime resume isn't enough.  We  must also save in "suspend"
> and restore in "resume".
> 
> Without this patch, and OMAP3 system with off_mode enabled will find
> the musb port non-functional after suspend/resume.  With the patch it
> works perfectly.

Hmmm... Some time ago, this has been removed in
5d193ce8 (usb: musb: PM: fix context save/restore in suspend/resume path)

Am I missing something? Or things changed and now this patch is correct?

> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index fd34867..b6ccc02 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -2225,6 +2225,7 @@ static int musb_suspend(struct device *dev)
>  	}
>  
>  	spin_unlock_irqrestore(&musb->lock, flags);
> +	musb_save_context(musb);
>  	return 0;
>  }
>  
> @@ -2234,6 +2235,8 @@ static int musb_resume_noirq(struct device *dev)
>  	 * unless for some reason the whole soc powered down or the USB
>  	 * module got reset through the PSC (vs just being disabled).
>  	 */
> +	struct musb	*musb = dev_to_musb(dev);
> +	musb_restore_context(musb);
>  	return 0;
>  }
>  

- -- 
Regards,
Igor.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQ/SjTAAoJEBDE8YO64EfaHrsP/2bl4rP6L/tWLSZ+rNEdz6B+
Qo+HVOhnTVsOxgWbbd5VrfhE28jLoFGMslrLuI+geeCcJ1zgwNsahG9C11bygyfu
54hQgkmaxDJPDKAlalcy7VK9C6tOTgQV5iSbuRlemttK879dTrb+33zP6idn5+zK
kxptY38fpmyojnl8gJiVa6Plik/apQcVr+GIx8CMwj+YQC5vkdg7cUEWyngfyk2C
W0U4NceroS8NSjRbcFV3V6Q912TVjKzl+B2yxVD0OBaSK4BpHEncDBXiVx8APq87
4nDeBB5gDXi1rtN3YjcfDaFu0me5qzpYc3JFFidvdLTdXIdvxDzjHgMqsZB8ZBYC
R0e5PtIw/62I90d63JkXZXVRTB7JeZsGfZFY2R7MxBab9or8zz0OyYwGWoW63vzH
oFrwmAkWoD0IEKcfc8+dd99eicgZrmQL6FDWrEMsX+RS34LRtVU30SVAudRhY+CR
MhNCjKyFySwx7wqkGgJl1ECl0Y6U4ua0v4bv7kdE6eyrgbQIkiGliSJ7DhWBPcP6
iMIOTwC7+LwPYP/MX2uYR3DXDfI0XwiqdtyzhD9LJe4PRol8zjozS2j0Y7FriItw
jFqsgCgwDc9j8ufcpXf5ZynJYnlCG0iLuAPEUugZot83/CpxgU++A8cuHqUrOnhH
76L95rflUTkpiQ76ffP7
=jqXb
-----END PGP SIGNATURE-----
