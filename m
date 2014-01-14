Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaANITw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:19:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33284 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaANITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:19:49 -0500
Date: Tue, 14 Jan 2014 09:19:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dtor_core@ameritech.net>, kernel@pengutronix.de
Subject: Re: [PATCHv2] driver core/platform: don't leak memory allocated for
 dma_mask
Message-ID: <20140114081944.GO29475@pengutronix.de>
References: <1386886207-2735-1-git-send-email-ydroneaud@opteya.com>
 <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
 <20140113225606.GA4132@kroah.com>
 <1389683909-17495-1-git-send-email-ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389683909-17495-1-git-send-email-ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Yann,

On Tue, Jan 14, 2014 at 08:18:29AM +0100, Yann Droneaud wrote:
> Since commit 01dcc60a7cb8, platform_device_register_full() is
> available to allocate and register a platform device.
> 
> If a dma_mask is provided as part of platform_device_info,
> platform_device_register_full() allocate memory for a u64
> using kmalloc().
> 
> A comment in the code state that "[t]his memory isn't freed
> when the device is put".
> 
> It's never a good thing to leak memory, but there's only very
> few users of platform_device_info's dma_mask, and those are mostly
> "static" devices that are not going to be plugged/unplugged.
> 
> So memory leak is not really an issue, but allocating 8 bytes
> through kmalloc() seems overkill, so this patch moves dma_mask
> after the platform_device struct, dynamically allocated along
> the name buffer.
> 
> With dma_mask part of the memory allocated for the platform_device
> struct, like name buffer, it will be released with it:
> no memory leak, no small allocation.
> 
> The drawback is the additional code needed to handle
> dma_mask allocation:
> 
> Before (on next-20140113 with gcc-4.8):
>    text    data     bss     dec     hex filename
>    5600     472      32    6104    17d8 obj-arm/drivers/base/platform.o
>    5927     532      32    6491    195b obj-i386/drivers/base/platform.o
>    7036     960      48    8044    1f6c obj-x86_64/drivers/base/platform.o
> 
> After:
>    text    data     bss     dec     hex filename
>    5668     472      32    6172    181c obj-arm/drivers/base/platform.o
>    6007     532      32    6571    19ab obj-i386/drivers/base/platform.o
>    7132     960      48    8140    1fcc obj-x86_64/drivers/base/platform.o
> 
> Changes from v1 [1]:
> - remove unneeded kfree() from error path
> - add reference to author/commit adding allocation of dmamask
> 
> Changes from v0 [2]:
> - small rewrite to squeeze the patch to a bare minimal
> 
> [1] http://lkml.kernel.org/r/1389649085-7365-1-git-send-email-ydroneaud@opteya.com
>     https://patchwork.kernel.org/patch/3480961/
> 
> [2] http://lkml.kernel.org/r/1386886207-2735-1-git-send-email-ydroneaud@opteya.com
> 
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Dmitry Torokhov <dtor_core@ameritech.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> ---
> 
> Hi Greg,
> 
> > Why haven't you cc:ed the author of that comment?  He would be best to
> > evaluate if this patch is good enough or not.
> >
> 
> I must admit I was a bit lazy: I've tried ./script/get_maintainer.pl --git / --git-blame
> but the results scare me, so I've send the patch to the maintainer only. (And somehow
> I've thought you wrote that comment).
> 
> > And is leaking that memory really an issue?  As you point out, these
> > aren't devices that are going to go away (I'd argue that no platform
> > device should ever be a removable device, but that's a longer
> > argument...)
> >
> 
> I've seen some removable platform driver ... and, in fact, wrote some:
> when writing/testing it, being able to remove the devices/driver is a must.
> 
> > Please resend and cc: all of the needed developers.
> > 
> 
> Thanks for the advice.
> 
> Regards.
> 
>  drivers/base/platform.c | 83 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 62 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 3a94b799f166..6e3e639fb886 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
>  
>  struct platform_object {
>  	struct platform_device pdev;
> -	char name[1];
> +	char payload[0];
I don't know the recent minimal versions needed to compile the kernel
and since when gcc supports c99 flexible array members, but I would
expect that they just work. Having said that I'd prefer using that one,
i.e. use
	char payload[];
>  };
>  
>  /**
> @@ -186,6 +186,25 @@ static void platform_device_release(struct device *dev)
>  	kfree(pa);
>  }
>  
> +static struct platform_object *platform_object_alloc(size_t payload)
> +{
> +	struct platform_object *pa;
> +
> +	pa = kzalloc(sizeof(*pa) + payload, GFP_KERNEL);
> +
> +	return pa;
> +}
> +
> +static void platform_object_init(struct platform_object *pa,
> +				 const char *name, int id)
> +{
> +	pa->pdev.name = name;
> +	pa->pdev.id = id;
> +	device_initialize(&pa->pdev.dev);
> +	pa->pdev.dev.release = platform_device_release;
> +	arch_setup_pdev_archdata(&pa->pdev);
> +}
> +
>  /**
>   * platform_device_alloc - create a platform device
>   * @name: base name of the device we're adding
> @@ -198,14 +217,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
>  {
>  	struct platform_object *pa;
>  
> -	pa = kzalloc(sizeof(struct platform_object) + strlen(name), GFP_KERNEL);
> +	pa = platform_object_alloc(strlen(name) + 1);
>  	if (pa) {
> -		strcpy(pa->name, name);
> -		pa->pdev.name = pa->name;
> -		pa->pdev.id = id;
> -		device_initialize(&pa->pdev.dev);
> -		pa->pdev.dev.release = platform_device_release;
> -		arch_setup_pdev_archdata(&pa->pdev);
> +		strcpy(pa->payload, name);
> +		platform_object_init(pa, pa->payload, id);
>  	}
>  
>  	return pa ? &pa->pdev : NULL;
> @@ -213,6 +228,39 @@ struct platform_device *platform_device_alloc(const char *name, int id)
>  EXPORT_SYMBOL_GPL(platform_device_alloc);
>  
>  /**
> + * platform_device_dmamask_alloc - create a platform device suitable to hold a dmamask
> + * @name: base name of the device we're adding
> + * @id: instance id
> + *
> + * Create a platform device object which can have other objects attached
> + * to it, and which will have attached objects freed when it is released.
> + */
> +static struct platform_device *platform_device_dmamask_alloc(const char *name,
> +							     int id)
> +{
> +	struct platform_object *pa;
> +	const size_t padding = (((offsetof(struct platform_object, payload) +
> +				  (__alignof__(u64) - 1)) &
> +				 ~(__alignof__(u64) - 1)) -
> +				offsetof(struct platform_object, payload));
> +
> +	pa = platform_object_alloc(padding + sizeof(u64) + strlen(name) + 1);
> +	if (pa) {
> +		char *payload = pa->payload + padding;
> +		/*
> +		 * Conceptually dma_mask in struct device should not be a pointer.
> +		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
> +		 */
> +		pa->pdev.dev.dma_mask = (void *)payload;
> +		payload += sizeof(u64);
> +		strcpy(payload, name);
> +		platform_object_init(pa, payload, id);
> +	}
> +
> +	return pa ? &pa->pdev : NULL;
> +}
This looks all complicated. Did you think about spending the extra
memory and add a dma_mask to platform_object? That should simplify the
code quite a bit which probably is worth the extra memory being used.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
