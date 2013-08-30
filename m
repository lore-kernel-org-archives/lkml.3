Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3H3Qbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:31:44 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:57547 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3H3Qbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com>
References: <CA+icZUXuw7QBn4CPLLuiVUjHin0m6GRdbczGw=bZY+Z60sXNow@mail.gmail.com>
	<CA+icZUVbUD1tUa_ORtn_ZZebpp3gXXHGAcNe0NdYPXPMPoABuA@mail.gmail.com>
	<1372192414.1888.8.camel@buesod1.americas.hpqcorp.net>
	<CA+icZUXgOd=URJBH5MGAZKdvdkMpFt+5mRxtzuDzq_vFHpoc2A@mail.gmail.com>
	<1372202983.1888.22.camel@buesod1.americas.hpqcorp.net>
	<521DE5D7.4040305@synopsys.com>
	<CA+icZUUrZG8pYqKcHY3DcYAuuw=vbdUvs6ZXDq5meBMjj6suFg@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA23075140FA3@IN01WEMBXA.internal.synopsys.com>
	<CA+icZUUn-r8iq6TVMAKmgJpQm4FhOE4b4QN_Yy=1L=0Up=rkBA@mail.gmail.com>
	<52205597.3090609@synopsys.com>
	<CA+icZUW=YXMC_2Qt=cYYz6w_fVW8TS4=Pvbx7BGtzjGt+31rLQ@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA230751411CB@IN01WEMBXA.internal.synopsys.com>
	<CALE5RAvaa4bb-9xAnBe07Yp2n+Nn4uGEgqpLrKMuOE8hhZv00Q@mail.gmail.com>
Date: Fri, 30 Aug 2013 13:31:41 -0300
Message-ID: <CAMJEocr1SgxQw0bEzB3Ti9bvRY74TE5y9e+PLUsAL1mJbK=-ew@mail.gmail.com>
Subject: Re: ipc-msg broken again on 3.11-rc7?
From: Davidlohr Bueso <dave.bueso@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>, sedat.dilek@gmail.com,
        linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Jonathan Gonzalez <jgonzalez@linets.cl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Date: Fri, Aug 30, 2013 at 4:46 AM
> Subject: Re: ipc-msg broken again on 3.11-rc7?
> To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
> Cc: linus Torvalds <torvalds@linux-foundation.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>, Manfred Spraul <manfred@colorfullife.com>, Jonathan Gonzalez <jgonzalez@linets.cl>
>
>
> On 08/30/2013 01:57 PM, Sedat Dilek wrote:
> > On Fri, Aug 30, 2013 at 10:19 AM, Vineet Gupta <vineetg76@gmail.com> wrote:
> >> Ping ?
> >>
> >> It seems 3.11 is pretty close to releasing but we stil have LTP msgctl08 causing a
> >> hang (atleast on ARC) for both linux-next 20130829 as well as Linus tree.
> >>
> >> So far, I haven't seemed to have drawn attention of people involved.
> >>

I apologize for the delay, I am on vacations and wasnt interrupting my
days at the beach by checking email.

You mention that the msgctl08 test case just hangs, nothing
interesting in dmesg appart from "msgmni has been set to 479" (which
is a standard initialization message anyways)?

After a quick glance, I suspect that the problem might be because we
are calling security_msg_queue_msgsnd() without taking the lock. This
is similar to the issue Sedat reported in the original thread with
find_msg() concerning msgrcv. The rest of the code looks otherwise
standard. Unfortunately I dont have a computer available to write/test
such a fix. I think we can move calls to security_msg_queue_msgsnd()
to be done right before ss_add(), which would simplify the code
changes, something like:

...

/* queue full, wait: */
if (msgflg & IPC_NOWAIT) {
     err = -EAGAIN;
     goto out_unlock1;
}

ipc_lock_object(&msq->q_perm);
err = security_msg_queue_msgsnd(msq, msg, msgflg);
if (err)
    goto out_unlock0;

ss_add(msq, &s);

...


Thanks,
Davidlohr


> >
> > Hi Vineet,
> >
> > I remember fakeroot was an another good test-case for me to test this
> > IPC breakage.
> > Attached is my build-script for Linux-next (tested with Debian/Ubuntu).
> > ( Cannot say if you can play with it in your environment. )
>
> Hi Sedat,
>
> I have a simpler buildroot based rootfs (initramfs based) and LTP is run off of
> NFS, although running of a local storage doesn't make a difference.
>
> For me msgctl08 standalone (w/o hassle of running full LTP) is enough to trigger
> it consistently.
>
> P.S. sorry my sender address kept flipping - mailer was broken !
>
> -Vineet
>
>
