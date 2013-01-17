Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3AQSvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:51:00 -0500
Received: from mail-gh0-f177.google.com ([209.85.160.177]:45427 "EHLO
	mail-gh0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3AQSu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:50:59 -0500
Date: Thu, 17 Jan 2013 10:50:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] async: fix __lowest_in_progress()
Message-ID: <20130117185053.GB16568@mtj.dyndns.org>
References: <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <20130116171952.GQ2668@htj.dyndns.org>
 <CA+55aFxfheczjP22pESE7zXS1hnK3=mOgcGjMHDeoQ2W4D0MDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxfheczjP22pESE7zXS1hnK3=mOgcGjMHDeoQ2W4D0MDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 17, 2013 at 10:16:50AM -0800, Linus Torvalds wrote:
> Tejun, mind explaining this one a bit more to me?
> 
> If ordering matters, and we have a running queue and a pending queue,
> how could the pending queue *ever* be lower than the running one?

So, before being converted to workqueue, async spooled up its own
workers and each worker would lock and move the first pending item to
the executing list and everything was in order.

The conversion to workqueue was done by adding work_struct to each
async_entry and async just schedules the work item.  The queueing and
dispatching of such work items are still in order but now each worker
thread is associated with a specific async_entry and move that
specific async_entry to the executing list.  So, depending on which
worker reaches that point earlier, which is completely
non-deterministic, we may end up moving an async_entry with larger
cookie before one with smaller one.

> That implies that something was taken off the pending queue and put on
> the running queue out of order, right?
> 
> And that in turn implies that there isn't much of a "lowest" ordering
> at all, so how could anybody even care about what lowest is? It seems
> to be a meaningless measure.

The execution is still lowest first as workqueue would dispatch
workers in queued order.  It just is that they can reach the
synchronization point at their own differing paces.

> So with that in mind, I don't see what semantics the first part of the
> patch fixes. Can you explain more?

The problem with the code is that it's keeping a global pending list
and domain-specific running lists.  I don't know why it developed like
this but even before workqueue conversion the code was weird.

* It has sorted per-domain running list, so looking at the first item
  is easy.

* It has sorted global pennding list, and looking for first item in a
  domain involves scanning it.

Global syncing ends up scanning all per-domain running lists and
domain syncing ends up scanning global pending list, when all we need
is each async item to be queued on two lists - global and per-domain
in-flight lists - and stay there until done.

The posted patch is minimal fix while keeping the basic operation the
same so that it doesn't disturb -stable too much.  I'll prep a patch
to redo synchronization for 3.9.

Thanks.

-- 
tejun
