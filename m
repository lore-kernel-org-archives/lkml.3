Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaEZSOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:14:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47354 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEZSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:14:37 -0400
Date: Mon, 26 May 2014 20:14:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Emil Goode <emilgoode@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core/platform: don't leak memory allocated
 for dma_mask
Message-ID: <20140526181424.GN20155@pengutronix.de>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 06:41:21PM +0200, Emil Goode wrote:
> From: Yann Droneaud <ydroneaud@opteya.com>
> 
> Since commit 01dcc60a7cb8, platform_device_register_full() is
> available to allocate and register a platform device.
> 
> If a dma_mask is provided as part of platform_device_info,
> platform_device_register_full() allocate memory for a u64 using
> kmalloc().
> 
> A comment in the code state that "[t]his memory isn't freed when the
> device is put".
> 
> It's never a good thing to leak memory, but there's only very few
> users of platform_device_info's dma_mask, and those are mostly
> "static" devices that are not going to be plugged/unplugged often.
> 
> So memory leak is not really an issue, but allocating 8 bytes through
> kmalloc() seems overkill.
> 
> To address this issue, this patch adds dma_mask to struct platform_object
> and when using platform_device_alloc() or platform_device_register_full()
> the .dma_mask pointer of struct device is assigned the address of this new
> dma_mask member of struct platform_object.  And since it's within struct
> platform_object, dma_mask won't be leaked anymore when struct platform_device
> get released.
> 
> No more memory leak, no small allocation and a slight reduction in code
> size.
> 
> Built on Debian jessie, using GCC 4.8, for ARM and x86_64 architectures,
> the size of the object file and the data structure layout are updated
> as follows, produced with commands:
> 
> $ size drivers/base/platform.o
> $ pahole drivers/base/platform.o \
> 	--recursive		 \
> 	--class_name device,pdev_archdata,platform_device,platform_object
> 
> -- size+pahole_3.15-rc6_ARM
> ++ size+pahole_3.15-rc6_ARM+
> @@ -2,7 +2,7 @@
>     text	   data	    bss	    dec	    hex	filename
> -   6530	   1008	      8	   7546	   1d7a	drivers/base/platform.o
> +   6482	   1008	      8	   7498	   1d4a	drivers/base/platform.o
> 
> @@ -93,8 +93,13 @@ struct platform_object {
>  	/* --- cacheline 12 boundary (768 bytes) was 40 bytes ago --- */
>  	char                       name[1];            /*   808     1 */
> 
> -	/* size: 816, cachelines: 13, members: 2 */
> -	/* padding: 7 */
> +	/* XXX 7 bytes hole, try to pack */
> 
> +	u64                        dma_mask;           /*   816     8 */
> 
> +	/* size: 824, cachelines: 13, members: 3 */
> +	/* sum members: 817, holes: 1, sum holes: 7 */
>  	/* paddings: 1, sum paddings: 4 */
> -	/* last cacheline: 48 bytes */
> +	/* last cacheline: 56 bytes */
>  };
> 
> -- size+pahole_3.15-rc6_x86_64
> ++ size+pahole_3.15-rc6_x86_64+
> @@ -2,7 +2,7 @@
>     text	   data	    bss	    dec	    hex	filename
> -   8570	   5032	   3424	  17026	   4282	drivers/base/platform.o
> +   8509	   5032	   3408	  16949	   4235	drivers/base/platform.o
> 
> @@ -95,7 +95,11 @@ struct platform_object {
>  	/* --- cacheline 22 boundary (1408 bytes) was 32 bytes ago --- */
>  	char                       name[1];             /*  1440     1 */
> 
> -	/* size: 1448, cachelines: 23, members: 2 */
> -	/* padding: 7 */
> -	/* last cacheline: 40 bytes */
> +	/* XXX 7 bytes hole, try to pack */
> 
> +	u64                        dma_mask;            /*  1448     8 */
> 
> +	/* size: 1456, cachelines: 23, members: 3 */
> +	/* sum members: 1449, holes: 1, sum holes: 7 */
> +	/* last cacheline: 48 bytes */
>  };
> 
> Changes from v4 [1]:
> - Split v4 of the patch into two separate patches.
> - Generated new object file size and data structure layout info.
> - Updated the changelog message.
> 
> Changes from v3 [2]:
> - fixed commit message so that git am doesn't fail.
> 
> Changes from v2 [3]:
> - move 'dma_mask' to platform_object so that it's always
>   allocated and won't leak on release; remove all previously
>   added support functions.
> - use C99 flexible array member for 'name' to remove padding
>   at the end of platform_object.
> 
> Changes from v1 [4]:
> - remove unneeded kfree() from error path
> - add reference to author/commit adding allocation of dmamask
> 
> Changes from v0 [5]:
> - small rewrite to squeeze the patch to a bare minimal
> 
> [1] http://lkml.kernel.org/r/1390817152-30898-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3541871/
> 
> [2] http://lkml.kernel.org/r/1390771138-28348-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3540081/
> 
> [3] http://lkml.kernel.org/r/1389683909-17495-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3484411/
> 
> [4] http://lkml.kernel.org/r/1389649085-7365-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3480961/
> 
> [5] http://lkml.kernel.org/r/1386886207-2735-1-git-send-email-ydroneaud@opteya.com
> 
> Cc: Yann Droneaud <ydroneaud@opteya.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> [Emil: split v4 of the patch in two and updated changelog]
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
> Hello Greg,
> 
> The first two patches in the series are created from v4 of the
> original patch, since I have not changed how the code works I think
> it is correct to keep the original author and Signed-off-by line.
> 
> Best regards,
> 
> Emil Goode
> 
>  drivers/base/platform.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9e9227e..dd1fa07 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -166,6 +166,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
>  struct platform_object {
>  	struct platform_device pdev;
>  	char name[1];
> +	u64 dma_mask;
This is broken. .name is used as flexible array, so .name and dma_mask
overlap.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
