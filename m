Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbaHYPFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaHYPFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:05:49 -0400
Date: Mon, 25 Aug 2014 17:03:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ipc/shm: fix the historical/wrong mm->start_stack
	check
Message-ID: <20140825150301.GB3021@redhat.com>
References: <20140823144246.GA6281@redhat.com> <20140823144327.GA6299@redhat.com> <20140823152240.GH25918@moon> <20140823155832.GA9406@redhat.com> <alpine.LSU.2.11.1408241818530.8474@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408241818530.8474@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Hugh Dickins wrote:
>
> On Sat, 23 Aug 2014, Oleg Nesterov wrote:
> > On 08/23, Cyrill Gorcunov wrote:
> > >
> > > On Sat, Aug 23, 2014 at 04:43:27PM +0200, Oleg Nesterov wrote:
> > > > The ->start_stack check in do_shmat() looks ugly and simply wrong.
> > > >
> > > > 1. ->start_stack is only valid right after exec(), the application
> > > >    can switch to another stack and even unmap this area.
> > > >
> > > > 2. The reason for this check is not clear at all. The application
> > > >    should know what it does. And why 4 pages? And why in fact it
> > > >    requires 5 pages?
> > > >
> > > > 3. This wrongly assumes that the stack can only grown down.
> > > >
> > > > Personally I think we should simply kill this check, but I did not
> > > > dare to do this. So the patch only fixes the 1st problem (mostly to
> > > > avoid the usage of mm->start_stack) and ignores VM_GROWSUP.
> > > >
> > > > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > > Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
>
> Yes, much better to use find_vma than have this strange stray use
> of unreliable start_stack.
>
> Acked-by: Hugh Dickins <hughd@google.com>

Thanks!

> though like Manfred I didn't quite see how overflow was impossible
> on unfamiliar architectures.

And you can't see, because the comment is simply wrong, I'll send v2.

> > > I don't understand this check either, the comment above it says nothing
> > > but only commits what code is doing not explaining why.
> >
> > Yes, and this check predates the git history. I even looked into
> > git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git but this
> > change was added by the huge "v2.5.0.7 -> v2.5.0.8" update in 2002,
> > and obviously without any explanation (apart from "fix up proper shmat
> > semantics", but this connects SHM_REMAP itself).
>
> I'd say it comes earlier, from Christoph Rohland's 2.4.17-pre7's
> "Add missing checks on shmat()", though I didn't find more than that.
>
> We can all understand wanting to leave a gap below the growsdown stack,
> but of course could argue about growsup and 1 or 4 or 5 or whatever:

And it is not clear to me why the kernel should care at all,

> okay that we're all more interested in just removing that start_stack.

so perhaps v2 should simply remove it? Or do you think it would be safer
to not do this?

Oleg.

