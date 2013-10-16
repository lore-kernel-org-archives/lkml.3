Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab3JPACO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:02:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759918Ab3JPACK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:02:10 -0400
Date: Tue, 15 Oct 2013 20:01:45 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
cc: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, tj@kernel.org
Subject: Re: A review of dm-writeboost
In-Reply-To: <525BAB32.5050901@gmail.com>
Message-ID: <alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com> <52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Oct 2013, Akira Hayakawa wrote:

> Hi, DM Guys
> 
> I suppose I have finished the tasks to
> answer Mikulas's pointing outs.
> So, let me update the progress report.
> 
> The code is updated now on my Github repo.
> Checkout the develop branch to avail
> the latest source code.
> 
> Compilation Status
> ------------------
> First, compilation status.
> Mikulas's advised me to compile the module in
> 32 bit environment. and Yes, I did.
> With all these kernels listed below
> writeboost can compile without any error nor warning.
> 
> For 64 bit
> 3.2.36, 3.4.25, 3.5.7, 3.6.9, 3.7.5, 3.8.5, 3.9.8, 3.10.5, 3.11.4 and 3.12-rc1
> 
> For 32 bit
> 3.2.0-4-686-pae (Debian 7.1.0-i386)
> 
> 
> Block up on error
> -----------------
> The most annoying thing in this update
> is how to handle the I/O error.
> For memory allocation error,
> writeboost now makes use of mempool to avoid
> the problem Mikulas's said in his last comments
> but handling I/O error gracefully
> when the system is running is very difficult.
> 
> My answer is 
> all the daemon stop when I/O error (-EIO returned) happens
> in any part of this module.
> They waits on wait_queue (blockup_wait_queue)
> and reactivates when sysadmin turns `blockup` variable to 0
> through message interface.
> When `blockup` is 1, all the incoming I/O
> are returned as -EIO to the upper layer.
> RETRY macro is introduced
> which wraps doing I/O and
> retries I/O submission if the error is -ENOMEN but

I/Os shouldn't be returned with -ENOMEM. If they are, you can treat it as 
a hard error.

> turns blockup to 1 and sleeps if the error is -EIO.
> -EIO is more serious than -ENOMEM because
> it may destroy the storage for some accidental problem
> that we have no control in device-mapper layer
> (e.g. the storage controller went crazy).
> Blocking up the whole I/O is to minimize the
> probable damage.
> 
> But, XFS stalls ...
> -------------------
> For testing,
> I manually turns `blockup` to 1
> when compiling Ruby is in progress
> on XFS on a writeboost device.
> As soon as I do it,
> XFS starts to dump error message 
> like "metadata I/O error: ... ("xlog_iodone") error ..."
> and after few seconds it then starts to dump
> like "BUG: soft lockup -CPU#3 stuck for 22s!".
> The system stalls and doesn't accept the keyboard.
> 
> I think this behavior is caused by
> the device always returning -EIO after turning 
> the variable to 1.
> But why XFS goes stalling on I/O error?

Because it is bloated and buggy. We have bug 924301 for XFS crash on I/O 
error...

> It should just suspend and starts returning
> error to the upper layer as writeboost now does.
> As Mikulas said the I/O error is often
> due to connection failure that is usually recoverable.
> Stalling the kernel will need reboot 
> after recovering nevertheless writeboost
> can recover just by again turning `blockup` to 0.
> Any reason for this design or
> existing of a option to not stall XFS on I/O error?
> 
> Thanks,
> Akira

Blocking I/O until the admin turns a specific variable isn't too 
reliable.

Think of this case - your driver detects I/O error and blocks all I/Os. 
The admin tries to log in. The login process needs memory. To fulfill this 
memory need, the login process writes out some dirty pages. Those writes 
are blocked by your driver - in the result, the admin is not able to log 
in and flip the switch to unblock I/Os.

Blocking I/O indefinitely isn't good because any system activity 
(including typing commands into shell) may wait on this I/O.

Mikulas
