Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3JVVC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab3JVVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:02:54 -0400
Date: Tue, 22 Oct 2013 17:02:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Hong Zhiguo <honkiko@gmail.com>
Cc: tj@kernel.org, cgroups@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH v4 2/2] blk-throttle: trim tokens generated for an idle
 tree
Message-ID: <20131022210232.GB2884@redhat.com>
References: <20131018155532.GD2277@redhat.com>
 <1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
 <1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 08:11:12PM +0800, Hong Zhiguo wrote:
> From: Hong Zhiguo <zhiguohong@tencent.com>
> 
> Why
> ====
> Pointed out by Vivek: Tokens generated during idle period should
> be trimmed. Otherwise a huge bio may be permited immediately.
> Overlimit behaviour may be observed during short I/O throughput
> test.
> 
> Vivek also pointed out: We should not over-trim for hierarchical
> groups. Suppose a subtree of groups are idle when a big bio comes.
> The token of the child group is trimmed and not enough. So the bio is
> queued on the child group. After some jiffies the child group reserved
> enough tokens and the bio climbs up. If we trim the parent group at
> this time again, this bio will wait too much time than expected.
> 
> Analysis
> ========
> When the bio is queued on child group, all it's ancestor groups
> becomes non-idle. They should start to reserve tokens for that
> bio from this moment. And their reserved tokens before should be
> trimmed at this moment.
> 
> How
> ====
> service_queue now has a new member nr_queued_tree[2], to represent
> the the number of bios waiting on the subtree rooted by this sq.
> 
> When a bio is queued on the hierarchy first time, nr_queued_tree
> of all ancestors and the child group itself are increased. When a
> bio climbs up, nr_queued_tree of the child group is decreased.
> 
> When nr_queued_tree turns from zero to one, the tokens reserved
> before are trimmed. And after this switch, this group will never
> be trimmed to reserve tokens for the bio waiting on it's descendant
> group.
> 

Hi Hong,

This approach looks good in general. Only downside I can think of
updation of nr_requests throughout the hierarchy. So deeper the 
hierarchy, higher the overhead.

I am not sure if that's a concern or not. I will have a closer look
a the patches tomorrow and do some testing too.

Thanks
Vivek
