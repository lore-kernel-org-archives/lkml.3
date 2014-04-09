Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398AbaDIVZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:25:42 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55776 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIVZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:25:40 -0400
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140409154346.GB18486@redhat.com>
References: <20140406201628.GA507@redhat.com>
	 <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com>
	 <20140409154346.GB18486@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Apr 2014 14:25:35 -0700
Message-ID: <1397078735.5261.20.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040921-8236-0000-0000-0000016ACBB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 17:43 +0200, Oleg Nesterov wrote:
> On 04/08, Jim Keniston wrote:
> >
> > On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> > > 0xe8. Anything else?

Oleg, thanks for responding to (if not necessarily agreeing with) all my
suggestions.  I think your code is solid, but I think we were wrong
about one thing.  See below.

> >
> > No, I think e8 is the only call instruction uprobes will see.
> 
> Good.
> 
> > The following couple of paragraphs should be included in the code,
> > perhaps merged with some of the related comments already there.  Without
> > it, the code is pretty hard to follow.
> 
> OK, I'll try to improve the comments somehow...
> 
> > > Emulating of rip-relative call is trivial, we only need to additionally
> > > push the ret-address. If this fails, we execute this instruction out of
> > > line and this should trigger the trap, the probed application should die
> > > or the same insn will be restarted if a signal handler expands the stack.
> > > We do not even need ->post_xol() for this case.
> > >
> > > But there is a corner (and almost theoretical) case: another thread can
> > > expand the stack right before we execute this insn out of line. In this
> > > case it hit the same problem we are trying to solve. So we simply turn
> > > the probed insn into "call 1f; 1:" and add ->post_xol() which restores
> > > ->sp and restarts.
> >
> > Can you explain under what circumstances emulation of the call
> > instruction would fail?  Will the copy_to_user() call that writes the
> > return address to the stack grow the stack if necessary?
> 
> If necessary and if possible.
> 
> > Will
> > single-stepping the mangled call instruction expand the stack?
> 
> In the likely case it won't. If copy_to_user() failes, then "call" should
> fail too (again, ignoring the potential race with another thread which can
> populate the memory ->sp - 8 points to).


I've experimented with putting a uprobe on a call instruction (in a
tight loop, with no ret) and a kprobe on expand_stack(), and my results
seem to indicate that a single-stepped call instruction will
successfully grow the stack vma where a call to copy_to_user() won't.

So your trick of single-stepping the mangled call after the failed
emulation, and then retrying the emulation should come into play in more
than just theoretical situations.  We'd need it any time the probed call
needs to grow the stack vma.

I can send you the test kprobe/uprobe modules I used, if you like.

Bottom line: no further code changes, but this would affect your
comments.

Jim

