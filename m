Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaJGQRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:17:22 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34553 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaJGQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:17:20 -0400
Date: Tue, 7 Oct 2014 09:17:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: opencores-kbd: Switch to using managed resources
Message-ID: <20141007161716.GB16469@dtor-ws>
References: <1412681501-28072-1-git-send-email-pramod.gurav@smartplayin.com>
 <20141007133322.GL3279@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007133322.GL3279@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 03:33:22PM +0200, Tobias Klauser wrote:
> On 2014-10-07 at 13:31:41 +0200, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> > This change switch to managed resources to simplifies error handling
> > and module unloading and does away with platform_driver remove function.
> > 
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: linux-input@vger.kernel.org
> > Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> > ---
> >  drivers/input/keyboard/opencores-kbd.c |   54 ++++++++------------------------
> >  1 file changed, 13 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
> > index 7b9b441..ecacb87 100644
> > --- a/drivers/input/keyboard/opencores-kbd.c
> > +++ b/drivers/input/keyboard/opencores-kbd.c
> > @@ -56,27 +56,27 @@ static int opencores_kbd_probe(struct platform_device *pdev)
> >  		return -EINVAL;
> >  	}
> >  
> > -	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
> > -	input = input_allocate_device();
> > +	opencores_kbd = devm_kzalloc(&pdev->dev, sizeof(*opencores_kbd),
> > +				     GFP_KERNEL);
> > +	input = devm_input_allocate_device(&pdev->dev);
> >  	if (!opencores_kbd || !input) {
> >  		dev_err(&pdev->dev, "failed to allocate device structures\n");
> > -		error = -ENOMEM;
> > -		goto err_free_mem;
> > +		return -ENOMEM;
> >  	}
> >  
> >  	opencores_kbd->addr_res = res;
> > -	res = request_mem_region(res->start, resource_size(res), pdev->name);
> > +	res = devm_request_mem_region(&pdev->dev, res->start,
> > +				      resource_size(res), pdev->name);
> >  	if (!res) {
> >  		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > -		error = -EBUSY;
> > -		goto err_free_mem;
> > +		return -EBUSY;
> >  	}
> >  
> > -	opencores_kbd->addr = ioremap(res->start, resource_size(res));
> > +	opencores_kbd->addr = devm_ioremap(&pdev->dev, res->start,
> > +					   resource_size(res));
> 
> You could use devm_ioremap_resource() here and get rid of the call to
> devm_request_mem_region() and the check for !res above, i.e. something
> like:
> 
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 	[...]
> 	opencores_kbd->addr = devm_ioremap_resource(&pdev->dev, res);
> 	if (!opencores_kbd->addr) {
> 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> 		return -ENXIO;
> 	}

You need to be careful with devm_ioremap_resource() ocnversions as it
returns ERR_PTR-encoded pointer on failures, not NULL.

I adjusted the patch to use devm_ioremap_resource() and applied.

Thanks.

-- 
Dmitry
