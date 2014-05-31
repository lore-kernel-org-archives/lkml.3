Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaEaF1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 01:27:06 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45058 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaEaF1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 01:27:04 -0400
Message-ID: <53896823.1060308@gmail.com>
Date: Sat, 31 May 2014 07:26:59 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Jeff Smith <jsmith.lkml@gmail.com>
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: Re: inotify_rm_watch() user-space safety requirements?
References: <CAAih0NjG4gC-7fkD5vOvF0CQks+DhqVZLeycsju-8RMVP6dbBw@mail.gmail.com> <5384E83B.1030209@gmx.de>
In-Reply-To: <5384E83B.1030209@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heinrich,

On 05/27/2014 09:32 PM, Heinrich Schuchardt wrote:
> On 27.05.2014 19:25, Jeff Smith wrote:
>> inotify's behavior concerning events from removed watches (they do
>> happen) and watch descriptor reuse (beyond my knowledge) is currently
>> undocumented.
>>
>> Although it mimics a standard multiplexing interface in most regards,
>> writing a robust user-space handler is comparatively more complex due
>> to the atypical delivery of "stale" wd events preceding an IN_IGNORE
>> event and a lack of guarantees about how quickly a wd can be reused
>> via inotify_add_watch(). Not being familiar with inotify/fsnotify
>> internals, it's not trivially obvious to me how the fsnotify_group
>> management is being done. Up to the present, I've maintained queues of
>> "dead" wd wrappers (or at least a counter) to filter stale events, but
>> I am clueless whether or not this is overkill.
>>
>> If removed descriptors are reserved until the IN_IGNORE event is
>> drained from the read queue, could that be formally guaranteed? If
>> it's not, is it functionality that could ever reasonably be expected
>> to be added, short of some other form of new (optional?)
>> queue-filter-on-rm functionality? It's my experience that the
>> asynchronous handling of watch removals is a cost that seldom serves
>> much user benefit.
>>
>  > Regards,
>  > Jeff
> 
> Hello Jeff,
> 
> I tried to dive a bit into the code. This is what I understand:
> 
> Function inotify_ignored_and_remove_idr is called after the mark has 
> been removed. This function puts an IN_IGNORED event onto the inotify 
> queue and removes the watch descriptor from the list of used watch 
> descriptors using function idr_remove.
> 
> With a test program I could receive the IN_IGNORED event. This behavior 
> is currently not documented in the manpages (inotify.7 and 
> inotify_rm_watch.2).

I'm a little unclear here... What behavior is not documented?

> When inotify_add_watch is called it uses function idr_alloc_cyclic to 
> assign a watch descriptor ID. This function starts looking for an unused 
> id starting with the id after the last assigned watch descriptor.
> 
> This implies that in most cases inotify_add_watch will return a watch 
> descriptor different to the one released by a prior call to 
> inotify_rm_watch. But there is no guarantee.
> 
> I consider this a bug.
> 
> I CCed the maintainers of the inotify interface hoping that they can 
> provide a better solution.
> Until such a solution is provided I suggest you use the following 
> workaround. After calling inotify_rm_watch read from the inotify file 
> descriptor until you reach the matching IN_IGNORED event.
> 
> Only thereafter you can safely call inotify_add_watch again.

As I wrote elsewhere (http://marc.info/?l=linux-man&m=140145559605117&w=2), 
it's not clear to me if this is really anything more than a theoretical 
problem. Quoting my earlier text:

Background is bugs https://bugzilla.kernel.org/show_bug.cgi?id=76851
and https://bugzilla.kernel.org/show_bug.cgi?id=77111 . The point is:

1. When an inotify watch descriptor is removed, pending unread 
   events remain pending.
2. When allocating a new watch descriptor, a past WD may 
   be recycled.
3. In theory, it could happen that events left over at 1 could
   be interpreted as though they belonged to the filesystem
   object watch in step 2.

But, in order to trigger this bug you need to

0. Remove your watch descriptor (wd1),
1. Leave some unread events for wd1 on the queue. and in the meantime,
2. Cycle through INT_MAX watch descriptors until you reuse wd1.

Unless I've missed something, the chances of that happening are 
pretty remote. (On the other hand, user-space applications can sometimes
be creatively zany ;_).)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
