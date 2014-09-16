Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaIPCCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:02:37 -0400
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:30008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753471AbaIPCCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:02:35 -0400
Date: Tue, 16 Sep 2014 10:02:25 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH] usb: gadget: udc_core: Use right kobj when calling
 sysfs_notify
Message-ID: <20140916020223.GD3379@peterchendt>
References: <1410777748-28090-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410777748-28090-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(199003)(189002)(33656002)(107046002)(97736003)(76482001)(44976005)(106466001)(104016003)(81542002)(81342002)(80022002)(77982002)(74662002)(79102002)(74502002)(20776003)(575784001)(95666004)(31966008)(64706001)(105606002)(50466002)(19580405001)(85306004)(6806004)(47776003)(19580395003)(92726001)(33716001)(23726002)(21056001)(86362001)(87936001)(76176999)(83322001)(83072002)(110136001)(46406003)(83506001)(85852003)(68736004)(90102001)(50986999)(26826002)(102836001)(57986006)(97756001)(46102002)(84676001)(92566001)(99396002)(54356999)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB270;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:42:27PM +0200, Andreas Larsson wrote:
> The state attribute is connected to the kobj of the udc, not the gadget.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
>  drivers/usb/gadget/udc/udc-core.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
> index b0d9817..37c129a 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -109,8 +109,20 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>  static void usb_gadget_state_work(struct work_struct *work)
>  {
>  	struct usb_gadget	*gadget = work_to_gadget(work);
> +	struct usb_udc		*udc = NULL;
> +
> +	mutex_lock(&udc_lock);
> +	list_for_each_entry(udc, &udc_list, list)
> +		if (udc->gadget == gadget)
> +			goto found;
> +	mutex_unlock(&udc_lock);
> +
> +	return;
> +
> +found:
> +	mutex_unlock(&udc_lock);
>  
> -	sysfs_notify(&gadget->dev.kobj, NULL, "state");
> +	sysfs_notify(&udc->dev.kobj, NULL, "state");
>  }
>  
>  void usb_gadget_set_state(struct usb_gadget *gadget,

What's the user mode difference with and without this patch?

-- 
Best Regards,
Peter Chen
