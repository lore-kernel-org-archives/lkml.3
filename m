Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3APMpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:45:17 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:42738 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3APMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:45:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130115224502.23734.7414@quantum>
References: <1357650191-30842-1-git-send-email-rajagopal.venkat@linaro.org>
	<1357712988-22317-1-git-send-email-rajagopal.venkat@linaro.org>
	<20130115224502.23734.7414@quantum>
Date: Wed, 16 Jan 2013 18:15:13 +0530
Message-ID: <CA+Z25wW=g+-Uo2DLpD=0ADjWTh5DKQb5ePPXR1tz0LXH3_b-xg@mail.gmail.com>
Subject: Re: [PATCH] clk: remove unreachable code
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2013 04:15, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Rajagopal Venkat (2013-01-08 22:29:48)
>> while reparenting a clock, NULL check is done for clock in
>> consideration and its new parent. So re-check is not required.
>> If done, else part becomes unreachable.
>>
>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>> ---
>>  drivers/clk/clk.c |   13 ++-----------
>>  1 file changed, 2 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 251e45d..1c4097c 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -1040,7 +1040,6 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>>  {
>>  #ifdef CONFIG_COMMON_CLK_DEBUG
>>         struct dentry *d;
>> -       struct dentry *new_parent_d;
>>  #endif
>>
>>         if (!clk || !new_parent)
>> @@ -1048,22 +1047,14 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>>
>>         hlist_del(&clk->child_node);
>>
>> -       if (new_parent)
>> -               hlist_add_head(&clk->child_node, &new_parent->children);
>> -       else
>> -               hlist_add_head(&clk->child_node, &clk_orphan_list);
>> +       hlist_add_head(&clk->child_node, &new_parent->children);
>
> Rajagopal,
>
> You found a bug, but not the right one :)
>
> This change would result in never moving a clock into the orphan list if
> the parent is missing.  The right thing to do is to allow the operation
> to succeed and migrate this clock into the orphan list.  In keeping
> with the clk.h api we need to treat struct clk new_parent as an opaque
> cookie and not care whether or not it is NULL.
>
Mike,

The only path where __clk_reparent() can get new parent as NULL is from
clk_set_parent() api. Tracing this path, here are the reasons why I submitted
this patch.

1. The clk_set_parent() function takes new parent for granted and tries to
access new_parent->rate when notifiers are registered,
2. For clocks with multiple parents, the __clk_set_parent() function also
takes new parent for granted and tries to access parent name while finding
the index of new parent from cached parent pointers.

But if the design decision is to allow clock to be re-parented to orphan list
when new parent is missing, I can provide the new working patch.

> Untested patch below fixes the real bug:
>
>
>
> From a4d56e3ee51452366365749873710e16631e9de7 Mon Sep 17 00:00:00 2001
> From: Mike Turquette <mturquette@linaro.org>
> Date: Tue, 15 Jan 2013 14:39:06 -0800
> Subject: [PATCH] clk: allow re-parenting to NULL clks
>
> __clk_reparent presently bails early if the new parent of a clk is NULL.
> This is wrong and prevents dynamically migrating clocks into the orphan
> list.  The fix is to remove the NULL pointer check for new_parent in
> __clk_parent.
>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/clk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 593a2e4..f056230 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1186,7 +1186,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>         struct dentry *new_parent_d;
>  #endif
>
> -       if (!clk || !new_parent)
> +       if (!clk)
>                 return;
>
>         hlist_del(&clk->child_node);
> --
> 1.7.10.4
>



-- 
Regards,
Rajagopal
