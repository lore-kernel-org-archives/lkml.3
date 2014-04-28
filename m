Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaD1TJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:09:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65502 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaD1TJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <1398707877-22596-2-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
	<1398707877-22596-2-git-send-email-pawel.moll@arm.com>
Date: Mon, 28 Apr 2014 13:02:28 -0500
Message-ID: <CAL_JsqJxWoxNL=P0SJm+Q1rTRGTpMkzmzTJDbFq2P1vPH4XxZQ@mail.gmail.com>
Subject: Re: [PATCH 01/10] of: Keep track of populated platform devices
From: Rob Herring <robherring2@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 12:57 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> In "Device Tree powered" systems, platform devices are usually
> massively populated with of_platform_populate() call, executed
> at some level of initcalls, either by generic architecture
> or by platform-specific code.
>
> There are situations though where certain devices must be
> created (and bound with drivers) before all the others.
> This presents a challenge, as devices created explicitly
> would be created again by of_platform_populate().
>
> This patch tries to solve that issue in a generic way,
> adding a "populated" flag for a DT node description.
> Once set, this device will never be created again via
> of_* API, so of_platform_populate() will skip such nodes
> (and its children) in a similar way to the non-available
> ones.
>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/of/platform.c | 10 ++++++++--
>  include/linux/of.h    |  1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..0ae757a 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -204,7 +204,8 @@ static struct platform_device *of_platform_device_create_pdata(
>  {
>         struct platform_device *dev;
>
> -       if (!of_device_is_available(np))
> +       if (!of_device_is_available(np) ||
> +                       of_node_check_flag(np, OF_POPULATED))

This and the amba case should be a test_and_set operation to avoid a
race condition.

Rob
