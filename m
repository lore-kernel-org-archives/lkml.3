Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbbAMVMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:12:31 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:58397 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbAMVM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:12:29 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: RE: [PATCH] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Thread-Topic: [PATCH] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Thread-Index: AQHQLx/VbjxSoc+syku/t5Lh02zMQJy+bElg
Date: Tue, 13 Jan 2015 21:12:27 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304845072F6@US01WEMBX2.internal.synopsys.com>
References: <1421146657-18587-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1421146657-18587-1-git-send-email-r.baldyga@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Tuesday, January 13, 2015 2:58 AM
> 
> This patch fixes bug described here:
> https://lkml.org/lkml/2014/12/22/185
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/dwc2/core_intr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> index ad43c5b..668c8dd 100644
> --- a/drivers/usb/dwc2/core_intr.c
> +++ b/drivers/usb/dwc2/core_intr.c
> @@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>  	u32 gintsts;
>  	irqreturn_t retval = IRQ_NONE;
> 
> +	spin_lock(&hsotg->lock);
> +
>  	if (!dwc2_is_controller_alive(hsotg)) {
>  		dev_warn(hsotg->dev, "Controller is dead\n");
>  		goto out;

This isn't right, now the spinlock isn't released if we take this path.

Besides, this patch doesn't really make sense. How could taking the
spinlock affect the value returned from dwc2_is_controller_alive? All
it does is read from the GSNPSID register, and that register is never
written to.

Are you absolutely sure this is the fix?

-- 
Paul

>  	}
> 
> -	spin_lock(&hsotg->lock);
> -
>  	gintsts = dwc2_read_common_intr(hsotg);
>  	if (gintsts & ~GINTSTS_PRTINT)
>  		retval = IRQ_HANDLED;
> --
> 1.9.1

