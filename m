Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaGKBSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:18:09 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56139 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaGKBSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140709195650.GZ4603@linux.vnet.ibm.com>
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
 <20140709000701.GJ4603@linux.vnet.ibm.com> <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
 <20140709195650.GZ4603@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 10 Jul 2014 21:17:33 -0400
Message-ID: <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 3:56 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
<snip>
> OK, so ->dynticks_snap is accessed by only one task, namely the
> corresponding RCU grace-period kthread.  So it can be accessed without
> any atomic instructions or memory barriers, since all accesses to it are
> single-threaded.  On the other hand, ->dynticks is written by one CPU
> and potentially accessed from any CPU.  Therefore, accesses to it must
> take concurrency into account.  Especially given that any confusion can
> fool RCU into thinking that a CPU is idle when it really is not, which
> could result in too-short grace periods, which could in turn result in
> random memory corruption.
>

Yes, I missed reading the call-chain for accessing dynticks_snap. It
does not need any synchronization/barriers.

Here since we are reading ->dynticks, doesn't having one barrier
before reading make sense? like

smp_mb();
dynticks_snap = atomic_read(...->dynticks);

instead of having two barriers with atomic_add_return()? i.e.,
why is the second barrier necessary?

On a related note, I see that dynticks is a per-cpu variable _and_
atomic. Is there such a need for that?

Digging into history I see that the change to an atomic variable was
made in the commit 23b5c8fa01b723c70a which says:

<quote>

In addition, the old dyntick-idle synchronization depended on the fact
that grace periods were many milliseconds in duration, so that it could
be assumed that no dyntick-idle CPU could reorder a memory reference
across an entire grace period.  Unfortunately for this design, the
addition of expedited grace periods breaks this assumption, which has
the unfortunate side-effect of requiring atomic operations in the
functions that track dyntick-idle state for RCU.

</quote>

Sorry to ask you about such an old change. But I am not able to see
why we need atomic_t for dynticks here since per-cpu operations are
guaranteed to be atomic.

It gets twisted pretty fast trying to understand the RCU code. No
wonder people say that rcu is scary black magic :)

-- 
Pranith
