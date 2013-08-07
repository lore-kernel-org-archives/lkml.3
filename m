Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3HGAzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:55:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52021 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3HGAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:55:12 -0400
Message-ID: <52019ACF.1020006@huawei.com>
Date: Wed, 7 Aug 2013 08:54:39 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] mm/mempolicy: return NULL if node is NUMA_NO_NODE in
 get_task_policy
References: <52007660.7070907@huawei.com> <20130806140326.1d0d75874e6be221a432c3bc@linux-foundation.org>
In-Reply-To: <20130806140326.1d0d75874e6be221a432c3bc@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 2013/8/7 5:03, Andrew Morton wrote:

> On Tue, 6 Aug 2013 12:06:56 +0800 Jianguo Wu <wujianguo@huawei.com> wrote:
> 
>> If node == NUMA_NO_NODE, pol is NULL, we should return NULL instead of
>> do "if (!pol->mode)" check.
>>
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>> ---
>>  mm/mempolicy.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 4baf12e..e0e3398 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -129,6 +129,8 @@ static struct mempolicy *get_task_policy(struct task_struct *p)
>>  		node = numa_node_id();
>>  		if (node != NUMA_NO_NODE)
>>  			pol = &preferred_node_policy[node];
>> +		else
>> +			return NULL;
>>  
>>  		/* preferred_node_policy is not initialised early in boot */
>>  		if (!pol->mode)
> 
> Well yes, it'll dereference a null pointer
> 
> This is neater, I think:
> 

Yes, this is more readable, Thanks.

> --- a/mm/mempolicy.c~mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy
> +++ a/mm/mempolicy.c
> @@ -123,16 +123,19 @@ static struct mempolicy preferred_node_p
>  static struct mempolicy *get_task_policy(struct task_struct *p)
>  {
>  	struct mempolicy *pol = p->mempolicy;
> -	int node;
>  
>  	if (!pol) {
> -		node = numa_node_id();
> -		if (node != NUMA_NO_NODE)
> -			pol = &preferred_node_policy[node];
> +		int node = numa_node_id();
>  
> -		/* preferred_node_policy is not initialised early in boot */
> -		if (!pol->mode)
> -			pol = NULL;
> +		if (node != NUMA_NO_NODE) {
> +			pol = &preferred_node_policy[node];
> +			/*
> +			 * preferred_node_policy is not initialised early in
> +			 * boot
> +			 */
> +			if (!pol->mode)
> +				pol = NULL;
> +		}
>  	}
>  
>  	return pol;
> _
> 
> 
> .
> 



