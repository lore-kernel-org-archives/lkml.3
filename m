Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3JWDab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:30:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65102 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3JWDaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <20131022210232.GB2884@redhat.com>
References: <20131018155532.GD2277@redhat.com>
	<1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
	<1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
	<20131022210232.GB2884@redhat.com>
Date: Wed, 23 Oct 2013 11:30:29 +0800
Message-ID: <CAA7+ByUn52WqCn=AgSi1QeHLGP=ziQ+vnNug3z3m7W-OXDqr+A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] blk-throttle: trim tokens generated for an idle tree
From: Hong zhi guo <honkiko@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek,

Sorry I don't have time to test them carefully this week. I'll do it
in this weekend.

The updating of nr_queued_tree level by level only happens once for
each bio. We have already the computing(and maybe queue operation)
level by level for every bio, even it's passed through without being
queued on the tree.  And the computing(and queue operation) on each
level is much bigger than updating one counter (nr_queued_tree).

So updating of nr_queued_tree doesn't introduce notable overhead
compared to existing overhead of blk-throttle.

Zhiguo

On Wed, Oct 23, 2013 at 5:02 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sun, Oct 20, 2013 at 08:11:12PM +0800, Hong Zhiguo wrote:
>> From: Hong Zhiguo <zhiguohong@tencent.com>
>>
>> Why
>> ====
>> Pointed out by Vivek: Tokens generated during idle period should
>> be trimmed. Otherwise a huge bio may be permited immediately.
>> Overlimit behaviour may be observed during short I/O throughput
>> test.
>>
>> Vivek also pointed out: We should not over-trim for hierarchical
>> groups. Suppose a subtree of groups are idle when a big bio comes.
>> The token of the child group is trimmed and not enough. So the bio is
>> queued on the child group. After some jiffies the child group reserved
>> enough tokens and the bio climbs up. If we trim the parent group at
>> this time again, this bio will wait too much time than expected.
>>
>> Analysis
>> ========
>> When the bio is queued on child group, all it's ancestor groups
>> becomes non-idle. They should start to reserve tokens for that
>> bio from this moment. And their reserved tokens before should be
>> trimmed at this moment.
>>
>> How
>> ====
>> service_queue now has a new member nr_queued_tree[2], to represent
>> the the number of bios waiting on the subtree rooted by this sq.
>>
>> When a bio is queued on the hierarchy first time, nr_queued_tree
>> of all ancestors and the child group itself are increased. When a
>> bio climbs up, nr_queued_tree of the child group is decreased.
>>
>> When nr_queued_tree turns from zero to one, the tokens reserved
>> before are trimmed. And after this switch, this group will never
>> be trimmed to reserve tokens for the bio waiting on it's descendant
>> group.
>>
>
> Hi Hong,
>
> This approach looks good in general. Only downside I can think of
> updation of nr_requests throughout the hierarchy. So deeper the
> hierarchy, higher the overhead.
>
> I am not sure if that's a concern or not. I will have a closer look
> a the patches tomorrow and do some testing too.
>
> Thanks
> Vivek



-- 
best regards
Hong Zhiguo
