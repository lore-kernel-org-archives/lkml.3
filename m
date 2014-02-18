Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaBRTrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:47:52 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40698 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaBRTru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:47:50 -0500
Date: Tue, 18 Feb 2014 11:47:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter.Sewell@cl.cam.ac.uk,
        "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218194745.GV4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
 <CA+55aFw=9iKadR-r5sdZdJ_7yDzSV4=+P=gZXXsrxU61wKHf5w@mail.gmail.com>
 <CAHWkzRQp3x4Wsnr6ZRdxfk04MuWT3bANnL8=VbCVEZ6+ifiqYA@mail.gmail.com>
 <CA+55aFyfjr7=kXu6W83HhMenOnX9fssOGaZTJv_vj6rQ_+jY3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyfjr7=kXu6W83HhMenOnX9fssOGaZTJv_vj6rQ_+jY3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021819-9332-0000-0000-000003255BC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:49:27AM -0800, Linus Torvalds wrote:
> On Tue, Feb 18, 2014 at 10:21 AM, Peter Sewell
> <Peter.Sewell@cl.cam.ac.uk> wrote:
> >
> > This is a bit more subtle, because (on ARM and POWER) removing the
> > dependency and conditional branch is actually in general *not* equivalent
> > in the hardware, in a concurrent context.
> 
> So I agree, but I think that's a generic issue with non-local memory
> ordering, and is not at all specific to the optimization wrt that
> "x?42:42" expression.
> 
> If you have a value that you loaded with a non-relaxed load, and you
> pass that value off to a non-local function that you don't know what
> it does, in my opinion that implies that the compiler had better add
> the necessary serialization to say "whatever that other function does,
> we guarantee the semantics of the load".
> 
> So on ppc, if you do a load with "consume" or "acquire" and then call
> another function without having had something in the caller that
> serializes the load, you'd better add the lwsync or whatever before
> the call. Exactly because the function call itself otherwise basically
> breaks the visibility into ordering. You've basically turned a
> load-with-ordering-guarantees into just an integer that you passed off
> to something that doesn't know about the ordering guarantees - and you
> need that "lwsync" in order to still guarantee the ordering.
> 
> Tough titties. That's what a CPU with weak memory ordering semantics
> gets in order to have sufficient memory ordering.

And that is in fact what C11 compilers are supposed to do if the function
doesn't have the [[carries_dependency]] attribute on the corresponding
argument or return of the non-local function.  If the function is marked
with [[carries_dependency]], then the compiler has the information needed
in both compilations to make things work correctly.

							Thanx, Paul

> And I don't think it's actually a problem in practice. If you are
> doing loads with ordered semantics, you're not going to pass the
> result off willy-nilly to random functions (or you really *do* require
> the ordering, because the load that did the "acquire" was actually for
> a lock!
> 
> So I really think that the "local optimization" is correct regardless.
> 
>                    Linus
> 

