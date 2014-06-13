Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaFMLhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:37:24 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43193 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751274AbaFMLhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:37:23 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Robert Baldyga'" <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH] usb: gadget: composite: unlock spinlock before
 usb_gadget_disconnect()
Thread-Topic: [PATCH] usb: gadget: composite: unlock spinlock before
 usb_gadget_disconnect()
Thread-Index: AQHPhvqRVW74IZkj4UCPUfgmWMlPmJtu6CCg
Date: Fri, 13 Jun 2014 11:36:24 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725C37A@AcuExch.aculab.com>
References: <1402658893-4809-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1402658893-4809-1-git-send-email-r.baldyga@samsung.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Baldyga
> usb_gadget_disconnect() shouldn't be called under spinlock to avoid
> spinlock recursion. Function usb_gadget_disconnect() calls pullup(),
> which is callback from UDC driver, usually calling composite_disconnect().
> This function wants to lock spinlock used in usb_function_deactivate()
> causing spinlock recursion.
...
> +++ b/drivers/usb/gadget/composite.c
> @@ -260,8 +260,11 @@ int usb_function_deactivate(struct usb_function *function)
> 
>  	spin_lock_irqsave(&cdev->lock, flags);
> 
> -	if (cdev->deactivations == 0)
> +	if (cdev->deactivations == 0) {
> +		spin_unlock_irqrestore(&cdev->lock, flags);
>  		status = usb_gadget_disconnect(cdev->gadget);
> +		spin_lock_irqsave(&cdev->lock, flags);
> +	}
>  	if (status == 0)
>  		cdev->deactivations++;

That sort of change rings big alarm bells.
You've effectively isolated the usb_gadget_disconnect() call
from the check that cdev->deactivations == 0.
And then you increment cdev->deactivations below.

Looks like it will be racy to me.

	David



