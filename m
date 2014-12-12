Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbaLLSzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:55:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbaLLSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:55:33 -0500
Date: Fri, 12 Dec 2014 13:54:54 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212185454.GB4716@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 01:49:17PM -0800, Linus Torvalds wrote:

 > Maybe it's worth it to concentrate on just testing current kernels,
 > and instead try to limit the triggering some other way. In particular,
 > you had a trinity run that was *only* testing lsetxattr(). Is that
 > really *all* that was going on? Obviously trinity will be using
 > timers, fork, and other things? Can you recreate that lsetxattr thing,
 > and just try to get as many problem reports as possible from one
 > particular kernel (say, 3.18, since that should be a reasonable modern
 > base with hopefully not a lot of other random issues)?

Something that's still making me wonder if it's some kind of hardware
problem is the non-deterministic nature of this bug.
Take the example above, by limiting trinity to doing nothing but lsetxattr's.
Why would the bug sometimes take 3-4 hours to shake out, and another
run take just 45 minutes.

"different entropy" really shouldn't matter a huge amount here. Even if
we end up picking different pathnames to pass in, it's the same source
(proc,sys,/dev).   The other arguments are a crapshoot, but it seems
unlikely that it would matter hugely whatever values they are.

If it *is* a kernel bug, it's not going to be in lsetxattr, but rather
some kind of scheduling or mm related thing that happens in some corner
case when we're under extreme load. That I can drive up the loadavg with
lsetxattr is I suspect just a symptom rather than the cause.

If enough callers pass in huge 'len' arguments, and an mmap that's big
enough to cover that size, I could see that giving the kernel a lot of
work to do.

Another thing I keep thinking is "well, how is this different from
a forkbomb?". The user account I'm running under has no ulimit set on
the maximum memory size for eg, but if that were the problem, surely
I'd be seeing the oom-killer rather than lockups.

	Dave

