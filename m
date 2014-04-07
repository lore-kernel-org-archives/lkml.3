Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaDGIL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:11:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaDGILw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:11:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        gdjakov@mm-sol.com
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
Date: Mon, 07 Apr 2014 10:11:20 +0200
Message-ID: <4366803.P4zmzQMZfl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396852708-11058-1-git-send-email-mike.looijmans@topic.nl>
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl> <1396852708-11058-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QUmJ36sO8DawrrrQZ06LOWLpf7qTdqc14ckBxF2FJGo
 qZR0sHP5PxAVduoZaWaV++aR0GBevr2yZ+gXfaSt8NIrRgPlml
 vnic2Bb0HhRRZERIBqBAVzMnWi0zan6HE7el5pHBhvc6/uDPAL
 EZNyVzgrdRpFTPEnsH0x5B5+/7uO5soOI1RSLO8z3rq8UShhuc
 xMaloiX/cLTL4d+QuxQdExZs8FuaDUL1l7HqwuyjsVEnImB1bB
 HgNdLNe9kw6TlF4eDad3AEYsA/jLU1nObny8Ehs9wP9ceGfmyd
 5L0NlX9/cCa01xuzS5w25rRIPjcjku/vZMEaVwCnh3gbNNTeBg
 qf2a0r25BDSS+1pXd0xE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2014 08:38:28 Mike Looijmans wrote:
> index 34aef81..43b90c1 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2972,6 +2972,8 @@ int sdhci_add_host(struct sdhci_host *host)
>         host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
>         if (IS_ERR_OR_NULL(host->vqmmc)) {
>                 if (PTR_ERR(host->vqmmc) < 0) {
> +                       if (PTR_ERR(host->vqmmc) == -EPROBE_DEFER)
> +                               return -EPROBE_DEFER;
>                         pr_info("%s: no vqmmc regulator found\n",
>                                 mmc_hostname(mmc));
>                         host->vqmmc = NULL;
> @@ -3048,8 +3050,10 @@ int sdhci_add_host(struct sdhci_host *host)
>         host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
>         if (IS_ERR_OR_NULL(host->vmmc)) {
>                 if (PTR_ERR(host->vmmc) < 0) {
> -                       pr_info("%s: no vmmc regulator found\n",
> -                               mmc_hostname(mmc));
> +                       if (PTR_ERR(host->vmmc) == -EPROBE_DEFER)
> +                               return -EPROBE_DEFER;
> +                       pr_info("%s: no vmmc regulator found (%d)\n",
> +                               mmc_hostname(mmc), PTR_ERR(host->vmmc));
>                         host->vmmc = NULL;
>                 }

Please change the code to not use IS_ERR_OR_NULL() instead, getting
a NULL return value from regulator_get_optional() should not be
considered a bug, while getting an error return should always
cause the probe function to fail.

	Arnd
