Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbbAMH6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:58:02 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11097 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAMH6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:58:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-66-54b4d006a725
Message-id: <54B4CFF3.5060100@samsung.com>
Date: Tue, 13 Jan 2015 08:57:39 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Mike Turquette <mturquette@linaro.org>, linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, andi@lisas.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, sboyd@codeaurora.org
Subject: Re: [PATCH 3/5] clk: convert clock name allocations to kstrdup_const
References: <1421054323-14430-1-git-send-email-a.hajda@samsung.com>
 <1421054323-14430-4-git-send-email-a.hajda@samsung.com>
 <20150112231104.20842.5239@quantum>
In-reply-to: <20150112231104.20842.5239@quantum>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xK7psF7aEGMxcpmVxa905Vos569ew
	WRy59p3d4vK/NywWZ5veAFm75rBZ3Fvzn9Vi7ZG77BZPJ1xks/hxppvF4vzf46wO3B6X+3qZ
	PObv/MjosenTJHaPO9f2sHmcmPGbxWPJTTWPvi2rGD0+b5Lz2PTkLVMAZxSXTUpqTmZZapG+
	XQJXxv9Lu5kKpktWvP/UwtjAOEeoi5GDQ0LARGLqm7AuRk4gU0ziwr31bF2MXBxCAksZJWb3
	/oFyPjFKnP46lRGkildAS2Lp7C/sIDaLgKrEqrf3WUBsNgFNib+bb7KB2KICERIfVn1lg6gX
	lPgx+R5YjYiAncS7E+uZQIYyC2xhkvh09CPYIGEBX4k/HddYILYtZpS4df4e2DZOAQOJzxd6
	WEBOZRZQl5gyJRckzCwgL7F5zVvmCYwCs5DsmIVQNQtJ1QJG5lWMoqmlyQXFSem5RnrFibnF
	pXnpesn5uZsYITHzdQfj0mNWhxgFOBiVeHh3ZG8JEWJNLCuuzD3EKMHBrCTCazcHKMSbklhZ
	lVqUH19UmpNafIiRiYNTqoGxPvXAkn8pfEbbQjzPpp4+lxF6RnBNQkMaQ2H2/hDl9Zl9L10X
	nji4MI8hab5m7pzbLfVp/huUfnRWafifO8a150m215JYe9lVz7mO+jRPP7Pixzuhn+VLjnW/
	Xv1FUMjLIivkz6EEV9cfmd62TSGzT3fUffh186bWhxM3F6669Wa5gZzUr2XxSizFGYmGWsxF
	xYkABDcIF3cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 12:11 AM, Mike Turquette wrote:
> Quoting Andrzej Hajda (2015-01-12 01:18:41)
>> Clock subsystem frequently performs duplication of strings located
>> in read-only memory section. Replacing kstrdup by kstrdup_const
>> allows to avoid such operations.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Looks OK to me. Is there an easy trick to measuring the number of string
> duplications saved short of instrumenting your code with a counter?

I have just added pr_err in kstrdup_const:

diff --git a/mm/util.c b/mm/util.c
index c96fc4b..32a97b2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -56,8 +56,10 @@ EXPORT_SYMBOL(kstrdup);
 
 const char *kstrdup_const(const char *s, gfp_t gfp)
 {
-       if (is_kernel_rodata((unsigned long)s))
+       if (is_kernel_rodata((unsigned long)s)) {
+               pr_err("%s: %pS:%s\n", __func__,
__builtin_return_address(0), s);
                return s;
+       }
 
        return kstrdup(s, gfp);
 }

Probably printk buffer size should be increased:
CONFIG_LOG_BUF_SHIFT=17

Regards
Andrzej

>
> Regards,
> Mike
>
>> ---
>>  drivers/clk/clk.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index f4963b7..27e644a 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -2048,7 +2048,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
>>                 goto fail_out;
>>         }
>>  
>> -       clk->name = kstrdup(hw->init->name, GFP_KERNEL);
>> +       clk->name = kstrdup_const(hw->init->name, GFP_KERNEL);
>>         if (!clk->name) {
>>                 pr_err("%s: could not allocate clk->name\n", __func__);
>>                 ret = -ENOMEM;
>> @@ -2075,7 +2075,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
>>  
>>         /* copy each string name in case parent_names is __initdata */
>>         for (i = 0; i < clk->num_parents; i++) {
>> -               clk->parent_names[i] = kstrdup(hw->init->parent_names[i],
>> +               clk->parent_names[i] = kstrdup_const(hw->init->parent_names[i],
>>                                                 GFP_KERNEL);
>>                 if (!clk->parent_names[i]) {
>>                         pr_err("%s: could not copy parent_names\n", __func__);
>> @@ -2090,10 +2090,10 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
>>  
>>  fail_parent_names_copy:
>>         while (--i >= 0)
>> -               kfree(clk->parent_names[i]);
>> +               kfree_const(clk->parent_names[i]);
>>         kfree(clk->parent_names);
>>  fail_parent_names:
>> -       kfree(clk->name);
>> +       kfree_const(clk->name);
>>  fail_name:
>>         kfree(clk);
>>  fail_out:
>> @@ -2112,10 +2112,10 @@ static void __clk_release(struct kref *ref)
>>  
>>         kfree(clk->parents);
>>         while (--i >= 0)
>> -               kfree(clk->parent_names[i]);
>> +               kfree_const(clk->parent_names[i]);
>>  
>>         kfree(clk->parent_names);
>> -       kfree(clk->name);
>> +       kfree_const(clk->name);
>>         kfree(clk);
>>  }
>>  
>> -- 
>> 1.9.1
>>

