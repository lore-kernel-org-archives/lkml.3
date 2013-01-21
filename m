Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3AUVix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:38:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3AUVit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:38:49 -0500
Date: Tue, 22 Jan 2013 08:38:32 +1100
From: NeilBrown <neilb@suse.de>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH] usb: musb: fix context save over suspend.
Message-ID: <20130122083832.7a3026c9@notabene.brown>
In-Reply-To: <50FD28D3.5070107@compulab.co.il>
References: <20130121202831.40a09bbc@notabene.brown>
	<50FD28D3.5070107@compulab.co.il>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0LLcrIh023676

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, 21 Jan 2013 13:38:59 +0200 Igor Grinberg <grinberg@compulab.co.il>
wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Neil,
> 
> On 01/21/13 11:28, NeilBrown wrote:
> > 
> > 
> > The standard suspend sequence involves runtime_resuming
> > devices before suspending the system.
> > So just saving context in runtime_suspend and restoring it
> > in runtime resume isn't enough.  We  must also save in "suspend"
> > and restore in "resume".
> > 
> > Without this patch, and OMAP3 system with off_mode enabled will find
> > the musb port non-functional after suspend/resume.  With the patch it
> > works perfectly.
> 
> Hmmm... Some time ago, this has been removed in
> 5d193ce8 (usb: musb: PM: fix context save/restore in suspend/resume path)
> 
> Am I missing something? Or things changed and now this patch is correct?

Hi Igor,
 thanks for alerting me to that patch .... does anyone else get the feeling
 that power management to too complex to be understood by a mere human?

 That commit (5d193ce8) suggests that the musb-hdrc device is an
 'omap_device', or maybe has a PM domain set to something else.
 However it isn't/doesn't.  dev->pm_domain is NULL.  So no PM domain layer
 will ever call the musb_core musb_runtime_suspend/resume.

 The parent device - musb-omap2430 - is an omap device, does have pm_domain
 set, and does have its omap2430_runtime_suspend/resume called for system
 suspend and so the context for that device is saved and restored.
 However that doesn't help the context for musb-hdrc.

 Whether musb ever was an omap_device is beyond my archaeological skills to
 determine.

 Kevin:  Was musb-hdrc ever a device with a pm_domain? or was it only ever
     the various possible parents that had domains?
     Are you able to defend your earlier patch in today's kernel?  It
     certainly causes my device not to work properly.

Thanks,
NeilBrown



> 
> > 
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > 
> > diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> > index fd34867..b6ccc02 100644
> > --- a/drivers/usb/musb/musb_core.c
> > +++ b/drivers/usb/musb/musb_core.c
> > @@ -2225,6 +2225,7 @@ static int musb_suspend(struct device *dev)
> >  	}
> >  
> >  	spin_unlock_irqrestore(&musb->lock, flags);
> > +	musb_save_context(musb);
> >  	return 0;
> >  }
> >  
> > @@ -2234,6 +2235,8 @@ static int musb_resume_noirq(struct device *dev)
> >  	 * unless for some reason the whole soc powered down or the USB
> >  	 * module got reset through the PSC (vs just being disabled).
> >  	 */
> > +	struct musb	*musb = dev_to_musb(dev);
> > +	musb_restore_context(musb);
> >  	return 0;
> >  }
> >  
> 
> - -- 
> Regards,
> Igor.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJQ/SjTAAoJEBDE8YO64EfaHrsP/2bl4rP6L/tWLSZ+rNEdz6B+
> Qo+HVOhnTVsOxgWbbd5VrfhE28jLoFGMslrLuI+geeCcJ1zgwNsahG9C11bygyfu
> 54hQgkmaxDJPDKAlalcy7VK9C6tOTgQV5iSbuRlemttK879dTrb+33zP6idn5+zK
> kxptY38fpmyojnl8gJiVa6Plik/apQcVr+GIx8CMwj+YQC5vkdg7cUEWyngfyk2C
> W0U4NceroS8NSjRbcFV3V6Q912TVjKzl+B2yxVD0OBaSK4BpHEncDBXiVx8APq87
> 4nDeBB5gDXi1rtN3YjcfDaFu0me5qzpYc3JFFidvdLTdXIdvxDzjHgMqsZB8ZBYC
> R0e5PtIw/62I90d63JkXZXVRTB7JeZsGfZFY2R7MxBab9or8zz0OyYwGWoW63vzH
> oFrwmAkWoD0IEKcfc8+dd99eicgZrmQL6FDWrEMsX+RS34LRtVU30SVAudRhY+CR
> MhNCjKyFySwx7wqkGgJl1ECl0Y6U4ua0v4bv7kdE6eyrgbQIkiGliSJ7DhWBPcP6
> iMIOTwC7+LwPYP/MX2uYR3DXDfI0XwiqdtyzhD9LJe4PRol8zjozS2j0Y7FriItw
> jFqsgCgwDc9j8ufcpXf5ZynJYnlCG0iLuAPEUugZot83/CpxgU++A8cuHqUrOnhH
> 76L95rflUTkpiQ76ffP7
> =jqXb
> -----END PGP SIGNATURE-----

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUP21WDnsnt1WYoG5AQIQlQ/+LlXi1ZRXKtO/oj/u4iqs7DL8PNcZX6C7
j7Rrx8nxd2C15pEnxvOYIrojLTrXqz3bgE9NmBvYOYY+dj2/+CaS7RJsTR0gYJi0
AMkLT9k6+edUJ79KtIRmeqbnPEnujOWHkBdg2dLrm4PpYmGUmc8VGeE3+mh3La97
ssZm4gYbip6TPzB4MdvTbhkxbEXJidOcgBJrsdTvMXB8HkZ30Wq6/YELtYoYNpZo
rn+CbQo5Dd0bUb8fQ3Fd5unfXqx5N5txBslwK8JgSA3L7l96d3+q9UOfBg/PsUJJ
WrnFahv11lypajHtnCnXb3z+TsGgV4v46aUZ4Yk+tkwVv81nbORHTRGoaLReRMG2
Sii/xYeugOuhnJI//07yWrnLfunFbJJyHmfZARz/6kKNoIPrZwRDmVeO3+Iu/39R
zmwvJDTqONwenXnZEmxqrON0E/Y8V6hdNlGZdFYIypJr/Ym2rp+R+qcRyEwQxAYi
7h1mACvXE7tYCCoBi+fN5hFaF2VQeN1QqJMTimQjqnkgaI2jQ4Zm7zMCUKREhGPu
3TTvOwuFGM+bwb2eKsW+4zSzebdepXaNjSPCmHSKU++5SVcOMNiZyKlrvoW8znM4
/1Ea+3CmkHqAhmja5Fly4NYL2fdy/NhfIqZI2yIrTAG58iIankQjBHysqAcGrvQp
TplHj7osO40=
=G91I
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
