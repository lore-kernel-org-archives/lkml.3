Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaJCUG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:06:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJCUG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:06:28 -0400
Date: Fri, 3 Oct 2014 22:06:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: Removing per-task TSD? (Re: Tightening up rdpmc permissions?)
Message-ID: <20141003200624.GL10583@worktop.programming.kicks-ass.net>
References: <CALCETrUwXk-WtfwMRtcg4NO5i8-36HXDqL3BdV7xRWDWT2w7Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUwXk-WtfwMRtcg4NO5i8-36HXDqL3BdV7xRWDWT2w7Jw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 09:41:30AM -0700, Andy Lutomirski wrote:
> So this is a mess.  I think that any reasonable implementation of
> rdpmc permissions should be per mm, since we perf_event maps are, of
> course, per mm.
> 
> Similarly, any reasonable implementation of rdtsc permissions should
> be per mm, since doing it sensibly involves telling the vdso not to
> use rdtsc, and the vdso is per mm

So far so good.

> Unfortunately, PR_SET_TSC is a per-thread setting.  Implementing this
> correctly looks like it'll require twiddling, or at least thinking
> about, cr4 at switch_mm time *and* when switching tasks, because the
> only sensible way of granting PMC access to a running mm is to
> broadcast a function call to the cpus running that mm.

Confused... now though.

Any cpu can only ever run one mm at the time, and the only way to change
mm on any one cpu is switch_mm(), so having a CR4 write in switch_mm()
will DTRT, no weird broadcasts or anything else required.

Or were you talking about doing the per mm filter while maintaining the
old TIF_NOTSC thing? Then still no broadcasts would be required I think.

> Nonetheless, this is doable.  Either there can be separate context
> switching of CR4.PCE (in switch_mm) and CR4.TSD (in switch_to), or
> there can be some crazy optimization to make it faster.

IFF you want to retain TIF_NOTSC then yes, we'll need both or crazy.

> All of this sucks, so I'll ask a normally verboten question: can we
> just remove PR_SET_TSC entirely?

Fine with me, see more in that thread, I'll try and reply to the right
copy.
