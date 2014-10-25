Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaJYWVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:21:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:51301 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaJYWVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:21:33 -0400
Date: Sun, 26 Oct 2014 00:21:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <chris.friesen@windriver.com>
cc: rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: semantics of reader/writer semaphores in rt patch
In-Reply-To: <alpine.DEB.2.11.1410252354030.5308@nanos>
Message-ID: <alpine.DEB.2.11.1410260019280.5308@nanos>
References: <544956B8.2000406@windriver.com> <alpine.DEB.2.11.1410252354030.5308@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014, Thomas Gleixner wrote:
> On Thu, 23 Oct 2014, Chris Friesen wrote:
> > Does the RT kernel just disallow this sort of algorithm?
> 
> Yes. For a good reason. Let's add thread C
> 
> A    	   	B		C
> down_read(X)
> 				down_write(X)
> lock(Y)
> modify data
> unlock(Y)
> wake(B)
> 		down_read(X)
> 
> Due to the mainline rwsem fairness semantics:
> 
> A holds X, C is blocked on A and B is blocked on A.
> 
> Deadlock, without RT and the single reader restriction being involved.
> 
> So RT does not violate ANY of the existing mainline semantics, it just
> imposes a performance impact of not allowing multiple readers.

@peterz: It might be worthwhile to have a CONFIG_LOCKDEP=y dependent
mode which restricts concurrent readers to 1 in mainline to catch this
kind of stuff. Hmm?

Thanks,

	tglx
