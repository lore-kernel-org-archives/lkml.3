Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaDSKkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:40:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:34200 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751043AbaDSKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:40:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,888,1389715200"; 
   d="scan'208";a="29471159"
Message-ID: <5352535D.8030407@cn.fujitsu.com>
Date: Sat, 19 Apr 2014 18:43:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 6/8] idr: avoid ping-pong
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com> <1397825404-12039-7-git-send-email-laijs@cn.fujitsu.com> <20140418171717.GE23576@htj.dyndns.org>
In-Reply-To: <20140418171717.GE23576@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 01:17 AM, Tejun Heo wrote:
> On Fri, Apr 18, 2014 at 08:49:53PM +0800, Lai Jiangshan wrote:
>> The ida callers always calls ida_pre_get() before ida_get_new*().
>> ida_pre_get() will do layer allocation, and ida_get_new*() will do layer removal.
>>
>> It causes an unneeded ping-pong. The speculative layer removal in
>> ida_get_new*() can't result expected optimization.
>>
>> So we remove the unneeded layer removal in ida_get_new*().
> 
> But the as comment says, ida doesn't want to keep extra layers around
> as it wants to keep its memory footprint minimal.  

It only frees one layer. And the ida_pre_get() for the next ida_get_new*()
will allocation it back again. The aim "Throw away extra resources one by one"
can't be achieved. It can't keep its memory footprint minimal.


> I think the right
> thing to do is implementing ida_preload() which is simliar to
> idr_preload() and do away with per-ida layer cache.

Yes and no.

We need a static private ida_preload() for ida_simple_get() only.

Because the IDA doesn't have any query-function, so IDA's own synchronization
is enough for all use cases, IDA should off-loads the caller's
synchronization burden.

In my todo-list, IDA only needs the following functions. other functions
will be deprecated and scheduled to be removed:
	void ida_destroy(struct ida *ida);
	void ida_init(struct ida *ida);
	int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
			   gfp_t gfp_mask);
	void ida_simple_remove(struct ida *ida, unsigned int id);

(I don't think we need any query-function, But...)
If in the future we need some query-functions such as:
	ida_is_this_id_allocated()
	ida_find_next_[un]allocated_id(),
In this case, we can expose the ida_preload() and ida_alloc() at the same time that
we introduce the query-functions.

Any thought?

But we need to remove this unneeded ping-pong despite of any plan.

Thanks,
Lai
