Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3FLK4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:56:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3FLK4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:56:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        linux-pci@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Andrew Murray'" <andrew.murray@arm.com>
Subject: Re: [PATCH V4 3/3] ARM: dts: Add pcie controller node for Samsung EXYNOS5440 SoC
Date: Wed, 12 Jun 2013 12:55:36 +0200
Message-ID: <3532163.SqzZzxO4BR@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <003801ce6756$6578ff80$306afe80$@samsung.com>
References: <003801ce6756$6578ff80$306afe80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GraIAENF5W3NSLI+SaribYcgh/2T4JEWMNG9tAPqw7P
 pRgmhzCDW0fO8bsVoqJxd82Fbf6CoMuRNwOVZ1hSwzTZfE0Qhz
 RaufVXflu3COW9n8f4UcIkWpe4GHomW0JjS8JXCynwZDF2A1fE
 Snmyksts5Kq3RZwjXqCyeUb4gTSZRLDHWwquP3oWTJ55735OS8
 Lqcs9bT5A7g9Jwid6Elk4H+VvTLhSXG56U7WE6liNecM66ErJE
 uO8aKaQfjvNPBKMQ7vmnipus8CBZdb8AY9wZFtrXq7oG+FT6Aw
 oy10+oN0l4bEoxRpxCxuT2N8yzFhHt+USiYcEdDIIf5zCi3O0e
 kbxEtA5ywhJTLXcR+aOY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the update! A few comments again:

On Wednesday 12 June 2013 19:20:00 Jingoo Han wrote:
> 
> diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> index d55042b..efe7d39 100644
> --- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> +++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
> @@ -30,4 +30,12 @@
>                         clock-frequency = <50000000>;
>                 };
>         };
> +
> +       pcie0@40000000 {
> +               reset-gpio = <5>;
> +       };
> +
> +       pcie1@60000000 {
> +               reset-gpio = <22>;
> +       };
>  };

As mentioned before, please use the gpio binding to pass gpio numbers.

> diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
> index f6b1c89..2c15f9d 100644
> --- a/arch/arm/boot/dts/exynos5440.dtsi
> +++ b/arch/arm/boot/dts/exynos5440.dtsi
> @@ -216,4 +216,42 @@
>                 clock-names = "rtc";
>                 status = "disabled";
>         };
> +
> +       pcie0@0x290000 {
> +               compatible = "samsung,exynos5440-pcie";
> +               reg = <0x290000 0x1000
> +                       0x270000 0x1000
> +                       0x271000 0x40>;
> +               interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
> +               clocks = <&clock 28>, <&clock 27>;
> +               clock-names = "pcie", "pcie_bus";
> +               #address-cells = >;
> +               #size-cells = <2>;
> +               device_type = "pci";
> +               ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
> +                         0x81000000 0 0          0x40200000 0 0x00010000   /* downstream I/O */
> +                         0x82000000 0 0x40210000 0x40210000 0 0x10000000>; /* non-prefetchable memory */

I think you did not reply to my question regarding the size of the
memory space. Does it extend from 0x40210000 to 0x50210000,
or from 0x40210000 to 0x50000000. You probably meant the latter
but wrote the former. If not, please add a comment for clarification.

> +               #interrupt-cells = <1>;
> +               interrupt-map-mask = <0 0 0 0>;
> +               interrupt-map = <0x0 0 &gic 53>;
> +       };

So all PCI IntA interrupts are mapped to a single gic interrupt? That
sounds like a bottleneck when you have a lot of devices on the bus.
Do you have MSI support?

	Arnd
