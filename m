Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab3GPS0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:26:09 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:45055 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab3GPS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:26:08 -0400
Date: Tue, 16 Jul 2013 21:26:01 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
Message-ID: <20130716182601.GB14385@blackmetal.musicnaut.iki.fi>
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
 <51E4E922.2040707@gmail.com>
 <51E4EF70.3040502@ti.com>
 <20130716080836.GC8880@arwen.pp.htv.fi>
 <20130716082247.GD8880@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716082247.GD8880@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 16, 2013 at 11:22:47AM +0300, Felipe Balbi wrote:
> > On Tue, Jul 16, 2013 at 12:30:00PM +0530, Kishon Vijay Abraham I wrote:
> > > On Tuesday 16 July 2013 12:03 PM, Daniel Mack wrote:
> > > > Hi Aaro,
> > > > 
> > > > On 16.07.2013 00:56, Aaro Koskinen wrote:
> > > >> Hi,
> > > >>
> > > >> I think USB tree introduced regressions in v3.11-rc1, at least for some
> > > >> OMAP devices using legacy boot.
> > > > 
> > > > Thanks for checking the tree so early.
> > > > 
> > > >> I have only bisected these; I have no
> > > >> idea what the real fixes are but the following reverts make Nokia OMAP2+
> > > >> boards again usable for kernel development work (they need working USB
> > > >> connection for interacting with the device):
> > > >>
> > > >> 1) USB peripheral mode (g_ether) is broken on Nokia N900, N950 and N9
> > > >>    (USB_MUSB_OMAP2PLUS). To make it it work, I need to revert three
> > > >>    commits:
> > > >>
> > > >> 	09fc7d22b024692b2fe8a943b246de1af307132b
> > > >> 	usb: musb: fix incorrect usage of resource pointer
> > > >> 	(Reverting this fixes the g_ether probe failure "couldn't find
> > > >> 	 an available UDC")
> > > 
> > > I've posted a patch fixing the issue
> > > http://comments.gmane.org/gmane.linux.usb.general/89541
> > > There were some comments on it. I'll be posting a new version for it.
> > 
> > hmm, n8x0 used tusb6010, so perhaps a similar patch needs to be cooked
> > for that too. Right now, let's to the minimum fix, which is just to
> > increment the array size to 3 and for v3.12 we do the changes that I
> > suggested.
> 
> this should solve the problem on n900 and n8x0, it's pretty much
> kishon's original patch, so I guess it deserves his authorship:

Thanks, and yes it fixes this issue. I tested both N900 and N800, so
feel free to add my Tested-by.

> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index 6708a3b..f44e8b5 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -481,7 +481,7 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
>  
>  static int omap2430_probe(struct platform_device *pdev)
>  {
> -	struct resource			musb_resources[2];
> +	struct resource			musb_resources[3];
>  	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
>  	struct omap_musb_board_data	*data;
>  	struct platform_device		*musb;
> @@ -581,6 +581,11 @@ static int omap2430_probe(struct platform_device *pdev)
>  	musb_resources[1].end = pdev->resource[1].end;
>  	musb_resources[1].flags = pdev->resource[1].flags;
>  
> +	musb_resources[2].name = pdev->resource[2].name;
> +	musb_resources[2].start = pdev->resource[2].start;
> +	musb_resources[2].end = pdev->resource[2].end;
> +	musb_resources[2].flags = pdev->resource[2].flags;
> +
>  	ret = platform_device_add_resources(musb, musb_resources,
>  			ARRAY_SIZE(musb_resources));
>  	if (ret) {
> diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
> index 2c06a89..6f8a9ca 100644
> --- a/drivers/usb/musb/tusb6010.c
> +++ b/drivers/usb/musb/tusb6010.c
> @@ -1156,7 +1156,7 @@ static u64 tusb_dmamask = DMA_BIT_MASK(32);
>  
>  static int tusb_probe(struct platform_device *pdev)
>  {
> -	struct resource musb_resources[2];
> +	struct resource musb_resources[3];
>  	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
>  	struct platform_device		*musb;
>  	struct tusb6010_glue		*glue;
> @@ -1199,6 +1199,11 @@ static int tusb_probe(struct platform_device *pdev)
>  	musb_resources[1].end = pdev->resource[1].end;
>  	musb_resources[1].flags = pdev->resource[1].flags;
>  
> +	musb_resources[2].name = pdev->resource[2].name;
> +	musb_resources[2].start = pdev->resource[2].start;
> +	musb_resources[2].end = pdev->resource[2].end;
> +	musb_resources[2].flags = pdev->resource[2].flags;
> +
>  	ret = platform_device_add_resources(musb, musb_resources,
>  			ARRAY_SIZE(musb_resources));
>  	if (ret) {
> 
> -- 
> balbi

A.
