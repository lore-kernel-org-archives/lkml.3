Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbaCSMJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:09:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42829 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933828AbaCSMJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:09:06 -0400
Message-ID: <532988DA.8030002@ti.com>
Date: Wed, 19 Mar 2014 17:38:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <myungjoo.ham@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/2] extcon: of: Remove unnecessary function call by using
 the name of device_node
References: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com> <1395144280-23240-2-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1395144280-23240-2-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18 March 2014 05:34 PM, Chanwoo Choi wrote:
> This patch remove unnecessary function call in of_extcon_get_extcon_dev()
> by using the name of device_node structure.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/extcon/of_extcon.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
> index 72173ec..0a29f82 100644
> --- a/drivers/extcon/of_extcon.c
> +++ b/drivers/extcon/of_extcon.c
> @@ -32,7 +32,6 @@ struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
>  {
>  	struct device_node *node;
>  	struct extcon_dev *edev;
> -	struct platform_device *extcon_parent_dev;
>  
>  	if (!dev->of_node) {
>  		dev_dbg(dev, "device does not have a device node entry\n");
> @@ -46,16 +45,9 @@ struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
>  		return ERR_PTR(-ENODEV);
>  	}
>  
> -	extcon_parent_dev = of_find_device_by_node(node);
> -	if (!extcon_parent_dev) {
> -		dev_dbg(dev, "unable to find device by node\n");
> -		return ERR_PTR(-EPROBE_DEFER);
> -	}
> -
> -	edev = extcon_get_extcon_dev(dev_name(&extcon_parent_dev->dev));
> +	edev = extcon_get_extcon_dev(node->name);

Since you no longer want to use device names I think you should add this too to
warn users if they rely on using the device name.
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index bc4c789..025eb39 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -601,7 +601,6 @@ int extcon_dev_register(struct extcon_dev *edev)
        edev->dev.class = extcon_class;
        edev->dev.release = extcon_dev_release;

-       edev->name = edev->name ? edev->name : dev_name(edev->dev.parent);
//The user should always pass the 'name' as we no longer use device name while
getting extcon device. And this name should also be the 'node' name?
        if (IS_ERR_OR_NULL(edev->name)) {
                dev_err(&edev->dev,
                        "extcon device name is null\n");

Btw changing to node name from device name breaks dwc3 in OMAP5 and you would
need this too..

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 2aea4bc..cea8cd3 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -188,6 +188,7 @@ static int palmas_usb_probe(struct platform_device *pdev)

        palmas_usb->edev.supported_cable = palmas_extcon_cable;
        palmas_usb->edev.dev.parent = palmas_usb->dev;
+       palmas_usb->edev.name = "palmas_usb";
        palmas_usb->edev.mutually_exclusive = mutually_exclusive;

        status = extcon_dev_register(&palmas_usb->edev);

Cheers
Kishon
