Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab3CMR2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:28:54 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:65329 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab3CMR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <1363136988-3704-1-git-send-email-agraf@suse.de>
References: <1363136988-3704-1-git-send-email-agraf@suse.de>
Date: Wed, 13 Mar 2013 10:28:50 -0700
X-Google-Sender-Auth: iYuQHC9_3bcKlddsz9eVl48cNtw
Message-ID: <CAD=FV=UXaZvZJOZwAguwi=iyYO1iMSvt8fdEsDhr96pgMXDYSg@mail.gmail.com>
Subject: Re: [PATCH] USB: ehci-s5p: Fix phy reset
From: Doug Anderson <dianders@chromium.org>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Tue, Mar 12, 2013 at 6:09 PM, Alexander Graf <agraf@suse.de> wrote:
> -       err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> -       if (err)
> +       /* reset pulls the line down, then up again */
> +       err = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, "ehci_vbus_gpio");
> +       if (err) {
>                 dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
> +               return;
> +       }
> +       mdelay(1);
> +       __gpio_set_value(gpio, 1);
> +       gpio_free(gpio);

Freeing the gpio is a little on the iffy side since you actually care
about keeping the value.  Perhaps you can change this to
devm_gpio_request_one() and avoid the free?  I was about to submit a
patch to do just that (since otherwise you run into trouble if you
ever defer the probe) but then ran across your patch.

Thanks!

-Doug
