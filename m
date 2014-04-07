Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaDGMc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:32:28 -0400
Received: from smtp103.mer-nm.internl.net ([217.149.192.139]:58162 "EHLO
	smtp103.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161AbaDGMcZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:32:25 -0400
X-Spam-scanned: scanned by InterNLnet Mail Scan System
X-Spam-Flag: NO
X-Spam-Score: -2.9
X-Spam-Languages: en
Message-ID: <53429AD4.7030508@topic.nl>
Date: Mon, 7 Apr 2014 14:32:20 +0200
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben.dooks@codethink.co.uk>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cjb@laptop.org>, <gdjakov@mm-sol.com>
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
References: <1395991817-3503-1-git-send-email-mike.looijmans@topic.nl> <5342971F.3010705@codethink.co.uk> <534297AE.1020907@codethink.co.uk> <10471336.Pb8zVvW3Hp@wuerfel>
In-Reply-To: <10471336.Pb8zVvW3Hp@wuerfel>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 04/07/2014 02:25 PM, Arnd Bergmann wrote:
> On Monday 07 April 2014 13:18:54 Ben Dooks wrote:
>> On 07/04/14 13:16, Ben Dooks wrote:
>>> On 07/04/14 13:09, Mike Looijmans wrote:
>>>> On 04/07/2014 10:11 AM, Arnd Bergmann wrote:
>>>>> On Monday 07 April 2014 08:38:28 Mike Looijmans wrote:
>>>>>> index 34aef81..43b90c1 100644
>>>>>> --- a/drivers/mmc/host/sdhci.c
>>>>>> +++ b/drivers/mmc/host/sdhci.c
>>>>>> @@ -2972,6 +2972,8 @@ int sdhci_add_host(struct sdhci_host *host)
>>>>>>           host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
>>>>>>           if (IS_ERR_OR_NULL(host->vqmmc)) {
>>>>>>                   if (PTR_ERR(host->vqmmc) < 0) {
>>>>>> +                       if (PTR_ERR(host->vqmmc) == -EPROBE_DEFER)
>>>>>> +                               return -EPROBE_DEFER;
>>>>>>                           pr_info("%s: no vqmmc regulator found\n",
>>>>>>                                   mmc_hostname(mmc));
>>>>>>                           host->vqmmc = NULL;
>>>>>> @@ -3048,8 +3050,10 @@ int sdhci_add_host(struct sdhci_host *host)
>>>>>>           host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
>>>>>>           if (IS_ERR_OR_NULL(host->vmmc)) {
>>>>>>                   if (PTR_ERR(host->vmmc) < 0) {
>>>>>> -                       pr_info("%s: no vmmc regulator found\n",
>>>>>> -                               mmc_hostname(mmc));
>>>>>> +                       if (PTR_ERR(host->vmmc) == -EPROBE_DEFER)
>>>>>> +                               return -EPROBE_DEFER;
>>>>>> +                       pr_info("%s: no vmmc regulator found (%d)\n",
>>>>>> +                               mmc_hostname(mmc),
>>>>>> PTR_ERR(host->vmmc));
>>>>>>                           host->vmmc = NULL;
>>>>>>                   }
>>>>>
>>>>> Please change the code to not use IS_ERR_OR_NULL() instead, getting
>>>>> a NULL return value from regulator_get_optional() should not be
>>>>> considered a bug, while getting an error return should always
>>>>> cause the probe function to fail.
>>>
>>> Surely it needs to be changed to IS_ERR(), nor IS_ERR_OR_NULL()?
>>
>>
>> And by that, I mean the use of "PTR_ERR(host->vmmc) < 0" to be
>> changed to IS_ERR(), which I think Arnd was originally complaining
>> about.
>
> I mean something like
>
> 	host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
>
> 	if (IS_ERR(host->vqmmc)) {
> 		if (PTR_ERR(host->vqmmc) != -EPROBE_DEFER)
> 			complain(); /* only print a message if we won't retry */
> 		return ERR_PTR(host->vqmmc); /* never ignore an error */
> 	}
> 	/* silently continue if no regulator is defined */
>
> regulator_get_optional() means we can continue if it's not there, but
> we should not continue if there is a regulator that we fail to use
> for some reason.
>
> As has been found a number of times, any use of IS_ERR_OR_NULL()
> means that the person responsible for the code is confused about
> what the API is supposed to be.

Judging from the kernel output, regulator_get_optional returns -ENODEV if the 
supply wasn't found.

Maybe the API is confusing (or wrong?) here.

If you change the code as per your suggestion, the SD will not work unless you 
explicitly assign supplies. And judging from what I've seen so far, I am the 
first to have ever attached a power supply to this controller...

Mike.



Met vriendelijke groet / kind regards,

Mike Looijmans

TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Visit us at the Hannover Messe 7 - 11 April 2014 - Hall 002/D10 (Dutch Pavillion)
http://www.hannovermesse.de/exhibitor/topic-embedded-products/V229623

