Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3AYNTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:19:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38604 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3AYNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:19:50 -0500
Message-ID: <51028668.1020800@ti.com>
Date: Fri, 25 Jan 2013 15:19:36 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/6] usb: otg: Add an API to bind the USB controller
 and PHY
References: <1359081206-5602-1-git-send-email-kishon@ti.com> <1359081206-5602-2-git-send-email-kishon@ti.com>
In-Reply-To: <1359081206-5602-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 04:33 AM, Kishon Vijay Abraham I wrote:
> In order to support platforms which has multiple PHY's (of same type) and
> which has multiple USB controllers, a new design is adopted wherin the binding
> information (between the PHY and the USB controller) should be passed to the
> PHY library from platform specific file (board file).
> So added a new API to pass the binding information.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/otg/otg.c   |   37 +++++++++++++++++++++++++++++++++++++
>  include/linux/usb/phy.h |   22 ++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
> index a30c041..8e756d9 100644
> --- a/drivers/usb/otg/otg.c
> +++ b/drivers/usb/otg/otg.c
> @@ -18,6 +18,7 @@
>  #include <linux/usb/otg.h>
>  
>  static LIST_HEAD(phy_list);
> +static LIST_HEAD(phy_bind_list);
>  static DEFINE_SPINLOCK(phy_lock);
>  
>  static struct usb_phy *__usb_find_phy(struct list_head *list,
> @@ -201,6 +202,42 @@ void usb_remove_phy(struct usb_phy *x)
>  }
>  EXPORT_SYMBOL(usb_remove_phy);
>  
> +/**
> + * usb_bind_phy - bind the phy and the controller that uses the phy
> + * @dev_name: the device name of the device that will bind to the phy
> + * @index: index to specify the port number
> + * @phy_dev_name: the device name of the phy
> + *
> + * Fills the phy_bind structure with the dev_name and phy_dev_name. This will
> + * be used when the phy driver registers the phy and when the controller
> + * requests this phy.
> + *
> + * To be used by platform specific initialization code.
> + */
> +int __init usb_bind_phy(const char *dev_name, u8 index,
> +				const char *phy_dev_name)
> +{
> +	struct usb_phy_bind *phy_bind;
> +	unsigned long flags;
> +
> +	phy_bind = kzalloc(sizeof(*phy_bind), GFP_KERNEL);
> +	if (!phy_bind) {
> +		pr_err("phy_bind(): No memory for phy_bind");

nitpick. Function name is usb_bind_phy() and you don't need to mention it twice ;).

Is it even needed to print here as the user would most likely print it anyways. At least
the user can decide if it needs to be printed or not.

> +		return -ENOMEM;
> +	}
> +
> +	phy_bind->dev_name = dev_name;
> +	phy_bind->phy_dev_name = phy_dev_name;
> +	phy_bind->index = index;
> +
> +	spin_lock_irqsave(&phy_lock, flags);
> +	list_add_tail(&phy_bind->list, &phy_bind_list);
> +	spin_unlock_irqrestore(&phy_lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_bind_phy);
> +
>  const char *otg_state_string(enum usb_otg_state state)
>  {
>  	switch (state) {
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index a29ae1e..e7eb429 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -106,6 +106,21 @@ struct usb_phy {
>  			enum usb_device_speed speed);
>  };

cheers,
-roger

