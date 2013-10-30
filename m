Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3J3Iii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:38:38 -0400
Received: from canardo.mork.no ([148.122.252.1]:38385 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab3J3Iie convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:38:34 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: David Miller <davem@davemloft.net>
Cc: changbinx.du@intel.com, oliver@neukum.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/cdc_ncm: fix null pointer panic at usbnet_link_change
Organization: m
References: <0C18FE92A7765D4EB9EE5D38D86A563A019F450F@SHSMSX103.ccr.corp.intel.com>
	<20131029.223823.1852248673779937090.davem@davemloft.net>
Date: Wed, 30 Oct 2013 09:38:18 +0100
In-Reply-To: <20131029.223823.1852248673779937090.davem@davemloft.net> (David
	Miller's message of "Tue, 29 Oct 2013 22:38:23 -0400 (EDT)")
Message-ID: <87y55bduh1.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> The problem is in cdc_ncm_bind_common().
>
> It seems to leave dangling interface data pointers in some cases, and
> then branches just to "error" so that they don't get cleared back out.

Sorry, but I fail to see this as well.  I see one "return" and two "goto
error", but all are well before any intfdata pointer is set:

    364         ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
    365         if (!ctx)
    366                 return -ENOMEM;
    367 
[..]
    453         /* check if we got everything */
    454         if ((ctx->control == NULL) || (ctx->data == NULL) ||
    455             ((!ctx->mbim_desc) && ((ctx->ether_desc == NULL) || (ctx->control != intf))))
    456                 goto error;
    457 
    458         /* claim data interface, if different from control */
    459         if (ctx->data != ctx->control) {
    460                 temp = usb_driver_claim_interface(driver, ctx->data, dev);
    461                 if (temp)
    462                         goto error;
    463         }
[..]
    490         usb_set_intfdata(ctx->data, dev);
    491         usb_set_intfdata(ctx->control, dev);
    492         usb_set_intfdata(ctx->intf, dev);
[..]
    510         return 0;
    511 
    512 error2:
    513         usb_set_intfdata(ctx->control, NULL);
    514         usb_set_intfdata(ctx->data, NULL);
    515         if (ctx->data != ctx->control)
    516                 usb_driver_release_interface(driver, ctx->data);
    517 error:
    518         cdc_ncm_free((struct cdc_ncm_ctx *)dev->data[0]);
    519         dev->data[0] = 0;
    520         dev_info(&dev->udev->dev, "bind() failure\n");
    521         return -ENODEV;
    522 }
 

This could (and given this thread, probably should) certainly be
refactored and cleaned up a bit.  But I do not see how it leaves any
dangling pointers.  The pointers are only set near the end of the
function, and the only exit points after that are either success or
through the "error2" label.

Side note: It is definitely confusing that we set 3 pointers, but only
clean up 2.  The reason is that there are never more than 2 interfaces
involved here. We always have ctx->intf == ctx->control.  I'd really
like to get rid of that redundant ctx->intf pointer.  That's one issue
to cleanup throughout this driver.



Bjørn
