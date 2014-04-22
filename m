Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbaDVP5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:57:36 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61710 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbaDVP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:57:25 -0400
Message-ID: <5356916F.4000205@kernel.dk>
Date: Tue, 22 Apr 2014 09:57:35 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
References: <cover.1395840483.git.agordeev@redhat.com> <20140422071057.GA13195@dhcp-26-169.brq.redhat.com> <535676A1.3070706@kernel.dk>
In-Reply-To: <535676A1.3070706@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------090609060503040406030500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090609060503040406030500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/22/2014 08:03 AM, Jens Axboe wrote:
> On 2014-04-22 01:10, Alexander Gordeev wrote:
>> On Wed, Mar 26, 2014 at 02:34:22PM +0100, Alexander Gordeev wrote:
>>> But other systems (more dense?) showed increased cache-hit rate
>>> up to 20%, i.e. this one:
>>
>> Hello Gentlemen,
>>
>> Any feedback on this?
> 
> Sorry for dropping the ball on this. Improvements wrt when to steal, how
> much, and from whom are sorely needed in percpu_ida. I'll do a bench
> with this on a system that currently falls apart with it.

Ran some quick numbers with three kernels:

stock		3.15-rc2
limit		3.15-rc2 + steal limit patch (attached)
limit+ag	3.15-rc2 + steal limit + your topology patch

Two tests were run - the device has an effective queue depth limit of
255, so I ran one test at QD=248 (low) and one at QD=512 (high) to both
exercise near-limit depth and over limit depth. 8 processes were used,
split into two groups. One group would always run on the local node, the
other would be run on the adjacent node (near) or on the far node (far).

Near + low
-----------
		IOPS		sys time
stock		1009.5K		55.78%
limit		1084.4K		54.47%
limit+ag	1058.1K		52.42%

Near + high
-----------
		IOPS		sys time
stock		 949.1K		75.12%
limit		 980.7K		64.74%
limit+ag	1010.1K		70.27%

Far + low
---------
		IOPS		sys time
stock		600.0K		72.28%
limit		761.7K		71.17%
limit+ag	762.5K		74.48%

Far + high
----------
		IOPS		sys time
stock		465.9K		91.66%
limit		716.2K		88.68%
limit+ag	758.0K		91.00%

One huge issue on this box is that it's a 4 socket/node machine, with 32
cores (64 threads). Combined with a 255 queue depth limit, the percpu
caching does not work well. I did not include stock+ag results, they
didn't change things very much for me. We simply have to limit the
stealing first, or we're still going to be hammering on percpu locks. If
we compare the top profiles from stock-far-high and limit+ag-far-high,
it looks pretty scary. Here's the stock one:

-  50,84%  fio  [kernel.kallsyms]
_raw_spin_lock
      + 89,83% percpu_ida_alloc
      + 6,03% mtip_queue_rq
      + 2,90% percpu_ida_free

so 50% of the system time spent acquiring a spinlock, with 90% of that
being percpu ida. The limit+ag variant looks like this:

-  32,93%  fio  [kernel.kallsyms]
_raw_spin_lock
      + 78,35% percpu_ida_alloc
      + 19,49% mtip_queue_rq
      + 1,21% __blk_mq_run_hw_queue

which is still pretty horrid and has plenty of room for improvement. I
think we need to make better decisions on the granularity of the tag
caching. If we ignore thread siblings, that'll double our effective
caching. If that's still not enough, I bet per-node/socket would be a
huge improvement.

-- 
Jens Axboe


--------------090609060503040406030500
Content-Type: text/x-patch;
 name="limit-steal.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="limit-steal.patch"

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 7a799c4..689bbaf 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -109,6 +109,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 {
 	unsigned int nr_tags, nr_cache;
 	struct blk_mq_tags *tags;
+	unsigned int num_cpus;
 	int ret;
 
 	if (total_tags > BLK_MQ_TAG_MAX) {
@@ -121,7 +122,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 		return NULL;
 
 	nr_tags = total_tags - reserved_tags;
-	nr_cache = nr_tags / num_possible_cpus();
+	num_cpus = min(8U, num_online_cpus());
+	nr_cache = nr_tags / num_cpus;
 
 	if (nr_cache < BLK_MQ_TAG_CACHE_MIN)
 		nr_cache = BLK_MQ_TAG_CACHE_MIN;

--------------090609060503040406030500--
