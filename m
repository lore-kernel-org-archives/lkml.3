Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaIXN1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:27:19 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45181 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaIXN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:27:17 -0400
Date: Wed, 24 Sep 2014 08:27:12 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 5/6] AHCI: Optimize single IRQ interrupt
 processing
Message-ID: <20140924082713.7ddd718e@as>
In-Reply-To: <20140924130444.GA16555@htj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
	<b1a04379e05e40f9774fb4668609fac4255a6514.1411297686.git.agordeev@redhat.com>
	<20140923205710.GB17332@mtj.dyndns.org>
	<20140924104213.GA2695@agordeev.usersys.redhat.com>
	<20140924130444.GA16555@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 09:04:44 -0400
Tejun Heo <tj@kernel.org> wrote:

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
> 

I think he meant other, non-AHCI, interrupt handlers would benefit. A
good test of this patch might be to stream 10Gb ethernet while also
streaming writes to an AHCI device.
