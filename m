Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaDASb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:31:26 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:5508 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaDASbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:31:25 -0400
Message-ID: <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Tue, 01 Apr 2014 11:31:23 -0700
In-Reply-To: <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	 <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
	 <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
	 <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
	 <20140331170546.3b3e72f0.akpm@linux-foundation.org>
	 <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 14:10 -0400, KOSAKI Motohiro wrote:
> On Tue, Apr 1, 2014 at 1:01 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > On Mon, 2014-03-31 at 17:05 -0700, Andrew Morton wrote:
> >> On Mon, 31 Mar 2014 16:25:32 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> >>
> >> > On Mon, 2014-03-31 at 16:13 -0700, Andrew Morton wrote:
> >> > > On Mon, 31 Mar 2014 15:59:33 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> >> > >
> >> > > > >
> >> > > > > - Shouldn't there be a way to alter this namespace's shm_ctlmax?
> >> > > >
> >> > > > Unfortunately this would also add the complexity I previously mentioned.
> >> > >
> >> > > But if the current namespace's shm_ctlmax is too small, you're screwed.
> >> > > Have to shut down the namespace all the way back to init_ns and start
> >> > > again.
> >> > >
> >> > > > > - What happens if we just nuke the limit altogether and fall back to
> >> > > > >   the next check, which presumably is the rlimit bounds?
> >> > > >
> >> > > > afaik we only have rlimit for msgqueues. But in any case, while I like
> >> > > > that simplicity, it's too late. Too many workloads (specially DBs) rely
> >> > > > heavily on shmmax. Removing it and relying on something else would thus
> >> > > > cause a lot of things to break.
> >> > >
> >> > > It would permit larger shm segments - how could that break things?  It
> >> > > would make most or all of these issues go away?
> >> > >
> >> >
> >> > So sysadmins wouldn't be very happy, per man shmget(2):
> >> >
> >> > EINVAL A new segment was to be created and size < SHMMIN or size >
> >> > SHMMAX, or no new segment was to be created, a segment with given key
> >> > existed, but size is greater than the size of that segment.
> >>
> >> So their system will act as if they had set SHMMAX=enormous.  What
> >> problems could that cause?
> >
> > So, just like any sysctl configurable, only privileged users can change
> > this value. If we remove this option, users can theoretically create
> > huge segments, thus ignoring any custom limit previously set. This is
> > what I fear. Think of it kind of like mlock's rlimit. And for that
> > matter, why does sysctl exist at all, the same would go for the rest of
> > the limits.
> 
> Hmm. It's hard to agree. AFAIK 32MB is just borrowed from other Unix
> and it doesn't respect any Linux internals. 

Agreed, it's stupid, but it's what Linux chose to use since forever.

> Look, non privileged user
> can user unlimited memory, at least on linux. So I don't find out any
> difference between regular anon and shmem.

Fine, let's try it, if users complain we can revert.

> 
> So, I personally like 0 byte per default.

If by this you mean 0 bytes == unlimited, then I agree. It's less harsh
then removing it entirely. So instead of removing the limit we can just
set it by default to 0, and in newseg() if shm_ctlmax == 0 then we don't
return EINVAL if the passed size is great (obviously), otherwise, if the
user _explicitly_ set it via sysctl then we respect that. Andrew, do you
agree with this? If so I'll send a patch.

Thanks,
Davidlohr

