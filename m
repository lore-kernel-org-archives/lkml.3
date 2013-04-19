Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3DSEx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 00:53:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1599 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3DSEx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 00:53:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 18 Apr 2013 21:53:25 -0700
Message-ID: <5170CCD1.6000600@nvidia.com>
Date: Fri, 19 Apr 2013 10:19:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: palmas: Remove wrong voltage setting for
 enabling LDO8 tracking mode
References: <1366341289.18636.2.camel@phoenix>
In-Reply-To: <1366341289.18636.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013 08:44 AM, Axel Lin wrote:
> When SMPS45 is set to off and LDO8 tracking is enabled, LDO8 output can be set
> from 0.45 to 1.65V and the steps of voltage change is 25mV.
>
> This is done by setting:
>          pmic->desc[id].min_uV = 450000;
>          pmic->desc[id].uV_step = 25000;
>
> I don't see the point of reading vsel register, multiple the register value by
> 2 and then write back to the register.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Laxman,
>
> Current code looks strange (and wrong) to me.
> I don't see the point of reading vsel register, multiple the register value by
> 2 and then write back to the register.
> Can you double check this patch, in case I might misunderstand the code.

When we configure for tracking mode, the equation of voltage out put change:
Vnt = 0.9 + reg*0.05
to
Vt = 0.45 + reg*0.025

So we need to adjust the current register setting to have the same 
voltage output when smps45 is OFF.

But however, just doubling the register content is not suffice here. I 
did math again and it should be

reg = reg << 2 + 18.

+18 because we need to adjust the Vmin also (18 * 0.25 = 0.45).
So here we need to fix this.

