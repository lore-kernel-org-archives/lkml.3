Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaDGMTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:19:10 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37888 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753408AbaDGMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:19:07 -0400
Message-ID: <534297AE.1020907@codethink.co.uk>
Date: Mon, 07 Apr 2014 13:18:54 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>, Arnd Bergmann <arnd@arndb.de>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org,
        gdjakov@mm-sol.com
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl> <1396852708-11058-1-git-send-email-mike.looijmans@topic.nl> <4366803.P4zmzQMZfl@wuerfel> <53429582.9010007@topic.nl> <5342971F.3010705@codethink.co.uk>
In-Reply-To: <5342971F.3010705@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/14 13:16, Ben Dooks wrote:
> On 07/04/14 13:09, Mike Looijmans wrote:
>> On 04/07/2014 10:11 AM, Arnd Bergmann wrote:
>>> On Monday 07 April 2014 08:38:28 Mike Looijmans wrote:
>>>> index 34aef81..43b90c1 100644
>>>> --- a/drivers/mmc/host/sdhci.c
>>>> +++ b/drivers/mmc/host/sdhci.c
>>>> @@ -2972,6 +2972,8 @@ int sdhci_add_host(struct sdhci_host *host)
>>>>          host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
>>>>          if (IS_ERR_OR_NULL(host->vqmmc)) {
>>>>                  if (PTR_ERR(host->vqmmc) < 0) {
>>>> +                       if (PTR_ERR(host->vqmmc) == -EPROBE_DEFER)
>>>> +                               return -EPROBE_DEFER;
>>>>                          pr_info("%s: no vqmmc regulator found\n",
>>>>                                  mmc_hostname(mmc));
>>>>                          host->vqmmc = NULL;
>>>> @@ -3048,8 +3050,10 @@ int sdhci_add_host(struct sdhci_host *host)
>>>>          host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
>>>>          if (IS_ERR_OR_NULL(host->vmmc)) {
>>>>                  if (PTR_ERR(host->vmmc) < 0) {
>>>> -                       pr_info("%s: no vmmc regulator found\n",
>>>> -                               mmc_hostname(mmc));
>>>> +                       if (PTR_ERR(host->vmmc) == -EPROBE_DEFER)
>>>> +                               return -EPROBE_DEFER;
>>>> +                       pr_info("%s: no vmmc regulator found (%d)\n",
>>>> +                               mmc_hostname(mmc),
>>>> PTR_ERR(host->vmmc));
>>>>                          host->vmmc = NULL;
>>>>                  }
>>>
>>> Please change the code to not use IS_ERR_OR_NULL() instead, getting
>>> a NULL return value from regulator_get_optional() should not be
>>> considered a bug, while getting an error return should always
>>> cause the probe function to fail.
>
> Surely it needs to be changed to IS_ERR(), nor IS_ERR_OR_NULL()?


And by that, I mean the use of "PTR_ERR(host->vmmc) < 0" to be
changed to IS_ERR(), which I think Arnd was originally complaining
about.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
