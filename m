Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab3CZO7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:59:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3CZO7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:59:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
Date: Tue, 26 Mar 2013 14:58:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, konrad.wilk@oracle.com,
        Ian.Campbell@citrix.com, will.deacon@arm.com, marc.zyngier@arm.com,
        linux@arm.linux.org.uk, nico@linaro.org
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261458.55183.arnd@arndb.de>
X-Provags-ID: V02:K0:d6auu/n59I6iyuD3T2VPL/RodRczpWwWfXFnTvA/EoY
 tomJxxEENvw7c80KCHrznJkt0uHmC3rgGIgkd8DVLxBamoitsY
 hcyHjaEcKnBwKYAQgIGW0C1ThRPmilFVaUgF6LG70CK/p6ZVf+
 opcop0PtdOifcC/yfrdwDotB8VK+OraPpw9vgMKzHVQnZ+1Lcr
 DEBpvJDmDsytP0K9NdnSkJED5JUUBtfVdJfu/mKQw/Dqhg2dOI
 kZzus9xyPEfL+CSjnJijYXKJpAvz88+O5S2/kjDO6LJNLTJbAd
 xa0LiWJ7Kc1xIS8XhaeNdOLwQ5WX/SXiLK4BbAw4aHF0pKhewW
 x3oi7JNo71xuHT+/oL2o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Stefano Stabellini wrote:
> Check for the presence of PSCI before setting smp_ops, use PSCI if it is
> available.
> 
> This is useful because at least when running on Xen it's possible to have a
> PSCI node for example on a Versatile Express or an Exynos5 machine. In these
> cases the PSCI SMP calls should be the ones to be called.
> 
> Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
> anymore.

Very nice, I had a similar idea but had not gotten around to write a patch.
This fits in nicely with my plans to make all fields of machine_desc optional.

>  void __init smp_set_ops(struct smp_operations *ops)
>  {
> -       if (ops)
> +       int rc = -ENODEV;
> +#ifdef CONFIG_ARM_PSCI
> +       rc = psci_init(&smp_ops);
> +#endif
> +       if (rc && ops)
>                smp_ops = *ops;
>  };

Could you move this into the caller, i.e. setup_arch() so we call smp_set_ops
either for psci_smp_ops or for machine_desc->smp?

	Arnd
