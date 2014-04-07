Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaDGMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:25:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:65492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaDGMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:25:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cjb@laptop.org, gdjakov@mm-sol.com
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
Date: Mon, 07 Apr 2014 14:25:23 +0200
Message-ID: <10471336.Pb8zVvW3Hp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <534297AE.1020907@codethink.co.uk>
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl> <5342971F.3010705@codethink.co.uk> <534297AE.1020907@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QACehD1MvRluKQJ7CAgV0HXMUtVxaS51qMlUAoph8oo
 I+7ga+zyZtRn88wCX9STXI1p9oDfflSryX0CvTt8010ZgriCYb
 thAZEEWxqB7DvFtqCssklb6Bp5jQHVVSqHu0pg4OaoNF5BLZIC
 Upmdgu64KJsaePNY1Xrswh8Rlcnw81dIzV3vg2JfOYDa6wwV5t
 wRPavSLzaI9MhX51PwjaOgLyYzN/1ItxnMX+42+t0/8enwAYE1
 UD/8o93+/XFMvN3gIEzpR8Nxv4rOwbmFjm1ouk7HWkxGUqWcLQ
 5A40Kk1dDgzMp8lKiAvZSWMwbAIV+sFMgDh2EwBWg6Kw0fZzRD
 ZBXkBTtd0okNuXZyfZtE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 April 2014 13:18:54 Ben Dooks wrote:
> On 07/04/14 13:16, Ben Dooks wrote:
> > On 07/04/14 13:09, Mike Looijmans wrote:
> >> On 04/07/2014 10:11 AM, Arnd Bergmann wrote:
> >>> On Monday 07 April 2014 08:38:28 Mike Looijmans wrote:
> >>>> index 34aef81..43b90c1 100644
> >>>> --- a/drivers/mmc/host/sdhci.c
> >>>> +++ b/drivers/mmc/host/sdhci.c
> >>>> @@ -2972,6 +2972,8 @@ int sdhci_add_host(struct sdhci_host *host)
> >>>>          host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
> >>>>          if (IS_ERR_OR_NULL(host->vqmmc)) {
> >>>>                  if (PTR_ERR(host->vqmmc) < 0) {
> >>>> +                       if (PTR_ERR(host->vqmmc) == -EPROBE_DEFER)
> >>>> +                               return -EPROBE_DEFER;
> >>>>                          pr_info("%s: no vqmmc regulator found\n",
> >>>>                                  mmc_hostname(mmc));
> >>>>                          host->vqmmc = NULL;
> >>>> @@ -3048,8 +3050,10 @@ int sdhci_add_host(struct sdhci_host *host)
> >>>>          host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
> >>>>          if (IS_ERR_OR_NULL(host->vmmc)) {
> >>>>                  if (PTR_ERR(host->vmmc) < 0) {
> >>>> -                       pr_info("%s: no vmmc regulator found\n",
> >>>> -                               mmc_hostname(mmc));
> >>>> +                       if (PTR_ERR(host->vmmc) == -EPROBE_DEFER)
> >>>> +                               return -EPROBE_DEFER;
> >>>> +                       pr_info("%s: no vmmc regulator found (%d)\n",
> >>>> +                               mmc_hostname(mmc),
> >>>> PTR_ERR(host->vmmc));
> >>>>                          host->vmmc = NULL;
> >>>>                  }
> >>>
> >>> Please change the code to not use IS_ERR_OR_NULL() instead, getting
> >>> a NULL return value from regulator_get_optional() should not be
> >>> considered a bug, while getting an error return should always
> >>> cause the probe function to fail.
> >
> > Surely it needs to be changed to IS_ERR(), nor IS_ERR_OR_NULL()?
> 
> 
> And by that, I mean the use of "PTR_ERR(host->vmmc) < 0" to be
> changed to IS_ERR(), which I think Arnd was originally complaining
> about.

I mean something like

	host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");

	if (IS_ERR(host->vqmmc)) {
		if (PTR_ERR(host->vqmmc) != -EPROBE_DEFER)
			complain(); /* only print a message if we won't retry */
		return ERR_PTR(host->vqmmc); /* never ignore an error */
	}
	/* silently continue if no regulator is defined */

regulator_get_optional() means we can continue if it's not there, but
we should not continue if there is a regulator that we fail to use
for some reason.

As has been found a number of times, any use of IS_ERR_OR_NULL()
means that the person responsible for the code is confused about
what the API is supposed to be.

	Arnd
