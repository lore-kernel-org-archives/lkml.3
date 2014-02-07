Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBGKpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:45:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44028 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaBGKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:45:39 -0500
Date: Fri, 7 Feb 2014 11:45:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Torsten Duwe <duwe@lst.de>
Cc: Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Tom Musta <tommusta@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
Message-ID: <20140207104530.GG5126@laptop.programming.kicks-ass.net>
References: <20140206103736.GA18054@lst.de>
 <20140206163837.GT2936@laptop.programming.kicks-ass.net>
 <20140206173727.GA13048@lst.de>
 <1391717992.6733.232.camel@snotra.buserror.net>
 <20140207090248.GB26811@lst.de>
 <20140207103139.GP5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207103139.GP5002@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 11:31:39AM +0100, Peter Zijlstra wrote:
> Anyway, what might work is something like (please forgive my ppc asm, I
> can barely read the thing, I've never before attempted writing it):
> 
> lock:
> 1:	lharx	%0, 0, &head
> 	mov	%1, %0
> 	addic	%0, %0, 1
> 	stwcd   %0, 0, &head
> 	bne-	1b
> 2:	lhax	%0, 0, &tail

That might need to be lhz too, I'm confused on all the load variants.

> 	lwsync
> 	cmp	0, %0, %0

	cmp	0, %0, %1

So we compare the &tail load to the xadd return %1 above.

> 	bne-	2b
> 
> 
> unlock:
> 	lhz	%0, 0, &tail
> 	addic	%0, %0, 1
> 	lwsync
> 	sth	%0, 0, &tail
> 
