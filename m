Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaEZFcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:32:55 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:45402 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaEZFcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:32:54 -0400
Date: Sun, 25 May 2014 22:32:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] Input: mc13783-pwrbutton: Allocate resources using
 managed interfaces
Message-ID: <20140526053251.GC12890@core.coreip.homeip.net>
References: <20140525101400.GA19075@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140525101400.GA19075@himangi-Dell>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 03:44:01PM +0530, Himangi Saraogi wrote:
> This patch moves most data allocated in the probe function from
> unmanaged interfaces to managed interfaces. The kfrees and error
> handling code is done away with. The unnecesary labels are
> removed. Also, linux/device.h is added to make sure the devm_*()
> routine declarations are unambiguously available. The name of label
> free_priv is changed to unlock as it does not free priv anymore.
> 
> The following Coccinelle semantic patch was used for making a part of
> the change:
> 
> @platform@
> identifier p, probefn, removefn;
> @@
> struct platform_driver p = {
>   .probe = probefn,
>   .remove = removefn,
> };
> 
> @prb@
> identifier platform.probefn, pdev;
> expression e, e1, e2;
> @@
> probefn(struct platform_device *pdev, ...) {
>   <+...
> - e = kzalloc(e1, e2)
> + e = devm_kzalloc(&pdev->dev, e1, e2)
>   ...
> ?-kfree(e);
>   ...+>
> }
> 
> @rem depends on prb@
> identifier platform.removefn;
> expression e;
> @@
> removefn(...) {
>   <...
> - kfree(e);
>   ...>
> }
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> Not compiled due to incompatible architecture.
> 
> mc13xxx_irq_request is not devm'd, and doing so looks complicated due to
> the locks around the frees.  Is there some way to resolve this issue?

Yes there us - let's leave the driver as is so we are not mixing the 2
styles.

Thanks.

-- 
Dmitry
