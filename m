Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaANFnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:43:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaANFm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:42:58 -0500
Message-ID: <52D4CE4C.1030809@oracle.com>
Date: Tue, 14 Jan 2014 13:42:36 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Cai Liu <cai.liu@samsung.com>, sjenning@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, liucai.lfn@gmail.com
Subject: Re: [PATCH] mm/zswap: Check all pool pages instead of one pool pages
References: <000101cf0ea0$f4e7c560$deb75020$@samsung.com> <20140113233505.GS1992@bbox> <52D4909B.7070107@oracle.com> <20140114045022.GZ1992@bbox> <20140114050528.GA1992@bbox>
In-Reply-To: <20140114050528.GA1992@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/14/2014 01:05 PM, Minchan Kim wrote:
> On Tue, Jan 14, 2014 at 01:50:22PM +0900, Minchan Kim wrote:
>> Hello Bob,
>>
>> On Tue, Jan 14, 2014 at 09:19:23AM +0800, Bob Liu wrote:
>>>
>>> On 01/14/2014 07:35 AM, Minchan Kim wrote:
>>>> Hello,
>>>>
>>>> On Sat, Jan 11, 2014 at 03:43:07PM +0800, Cai Liu wrote:
>>>>> zswap can support multiple swapfiles. So we need to check
>>>>> all zbud pool pages in zswap.
>>>>
>>>> True but this patch is rather costly that we should iterate
>>>> zswap_tree[MAX_SWAPFILES] to check it. SIGH.
>>>>
>>>> How about defining zswap_tress as linked list instead of static
>>>> array? Then, we could reduce unnecessary iteration too much.
>>>>
>>>
>>> But if use linked list, it might not easy to access the tree like this:
>>> struct zswap_tree *tree = zswap_trees[type];
>>
>> struct zswap_tree {
>>     ..
>>     ..
>>     struct list_head list;
>> }
>>
>> zswap_frontswap_init()
>> {
>>     ..
>>     ..
>>     zswap_trees[type] = tree;
>>     list_add(&tree->list, &zswap_list);
>> }
>>
>> get_zswap_pool_pages(void)
>> {
>>     struct zswap_tree *cur;
>>     list_for_each_entry(cur, &zswap_list, list) {
>>         pool_pages += zbud_get_pool_size(cur->pool);
>>     }
>>     return pool_pages;
>> }

Okay, I see your point. Yes, it's much better.
Cai, Please make an new patch.

Thanks,
-Bob

>>
>>
>>>
>>> BTW: I'm still prefer to use dynamic pool size, instead of use
>>> zswap_is_full(). AFAIR, Seth has a plan to replace the rbtree with radix
>>> which will be more flexible to support this feature and page migration
>>> as well.
>>>
>>>> Other question:
>>>> Why do we need to update zswap_pool_pages too frequently?
>>>> As I read the code, I think it's okay to update it only when user
>>>> want to see it by debugfs and zswap_is_full is called.
>>>> So could we optimize it out?
>>>>
>>>>>
>>>>> Signed-off-by: Cai Liu <cai.liu@samsung.com>
>>>
>>> Reviewed-by: Bob Liu <bob.liu@oracle.com>
>>
>> Hmm, I really suprised you are okay in this code piece where we have
>> unnecessary cost most of case(ie, most system has a swap device) in
>> *mm* part.
>>
>> Anyway, I don't want to merge this patchset.
>> If Andrew merge it and anybody doesn't do right work, I will send a patch.
>> Cai, Could you redo a patch?
>> I don't want to intercept your credit.
>>
>> Even, we could optimize to reduce the the number of call as I said in
>> previous reply.
> 
> You did it already. Please write it out in description.
> 
