Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab3LJWiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:38:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:37114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab3LJWiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:38:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,867,1378882800"; 
   d="scan'208";a="450137154"
Message-ID: <1386715081.3685.94.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: process 'stuck' at exit.
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Date: Tue, 10 Dec 2013 14:38:01 -0800
In-Reply-To: <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
References: <20131210154724.GA30020@redhat.com>
	 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com>
	 <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com>
	 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
	 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
	 <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 14:33 -0800, Linus Torvalds wrote:
> On Tue, Dec 10, 2013 at 2:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Shouldn't we do something like the attached?
> 
> So I think that kernel/futex.c part of the patch might be a good idea,
> but on x86-64 (which is what Dave is running), the
> 
>         if (end >> __VIRTUAL_MASK_SHIFT)
> 
> test in get_user_pages_fast() should have been equivalent. And even on
> 32-bit, we do check the _PAGE_USER bits in the page tables, so I guess
> it's all good on a get_user_pages_fast() side.
> 
> So never mind. It's not the address checking.
> 
> And I think I see what's up.
> 
> I think what happens is:
>  - get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only)
>  - get_user_pages_fast(address, 1, 0, &page) succeeds and gets a large-page
>  - __get_user_pages_fast(address, 1, 1, &page) fails (because it's read-only).
> 
> so what triggers this is likely that Dave now does large-pages, and
> one of them is a read-only mapping.
> 
> So I would suggest replacing the second "1" in the
> __get_user_pages_fast() call with a "!ro" instead. So how about this
> second patch instead (the access_ok() move remains).
> 
> Comments?
> 

You're too fast for me, but I'm trying to keep up.

It was my understanding that access_ok() was an optimization for private
futexes, but something more heavy weight was required for shared. I
believe that was find_vma() in the past, but Peter Z changed that with
fast gup. Trying to page that all in now and get the exact details....

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


