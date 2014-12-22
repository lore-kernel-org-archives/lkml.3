Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaLVT0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:26:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41920 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaLVT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:26:44 -0500
Message-ID: <54987072.4050002@codeaurora.org>
Date: Mon, 22 Dec 2014 11:26:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
CC: Rajendra Nayak <rnayak@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk: Fix __GFP_FS allocation with irqs disabled
References: <1419248747-3367-1-git-send-email-k.kozlowski@samsung.com> <54986525.3070305@codeaurora.org>
In-Reply-To: <54986525.3070305@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 10:38 AM, Stephen Boyd wrote:
> On 12/22/2014 03:45 AM, Krzysztof Kozlowski wrote:
>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index f4963b7d4e17..35079302a650 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -1150,6 +1150,12 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
>>  {
>>  	int i;
>>  
>> +	if (clk->num_parents == 1) {
>> +		if (IS_ERR_OR_NULL(clk->parent))
>> +			clk->parent = __clk_lookup(clk->parent_names[0]);
>> +		return 0;
>> +	}
>> +
>>  	if (!clk->parents) {
>>  		clk->parents = kcalloc(clk->num_parents,
>>  					sizeof(struct clk *), GFP_KERNEL);
> This may be a worthwhile optimization, but I wonder why the clk_ops for
> this clock need to fetch the parent index at all? Which clock are we
> actually dealing with here?
>

The clk_set_rate() call should still be fixed, but we can probably do
this too.

---8<---

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Mon, 22 Dec 2014 11:24:28 -0800
Subject: [PATCH] clk: Skip fetching index for single parent clocks

We don't need to fetch the parent index for clocks if they only
have one parent. Doing this also avoid an unnecessary allocation
for the parent cache.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 675f37a7329f..e3a2d36124fd 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1420,7 +1420,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 	}
 
 	/* try finding the new parent index */
-	if (parent) {
+	if (parent && clk->num_parents > 1) {
 		p_index = clk_fetch_parent_index(clk, parent);
 		if (p_index < 0) {
 			pr_debug("%s: clk %s can not be parent of clk %s\n",

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

