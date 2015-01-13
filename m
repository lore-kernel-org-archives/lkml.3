Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbbAMW2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:28:14 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52974 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAMW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:28:10 -0500
MIME-Version: 1.0
In-Reply-To: <1420651854-17768-3-git-send-email-s-anna@ti.com>
References: <1420651854-17768-1-git-send-email-s-anna@ti.com> <1420651854-17768-3-git-send-email-s-anna@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 13 Jan 2015 16:27:48 -0600
Message-ID: <CAL_JsqK8ZAUZwd1zjjZ57MQZ+KD-_qiCyMXnhQ-zZ38wxUtf-g@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] core: platform: fix an invalid kfree during of_platform_depopulate
To: Suman Anna <s-anna@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Felipe Balbi <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 11:30 AM, Suman Anna <s-anna@ti.com> wrote:
> Drivers can use of_platform_populate() to create platform devices
> for children of the device main node, and a complementary API
> of_platform_depopulate() is provided to delete these child devices.
> Any platform_data supplied for the OF devices through auxdata lookup
> data is populated directly in the device's platform_data field, unlike
> those created using platform API. The of_platform_depopulate()
> leverages the platform code for cleanup, and this will result in a
> kernel oops due to an invalid kfree on this direct populated
> platform_data.
>
> Fix this by resetting the platform data for OF devices during
> platform device cleanup.

We should probably copy the platform_data like is done for non-OF
platform devices. I'm sure there was some reason for it. It looks
strange doing this in release.

However, I'm inclined to not fix this and force users to move off of
auxdata. That's intended to be a temporary migration path and there
are only 54 instances of it that have platform_data. What device do
you care about?

Rob

>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  drivers/base/platform.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9421fed40905..129e69c8c894 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -200,6 +200,8 @@ static void platform_device_release(struct device *dev)
>         struct platform_object *pa = container_of(dev, struct platform_object,
>                                                   pdev.dev);
>
> +       if (pa->pdev.dev.of_node)
> +               pa->pdev.dev.platform_data = NULL;
>         of_device_node_put(&pa->pdev.dev);
>         kfree(pa->pdev.dev.platform_data);
>         kfree(pa->pdev.mfd_cell);
> --
> 2.2.1
>
