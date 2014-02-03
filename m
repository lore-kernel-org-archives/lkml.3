Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBCSj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:39:27 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:8759 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaBCSj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:39:26 -0500
Message-ID: <1391452760.7498.26.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Date: Mon, 03 Feb 2014 10:39:20 -0800
In-Reply-To: <20140202211230.GX5002@laptop.programming.kicks-ass.net>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-6-git-send-email-jason.low2@hp.com>
	 <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
	 <1390949495.2807.52.camel@j-VirtualBox>
	 <20140129115142.GE9636@twins.programming.kicks-ass.net>
	 <1391138977.6284.82.camel@j-VirtualBox>
	 <20140131140941.GF4941@twins.programming.kicks-ass.net>
	 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
	 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
	 <1391374883.3164.8.camel@j-VirtualBox>
	 <20140202211230.GX5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-02 at 22:12 +0100, Peter Zijlstra wrote:
> The way I wrote that same loop in step-B, is:
> 
> 
> 	for (;;) {
> 		if (*lock == node && cmpxchg(lock, node, prev) == node)
> 			return
> 
> 		next = xchg(&node->next, NULL); /* B -> A */
> 		if (next)
> 			break;
> 
> 		arch_mutex_cpu_relax();
> 	}
> 
> I suppose we can make that something like:
> 
> 
> 	if (node->next) {
> 		next = xchg(&node->next, NULL);
> 		if (next)
> 			break
> 	}
> 
> To avoid the xchg on every loop.

Ah yes, we want to use xchg() on &node->next.

Since the cmpxchg() is now in a loop in the unlock function, an
additional (*lock == node) check before the cmpxchg() would also be nice
to avoid spinning on cmpxchg() there too.

