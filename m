Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaLNAPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 19:15:00 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:49076 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaLNAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 19:14:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141213234730.GP22149@ZenIV.linux.org.uk>
References: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
	<CA+55aFzuRCJDWQcBBET6x1OHThLrtJmnn=hS40tE7hNXfmfm6g@mail.gmail.com>
	<20141213233508.GN22149@ZenIV.linux.org.uk>
	<CA+55aFw5pb7g+k1EOGj6t2xqibGGUBmZMuA_YAgtyejiv76omg@mail.gmail.com>
	<20141213234730.GP22149@ZenIV.linux.org.uk>
Date: Sat, 13 Dec 2014 16:14:58 -0800
X-Google-Sender-Auth: HVzTMdUhW3T8C40OLkYhQdAqEcQ
Message-ID: <CA+55aFxZWPP+wCDbwB-n=z5z_8isqdJ_4Ka6+P+KaBAY4ihw1Q@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 3:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> static inline void mnt_dec_writers(struct mount *mnt)
> {
> #ifdef CONFIG_SMP
>         this_cpu_dec(mnt->mnt_pcp->mnt_writers);
> #else
>         mnt->mnt_writers--;
> #endif
> }
> It's load/modify/store, without any kind of atomicity; get preempted in the
> middle of that sequence by another caller of mnt_dec_writers() and obvious bad
> things will happen...

Ugh, yes ok, the UP case needs it for the actual counter itself. Ugh.
What an ugly mess. I'd rather have the preemption disable where it is
actually *needed*, in that function itself for the UP case (or just
make it "atomic_t", which would likely be better still.

                     Linus
