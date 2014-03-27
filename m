Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaC0VNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:13:48 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:38685 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbaC0VNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:13:44 -0400
Message-ID: <53349484.5050100@mm-sol.com>
Date: Thu, 27 Mar 2014 23:13:40 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>, cjb@laptop.org,
        linux-mmc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, git@xilinx.com
Subject: Re: [PATCH] sdhci: Forward EPROBE_DEFER on vmmc and vqmmc regulators
References: <1394201923-27345-1-git-send-email-mike.looijmans@topic.nl> <5332EDBB.7010105@mm-sol.com> <5334644A.3010201@topic.nl>
In-Reply-To: <5334644A.3010201@topic.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.03.14, 19:47, Mike Looijmans wrote:
> On 26-3-2014 16:09, Georgi Djakov wrote:
>> On 03/07/2014 04:18 PM, Mike Looijmans wrote:
>>> If vmmc or vqmmc regulators are controlled by an I2C device, the
>>> request for the regulator is likely to fail because the I2C bus has
>>> not been probed yet. The sdhci then incorrectly assumes that the user
>>> never wanted to use a regulator anyway and continues without ever
>>> enabling or configuring the required regulator.
>>>
>>> To solve this, when a required voltage regulator returns
>>> EPROBE_DEFER, signalling that the regulator exists but is not
>>> available yet, forward this error to the probe method instead
>>> of simply assuming that the user never wanted to use a regulator
>>> anyway.
>>>
>>> Tested on a custom board that has an I2C regulator for one of the sdhcis
>>> and no regulators at all for the other. This patch enables such a system
>>> to work correctly.
>>> ---
>>>   drivers/mmc/host/sdhci.c |    8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
>>> index 34aef81..43b90c1 100644
>>> --- a/drivers/mmc/host/sdhci.c
>>> +++ b/drivers/mmc/host/sdhci.c
>>> @@ -2972,6 +2972,8 @@ int sdhci_add_host(struct sdhci_host *host)
>>>       host->vqmmc = regulator_get_optional(mmc_dev(mmc), "vqmmc");
>>>       if (IS_ERR_OR_NULL(host->vqmmc)) {
>>>           if (PTR_ERR(host->vqmmc) < 0) {
>>> +            if (PTR_ERR(host->vqmmc) == -EPROBE_DEFER)
>>> +                return -EPROBE_DEFER;
>>>               pr_info("%s: no vqmmc regulator found\n",
>>>                   mmc_hostname(mmc));
>>>               host->vqmmc = NULL;
>>> @@ -3048,8 +3050,10 @@ int sdhci_add_host(struct sdhci_host *host)
>>>       host->vmmc = regulator_get_optional(mmc_dev(mmc), "vmmc");
>>>       if (IS_ERR_OR_NULL(host->vmmc)) {
>>>           if (PTR_ERR(host->vmmc) < 0) {
>>> -            pr_info("%s: no vmmc regulator found\n",
>>> -                mmc_hostname(mmc));
>>> +            if (PTR_ERR(host->vmmc) == -EPROBE_DEFER)
>>> +                return -EPROBE_DEFER;
>>> +            pr_info("%s: no vmmc regulator found (%d)\n",
>>
>> I suggest using %ld here. The rest looks fine to me! Thanks!
> 
> Does this mean you're waiting for a patch v2 that I should submit?
> 

Yes, please submit v2 and hope to get some more feedback from the community.

Thanks,
Georgi

>>
>>> +                mmc_hostname(mmc), PTR_ERR(host->vmmc));
>>>               host->vmmc = NULL;
>>>           }
>>>       }
>>>
>>
>> BR,
>> Georgi
>>

