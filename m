Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaBNKer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:34:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbaBNKep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:34:45 -0500
Date: Fri, 14 Feb 2014 11:36:18 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kmo@daterainc.com>, Christoph Hellwig <hch@infradead.org>,
        Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140214103618.GA8584@dhcp-26-207.brq.redhat.com>
References: <20140104210804.GA24199@kmo-pixel>
 <20140105131300.GB4186@kernel.org>
 <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
 <20140106214726.GD9037@kmo>
 <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
 <20140210103211.GA28396@infradead.org>
 <52F8FDA7.7070809@kernel.dk>
 <20140210224145.GB2362@kmo>
 <52F95B73.7030205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F95B73.7030205@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:06:27PM -0700, Jens Axboe wrote:
> It obviously all depends on the access pattern. X threads for X tags
> would work perfectly well with per-cpu tagging, if they are doing
> sync IO. And similarly, 8 threads each having low queue depth would
> be fine. However, it all falls apart pretty quickly if threads*qd >
> tag space.

What about inroducing two modes: gentle and agressive?

Gentle would be something implemented now with occasional switches into
agressive mode and back (more about this below).

In agressive mode percpu_ida_alloc() would ignore nr_cpus/2 threshold
and rob remote caches of tags whenever available. Further, percpu_ida_free()
would wake waiters always, even under percpu_max_size limit.

In essence, the agressive mode would be used to overcome the tag space
fragmentation (garbage collector, if you want), but not only. Some classes
of devices would initialize it constantly - that would be the case for i.e.
libata, paired with TASK_RUNNING condition.

Most challenging question here is when to switch from gentle mode to
agressive and back. I am thinking about a timeout that indicates a
reasonable average time for an IO to complete:

  * Once CPU failed to obtain a tag and cpus_have_tags is not empty and the
    timeout expired, the agressive mode is enforced, meaning no IO activity
    on other CPUs and tags are out there;

  * Once no tags were requested and the timeout expired the agressive mode
    is switched back to gentle;

  * Once the second tag returned to a local cache the agressive mode is
    switched back to gentle, meaning no threads were/are in the waitqueue,
    hungry for tags;

The value of timeout is calculated based on the recent IO activity, probably
with some hints from the device driver. The good thing here that occasional
unnecessary switches to the agressive mode would not hit the overall
performance.

Quite complicated, huh? :)

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
