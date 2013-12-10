Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab3LJWv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:51:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:61889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3LJWv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:51:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,867,1378882800"; 
   d="scan'208";a="450147708"
Message-ID: <1386715917.3685.97.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: process 'stuck' at exit.
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Date: Tue, 10 Dec 2013 14:51:57 -0800
In-Reply-To: <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com>
	 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com>
	 <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com>
	 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
	 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
	 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 23:42 +0100, Thomas Gleixner wrote:
> On Tue, 10 Dec 2013, Linus Torvalds wrote:
> 
> > On Tue, Dec 10, 2013 at 1:57 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > So it looks like __get_user_pages_fast() fails, and keeps failing.
> > 
> > Hmm.. Is any of the addresses unchecked, perhaps?
> > __get_user_pages_fast() does an access_ok() check, while
> > get_user_pages_fast() does *not* seem to do one.
> > 
> > That looks a bit dangerous. Yeah, users should have checked the
> > address range, but there really is no reason not to do it in
> > get_user_pages_fast().
> > 
> > And it looks like the futex code is actually seriously buggered. It
> > only does the access_ok() check for the non-shared case.
> > 
> > Why?
> 
> The !fshared case is the fast path which does not even reach
> get_user_pages_fast().
> 
> We had this discussion some time ago already, where the access_ok()
> check was missing in the !fshared case or the check was buggered for
> some reason. Need to dig up the gory details.
> 
> And yes, I remember that we do not do an extra check for the fshared
> case, because get_user_pages_fast() should do it for us already. If
> not we are fubared not only in the futex code.
> 
> But there is a subtle detail:
> 
>     err = get_user_pages_fast(address, 1, 1, &page);
> 
> So we ask for write access as the write argument is 1. In case that
> fails we have that fallback path:
> 
>         /*
>          * If write access is not required (eg. FUTEX_WAIT), try
>          * and get read-only access.
>          */
>         if (err == -EFAULT && rw == VERIFY_READ) {
>                 err = get_user_pages_fast(address, 1, 0, &page);
> 
> That's a legitimate use case. And futex_requeue only requests
> VERIFY_READ for the !requeue_pi case.
> 
> Now, if that map is RO, i.e. we took the fallback path then the THP
> one will fail as it has write=1 unconditionally.
> 
>       if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) 
> 

Is there a reason THP requires unconditional rw? Andrea?

Or is the following actually the answer here?

diff --git a/kernel/futex.c b/kernel/futex.c
index 80ba086..02febad 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -288,7 +288,7 @@ again:
                put_page(page);
                /* serialize against __split_huge_page_splitting() */
                local_irq_disable();
-               if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
+               if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
                        page_head = compound_head(page);
                        /*
                         * page_head is valid pointer but we must pin




-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


