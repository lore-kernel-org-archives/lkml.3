Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3LFPTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:19:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3LFPTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:19:30 -0500
Date: Fri, 6 Dec 2013 16:19:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        William Dauchy <wdauchy@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Ma, Xindong" <xindong.ma@intel.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        gregkh@linuxfoundation.org, "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        azurIt <azurit@pobox.sk>, Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] Fix race between oom kill and task exit
Message-ID: <20131206151944.GC2674@redhat.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com> <20131128063505.GN3556@cmpxchg.org> <CAJ75kXZXxCMgf8=pghUWf=W9EKf3Z4nzKKy=CAn+7keVF_DCRA@mail.gmail.com> <20131128120018.GL2761@dhcp22.suse.cz> <20131128183830.GD20740@redhat.com> <20131202141203.GA31402@redhat.com> <alpine.DEB.2.02.1312041655370.13608@chino.kir.corp.google.com> <20131205172931.GA26018@redhat.com> <alpine.DEB.2.02.1312051531330.7717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312051531330.7717@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, David Rientjes wrote:
>
> On Thu, 5 Dec 2013, Oleg Nesterov wrote:
>
> > > Your v2 series looks good and I suspect anybody trying them doesn't have
> > > additional reports of the infinite loop?  Should they be marked for
> > > stable?
> >
> > Unlikely...
> >
> > I think the patch from Sameer makes more sense for stable as a temporary
> > (and obviously incomplete) fix.
>
> There's a problem because none of this is currently even in linux-next.  I
> think we could make a case for getting Sameer's patch at
> http://marc.info/?l=linux-kernel&m=138436313021133 to be merged for
> stable,

Probably.

Ah, I just noticed that this change

	-	if (p->flags & PF_EXITING) {
	+	if (p->flags & PF_EXITING || !pid_alive(p)) {

is not needed. !pid_alive(p) obviously implies PF_EXITING.

> but then we'd have to revert it in linux-next

Or perhaps Sameer can just send his fix to stable/gregkh.

Just the changelog should clearly explain that this is the minimal
workaround for stable. Once again it doesn't (and can't) fix all
problems even in oom_kill_process() paths, but it helps anyway to
avoid the easy-to-trigger hang.

> before merging your
> series at http://marc.info/?l=linux-kernel&m=138616217925981.

Just in case, I won't mind to rediff my patches on top of Sameer's
patch and then add git-revert patch.

> All of the
> issues you present in that series seem to be stable material, so why not
> just go ahead with your series and mark it for stable for 3.13?

OK... I can do this too.

I do not really like this because it adds thread_head/node but doesn't
remove the old ->thread_group. We will do this later, but obviously
this is not the stable material.

IOW, if we send this to stable, thread_head/node/for_each_thread will
be only used by oom_kill.c.

And this is risky. For example, 1/4 depends on (at least) another patch
I sent in preparation for this change, commit 81907739851
"kernel/fork.c:copy_process(): don't add the uninitialized
child to thread/task/pid lists", perhaps on something else.

So personally I'd prefer to simply send the workaround for stable.

Oleg.

