Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaIDNfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:35:06 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58482 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaIDNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:35:03 -0400
Message-ID: <54086A81.1060606@collabora.com>
Date: Thu, 04 Sep 2014 15:34:57 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 5/6] clk: Add floor and ceiling constraints to clock
 rates
References: <1409758148-20104-1-git-send-email-tomeu.vizoso@collabora.com> <1409758434-20810-1-git-send-email-tomeu.vizoso@collabora.com> <1409758434-20810-3-git-send-email-tomeu.vizoso@collabora.com> <5407A6B9.1080606@codeaurora.org>
In-Reply-To: <5407A6B9.1080606@codeaurora.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 01:39 AM, Stephen Boyd wrote:
> On 09/03/14 08:33, Tomeu Vizoso wrote:
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 61a3492..3a961c6 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -560,6 +560,8 @@ struct clk *__clk_create_clk(struct clk_core *clk_core, const char *dev,
>>  	clk->dev_id = dev;
>>  	clk->con_id = con;
>>  
>> +	hlist_add_head(&clk->child_node, &clk_core->per_user_clks);
>> +
> 
> How is this safe with another thread that may be traversing the list? Or
> even two threads calling clk_get_parent() at the same time?

Good point, will take the prepare lock.

>> +int clk_set_floor_rate(struct clk *clk_user, unsigned long rate)
>> +{
>> +	struct clk_core *clk = clk_to_clk_core(clk_user);
>> +
>> +	clk_user->floor_constraint = rate;
>> +	return clk_provider_set_rate(clk, clk_provider_get_rate(clk));
> 
> It would be nice if this was also locked around so that the
> floor_constraint or ceiling_constraint doesn't change while another
> thread is iterating the list. I guess we'll get by though because
> eventually things will settle and either this thread here will set the
> "final" rate, or the other thread in clk_provider_set_rate() will have
> already set the final rate. It just seems wrong to not hold the lock
> while updating what is supposed to be protected by the prepare lock.

Yeah, I also lean towards having an explicit lock, as having a more
deterministic behaviour can be quite helpful when debugging.

Thanks,

Tomeu
