Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaF0GAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:00:43 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59272 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaF0GAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:00:42 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 27 Jun 2014 15:05:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v3 8/8] slab: do not keep free objects/slabs on dead
 memcg caches
Message-ID: <20140627060534.GC9511@js1304-P5Q-DELUXE>
References: <cover.1402602126.git.vdavydov@parallels.com>
 <a985aec824cd35df381692fca83f7a8debc80305.1402602126.git.vdavydov@parallels.com>
 <20140624073840.GC4836@js1304-P5Q-DELUXE>
 <20140625134545.GB22340@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625134545.GB22340@esperanza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 05:45:45PM +0400, Vladimir Davydov wrote:
> On Tue, Jun 24, 2014 at 04:38:41PM +0900, Joonsoo Kim wrote:
> > On Fri, Jun 13, 2014 at 12:38:22AM +0400, Vladimir Davydov wrote:
> > And, you said that this way of implementation would be slow because
> > there could be many object in dead caches and this implementation
> > needs node spin_lock on each object freeing. Is it no problem now?
> > 
> > If you have any performance data about this implementation and
> > alternative one, could you share it?
> 
> I ran some tests on a 2 CPU x 6 core x 2 HT box. The kernel was compiled
> with a config taken from a popular distro, so it had most of debug
> options turned off.
> 
> ---
> 
> TEST #1: Each logical CPU executes a task that frees 1M objects
>          allocated from the same cache. All frees are node-local.
> 
> RESULTS:
> 
> objsize (bytes) | cache is dead? | objects free time (ms)
> ----------------+----------------+-----------------------
>           64    |       -        |       373 +- 5
>            -    |       +        |      1300 +- 6
>                 |                |
>          128    |       -        |       387 +- 6
>            -    |       +        |      1337 +- 6
>                 |                |
>          256    |       -        |       484 +- 4
>            -    |       +        |      1407 +- 6
>                 |                |
>          512    |       -        |       686 +-  5
>            -    |       +        |      1561 +- 18
>                 |                |
>         1024    |       -        |      1073 +- 11
>            -    |       +        |      1897 +- 12
> 
> TEST #2: Each logical CPU executes a task that removes 1M empty files
>          from its own RAMFS mount. All frees are node-local.
> 
> RESULTS:
> 
>  cache is dead? | files removal time (s)
> ----------------+----------------------------------
>       -         |       15.57 +- 0.55   (base)
>       +         |       16.80 +- 0.62   (base + 8%)
> 
> ---
> 
> So, according to TEST #1 the relative slowdown introduced by zapping per
> cpu arrays is really dreadful - it can be up to 4x! However, the
> absolute numbers aren't that huge - ~1 second for 24 million objects.
> If we do something else except kfree the slowdown shouldn't be that
> visible IMO.
> 
> TEST #2 is an attempt to estimate how zapping of per cpu arrays will
> affect FS objects destruction, which is the most common case of dead
> caches usage. To avoid disk-bound operations it uses RAMFS. From the
> test results it follows that the relative slowdown of massive file
> deletion is within 2 stdev, which looks decent.
> 
> Anyway, the alternative approach (reaping dead caches periodically)
> won't have this kfree slowdown at all. However, periodic reaping can
> become a real disaster as the system evolves and the number of dead
> caches grows. Currently I don't know how we can estimate real life
> effects of this. If you have any ideas, please let me know.
> 

Hello,

I have no idea here. I don't have much experience on large scale
system. But, current implementation would also have big trouble if
system is larger than yours.

I think that Christoph can say something about this result.

Christoph,
Is it tolerable result for large scale system? Or do we need to find
another solution?

Thanks.
