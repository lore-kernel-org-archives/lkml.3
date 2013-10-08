Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3JHUf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:35:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:25639 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab3JHUf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1058,1371106800"; 
   d="scan'208";a="390131409"
Subject: Re: [PATCH v8 5/9] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20131008195100.GA21046@localhost.localdomain>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
	 <1380753512.11046.87.camel@schen9-DESK>
	 <20131008195100.GA21046@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Oct 2013 13:34:55 -0700
Message-ID: <1381264495.11046.110.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 16:51 -0300, Rafael Aquini wrote:
> On Wed, Oct 02, 2013 at 03:38:32PM -0700, Tim Chen wrote:
> > We will need the MCS lock code for doing optimistic spinning for rwsem.
> > Extracting the MCS code from mutex.c and put into its own file allow us
> > to reuse this code easily for rwsem.
> > 
> > Reviewed-by: Ingo Molnar <mingo@elte.hu>
> > Reviewed-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  include/linux/mcs_spinlock.h |   64 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mutex.h        |    5 ++-
> >  kernel/mutex.c               |   60 ++++----------------------------------
> >  3 files changed, 74 insertions(+), 55 deletions(-)
> >  create mode 100644 include/linux/mcs_spinlock.h
> > 
> > diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
> > new file mode 100644
> > index 0000000..b5de3b0
> > --- /dev/null
> > +++ b/include/linux/mcs_spinlock.h
> > @@ -0,0 +1,64 @@
> > +/*
> > + * MCS lock defines
> > + *
> > + * This file contains the main data structure and API definitions of MCS lock.
> > + *
> > + * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
> > + * with the desirable properties of being fair, and with each cpu trying
> > + * to acquire the lock spinning on a local variable.
> > + * It avoids expensive cache bouncings that common test-and-set spin-lock
> > + * implementations incur.
> > + */
> 
> nitpick:
> 
> I believe you need 
> 
> +#include <asm/processor.h>
> 
> here, to avoid breaking the build when arch_mutex_cpu_relax() is not defined
> (arch/s390 is one case)

Probably 

+#include <linux/mutex.h> 

should be added instead?
It defines arch_mutex_cpu_relax when there's no 
architecture specific version.

Thanks.
Tim


