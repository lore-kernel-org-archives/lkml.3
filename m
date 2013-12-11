Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3LKBCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:02:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab3LKBCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:02:35 -0500
Date: Wed, 11 Dec 2013 01:02:24 +0000
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211010224.GN11295@suse.de>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 08:18:29PM +0100, Thomas Gleixner wrote:
> On Tue, 10 Dec 2013, Linus Torvalds wrote:
> 
> > Hmm. Looks like the futex code is somehow stuck in a loop, calling
> > get_user_pages_fast().
> > 
> > The futex code itself is apparently so low-overhead that it doesn't
> > show up in your 'perf top' report (which is dominated by all the
> > expensive debug things that get_user_pages_fast() etc ends up doing),
> > but that's the only looping I can see. Perhaps the "goto again" case
> > for transparent huge pages in get_futex_key()? Or the
> 
> Cc'ng more folks on that.
> 

I just saw this before heading to bed and have not read the thread. I'll
read it in the morning but in the meantime the following might ring a bell
for someone elses investigation or someone more familiar with how futexs
work from end to end.

Was NUMA balancing enabled and was this a NUMA machine?

I ask because of these two patches that are currently in flight

  mm: numa: Serialise parallel get_user_page against THP migration mm
  fix TLB flush race between migration, and change_protection_range

There are related patches but these two are the most important for what
I have in mind. The two in combination address a problem whereby a write
from one thread can be lost due to a THP migration but it's specific to
automatic NUMA balancing. If the lost update was for a page containing a
futex then the lost write could confuse waiters. The downside is that this
is a bad fit for the problem description in the first mail. A lost update
might result in processes waiting forever on a value that never changes
but offhand it's less clear why it might result in a loop. Unless of
course there is a combination of events that allows for a busy wait on a
value that will never change due to the lost write.

-- 
Mel Gorman
SUSE Labs
