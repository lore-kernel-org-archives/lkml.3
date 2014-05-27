Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaE0Tc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:32:28 -0400
Received: from mout.gmx.net ([212.227.15.15]:59760 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaE0Tc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:32:26 -0400
Message-ID: <5384E83B.1030209@gmx.de>
Date: Tue, 27 May 2014 21:32:11 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Jeff Smith <jsmith.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        linux-man <linux-man@vger.kernel.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: Re: inotify_rm_watch() user-space safety requirements?
References: <CAAih0NjG4gC-7fkD5vOvF0CQks+DhqVZLeycsju-8RMVP6dbBw@mail.gmail.com>
In-Reply-To: <CAAih0NjG4gC-7fkD5vOvF0CQks+DhqVZLeycsju-8RMVP6dbBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:AqUT7fsuA2tXvRGKIk77UNLJH11ZJRdBnlddiN+Db1EOgmCXL1o
 Ne9m3zSTbRLRlEyqDJoqzP4w6ujG67KrsLCJyepUlMFZvmfO1Jg1h1xE3sCAXjXF/5CnJoK
 BN5Oneomg8fb5jWO9oCClD5KHjcduQsNOrwCl6Uqx4c0HSWpQMBlPZkAXwsXqHHEWpbcubY
 7rm2zq2qURvfdtNN6cTAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2014 19:25, Jeff Smith wrote:
> inotify's behavior concerning events from removed watches (they do
> happen) and watch descriptor reuse (beyond my knowledge) is currently
> undocumented.
>
> Although it mimics a standard multiplexing interface in most regards,
> writing a robust user-space handler is comparatively more complex due
> to the atypical delivery of "stale" wd events preceding an IN_IGNORE
> event and a lack of guarantees about how quickly a wd can be reused
> via inotify_add_watch(). Not being familiar with inotify/fsnotify
> internals, it's not trivially obvious to me how the fsnotify_group
> management is being done. Up to the present, I've maintained queues of
> "dead" wd wrappers (or at least a counter) to filter stale events, but
> I am clueless whether or not this is overkill.
>
> If removed descriptors are reserved until the IN_IGNORE event is
> drained from the read queue, could that be formally guaranteed? If
> it's not, is it functionality that could ever reasonably be expected
> to be added, short of some other form of new (optional?)
> queue-filter-on-rm functionality? It's my experience that the
> asynchronous handling of watch removals is a cost that seldom serves
> much user benefit.
>
 > Regards,
 > Jeff

Hello Jeff,

I tried to dive a bit into the code. This is what I understand:

Function inotify_ignored_and_remove_idr is called after the mark has 
been removed. This function puts an IN_IGNORED event onto the inotify 
queue and removes the watch descriptor from the list of used watch 
descriptors using function idr_remove.

With a test program I could receive the IN_IGNORED event. This behavior 
is currently not documented in the manpages (inotify.7 and 
inotify_rm_watch.2).

When inotify_add_watch is called it uses function idr_alloc_cyclic to 
assign a watch descriptor ID. This function starts looking for an unused 
id starting with the id after the last assigned watch descriptor.

This implies that in most cases inotify_add_watch will return a watch 
descriptor different to the one released by a prior call to 
inotify_rm_watch. But there is no guarantee.

I consider this a bug.

I CCed the maintainers of the inotify interface hoping that they can 
provide a better solution.

Until such a solution is provided I suggest you use the following 
workaround. After calling inotify_rm_watch read from the inotify file 
descriptor until you reach the matching IN_IGNORED event.

Only thereafter you can safely call inotify_add_watch again.

Best regards

Heinrich Schuchardt

