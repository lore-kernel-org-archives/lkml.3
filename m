Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3FXQgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:36:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:57788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab3FXQgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,929,1363158000"; 
   d="scan'208";a="358757476"
Subject: Re: [PATCH 2/2] rwsem: do optimistic spinning for writer lock
 acquisition
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20130624084645.GL28407@twins.programming.kicks-ass.net>
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>
	 <1371858700.22432.5.camel@schen9-DESK>
	 <20130624084645.GL28407@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jun 2013 09:36:02 -0700
Message-ID: <1372091762.22432.16.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 10:46 +0200, Peter Zijlstra wrote:
> On Fri, Jun 21, 2013 at 04:51:40PM -0700, Tim Chen wrote:
> > Introduce in this patch optimistic spinning for writer lock
> > acquisition in read write semaphore.  The logic is
> > similar to the optimistic spinning in mutex but without
> > the MCS lock queueing of the spinner.  This provides a
> > better chance for a writer to acquire the lock before
> > being we block it and put it to sleep.
> > 
> > Disabling of pre-emption during optimistic spinning
> > was suggested by Davidlohr Bueso.  It
> > improved performance of aim7 for his test suite.
> > 
> > Combined with the patch to avoid unnecesary cmpxchg,
> > in testing by Davidlohr Bueso on aim7 workloads
> > on 8 socket 80 cores system, he saw improvements of
> > alltests (+14.5%), custom (+17%), disk (+11%), high_systime
> > (+5%), shared (+15%) and short (+4%), most of them after around 500
> > users when he implemented i_mmap as rwsem.
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > ---
> >  Makefile              |    2 +-
> >  include/linux/rwsem.h |    3 +
> >  init/Kconfig          |    9 +++
> >  kernel/rwsem.c        |   29 +++++++++-
> >  lib/rwsem.c           |  148 +++++++++++++++++++++++++++++++++++++++++++++----
> >  5 files changed, 178 insertions(+), 13 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 49aa84b..7d1ef64 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,7 +1,7 @@
> >  VERSION = 3
> >  PATCHLEVEL = 10
> >  SUBLEVEL = 0
> > -EXTRAVERSION = -rc4
> > +EXTRAVERSION = -rc4-optspin4
> >  NAME = Unicycling Gorilla
> >  
> >  # *DOCUMENTATION*
> 
> I'm fairly sure we don't want to commit this hunk ;-)

Fat fingers.  Thanks for catching.

Tim

