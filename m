Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3HTT3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3HTT33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:29:29 -0400
Date: Tue, 20 Aug 2013 21:23:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
Message-ID: <20130820192340.GA25441@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com> <20130819183319.GA24846@redhat.com> <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com> <20130819184355.GA25362@redhat.com> <CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com> <20130820185043.GA24040@redhat.com> <CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com> <20130820190529.GA24512@redhat.com> <CALCETrVC15BjcRMk2tc-SRT3tUr24057Zxt5ARQ-2Eq7RhjO2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVC15BjcRMk2tc-SRT3tUr24057Zxt5ARQ-2Eq7RhjO2w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Andy Lutomirski wrote:
>
> On Tue, Aug 20, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 08/20, Andy Lutomirski wrote:
> >>
> >> On Tue, Aug 20, 2013 at 11:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> >> Currently (with or without your patch), vfork() followed by
> >> >> unshare(CLONE_NEWUSER) or unshare(CLONE_NEWPID) will unshare the VM.
> >> >
> >> > Could you spell please?
> >> >
> >> > We never unshare the VM. CLONE_VM in sys_unshare() paths just means
> >> > "fail unless ->mm is not shared".
> >> >
> >>
> >> Argh.  In that case this is probably buggy,
> >
> > I don't think so. Just we can't really unshare ->mm

this looks confusing, sorry. Afaics it is possible to implement
unshare(CLONE_VM), but

> or implement
> > unshare(CLONE_THREAD).

this is unlikely.

but this doesn't matter,

> We simply pretend it works if there is nothing
> > to unshare.
> >
> >> sys_unshare will see CLONE_NEWPID or CLONE_NEWUSER and set
> >> CLONE_THREAD.  Then it will see CLONE_THREAD and set CLONE_VM.
> >
> > This matches copy_process() to some degree... but looks confusing,
> > I agree.

I only mean that copy_process() requires CLONE_VM if CLONE_THREAD.
But, unlike unshare(), it fails if CLONE_VM is not set.

> Huh?  Doesn't this mean that unshare(CLONE_NEWPID); vfork() will work
> with your patches,

I hope,

> but vfork(); unshare(CLONE_NEWPID) will fail?  (I
> admit I haven't tested it.)

Do you mean that the child does unshare(CLONE_NEWPID) before exec?
It should fail with or without this patch.

Oleg.

