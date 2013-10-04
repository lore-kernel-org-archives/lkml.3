Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3JDQAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3JDQAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:00:41 -0400
Date: Fri, 4 Oct 2013 11:56:42 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org
Subject: Re: [dm-devel] dm-writeboost testing
In-Reply-To: <524ECFC9.3000603@gmail.com>
Message-ID: <alpine.LRH.2.02.1310041113230.22029@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com> <524E27DD.2050809@gmail.com> <alpine.LRH.2.02.1310040923320.8473@file01.intranet.prod.int.rdu2.redhat.com> <524ECFC9.3000603@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Oct 2013, Akira Hayakawa wrote:

> Mikulas,
> 
> Thanks for your pointing out.
> 
> > The problem is that you are using workqueues the wrong way. You submit a 
> > work item to a workqueue and the work item is active until the device is 
> > unloaded.
> > 
> > If you submit a work item to a workqueue, it is required that the work 
> > item finishes in finite time. Otherwise, it may stall stall other tasks. 
> > The deadlock when I terminate Xserver is caused by this - the nvidia 
> > driver tries to flush system workqueue and it waits for all work items to 
> > terminate - but your work items don't terminate.
> > 
> > If you need a thread that runs for a long time, you should use 
> > kthread_create, not workqueues (see this 
> > http://people.redhat.com/~mpatocka/patches/kernel/dm-crypt-paralelizace/old-3/dm-crypt-encryption-threads.patch 
> > or this 
> > http://people.redhat.com/~mpatocka/patches/kernel/dm-crypt-paralelizace/old-3/dm-crypt-offload-writes-to-thread.patch 
> > as an example how to use kthreads).
> 
> But I see no reason why you recommend
> using a kthread for looping job
> instead of putting a looping work item
> into a single-threaded not-system workqueue.
>
> For me, they both seem to be working.

As I said, the system locks up when it tries to flush the system 
workqueue. This happens for example when terminating Xwindow with the 
nvidia binary driver, but it may happen in other parts of the kernel too. 
The fact that it works in your setup doesn't mean that it is correct.

> Is it documented that
> looping job should not be put into
> any type of workqueue?

It is general assumption when workqueues were created. Maybe it's not 
documented.

> You are only mentioning that
> putting a looping work item in system_wq
> is the wrong way since
> nvidia driver flush the workqueue.
> 
> Akira

Mikulas
