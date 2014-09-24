Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaIXN7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaIXN7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:59:52 -0400
Date: Wed, 24 Sep 2014 15:08:44 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140924140844.GB2695@agordeev.usersys.redhat.com>
References: <cover.1411297686.git.agordeev@redhat.com>
 <b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
 <20140923205710.GB17332@mtj.dyndns.org>
 <20140924104213.GA2695@agordeev.usersys.redhat.com>
 <20140924130444.GA16555@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924130444.GA16555@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:04:44AM -0400, Tejun Heo wrote:
> Hello, Alexander.
> 
> On Wed, Sep 24, 2014 at 11:42:15AM +0100, Alexander Gordeev wrote:
> > On Tue, Sep 23, 2014 at 04:57:10PM -0400, Tejun Heo wrote:
> > > Hmmm... how does it affect single device operation tho?  It does make
> > > individual interrupt handling heavier, no?
> > 
> > I think it is difficult to assess "individual interrupt handling", since
> > it depends from both the hardware and device access pattern. On the system
> > I use the results are rather counter-intuitive: ahci_thread_fn() does not
> > show up in perf report at all, nor ahci_single_irq_intr(). While before
> > the change ahci_single_irq_intr() reported 0.00%.
> > 
> > But since the handling is split in two parts it is rather incorrect to
> > apply the same metric to the threaded context. Obviously, the threaded
> > handler is expected slowed down by other interrupts handlers, but the
> > whole system should benefit from it, which is exactly the aim of this
> > change.
> 
> Hmmm, how would the whole system benefit from it if there's only
> single device?  Each individual servicing of the interrupt does more
> now which includes scheduling which may end up adding to completion
> latency.

As Chuck noticed, non-AHCI hardware context handlers will benefit.

> The thing I don't get is why multiple MSI handling and this patchset
> are tied to threaded interrupt handling.

Multiple MSIs were implemented with the above aim (let's say aim #1)
right away. Single MSI/IRQ handling is getting updated with this series.

> Splitting locks don't
> necessarily have much to do with threaded handling and it's not like
> ahci interrupt handling is heavy.  The hot path is pretty short
> actually.  The meat of the work - completing requests and propagating
> completions - is offloaded to softirq by block layer anyway.

So the aim (let's say aim #2) is to avoid any of those to compete with
hardware context handler. IOW, not to wait on host/port spinlocks with
local interrupts disabled unnecessarily.

I assume, if at the time of writing of original handlers the two
interrupt context existed, they were written the way I propose now :)

> Just to be clear, I'm not against the proposed changes but wanna
> understand the justifications behind them.

Should I send the fixed series? ;)

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
