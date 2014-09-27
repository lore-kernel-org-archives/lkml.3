Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaI0APE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:15:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42522 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaI0APD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:15:03 -0400
Message-ID: <54260184.2040704@codeaurora.org>
Date: Fri, 26 Sep 2014 17:15:00 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 0/9] Per-user clock constraints
References: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com> <5421DF46.2010107@codeaurora.org> <54228067.3090600@collabora.com> <5424C182.5000906@codeaurora.org> <54251F30.8080303@collabora.com> <20140926232009.19023.15825@quantum>
In-Reply-To: <20140926232009.19023.15825@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/14 16:20, Mike Turquette wrote:
> Quoting Tomeu Vizoso (2014-09-26 01:09:20)
>> On 09/26/2014 03:29 AM, Stephen Boyd wrote:
>>
>>> We already have the consumer/provider split in the struct clk_hw and
>>> struct clk separation. Why don't we just use struct clk_hw throughout
>>> the provider APIs? The only op that isn't doing this is determine_rate()
>>> which might be able to accept a flag day. Otherwise we rename it to
>>> something else and migrate everyone over to a different named function
>>> that doesn't take a struct clk **. Then we introduce new APIs for the
>>> providers to use that are struct clk_hw focused instead of struct clk
>>> focused and migrate them too. The benefit being that we get proper
>>> review of this stuff because the patches are small. We can let
>>> coccinelle do it too.
> I have been opposed to mucking with clk_hw before, but that was because
> the goal was never clear. Now that we know that we're trying to split
> the API then it might be reasonable to use it.
>
> Stephen, does your above proposal still allow for unique struct clk
> cookies for each user of a clock?
>
>

Yes. The clkdev code would know that it's getting clk_hw pointers back
from the provider instead of struct clk pointers because it uses a
different callback:

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bacc06ff939b..76c356b779d1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2337,6 +2337,7 @@ struct of_clk_provider {
 
        struct device_node *node;
        struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
+       struct clk_hw *(*get_hw)(struct of_phandle_args *clkspec, void *data);
        void *data;
 };
 

 

It would test for the presence of the get_hw callback and then fall back
to the get callback. Similarly we would have a clk_hw pointer in the
clkdev lookup structure. Once clkdev has the hw pointer it can ask the
ccf to generate a struct clk cookie. This would happen either in
__of_clk_get_from_provider() or clk_get_sys() depending on if we're
using DT or not.

The clk_hw structure will need to be updated to have a pointer to
clk_core. During the transition we would have struct clk and struct
clk_core next to each other in struct clk_hw. Eventually once we convert
all drivers we can remove struct clk from clk_hw. This would require
getting rid of the DEFINE_CLK macro in clk-private.h though.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

