Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3HFJck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:32:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3HFJci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:32:38 -0400
Date: Tue, 6 Aug 2013 17:33:56 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
Message-ID: <20130806093356.GA27889@kroah.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com>
 <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 10:53:44AM +0300, Pantelis Antoniou wrote:
> Removing any omap device always resulted in a crash; turns out
> BUS_NOTIFY_DEL_DEVICE is not the last notifier event sent in the
> course of removing the device, the correct event is
> BUS_NOTIFY_UNBOUND_DRIVER, which still is not the right place to
> perform the cleanup. A device callback handles that properly, as
> well as making sure the hwmods of the device are shutdown.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  arch/arm/mach-omap2/omap_device.c | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index f33b40c..6dec521 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -178,6 +178,32 @@ odbfd_exit:
>  	return ret;
>  }
>  
> +static void _omap_device_cleanup(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct omap_device *od;
> +	struct omap_hwmod *oh;
> +	int i;
> +
> +	od = pdev->archdata.od;
> +	if (!od)
> +		return;
> +
> +	for (i = 0; i < od->hwmods_cnt; i++) {
> +
> +		oh = od->hwmods[i];
> +
> +		/* shutdown hwmods */
> +		omap_hwmod_shutdown(oh);
> +
> +		/* we don't remove clocks cause there's no API to do so */
> +		/* no harm done, since they will not be created next time */
> +	}
> +
> +	/* cleanup the structure now */
> +	omap_device_delete(od);
> +}
> +
>  static int _omap_device_notifier_call(struct notifier_block *nb,
>  				      unsigned long event, void *dev)
>  {
> @@ -185,9 +211,13 @@ static int _omap_device_notifier_call(struct notifier_block *nb,
>  	struct omap_device *od;
>  
>  	switch (event) {
> -	case BUS_NOTIFY_DEL_DEVICE:
> +	case BUS_NOTIFY_UNBOUND_DRIVER:
> +		/* NOTIFY_DEL_DEVICE is not the right call...
> +		 * we use a callback here, to make sure no-one is going to
> +		 * try to use the omap_device data after they're deleted
> +		 */
>  		if (pdev->archdata.od)
> -			omap_device_delete(pdev->archdata.od);
> +			device_schedule_callback(dev, _omap_device_cleanup);

Really?  This is one sign that you are totally using the driver core
incorrectly.  You shouldn't have to rely on notifier callbacks to handle
device removals, your bus code should do that for you directly.

I don't like this at all, sorry.

And I was waiting for the day when people started to finally remove
platform devices from the system, I always thought it would never work
properly.  Good luck with this, I think you have a lot of work ahead of
yourself...

greg k-h
