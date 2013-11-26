Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab3KZNxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:53:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:34024 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3KZNxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:53:33 -0500
Date: Tue, 26 Nov 2013 14:53:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, jeffm@suse.com,
        "Norton, Scott J" <scott.norton@hp.com>, tom.vaden@hp.com,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>, Jason Low <jason.low2@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
In-Reply-To: <1385409830.12342.41.camel@dvhart-mobl4.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1311261436290.30673@ionos.tec.linutronix.de>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>   <1385168197-8612-5-git-send-email-davidlohr@hp.com>   <CA+55aFz9o2K-CEp+ECEaTgmP2fU=Eh7_o58VGmM1sOhKhu_n=w@mail.gmail.com>  <1385176773.5402.14.camel@buesod1.americas.hpqcorp.net> 
 <alpine.DEB.2.02.1311231206380.30673@ionos.tec.linutronix.de>  <alpine.DEB.2.02.1311251938570.30673@ionos.tec.linutronix.de> <1385409830.12342.41.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Nov 2013, Darren Hart wrote:
> On Mon, 2013-11-25 at 20:47 +0100, Thomas Gleixner wrote:
> > So now your code melts down to:
> > 
> >  write(hb->waiters)    |    write(uaddr)
> >  mb                    |    read(hb->waiters)
> >  read(uaddr)
> > 
> > I fear you simply managed to make the window small enough that your
> > testing was not longer able expose it.
> 
> Does seem to be the case.

Actually not. It's protected by an atomic_inc() between the
write(uaddr) and read(hb->waiters) on the waker side.

It took me a while to realize, that get_futex_key_refs() is providing
the protection inadvertently. But as I explained we cannot rely on
that for all architectures.

Thanks,

	tglx








