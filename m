Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbaFAKTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 06:19:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53771 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFAKTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:19:38 -0400
Date: Sun, 1 Jun 2014 12:19:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] driver core/platform: remove unused implicit padding in
 platform_object
Message-ID: <20140601101930.GC11207@pengutronix.de>
References: <1401480167-15091-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401480167-15091-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yann,

On Fri, May 30, 2014 at 10:02:47PM +0200, Yann Droneaud wrote:
> Up to 7 bytes are wasted at the end of struct platform_object
> in the form of padding after name field: unfortunately this
> padding is not used when allocating the memory to hold the
> name.
> 
> This patch converts name array from name[1] to C99 flexible
> array name[] (equivalent to name[0]) so that no padding is
> required by the presence of this field. Memory allocation
> is updated to take care of allocating an additional byte for
> the NUL terminating character.
> 
> Built on Fedora 20, using GCC 4.8, for ARM, i386, SPARC64 and
> x86_64 architectures, the data structure layout can be reported
> with following command:
> 
>   $ pahole drivers/base/platform.o \
>            --recursive             \
>            --class_name device,pdev_archdata,platform_device,platform_object
> 
> Please find below some comparisons of structure layout for arm,
> i386, sparc64 and x86_64 architecture before and after the patch.
> 
>   --- obj-arm/drivers/base/platform.o.pahole.v3.15-rc7-79-gfe45736f4134	2014-05-30 10:32:06.290960701 +0200
>   +++ obj-arm/drivers/base/platform.o.pahole.v3.15-rc7-80-g2cdb06858d71	2014-05-30 11:26:20.851988347 +0200
>   @@ -81,10 +81,9 @@
>      /* XXX last struct has 4 bytes of padding */
> 
>   	/* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
>   -	char                       name[1];              /*   392     1 */
>   +	char                       name[0];              /*   392     0 */
> 
>   -	/* size: 400, cachelines: 7, members: 2 */
>   -	/* padding: 7 */
>   +	/* size: 392, cachelines: 7, members: 2 */
>    	/* paddings: 1, sum paddings: 4 */
>   -	/* last cacheline: 16 bytes */
>   +	/* last cacheline: 8 bytes */
>    };
> 
>   --- obj-i386/drivers/base/platform.o.pahole.v3.15-rc7-79-gfe45736f4134 2014-05-30 10:32:06.305960691 +0200
>   +++ obj-i386/drivers/base/platform.o.pahole.v3.15-rc7-80-g2cdb06858d71 2014-05-30 11:26:20.875988332 +0200
>   @@ -73,9 +73,8 @@
>    struct platform_object {
>    	struct platform_device     pdev;                 /*     0   396 */
>    	/* --- cacheline 6 boundary (384 bytes) was 12 bytes ago --- */
>   -	char                       name[1];              /*   396     1 */
>   +	char                       name[0];              /*   396     0 */
> 
>   -	/* size: 400, cachelines: 7, members: 2 */
>   -	/* padding: 3 */
>   -	/* last cacheline: 16 bytes */
>   +	/* size: 396, cachelines: 7, members: 2 */
>   +	/* last cacheline: 12 bytes */
>    };
> 
>   --- obj-sparc64/drivers/base/platform.o.pahole.v3.15-rc7-79-gfe45736f4134 2014-05-30 10:32:06.406960625 +0200
>   +++ obj-sparc64/drivers/base/platform.o.pahole.v3.15-rc7-80-g2cdb06858d71 2014-05-30 11:26:20.971988269 +0200
>   @@ -94,9 +94,8 @@
>    struct platform_object {
>    	struct platform_device     pdev;                 /*     0  2208 */
>    	/* --- cacheline 34 boundary (2176 bytes) was 32 bytes ago --- */
>   -	char                       name[1];              /*  2208     1 */
>   +	char                       name[0];              /*  2208     0 */
> 
>   -	/* size: 2216, cachelines: 35, members: 2 */
>   -	/* padding: 7 */
>   -	/* last cacheline: 40 bytes */
>   +	/* size: 2208, cachelines: 35, members: 2 */
>   +	/* last cacheline: 32 bytes */
>    };
> 
>   --- obj-x86_64/drivers/base/platform.o.pahole.v3.15-rc7-79-gfe45736f4134 2014-05-30 10:32:06.432960608 +0200
>   +++ obj-x86_64/drivers/base/platform.o.pahole.v3.15-rc7-80-g2cdb06858d71 2014-05-30 11:26:21.000988250 +0200
>   @@ -84,9 +84,8 @@
>    struct platform_object {
>    	struct platform_device     pdev;                 /*     0   720 */
>    	/* --- cacheline 11 boundary (704 bytes) was 16 bytes ago --- */
>   -	char                       name[1];              /*   720     1 */
>   +	char                       name[0];              /*   720     0 */
> 
>   -	/* size: 728, cachelines: 12, members: 2 */
>   -	/* padding: 7 */
>   -	/* last cacheline: 24 bytes */
>   +	/* size: 720, cachelines: 12, members: 2 */
>   +	/* last cacheline: 16 bytes */
>    };
> 
> Changes from v5 [1]:
> - dropped dma_mask allocation changes and only kept padding
>   removal changes (name array length set to 0).
> 
> Changes from v4 [2]:
> [by Emil Goode <emilgoode@gmail.com>:]
> - Split v4 of the patch into two separate patches.
> - Generated new object file size and data structure layout info.
> - Updated the changelog message.
> 
> Changes from v3 [3]:
> - fixed commit message so that git am doesn't fail.
> 
> Changes from v2 [4]:
> - move 'dma_mask' to platform_object so that it's always
>   allocated and won't leak on release; remove all previously
>   added support functions.
> - use C99 flexible array member for 'name' to remove padding
>   at the end of platform_object.
> 
> Changes from v1 [5]:
> - remove unneeded kfree() from error path
> - add reference to author/commit adding allocation of dmamask
> 
> Changes from v0 [6]:
> - small rewrite to squeeze the patch to a bare minimal
I'd drop the changes from the commit log, but other than that I like it.
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe
> 
> [1] http://lkml.kernel.org/r/1401122483-31603-2-git-send-email-emilgoode@gmail.com
>     http://lkml.kernel.org/r/1401122483-31603-1-git-send-email-emilgoode@gmail.com
>     http://lkml.kernel.org/r/1401122483-31603-3-git-send-email-emilgoode@gmail.com
> 
> [2] http://lkml.kernel.org/r/1390817152-30898-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3541871/
> 
> [3] http://lkml.kernel.org/r/1390771138-28348-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3540081/
> 
> [4] http://lkml.kernel.org/r/1389683909-17495-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3484411/
> 
> [5] http://lkml.kernel.org/r/1389649085-7365-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3480961/
> 
> [6] http://lkml.kernel.org/r/1386886207-2735-1-git-send-email-ydroneaud@opteya.com
> 
> Cc: Emil Goode <emilgoode@gmail.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
>  drivers/base/platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 5b47210889e0..b126c9363f53 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -162,7 +162,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
>  
>  struct platform_object {
>  	struct platform_device pdev;
> -	char name[1];
> +	char name[];
>  };
>  
>  /**
> @@ -203,7 +203,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
>  {
>  	struct platform_object *pa;
>  
> -	pa = kzalloc(sizeof(struct platform_object) + strlen(name), GFP_KERNEL);
> +	pa = kzalloc(sizeof(*pa) + strlen(name) + 1, GFP_KERNEL);
>  	if (pa) {
>  		strcpy(pa->name, name);
>  		pa->pdev.name = pa->name;
> -- 
> 1.9.3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
