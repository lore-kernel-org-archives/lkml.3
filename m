Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaAOBA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:00:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaAOBA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:00:58 -0500
Date: Tue, 14 Jan 2014 17:00:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com, davidlohr@hp.com,
        hpa@zytor.com, aswin@hp.com, scott.norton@hp.com
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after
 too many tries
Message-Id: <20140114170056.7e93f279e11c751acb15ae67@linux-foundation.org>
In-Reply-To: <1389745990-7069-4-git-send-email-jason.low2@hp.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	<1389745990-7069-4-git-send-email-jason.low2@hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 16:33:10 -0800 Jason Low <jason.low2@hp.com> wrote:

> When running workloads that have high contention in mutexes on an 8 socket
> machine, spinners would often spin for a long time with no lock owner.
> 
> One of the potential reasons for this is because a thread can be preempted
> after clearing lock->owner but before releasing the lock, or preempted after
> acquiring the mutex but before setting lock->owner. In those cases, the
> spinner cannot check if owner is not on_cpu because lock->owner is NULL.

That sounds like a very small window.  And your theory is that this
window is being hit sufficiently often to impact aggregate runtime
measurements, which sounds improbable to me?

> A solution that would address the preemption part of this problem would
> be to disable preemption between acquiring/releasing the mutex and
> setting/clearing the lock->owner. However, that will require adding overhead
> to the mutex fastpath.

preempt_disable() is cheap, and sometimes free.

Have you confirmed that the preempt_disable() approach actually fixes
the performance issues?  If it does then this would confirm your
"potential reason" hypothesis.  If it doesn't then we should be hunting
further for the explanation.

> The solution used in this patch is to limit the # of times thread can spin on
> lock->count when !owner.
> 
> The threshold used in this patch for each spinner was 128, which appeared to
> be a generous value, but any suggestions on another method to determine
> the threshold are welcomed.

It's a bit hacky, isn't it?  If your "owner got preempted in the
window" theory is correct then I guess this is reasonableish.  But if
!owner is occurring for other reasons then perhaps there are better
solutions.  
