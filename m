Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3EaPbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:31:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab3EaPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:31:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Cc: Timur Tabi <timur@tabi.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
Date: Fri, 31 May 2013 17:28:45 +0200
Message-ID: <1506693.18n3ImgyKs@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51A8B220.6070308@monstr.eu>
References: <cover.1370004925.git.michal.simek@xilinx.com> <51A8A89C.8030404@tabi.org> <51A8B220.6070308@monstr.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8UO6vrarpx1iLShO3RUv1oP4I/F6MJgJDIx1esKah1d
 boP//V1jemN5z6kmNRemOTCZ1Zm/2ya8E5rv2r3SoXLK7hSSC9
 J9QXKinvLcY3V+tUbWktK2mkiVQIEpldZ6XI+waOAPK9F7um0z
 btHWG7blCv00uHTyuPM+XsqoyxH9K8zziowN3bJH0rl/XKBKaH
 q6xYWBtTPgoNkeX7Au6ivTdY2gb2RbSjrhLpgQdQW5f9Krt9G6
 R3jzxSJiX7Fpp87CtGv+VK8fJIs4u5OiZSf3vl2IngczeZbYOR
 EnZd9FCWM9DkFBjUUgOuQVIGHU1wOGu3sQAxkM8zrs3UlawkOP
 +zEQQbO/qcnPEnJLnLtI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 16:22:24 Michal Simek wrote:
>         if (pdata->fb_phys) {
>                 drvdata->fb_phys = pdata->fb_phys;
> -               drvdata->fb_virt = ioremap(pdata->fb_phys, fbsize);
> +               drvdata->fb_virt_io = ioremap(pdata->fb_phys, fbsize);
> +
> +               if (!drvdata->fb_virt_io) {
> +                       dev_err(dev, "Could not allocate frame buffer memory\n");
> +                       rc = -ENOMEM;
> +                       if (drvdata->flags & BUS_ACCESS_FLAG)
> +                               goto err_fbmem;
> +                       else
> +                               goto err_region;
> +               }
> +
> +               /* Clear (turn to black) the framebuffer */
> +               memset_io(drvdata->fb_virt_io, 0, fbsize);
>         } else {
> -               drvdata->fb_alloced = 1;
>                 drvdata->fb_virt = dma_alloc_coherent(dev, PAGE_ALIGN(fbsize),
>                                         &drvdata->fb_phys, GFP_KERNEL);
> -       }
> 

I think you also want to use ioremap_wc or dma_alloc_writecombine
here, to get a write-combining mapping, rather than a device mapping
that you would use for MMIO register access.

There is also a builtin assumption in the code above that the DMA
address space pointer (which you pass into REG_FB_ADDR) is the
same as what you pass into drvdata->info.fix.smem_start. That is
not the case in general, but I don't see a good way around it
when pdata->fb_phys is set by the platform to something outside
of system memory. It should probably have a comment next to it.

	Arnd
