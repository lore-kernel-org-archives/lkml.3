Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3J1JXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:23:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46113 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3J1JXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:23:20 -0400
Date: Mon, 28 Oct 2013 10:22:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: anton@samba.org, benh@kernel.crashing.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au, Michael Neuling <mikey@neuling.org>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131028092259.GJ19466@laptop.lan>
References: <12083.1382486094@ale.ozlabs.ibm.com>
 <20131023141948.GB3566@localhost.localdomain>
 <20131025173749.GG19466@laptop.lan>
 <OF1519E98D.692AF083-ON42257C11.002E693E-42257C11.00317D48@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF1519E98D.692AF083-ON42257C11.002E693E-42257C11.00317D48@il.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 11:00:33AM +0200, Victor Kaplansky wrote:
> Peter Zijlstra <peterz@infradead.org> wrote on 10/25/2013 07:37:49 PM:
> 
> > I would argue for:
> >
> >   READ ->data_tail         READ ->data_head
> >     smp_rmb()   (A)          smp_rmb()   (C)
> >   WRITE $data              READ $data
> >     smp_wmb()   (B)          smp_mb()   (D)
> >   STORE ->data_head        WRITE ->data_tail
> >
> > Where A pairs with D, and B pairs with C.
> 
> 1. I agree. My only concern is that architectures which do use atomic
> operations
> with memory barriers, will issue two consecutive barriers now, which is
> sub-optimal.

Yeah, although that would be fairly easy to optimize by the CPUs itself;
not sure they actually do this though.

But we don't really have much choice aside of introducing things like:

smp_wmb__after_local_$op; and I'm fairly sure people won't like adding a
ton of conditional barriers like that either.


> 2. I think the comment in "include/linux/perf_event.h" describing
> "data_head" and
> "data_tail" for user space need an update as well. Current version -

Oh, indeed. Thanks; I'll update that too!
