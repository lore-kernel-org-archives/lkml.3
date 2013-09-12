Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3ILWhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:37:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:30904 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab3ILWh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:37:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,893,1371106800"; 
   d="scan'208";a="400860996"
Message-ID: <1379025421.1285.55.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH] kernel/futex.c: notice the return value after
 rt_mutex_finish_proxy_lock() fails
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Gang <gang.chen@asianux.com>, ccross@android.com,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Sep 2013 15:37:01 -0700
In-Reply-To: <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de>
References: <5212DD71.7070208@asianux.com>
	 <alpine.DEB.2.02.1309121627040.4089@ionos.tec.linutronix.de>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 16:32 +0200, Thomas Gleixner wrote:
> On Tue, 20 Aug 2013, Chen Gang wrote:
> 
> > rt_mutex_finish_proxy_lock() can return failure code (e.g. -EINTR,
> > -ETIMEDOUT).
> > 
> > Original implementation has already noticed about it, but not check it
> > before next work.
> > 
> > Also let coments within 80 columns to pass "./scripts/checkpatch.pl".
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  kernel/futex.c |   30 ++++++++++++++++--------------
> >  1 files changed, 16 insertions(+), 14 deletions(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index c3a1a55..1a94e7d 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -2373,21 +2373,23 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
> >               ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
> >               debug_rt_mutex_free_waiter(&rt_waiter);
> >  
> > -             spin_lock(q.lock_ptr);
> > -             /*
> > -              * Fixup the pi_state owner and possibly acquire the lock if we
> > -              * haven't already.
> > -              */
> > -             res = fixup_owner(uaddr2, &q, !ret);
> > -             /*
> > -              * If fixup_owner() returned an error, proprogate that.  If it
> > -              * acquired the lock, clear -ETIMEDOUT or -EINTR.
> > -              */
> > -             if (res)
> > -                     ret = (res < 0) ? res : 0;
> > +             if (!ret) {
> 
> Again. This is completely wrong!  
> 
> We MUST call fixup_owner even if finish_proxy_lock() returned with an
> error code. Simply because finish_proxy_lock() is called outside of
> the spin_lock(q.lock_ptr) region and another thread might have
> modified the futex state. So we need to handle the corner cases
> otherwise we might leave the futex in some undefined state.
> 
> You're reintroducing a hard to decode bug, which got analyzed and
> fixed in futex_lock_pi() years ago. See the history for the
> explanation.
> 
> Sigh.
> 
>         tglx

Chen, perhaps you can let us know what the failure scenario is that you
are trying to address with this patch. I only replied the once as I
pointed out the corner-case and expected you to follow up with that.
This region of code is very fragile to modifications as it has become
more corner-cases than core logic in some places :-)

For starters, I'm not following your second sentence in the commit log.
Can you elaborate on the following?

"Original implementation has already noticed about it, but not check it
before next work."

Do you have a test-case that demonstrates a failure mode?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


