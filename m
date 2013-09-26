Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3IZDnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:43:31 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23337 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361Ab3IZDna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:43:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AucGANmsQ1J5LCC0/2dsb2JhbABbgwe8K4U8gSEXdIIlAQEFOhwjEAgDDgoJJQ8FJQMhE4gFvFcWjgiBMweEHgOXe5F4gzYqgS0
Date: Thu, 26 Sep 2013 13:43:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: snitzer@redhat.com, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com, ejt@redhat.com, dan.carpenter@oracle.com
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
Message-ID: <20130926034325.GO26872@dastard>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
 <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524183A2.9050301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:20:50PM +0900, Akira Hayakawa wrote:
> * Deferring ACK for barrier writes
> Barrier flags such as REQ_FUA and REQ_FLUSH are handled lazily.
> Immediately handling these bios badly slows down writeboost.
> It surveils the bios with these flags and forcefully flushes them
> at worst case within `barrier_deadline_ms` period.

That rings alarm bells.

If the filesystem is using REQ_FUA/REQ_FLUSH for ordering reasons,
delaying them to allow other IOs to be submitted and dispatched may
very well violate the IO ordering constraints the filesystem is
trying to acheive.

Alternatively, delaying them will stall the filesystem because it's
waiting for said REQ_FUA IO to complete. For example, journal writes
in XFS are extremely IO latency sensitive in workloads that have a
signifincant number of ordering constraints (e.g. O_SYNC writes,
fsync, etc) and delaying even one REQ_FUA/REQ_FLUSH can stall the
filesystem for the majority of that barrier_deadline_ms.

i.e. this says to me that the best performance you can get from such
workloas is one synchronous operation per process per
barrier_deadline_ms, even when the storage and filesystem might be
capable of executing hundreds of synchronous operations per
barrier_deadline_ms..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
