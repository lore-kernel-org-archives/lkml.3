Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaIXOjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:39:22 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50391 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaIXOjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:39:18 -0400
Date: Wed, 24 Sep 2014 10:39:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140924143913.GH16555@htj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
 <20140924140844.GB2695@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924140844.GB2695@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Wed, Sep 24, 2014 at 03:08:44PM +0100, Alexander Gordeev wrote:
> > Hmmm, how would the whole system benefit from it if there's only
> > single device?  Each individual servicing of the interrupt does more
> > now which includes scheduling which may end up adding to completion
> > latency.
> 
> As Chuck noticed, non-AHCI hardware context handlers will benefit.

Maybe I'm off but I'm kinda skeptical that we'd be gaining back the
overhead we pay by punting to a thread.

> > The thing I don't get is why multiple MSI handling and this patchset
> > are tied to threaded interrupt handling.
> 
> Multiple MSIs were implemented with the above aim (let's say aim #1)
> right away. Single MSI/IRQ handling is getting updated with this series.

Yeah, I get that.  I'm curious whether that was justified.

> > Splitting locks don't
> > necessarily have much to do with threaded handling and it's not like
> > ahci interrupt handling is heavy.  The hot path is pretty short
> > actually.  The meat of the work - completing requests and propagating
> > completions - is offloaded to softirq by block layer anyway.
> 
> So the aim (let's say aim #2) is to avoid any of those to compete with
> hardware context handler. IOW, not to wait on host/port spinlocks with
> local interrupts disabled unnecessarily.
> 
> I assume, if at the time of writing of original handlers the two
> interrupt context existed, they were written the way I propose now :)

Maybe it makes sense with many high speed devices attached to a single
host; otherwise, I think we'd prolly be paying more than we're
gaining.  Lock splitting itself is likely beneficial as our issue path
is a lot heavier than completion path but I'm not too sure about
splitting completion contexts especially given that completion for
block layer and up are already punted to softirq.

Would it be possible for you compare threaded vs. unthreaded under
relatively heavy load?  ie. let the interrupt handler access irq
status under host lock but release it and then go through per-port
locks from the interrupt handler.

Thanks for doing this!

-- 
tejun
