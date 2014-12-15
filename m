Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaLOGVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:21:48 -0500
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:24616
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbaLOGVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:21:44 -0500
Date: Mon, 15 Dec 2014 13:13:18 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget
 unbind
Message-ID: <20141215051317.GC25410@shlinux2>
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(20776003)(76176999)(97756001)(54356999)(33656002)(104016003)(105606002)(110136001)(97736003)(23726002)(83506001)(87936001)(92566001)(575784001)(86362001)(50986999)(47776003)(64706001)(85426001)(4396001)(84676001)(120916001)(46102003)(106466001)(77156002)(19580405001)(62966003)(46406003)(107046002)(50466002)(77096005)(19580395003)(99396003)(68736005)(31966008)(21056001)(6806004);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0635;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:CY1PR0301MB0635;
X-Forefront-PRVS: 04267075BD
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0635;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
> As usb function drivers assumes that all usb request will be completed
> before function unbind call, we should supply such behavior. In some
> cases ep_disable() won't kill all request effectively, because some
> IN requests can be in running state. In such situation it's possible
> to have unbind function called before last request completion, which
> can cause problems.

Doesn't the function's disable/unbind should call usb_ep_dequeue to make
sure the transfer has ended?

.udc_stop may stop the controller, and .unbind may still visit hardware.

> 
> For example unbinding f_ecm function while request on 'notify' endpoint
> is not completed, ends up NULL pointer dereference in unbind() function.
> 
> usb_gadget_udc_stop() call causes completion of all requests so if it's
> called before gadget unbind there is no risk that some of requests will
> stay uncompleted.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/gadget/udc/udc-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
> index e31d574..6f0d233 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -331,8 +331,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
>  
>  	usb_gadget_disconnect(udc->gadget);
>  	udc->driver->disconnect(udc->gadget);
> -	udc->driver->unbind(udc->gadget);
>  	usb_gadget_udc_stop(udc);
> +	udc->driver->unbind(udc->gadget);
>  
>  	udc->driver = NULL;
>  	udc->dev.driver = NULL;
> -- 
> 1.9.1
> 

-- 

Best Regards,
Peter Chen
