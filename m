Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaEAUoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:44:00 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:43700 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaEAUn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140501200858.GA27787@localhost.localdomain>
References: <1398970535-6880-1-git-send-email-eparis@redhat.com>
	<20140501191720.GA198341@redhat.com>
	<20140501200858.GA27787@localhost.localdomain>
Date: Thu, 1 May 2014 22:43:57 +0200
Message-ID: <CAFTL4hzEpRz+fnVRhjbhnfnP0+k4YxqKJtzLJJz2AF=xMUh-rg@mail.gmail.com>
Subject: Re: [PATCH] watchdog: print all locks on a softlock
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Ben Zhang <benzh@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-01 22:09 GMT+02:00 Frederic Weisbecker <fweisbec@gmail.com>:
> On Thu, May 01, 2014 at 03:17:20PM -0400, Don Zickus wrote:
>> On Thu, May 01, 2014 at 02:55:35PM -0400, Eric Paris wrote:
>> > If the CPU hits a softlockup this patch will also have it print the
>> > information about all locks being held on the system.  This might help
>> > determine if a lock is being held too long leading to this problem.
>>
>> I am not sure this helps you.  A softlockup is the result of pre-emption
>> disabled, ie the scheduler not being called after 60 seconds.  Holding a
>> lock does not disable pre-emption usually.  So I don't think this is going
>> to add anything.
>>
>> Are you trying to debug a hung task?  The the hung_task thread checks to
>> see if a task hasn't scheduled in 2 minutes or so.  That could be the
>> result of long lock (but that output already dumps the lockdep stuff).
>
> There may be some deadlocks that lockdep doesn't detect yet. 2 example:
>
> 1) spinlock <-> IPI dependency
>
>
>         CPU 0                                            CPU 1
>         --------------------------------------------------------
>         spin_lock_irq(A)
>         smp_send_function_single_async(CPU 1, func)
>                                                          //IPI
>                                                          func {
>                                                             spin_lock(1)
>                                                          }
>
> But this should be resolved with a virtual lock on the IPI functions.
> I should try that.

So actually this one above shouldn't be a problem because the _async
version doesn't wait for the IPI to complete. But the below still
looks possible.

>
> 2) rwlock <-> IPI
>
>         CPU 0                                            CPU 1
>         --------------------------------------------------------
>         read_lock(A)
>                                                          write_lock_irq(A)
>         smp_send_function_single(CPU 1, func)
>                                                          //IPI never happens
>
> This one is much trickier.
>
> Anyway those are the only scenario I know of but there may be more. When possible
> we want to extend lockdep to detect new scenarios of deadlock but we don't have the
> guarantee that it can detect everything.
>
> So, could be useful...
