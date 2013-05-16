Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3EPLec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:34:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59268 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3EPLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:34:29 -0400
Message-ID: <5194C437.4070801@gmail.com>
Date: Thu, 16 May 2013 19:34:15 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jaegeuk Kim <jaegeuk.kim@samsung.com>, mingo@redhat.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC][PATCH] f2fs: Avoid print false deadlock messages.
References: <5193322D.1080009@gmail.com> <20130515082834.GB10510@laptop.programming.kicks-ass.net> <5194337D.1080503@gmail.com> <20130516084143.GE19669@dyad.programming.kicks-ass.net>
In-Reply-To: <20130516084143.GE19669@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 04:41 PM, Peter Zijlstra wrote:
> On Thu, May 16, 2013 at 09:16:45AM +0800, majianpeng wrote:
>
>>> There isn't. What you typically want to do is annotate the lock site.
>>> In particular it looks like mutex_lock_all() is the offensive piece of
>>> code (horrible function name though; the only redeeming thing being that
>>> f2fs.h isn't likely to be included elsewhere).
>>>
>>> One thing you can do here is modify it to look like:
>>>
>>> static inline void mutex_lock_all(struct f2fs_sb_info *sbi)
>>> {
>>> 	int i;
>>>
>>> 	for (i = 0; i < NR_GLOBAL_LOCKS; i++) {
>>> 		/*
>>> 		 * This is the only time we take multiple fs_lock[]
>>> 		 * instances; the order is immaterial since we
>>> 		 * always hold cp_mutex, which serializes multiple
>>> 		 * such operations.
>>> 		 */
>>> 		mutex_lock_nest_lock(&sbi->fs_lock[i], &sbi->cp_mutex);
>>> 	}
>>> }
>>>
>>> That tells the lock validator that it is ok to lock multiple instances
>>> of the fs_lock[i] class because the lock order is guarded by cp_mutex.
>>> While your patch also works, it has multiple down-sides; its easy to get
>>> out of sync when you modify NR_GLOBAL_LOCKS; also it consumes more
>>> static lockdep resources (lockdep has to allocate all its resources
>>> from static arrays since allocating memory also uses locks -- recursive
>>> problem).
>>>
>> Yes, but there is a problem if fs_block[] met deadlock. How to find which one?
>> Because the lock->name is the same.
> The most useful part of the lockdep report are the call traces that tell you
> where locks where acquired; the names are secondary. That is, while they are at
> times helpful in finding the right lock site, they're rarely _that_ important.
>
> Remember, your code will very likely not have the exact number hardcoded either.
> It'll be a variable. So having the number in the lockdep output will not help
> you find the offending code any sooner.
>
> Suppose there's another site that acquires two fs_block[] locks; currently this
> would generate another such warning as this thread started with -- lockdep
> doesn't look at lock instances but at classes; and it cannot differentiate
> between two locks of the same class and thus reports the possible deadlock.
>
> The way to find the offending code is to look at the "locks held" section of
> the lockdep report along with the call traces.
>
> Once you find the way in which the two locks nest the specific numbers are
> irrelevant. Your aim then is to prove your locking scheme is indeed deadlock
> free and then tell lockdep about it.
>
>
Thanks very much! I'll take times to understand.
Can you send a patch about this?

Thanks!
Jianpeng Ma

