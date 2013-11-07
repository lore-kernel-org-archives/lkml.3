Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3KGOcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:32:41 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43793 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3KGOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:32:39 -0500
Date: Thu, 7 Nov 2013 06:31:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>, Arnd Bergmann <arnd@arndb.de>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Figo. zhang" <figo1802@gmail.com>, linux-arch@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Alex Shi <alex.shi@linaro.org>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Re: [PATCH v3 3/5] MCS Lock: Barrier corrections
Message-ID: <20131107143139.GT18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1383771175.git.tim.c.chen@linux.intel.com>
 <1383773827.11046.355.camel@schen9-DESK>
 <CA+55aFyNX=5i0hmk-KuD+Vk+yBD-kkAiywx1Lx_JJmHVPx=1wA@mail.gmail.com>
 <CANN689HkNP-UZOu+vDCFPG5_k=BNZG6a+oP+Ope16vLc2ShFzw@mail.gmail.com>
 <CA+55aFwn1HUt3iXo6Zz8j1HUJi+qJ1NfcnUz-P+XCYLL7gjCMQ@mail.gmail.com>
 <CANN689EgdDQV=srsLELUpiTGOSF0SLUZ=BC2LnMxNrYTv3H=Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689EgdDQV=srsLELUpiTGOSF0SLUZ=BC2LnMxNrYTv3H=Wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110714-6688-0000-0000-00000342C139
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 04:50:23AM -0800, Michel Lespinasse wrote:
> On Thu, Nov 7, 2013 at 4:06 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Nov 7, 2013 6:55 PM, "Michel Lespinasse" <walken@google.com> wrote:
> >>
> >> Rather than writing arch-specific locking code, would you agree to
> >> introduce acquire and release memory operations ?
> >
> > Yes, that's probably the right thing to do. What ops do we need? Store with
> > release, cmpxchg and load with acquire? Anything else?
> 
> Depends on what lock types we want to implement on top; for MCS we would need:
> - xchg acquire (common case) and load acquire (for spinning on our
> locker's wait word)
> - cmpxchg release (when there is no next locker) and store release
> (when writing to the next locker's wait word)
> 
> One downside of the proposal is that using a load acquire for spinning
> puts the memory barrier within the spin loop. So this model is very
> intuitive and does not add unnecessary barriers on x86, but it my
> place the barriers in a suboptimal place for architectures that need
> them.

OK, I will bite...  Why is a barrier in the spinloop suboptimal?

Can't say that I have tried measuring it, but the barrier should not
normally result in interconnect traffic.  Given that the barrier is
required anyway, it should not affect lock-acquisition latency.

So what am I missing here?

							Thanx, Paul

