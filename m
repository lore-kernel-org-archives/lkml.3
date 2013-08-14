Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab3HNRkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:40:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759971Ab3HNRkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:40:43 -0400
Date: Wed, 14 Aug 2013 19:40:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ben Tebulin <tebulin@googlemail.com>
Cc: mgorman@suse.de, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug] Reproducible data corruption on i5-3340M: Please revert
 53a59fc67!
Message-ID: <20130814174039.GA24033@dhcp22.suse.cz>
References: <52050382.9060802@gmail.com>
 <520BB225.8030807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BB225.8030807@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Let's CC some more people]

On Wed 14-08-13 18:36:53, Ben Tebulin wrote:
> Hello Michal, Johannes, Balbir, Kamezawa and Mailing lists!

Hi,

> Since v3.7.2 on two independent machines a very specific Git repository
> fails in 9/10 cases on git-fsck due to an SHA1/memory failures. This
> only occurs on a very specific repository and can be reproduced stably
> on two independent laptops. Git mailing list ran out of ideas and for me 
> this looks like some very exotic kernel issue.
> 
> After a _very long session of rebooting and bisecting_ the Linux kernel
> (fortunately I had a SSD and ccache!) I was able to pinpoint the cause
> to the following patch:
> 
> *"mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT"*
>   787f7301074ccd07a3e82236ca41eefd245f4e07 linux stable    [1]
>   53a59fc67f97374758e63a9c785891ec62324c81 upstream commit [2]

Thanks for bisecting this up!

I will look into this but I find it really strange. The patch only
limits the number of batched pages to be freed. This might happen even
without the patch, albeit less likely, when a new batch cannot be
allocated.
That being said, I do not see anything obviously wrong with the patch
itself. Maybe we are not flushing those pages properly in some corner
case which doesn't trigger normally. I will have to look at it but I
really think this just exhibits a subtle bug in batch pages freeing.

I have no objection to revert the patch for now until we find out what
is really going on.

> More details are available in my previous discussion on the Git mailing:
> 
>    http://thread.gmane.org/gmane.comp.version-control.git/231872
> 
> Never had any hardware/stability issues _at all_ with these machines. 
> Only one repo out of 112 is affected. It's a git-svn clone and even 
> recreated copies out of svn do trigger the same failure.
> 
> I was able to bisect this error to this very specific commit. 
> Furthermore: Reverting this commit in 3.9.11 still solves the error. 
> 
> I assume this is a regression of the Linux kernel (not Git) and would 
> kindly ask you to revert the afore mentioned commits.
> 
> Thanks!
> - Ben
> 
> 
> I'm not subscribed - please CC me.
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=787f7301074ccd07a3e82236ca41eefd245f4e07
> [2] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=53a59fc67f97374758e63a9c785891ec62324c81
> 

-- 
Michal Hocko
SUSE Labs
