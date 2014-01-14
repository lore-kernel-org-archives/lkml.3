Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaANJ5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:57:50 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:48995 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaANJ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:57:47 -0500
Message-ID: <1389693453.1585.26.camel@localhost.localdomain>
Subject: Re: [PATCHv2] driver core/platform: don't leak memory allocated for
 dma_mask
From: Yann Droneaud <ydroneaud@opteya.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Tue, 14 Jan 2014 10:57:33 +0100
In-Reply-To: <20140114081944.GO29475@pengutronix.de>
References: <1386886207-2735-1-git-send-email-ydroneaud@opteya.com>
	 <1389649085-7365-1-git-send-email-ydroneaud@opteya.com>
	 <20140113225606.GA4132@kroah.com>
	 <1389683909-17495-1-git-send-email-ydroneaud@opteya.com>
	 <20140114081944.GO29475@pengutronix.de>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Le mardi 14 janvier 2014 à 09:19 +0100, Uwe Kleine-König a écrit :
> On Tue, Jan 14, 2014 at 08:18:29AM +0100, Yann Droneaud wrote:
> > Since commit 01dcc60a7cb8, platform_device_register_full() is
> > available to allocate and register a platform device.
> > 
> > If a dma_mask is provided as part of platform_device_info,
> > platform_device_register_full() allocate memory for a u64
> > using kmalloc().
> > 
> > A comment in the code state that "[t]his memory isn't freed
> > when the device is put".
> >

[...]

> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 3a94b799f166..6e3e639fb886 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
> >  
> >  struct platform_object {
> >  	struct platform_device pdev;
> > -	char name[1];
> > +	char payload[0];
> I don't know the recent minimal versions needed to compile the kernel
> and since when gcc supports c99 flexible array members, but I would
> expect that they just work. Having said that I'd prefer using that one,
> i.e. use
> 	char payload[];
> >  };

I'm not confident with flexible array when using sizeof(), offsetof(),
etc. I will try to use the c99 feature.

> > +static struct platform_device *platform_device_dmamask_alloc(const char *name,
> > +							     int id)
> > +{
> > +	struct platform_object *pa;
> > +	const size_t padding = (((offsetof(struct platform_object, payload) +
> > +				  (__alignof__(u64) - 1)) &
> > +				 ~(__alignof__(u64) - 1)) -
> > +				offsetof(struct platform_object, payload));
> > +
> > +	pa = platform_object_alloc(padding + sizeof(u64) + strlen(name) + 1);
> > +	if (pa) {
> > +		char *payload = pa->payload + padding;
> > +		/*
> > +		 * Conceptually dma_mask in struct device should not be a pointer.
> > +		 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
> > +		 */
> > +		pa->pdev.dev.dma_mask = (void *)payload;
> > +		payload += sizeof(u64);
> > +		strcpy(payload, name);
> > +		platform_object_init(pa, payload, id);
> > +	}
> > +
> > +	return pa ? &pa->pdev : NULL;
> > +}
> This looks all complicated. Did you think about spending the extra
> memory and add a dma_mask to platform_object? That should simplify the
> code quite a bit which probably is worth the extra memory being used.
> 

You could have did it in the first place. But you choose to allocate a
chunk of memory for the u64. I believe there's a reason ;)

I will try to get some figure on the number of platform_device
registered with a dmamask versus without a dmamask: adding the u64 to
all platform_object might cost more memory than the extra code (1 branch
and a function).

Regards.

-- 
Yann Droneaud
OPTEYA

