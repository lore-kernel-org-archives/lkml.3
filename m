Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaJMJ2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:28:03 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:65518 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaJMJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:28:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sricharan R <r.sricharan@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 3/7] irqchip: gic: Support hierarchy irq domain.
Date: Mon, 13 Oct 2014 11:27:01 +0200
Message-ID: <3536113.xYztHpGTJM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543B93B4.3040404@arm.com>
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-4-git-send-email-yingjoe.chen@mediatek.com> <543B93B4.3040404@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kWjihPvfcaDx/pY2EXyxXUf7NC8pzsEVzAgcGcOCJPz
 Nx4cH/lIy37P2EpKoWq9YqNmftueoNHo+zFb9dJ0AMPRXaqmYg
 vx++OCfegkmchyA7/GzunDpio0x5vADm/b9CM+9YUwLbZ6PsRS
 0oiTOvHucaG3Js1yiQQGclZLDWaM7gd7Yzk79OvLxQb6+oP2ed
 CcqBWYhw5Bu+bUagQvgjsMpqSkgOc2hLoi/mcZ1pcWfwanW2kX
 ufPeuN+WG67i9p+1gbUQQIPRhGTUgNF9S/xXEwBSJsN8Wly3Uq
 DiLeNGelKsSokZvQ4hczu2VkEaVW4AhU/S3mQ+GbwUWeSwLYTR
 Km520kA5mYubbJPwDarg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 October 2014 09:56:20 Marc Zyngier wrote:
>         if (irq_domain_is_hierarchy(domain)) {
> +               if (domain->ops->xlate) {
> +                       /*
> +                        * If we've already configured this interrupt,
> +                        * don't do it again, or hell will break loose.
> +                        */
> +                       if (domain->ops->xlate(domain, irq_data->np,
> +                                              irq_data->args,
> +                                              irq_data->args_count,
> +                                              &hwirq, &type))
> +                               return 0;
> +
> +                       virq = irq_find_mapping(domain, hwirq);
> +                       if (virq)
> +                               return virq;
> +               }
>                 virq = irq_domain_alloc_irqs(domain, 1, NUMA_NO_NODE, irq_data);
>                 return virq <= 0 ? 0 : virq;
>         }
> 
> Thoughts?

Using irq_find_mapping() first is probably the right approach, that
is what irq_create_mapping() does too, and I suppose we want those
to be symmetric.

mt_sysirq_domain_alloc() in patch 4 has the irq_find_domain check
in it, which I guess we can remove when it has moved to the common
code.

I don't see irq_domain_alloc_irqs() in linux-next or older kernels, where
does that get introduced?

	Arnd
