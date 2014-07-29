Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaG2MB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:01:59 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59564 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaG2MB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:01:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@linaro.org>,
        Rob Herring <robherring2@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, Mark Brown <broonie@linaro.org>
Subject: Re: use IORESOURCE_REG resource type for non-translatable addresses in DT
Date: Tue, 29 Jul 2014 14:00:50 +0200
Message-ID: <3794875.CZFbAag5Sv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53D788A7.4020303@mm-sol.com>
References: <53D788A7.4020303@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bBFuRxr95vrLXWLwzXcOjmXs3Fft5LJRwg4mhHx4E0s
 S3eCGlJfF3ImGYYib8vDjVCy+EpxKZT4PapynFXs13XzGBhT9O
 p/wit0RTPPEvg8dfrPif9Wxfc/Brk+kXH6wJto7zfaCEunkST7
 ip/+Lh/gIojJ3of/AazzFVqUmG700gxh+qvZ0MOXJPk11dF/rW
 XojP6YBgjiaypbD1e4w6DwtojkLidp16uqA9Em9y2ikcJzKpoL
 QNwFxtFOQUKIsmXwlSP1bkhLNGp2H+UmripzenjwbcSFcyw/Ox
 aKDfzLESbKSaK7wU7Ygcx962XHUi26Rhs0H1qNQuyAvtOLjV4q
 L0j1gjI3+T90RPvl48bA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2014 14:42:31 Stanimir Varbanov wrote:
>         taddr = of_translate_address(dev, addrp);
> -       if (taddr == OF_BAD_ADDR)
> -               return -EINVAL;
> +       /*
> +        * if the address is non-translatable to cpu physical address
> +        * fallback to a IORESOURCE_REG resource.
> +        */
> +       if (taddr == OF_BAD_ADDR) {
> +               memset(r, 0, sizeof(*r));
> +               taddr = of_read_number(addrp, 1);
> +               if (taddr == OF_BAD_ADDR)
> +                       return -EINVAL;
> +               r->start = taddr;
> +               r->end = taddr + size - 1;
> +               r->flags = IORESOURCE_REG;
> +               r->name = name ? name : dev->full_name;
> +               return 0;
> +       }
> +

I don't think that everything returning OF_BAD_ADDR makes sense
to turn into IORESOURCE_REG. It could be an e.g. invalid DT
representation, a node with #size-cells=<0>, or it could be
something that gets translated one or more nodes up in the
tree before it reaches a bus without a ranges property.

Also, you should not rely on #address-cells being hardcoded
to <1> above.

How about modifying of_get_address() rather than
__of_address_to_resource() instead? You could introduce
a new of_bus entry for each bus you expect to return
an IORESOURCE_REG, or you could change of_bus_default_get_flags
to return IORESOURCE_REG if the parent node has no ranges property
and is not the root node.

	Arnd
