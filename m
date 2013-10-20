Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3JTMIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:08:16 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37602 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3JTMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <20131018155532.GD2277@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1382012272-26170-1-git-send-email-zhiguohong@tencent.com>
	<20131018155532.GD2277@redhat.com>
Date: Sun, 20 Oct 2013 20:08:12 +0800
Message-ID: <CAA7+ByVfuUz74NHoH+hu=Nb=TpKL0kVtn5Nsf7gs83b4Den2zw@mail.gmail.com>
Subject: Re: [PATCH v3] blk-throttle: simplify logic by token bucket algorithm
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

Thanks for your comments. I didn't realize the ancestor over-trim issue before.

Trimming of iops token is not necessary. Since a bio always costs
_one_ iops token. Trimming it won't change the fact that current iops
token is zero or not.

For hierarchical triming, as you pointed out, there's 2 issues in my v3 patch.
1) When bio climbs up, the parent group is not trimmed.
2) When bio climbs up, we should not trim groups level by level,
   that would block the bio too much time than expected.

You proposed time keeping method helps.
But how about some bios waiting on multiple child group, and climb up
in different order than they get queued on clild group? Some token is
still missed.
How does this works for multiple levels of ancestors?

I got another idea and implementation for the issues. The basic idea is:
When the bio is queued on child group, all it's ancestor groups
becomes non-idle. They should start to reserve tokens for that bio
from this moment. And tokens they reserved before should be trimmed at
this moment.

I'll also send the implementation later.

Please help to review the idea and code. Thanks.

On Fri, Oct 18, 2013 at 11:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 17, 2013 at 08:17:52PM +0800, Hong Zhiguo wrote:
>
> I think same logic need to be applied to iops too?
>
> Also, how does it work in case of hierarchy? IIUC, when bio is being
> propogated upwards, we first add it to the parent, and then later
> update dispatch time which will in turn call tg_with_in_bps_limit().
>
> So by the time you come here after bio propogation, bio is already
> on service queue and it will be entitiled to *unlimited* idle tokens.
>
> On the flip side, we can't do blind truncation of idle tokens in
> parent group. Reason being that once bio got queued in child group,
> effectively it should be subjected to parent's limits too right now
> and not necessarily when it climbs up the tree.
>
> To solve this problem I had put following patch.
>
> commit 32ee5bc4787dfbdb280b4d81a338dcdd55918c1e
> Author: Vivek Goyal <vgoyal@redhat.com>
> Date:   Tue May 14 13:52:38 2013 -0700
>
>     blk-throttle: Account for child group's start time in parent while bio
> climb
>
>
> Above solution was not perfect but seemed like reasonable approximation.
> We might have to do something similar. I think we can keep track of time
> when an bio starts waiting in a group (gets to head of list) and then
> when that bio is dispatched, pass that time to parent group. Now
> parent can give more tokens to bio based on wait time start as passed
> by children.
>
> For example say Twaitstart is the time a bio started waiting on the head
> of queue of a group. Say Tidle is time when parent became idle. Now when
> child passes this bio to parent, it will also pass Twaitstart to parent.
> When it comes time for token calculation, parent can do following.
>
> If (time_after(Twaitstart, Tidle)
>         start_time = Twaitstart;
> else
>         start_time = Tidle;
>
> token_eligibility = (jiffies - start_time) * rate;
>
> This is far from perfect, but it should work reasonably.
>
> Thanks
> Vivek

-- 
best regards
Hong Zhiguo
