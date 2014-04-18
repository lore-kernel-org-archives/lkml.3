Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaDRHqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:46:25 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:63656 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDRHqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:46:21 -0400
Date: Fri, 18 Apr 2014 09:46:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 05/19] qspinlock: Optimize for smaller NR_CPUS
Message-ID: <20140418074616.GB13517@gmail.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
 <1397747051-15401-6-git-send-email-Waiman.Long@hp.com>
 <20140417155844.GS11096@twins.programming.kicks-ass.net>
 <53504C4E.8060800@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53504C4E.8060800@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 04/17/2014 11:58 AM, Peter Zijlstra wrote:
> >On Thu, Apr 17, 2014 at 11:03:57AM -0400, Waiman Long wrote:
> >>+static __always_inline void
> >>+clear_pending_set_locked(struct qspinlock *lock, u32 val)
> >>+{
> >>+	struct __qspinlock *l = (void *)lock;
> >>+
> >>+	ACCESS_ONCE(l->locked_pending) = 1;
> >>+}
> >>@@ -157,8 +251,13 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
> >>  	 * we're pending, wait for the owner to go away.
> >>  	 *
> >>  	 * *,1,1 ->  *,1,0
> >>+	 *
> >>+	 * this wait loop must be a load-acquire such that we match the
> >>+	 * store-release that clears the locked bit and create lock
> >>+	 * sequentiality; this because not all try_clear_pending_set_locked()
> >>+	 * implementations imply full barriers.
> >You renamed the function referred in the above comment.
> >
> 
> Sorry, will fix the comments.

I suggest not renaming the function instead. 
try_clear_pending_set_locked() tells the intent in a clearer fashion.

Thanks,

	Ingo
