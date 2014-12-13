Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaLMW7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 17:59:48 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:46436 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaLMW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 17:59:46 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
References: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
Date: Sat, 13 Dec 2014 14:59:43 -0800
X-Google-Sender-Auth: mSH09GJdrZOdcdzuHavmER5guKk
Message-ID: <CA+55aFydeGFQs+HZkqC1ecyh=MxOow-hw817e1q4DUrAX7uqWw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Side note: I think I've found a real potential lockup bug in
fs/namespace.c, but afaik it could only trigger with the RT patches.

I'm looking at what lxsetattr() does, since you had that
lxsetattr-only lockup. I doubt it's really related to lxsetattr(), but
whatever. The generic code does that mnt_want_write/mnt_drop_write
dance adound the call to setxattr, and that in turn does

        while (ACCESS_ONCE(mnt->mnt.mnt_flags) & MNT_WRITE_HOLD)
                cpu_relax();

with preemption explicitly disabled. It's waitingo for
mnt_make_readonly() to go away if it is racing with it.

But mnt_make_readonly() doesn't actually explicitly disable preemption
while it sets that MNT_WRITE_HOLD bit. Instead, it depends on
lock_mount_hash() to disable preemption for it. Which it does, because
it is a seq-writelock, which uses a spinlock, which will disable
preemption.

Except it won't with the RT patches, I guess. So it looks like you could have:\

 - mnt_make_readonly() sets that bit
 - gets preempted with the RT patches
 - we run mnt_want_write() on all CPU's, which disables preemption and
waits for the bit to be cleared
 - nothing happens.

This is clearly not what happens in your lockup, but it does seem to
be a potential issue for the RT kernel.

Added Al and Thomas to the cc, for fs/namespace.c and RT kernel
respectively. Maybe the RT patches already fix this, I didn't actually
check.

                     Linus
