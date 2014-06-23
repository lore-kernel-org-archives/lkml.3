Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaFWG6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 02:58:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:45903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaFWG6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 02:58:39 -0400
Date: Mon, 23 Jun 2014 08:58:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch,locking: Ciao arch_mutex_cpu_relax()
Message-ID: <20140623065835.GF19860@laptop.programming.kicks-ass.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:21:13AM -0700, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> The arch_mutex_cpu_relax() function, introduced by 34b133f, is
> hacky and ugly. It was added a few years ago to address the fact
> that common cpu_relax() calls include yielding on s390, and thus
> impact the optimistic spinning functionality of mutexes. Nowadays
> we use this function well beyond mutexes: rwsem, qrwlock, mcs and
> lockref. Since the macro that defines the call is in the mutex header,
> any users must include mutex.h and the naming is misleading as well.
> 
> This patch (i) renames the call to arch_cpu_relax (for lack of a better
> name), and (ii) defines it in each arch's asm/processor.h local header,
> just like for regular cpu_relax() functions. On all archs, except s390,
> arch_cpu_relax is simply cpu_relax, and thus we can take it out of
> mutex.h. While this can seem redundant or weird, I believe it is a
> good choice as it allows us to move out arch specific logic from generic
> locking primitives and enables future(?) archs to transparently define
> it, similarly to System Z.
> 
> Please note that these changes are only tested on x86-64.

While I like the general idea; does anyone have a better name for this?
So in particular, the difference is that on s390:

 cpu_relax()                - yields the vcpu
 arch_{,mutex_}cpu_relax()  - will actually spin-wait


