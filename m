Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3HaNhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 09:37:10 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:38445 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3HaNhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 09:37:07 -0400
X-Fcrdns: No
Message-ID: <5221F183.10405@profihost.ag>
Date: Sat, 31 Aug 2013 15:37:07 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: kernel neophyte <neophyte.hacker001@gmail.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcache: Fix a shrinker deadlock
References: <CAFkUHxd6xN3On4DTC7VnUgVuy8M57k=8eKYr47bKKnpQWS+p8A@mail.gmail.com> <20130830211510.GA20307@kmo-pixel>
In-Reply-To: <20130830211510.GA20307@kmo-pixel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks applied to my local kernel git

Stefan

Am 30.08.2013 23:15, schrieb Kent Overstreet:
> GFP_NOIO means we could be getting called recursively - mca_alloc() ->
> mca_data_alloc() - definitely can't use mutex_lock(bucket_lock) then.
> Whoops.
>
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> ---
>
> On Thu, Aug 29, 2013 at 05:29:54PM -0700, kernel neophyte wrote:
>> We are evaluating to use bcache on our production systems where the
>> caching devices are insanely fast, in this scenario under a moderate load
>> of random 4k writes.. bcache fails miserably :-(
>>
>> [ 3588.513638] bcache: bch_cached_dev_attach() Caching sda4 as bcache0
>> on set b082ce66-04c6-43d5-8207-ebf39840191d
>> [ 4442.163661] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
>> [ 4442.163671] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 4442.163678] kworker/0:0     D ffffffff81813d40     0     4      2 0x00000000
>> [ 4442.163695] Workqueue: bcache bch_data_insert_keys
>> [ 4442.163699]  ffff882fa6ac93c8 0000000000000046 ffff882fa6ac93e8
>> 0000000000000151
>> [ 4442.163705]  ffff882fa6a84cb0 ffff882fa6ac9fd8 ffff882fa6ac9fd8
>> ffff882fa6ac9fd8
>> [ 4442.163711]  ffff882fa6ad6640 ffff882fa6a84cb0 ffff882fa6a84cb0
>> ffff8822ca2c0d98
>> [ 4442.163716] Call Trace:
>> [ 4442.163729]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 4442.163735]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
>> [ 4442.163741]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
>> [ 4442.163746]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
>> [ 4442.163752]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
>> [ 4442.163759]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
>> [ 4442.163769]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
>> [ 4442.163776]  [<ffffffff81076828>] ? resched_task+0x68/0x70
>> [ 4442.163782]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
>> [ 4442.163788]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
>> [ 4442.163794]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
>> [ 4442.163800]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
>> [ 4442.163810]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
>> [ 4442.163818]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
>> [ 4442.163824]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
>> [ 4442.163829]  [<ffffffff8150ebb3>] mca_data_alloc+0x73/0x1d0
>> [ 4442.163834]  [<ffffffff8150ee5a>] mca_bucket_alloc+0x14a/0x1f0
>> [ 4442.163838]  [<ffffffff81511020>] mca_alloc+0x360/0x470
>> [ 4442.163843]  [<ffffffff81511d1c>] bch_btree_node_alloc+0x8c/0x1c0
>> [ 4442.163849]  [<ffffffff81513020>] btree_split+0x110/0x5c0
>
> Ohhh, that definitely isn't supposed to happen.
>
> Wonder why I hadn't seen this before, looking at the backtrace it's
> pretty obvious what's broken though - try this patch:
>
>   drivers/md/bcache/btree.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 60908de..55e8666 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -617,7 +617,7 @@ static int bch_mca_shrink(struct shrinker *shrink, struct shrink_control *sc)
>   		return mca_can_free(c) * c->btree_pages;
>
>   	/* Return -1 if we can't do anything right now */
> -	if (sc->gfp_mask & __GFP_WAIT)
> +	if (sc->gfp_mask & __GFP_IO)
>   		mutex_lock(&c->bucket_lock);
>   	else if (!mutex_trylock(&c->bucket_lock))
>   		return -1;
>
