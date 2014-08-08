Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbaHHRrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:47:01 -0400
Received: from longford.logfs.org ([213.229.74.203]:43742 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHHRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:46:59 -0400
Date: Fri, 8 Aug 2014 13:43:35 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: oren@purestorage.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race in get_request()
Message-ID: <20140808174335.GA12487@logfs.org>
References: <20140808005443.GA7895@logfs.org>
 <53E4DD9C.1050306@kernel.dk>
 <53E4DE9F.7090603@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53E4DE9F.7090603@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 August 2014 08:28:47 -0600, Jens Axboe wrote:
> On 08/08/2014 08:24 AM, Jens Axboe wrote:
> > On 08/07/2014 06:54 PM, Jörn Engel wrote:
> >>
> >> If __get_request() returns NULL, get_request will call
> >> prepare_to_wait_exclusive() followed by io_schedule().  Not rechecking
> >> the sleep condition after prepare_to_wait_exclusive() leaves a race
> >> where the condition changes before prepare_to_wait_exclusive(), but
> >> not after and accordingly this thread never gets woken up.
> >>
> >> The race must be exceedingly hard to hit, otherwise I cannot explain how
> >> such a classic race could outlive the last millenium.
> > 
> > I think that is a genuine bug, it's just extremely hard to hit in real
> > life. It has probably only potentially ever triggered in the cases where
> > we are so out of memory that a blocking ~300b alloc fails, and Linux
> > generally shits itself pretty hard when it gets to that stage anyway...
> > And for the bug to be critical, you'd need this to happen for a device
> > that otherwise has no IO pending, since you'd get woken up by the next
> > completed request anyway.
> 
> Actually, this can't trigger for an empty queue, since the mempool holds
> a few requests. So it should never result in a softlock, we will make
> progress. Given that we also still hold the queue spinlock (that will be
> held for a free as well), we should not be able to get a free of a
> request until the prepare_to_wait() has been done. So not sure there is
> an actual bug there, but I agree the code looks confusing that way.

The race I was afraid of is not on an empty queue, but where all IO
gets completed between the __get_request() and
prepare_to_wait_exclusive().  That may well be hundreds of requests,
so under normal circumstances they should take far longer than the
race window to complete.  So something has to enlarge the window.

With the spin_lock_irq held, that removes interrupts and a preemptible
kernel from the candidate list.  Now we would need hardware support,
either some kind of unfair SMT cpus or a hypervisor that doesn't
schedule the victim cpu's thread for a long time and at just the right
time.

Maybe the hypervisor case is at least theoretically possible.  But I
would also be happy with leaving the code as-is and at most adding a
comment for the next person.

Jörn

--
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
