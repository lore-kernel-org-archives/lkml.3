Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3LJXCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:02:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab3LJXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:02:07 -0500
Date: Tue, 10 Dec 2013 18:01:16 -0500
From: Dave Jones <davej@redhat.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210230116.GG5050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Darren Hart <dvhart@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
 <CA+55aFzhCSvc4Vy7tEC2K972h+vne6Y0QSekDDZbV_ATB-9mxw@mail.gmail.com>
 <1386716299.3685.99.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386716299.3685.99.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 02:58:19PM -0800, Darren Hart wrote:
 > On Tue, 2013-12-10 at 14:48 -0800, Linus Torvalds wrote:
 > > On Tue, Dec 10, 2013 at 2:42 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
 > > >
 > > > And yes, I remember that we do not do an extra check for the fshared
 > > > case, because get_user_pages_fast() should do it for us already. If
 > > > not we are fubared not only in the futex code.
 > > 
 > > Yeah. It turns out we do do the access check indirectly - by looking
 > > at the PAGE_USER bit, even if we don't necessarily check the actual
 > > limits. So get_user_pages_fast() is fine.
 > > 
 > > > But there is a subtle detail:
 > > 
 > > Yup, see my email from ten minutes ago, we found the same thing. And
 > > that would seem to explain the endless loop, and also the timing
 > > (since Dave mentions he started doing large-pages lately).
 > > 
 > > So I think the "__get_user_pages_fast(address, 1, !ro, &page)" thing
 > > should work.
 > > 
 > > Dave, can you re-create that trinity run and test that patch? I think
 > > we've got this, but it might be nice to leave the hung machine up and
 > > running until it's verified.. Although I don't really see what else we
 > > could need or get out of it, so..
 > 
 > Would it be possible to limit the options to only pass FUTEX_CMP_REQUEUE
 > and a read-only uaddr? That should improve confidence when it doesn't
 > fail :-)

easy enough to hack into the code yeah. A bit complicated to come up with
a sensible grammar for a command line parser for such cases sadly.

I'll give the patch a try after dinner.

	Dave

