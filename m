Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbaLAXZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:25:06 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33818 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbaLAXZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:25:02 -0500
MIME-Version: 1.0
In-Reply-To: <20141201230339.GA20487@ret.masoncoding.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
Date: Mon, 1 Dec 2014 15:25:01 -0800
X-Google-Sender-Auth: I7qUohFu7ZIRhsI9HfZx55TkMdg
Message-ID: <CA+55aFxOKsK-E438QEOd5Tq2dUZjO8sOnQtpTtPmpBKngmgpkg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 3:08 PM, Chris Mason <clm@fb.com> wrote:
> I'm not sure if this is related, but running trinity here, I noticed it
> was stuck at 100% system time on every CPU.  perf report tells me we are
> spending all of our time in spin_lock under the sync system call.
>
> I think it's coming from contention in the bdi_queue_work() call from
> inside sync_inodes_sb, which is spin_lock_bh().

Please do a perf run with -g to get the call chain to make sure..

> I wonder if we're just spinning so hard on this one bh lock that we're
> starving the watchdog?

If it was that simple, we should see it in the actual soft-lockup stack trace.

That said, looking at the bdi_queue_work() function, I don't think you
should see any real contention there, although:

 - spin-lock debugging can make any bad situation about 10x worse by
making the spinlocks just that much more horrible from a performance
standpoint

 - the whole "complete(work->done)" thing seems to be pointlessly done
inside the spinlock, and that just seems horrible. Do you have a ton
of BDI's that might fail that BDI_registered thing?

 - even the "mod_delayed_work()" is dubious wrt the wb_lock. From what
I can tell, the spinlock is supposed to just protect the list.

So I think that bdi_queue_work() quite possibly is horribly broken
crap and *if* it really is contention on wb_lock, we could rewrite it
to not be so bad locking-wise.

That said, contention that happens with spinlock debugging enabled
really tends to fall under the heading of "that's your own fault".

                     Linus
