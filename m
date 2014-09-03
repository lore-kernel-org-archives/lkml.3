Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaICOOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:14:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:51941 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaICOOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:14:15 -0400
Message-ID: <5407222F.9040200@collabora.com>
Date: Wed, 03 Sep 2014 16:14:07 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v8 6/7] clk: Add floor and ceiling constraints to clock
 rates
References: <1409585377-26091-1-git-send-email-tomeu.vizoso@collabora.com> <1409585675-26894-1-git-send-email-tomeu.vizoso@collabora.com> <1409585675-26894-3-git-send-email-tomeu.vizoso@collabora.com> <20140903001346.5251.47709@quantum>
In-Reply-To: <20140903001346.5251.47709@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:13 AM, Mike Turquette wrote:
> Quoting Tomeu Vizoso (2014-09-01 08:34:34)
>> @@ -1633,6 +1636,13 @@ int clk_provider_set_rate(struct clk_core *clk, unsigned long rate)
>>          /* prevent racing with updates to the clock topology */
>>          clk_prepare_lock();
>>
>> +       hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
>> +               rate = max(rate, clk_user->floor_constraint);
>> +
>> +               if (clk_user->ceiling_constraint > 0)
>> +                       rate = min(rate, clk_user->ceiling_constraint);
>
> A ceiling_constraint from consumer_A could be less than a
> floor_constraint from consumer_B. What should we do in this case?
>
> In the code above the ceiling_constraint will always win. Is that by
> design? We should document that behavior in Documentation/clk.txt.
>
> This is the right place to check for the aforementioned corner case,
> since we not only care about a single consumer having sane constraints
> (e.g. min < max) but also mixing constraints across consumers.

Yeah. I think I lean towards first applying all floors, then applying 
all ceilings. Because hardware damage could happen if a ceiling from 
thermal isn't applied because of a bug in some other driver.

This also has the advantage of being deterministic, when with the 
current approach the result depends on the order in which the per-user 
clocks are iterated.

> However ...
>
>> +       }
>> +
>>          /* bail early if nothing to do */
>>          if (rate == clk_provider_get_rate(clk))
>>                  goto out;
>> @@ -1699,6 +1709,24 @@ int clk_set_rate(struct clk *clk_user, unsigned long rate)
>>   }
>>   EXPORT_SYMBOL_GPL(clk_set_rate);
>>
>> +int clk_set_floor_rate(struct clk *clk_user, unsigned long rate)
>> +{
>> +       struct clk_core *clk = clk_to_clk_core(clk_user);
>> +
>> +       clk_user->floor_constraint = rate;
>> +       return clk_provider_set_rate(clk, clk_provider_get_rate(clk));
>> +}
>> +EXPORT_SYMBOL_GPL(clk_set_floor_rate);
>> +
>> +int clk_set_ceiling_rate(struct clk *clk_user, unsigned long rate)
>> +{
>> +       struct clk_core *clk = clk_to_clk_core(clk_user);
>> +
>> +       clk_user->ceiling_constraint = rate;
>> +       return clk_provider_set_rate(clk, clk_provider_get_rate(clk));
>> +}
>> +EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
>
> ... we should probably sanity-check constraints here to make sure that
> ceiling_rates for a given consumer are higher than floor_constraints for
> that same consumer. It's a bit extra overhead but a WARN would probably
> be helpful in this case.

Sounds like a good idea to me, will do.

Thanks,

Tomeu

> Rest of the patch looks good.
>
> Regards,
> Mike
>

