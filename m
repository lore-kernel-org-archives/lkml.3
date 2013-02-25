Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab3BYPqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:46:51 -0500
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:47208 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab3BYPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:46:50 -0500
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2013 10:46:49 EST
Message-ID: <512B84A8.9040700@ge.com>
Date: Mon, 25 Feb 2013 15:35:04 +0000
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manohar Vanga <manohar.vanga@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vme: add missing put_device() after device_register()
 fails
References: <1360781274-14405-1-git-send-email-cota@braap.org>
In-Reply-To: <1360781274-14405-1-git-send-email-cota@braap.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/13 18:47, Emilio G. Cota wrote:
> From: "Emilio G. Cota" <cota@braap.org>
> 
> put_device() must be called after device_register() fails,
> since device_register() always initializes the refcount
> on the device structure.
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>
> ---
>  drivers/vme/vme.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vme/vme.c b/drivers/vme/vme.c
> index 95a9f71..5e6c7d7 100644
> --- a/drivers/vme/vme.c
> +++ b/drivers/vme/vme.c
> @@ -1366,26 +1366,27 @@ static int __vme_register_driver_bus(struct vme_driver *drv,
>  		err = device_register(&vdev->dev);
>  		if (err)
>  			goto err_reg;
>  
>  		if (vdev->dev.platform_data) {
>  			list_add_tail(&vdev->drv_list, &drv->devices);
>  			list_add_tail(&vdev->bridge_list, &bridge->devices);
>  		} else
>  			device_unregister(&vdev->dev);
>  	}
>  	return 0;
>  
>  err_reg:
> +	put_device(&vdev->dev);
>  	kfree(vdev);
>  err_devalloc:
>  	list_for_each_entry_safe(vdev, tmp, &drv->devices, drv_list) {
>  		list_del(&vdev->drv_list);
>  		list_del(&vdev->bridge_list);
>  		device_unregister(&vdev->dev);
>  	}
>  	return err;
>  }

Acked-by: Martyn Welch <martyn.welch@ge.com>

(Sorry it took me so long to respond)

>  
>  static int __vme_register_driver(struct vme_driver *drv, unsigned int ndevs)
>  {
>  	struct vme_bridge *bridge;
> 


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
