Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaBXOvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:51:15 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:43456 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBXOvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:51:12 -0500
MIME-Version: 1.0
In-Reply-To: <530B4CB6.9010608@epfl.ch>
References: <530B4CB6.9010608@epfl.ch>
Date: Mon, 24 Feb 2014 20:21:11 +0530
Message-ID: <CAK9yfHy+ZNtY1bsiupyhf7LTPkAUSntB5O7sqgt7Lk+B2EowZg@mail.gmail.com>
Subject: Re: [PATCH 13/16] regulator: mc13xxx: Use of_get_child_by_name
From: Sachin Kamat <sachin.kamat@linaro.org>
To: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@epfl.ch>
Cc: Mark Brown <broonie@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 February 2014 19:14, Philippe Rétornaz <philippe.retornaz@epfl.ch> wrote:
> Hi
>
> This patch breaks DT-Enabled kernel run on non-DT board:
> [    0.822977] Unable to handle kernel NULL pointer dereference at virtual
> address 0000001c
> (...)
> [    0.880320] [<c02f3e94>] (of_get_next_child) from [<c02f5420>]
> (of_get_child_by_name+0x38/0x50)
> [    0.881449] [<c02f5420>] (of_get_child_by_name) from [<c01f6258>]
> (mc13xxx_get_num_regulators_dt+0x18/0x64)
> [    0.882707] [<c01f6258>] (mc13xxx_get_num_regulators_dt) from
> [<c01f5d38>] (mc13783_regulator_probe+0x34/0x17c)
> [    0.884011] [<c01f5d38>] (mc13783_regulator_probe) from [<c021fed0>]
> (platform_drv_probe+0x20/0x54)
> [    0.885182] [<c021fed0>] (platform_drv_probe) from [<c021e674>]
> (driver_probe_device+0x144/0x360)
> (...)
>
> Because mc13783-regulator do in its probe:
> static int mc13783_regulator_probe(struct platform_device *pdev)
> {
> (...)
>         int i, num_regulators;
>
>         num_regulators = mc13xxx_get_num_regulators_dt(pdev);
>         if (num_regulators <= 0 && pdata)
>                 num_regulators = pdata->num_regulators
>
>
> and mc13xxx_get_num_regulators_dt() do, before your patch:
>
> parent = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
> if (!parent)
>                 return -ENODEV;
>
> of_find_node_by_name will return NULL if the node passed is NULL and the
> DT is non-existant.
>
> But, with your change we use this:
> parent = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
>
> Which will OOPS as it does not expect to have a NULL node passed as
> argument.
>
> So please revert this patch.

Sorry for the issue caused due to this patch. I would prefer to try to
have this fixed before reverting.
Can you please try with below change and let me know if it works:

 parent = of_get_child_by_name(pdev->dev->of_node, "regulators");

Also, how about adding NULL check to see it the node exists at all?

-- 
With warm regards,
Sachin
