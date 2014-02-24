Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaBXPHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:07:21 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:38657 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbaBXPHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:07:19 -0500
Message-ID: <530B6023.5020400@epfl.ch>
Date: Mon, 24 Feb 2014 16:07:15 +0100
From: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - LSRO1
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 13/16] regulator: mc13xxx: Use of_get_child_by_name
References: <530B4CB6.9010608@epfl.ch> <CAK9yfHy+ZNtY1bsiupyhf7LTPkAUSntB5O7sqgt7Lk+B2EowZg@mail.gmail.com>
In-Reply-To: <CAK9yfHy+ZNtY1bsiupyhf7LTPkAUSntB5O7sqgt7Lk+B2EowZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/02/2014 15:51, Sachin Kamat a écrit :
> On 24 February 2014 19:14, Philippe Rétornaz
> <philippe.retornaz@epfl.ch> wrote:
>> Hi
>>
>> This patch breaks DT-Enabled kernel run on non-DT board: [
>> 0.822977] Unable to handle kernel NULL pointer dereference at
>> virtual address 0000001c (...) [    0.880320] [<c02f3e94>]
>> (of_get_next_child) from [<c02f5420>]
>> (of_get_child_by_name+0x38/0x50) [    0.881449] [<c02f5420>]
>> (of_get_child_by_name) from [<c01f6258>]
>> (mc13xxx_get_num_regulators_dt+0x18/0x64) [    0.882707]
>> [<c01f6258>] (mc13xxx_get_num_regulators_dt) from [<c01f5d38>]
>> (mc13783_regulator_probe+0x34/0x17c) [    0.884011] [<c01f5d38>]
>> (mc13783_regulator_probe) from [<c021fed0>]
>> (platform_drv_probe+0x20/0x54) [    0.885182] [<c021fed0>]
>> (platform_drv_probe) from [<c021e674>]
>> (driver_probe_device+0x144/0x360) (...)
>>
>> Because mc13783-regulator do in its probe: static int
>> mc13783_regulator_probe(struct platform_device *pdev) { (...) int
>> i, num_regulators;
>>
>> num_regulators = mc13xxx_get_num_regulators_dt(pdev); if
>> (num_regulators <= 0 && pdata) num_regulators =
>> pdata->num_regulators
>>
>>
>> and mc13xxx_get_num_regulators_dt() do, before your patch:
>>
>> parent = of_find_node_by_name(pdev->dev.parent->of_node,
>> "regulators"); if (!parent) return -ENODEV;
>>
>> of_find_node_by_name will return NULL if the node passed is NULL
>> and the DT is non-existant.
>>
>> But, with your change we use this: parent =
>> of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
>>
>> Which will OOPS as it does not expect to have a NULL node passed as
>> argument.
>>
>> So please revert this patch.
>
> Sorry for the issue caused due to this patch. I would prefer to try
> to have this fixed before reverting. Can you please try with below
> change and let me know if it works:
>
> parent = of_get_child_by_name(pdev->dev->of_node, "regulators");
>

You meant pdev->dev.of_node here I guess ?
This still OOPS as the board is not booting with DT, so all of_node are
NULL.

> Also, how about adding NULL check to see it the node exists at all?
>

Could be an option. BTW, mc13xxx_parse_regulators_dt() has the same problem.

Regards,

Philippe



