Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaEUV7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:59:34 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34665 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaEUV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <537CFECF.9070701@ccur.com>
References: <537CFECF.9070701@ccur.com>
Date: Wed, 21 May 2014 14:59:30 -0700
Message-ID: <CANGgnMYCFVQ7aR2Qjo+c5B=Jyi3QfyhAHd6y3imSN_7a3Y4Ekg@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Austin Schuh <austin@peloton-tech.com>
To: John Blackwood <john.blackwood@ccur.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, xfs <xfs@oss.sgi.com>,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 12:30 PM, John Blackwood
<john.blackwood@ccur.com> wrote:
>> Date: Wed, 21 May 2014 03:33:49 -0400
>> From: Richard Weinberger <richard.weinberger@gmail.com>
>> To: Austin Schuh <austin@peloton-tech.com>
>> CC: LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, rt-users
>>       <linux-rt-users@vger.kernel.org>
>> Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
>
>>
>> CC'ing RT folks
>>
>> On Wed, May 21, 2014 at 8:23 AM, Austin Schuh <austin@peloton-tech.com>
>> wrote:
>> > > On Tue, May 13, 2014 at 7:29 PM, Austin Schuh
>> > > <austin@peloton-tech.com> wrote:
>> >> >> Hi,
>> >> >>
>> >> >> I am observing a filesystem lockup with XFS on a CONFIG_PREEMPT_RT
>> >> >> patched kernel.  I have currently only triggered it using dpkg.
>> >> >> Dave
>> >> >> Chinner on the XFS mailing list suggested that it was a rt-kernel
>> >> >> workqueue issue as opposed to a XFS problem after looking at the
>> >> >> kernel messages.
>> >> >>
>> >> >> The only modification to the kernel besides the RT patch is that I
>> >> >> have applied tglx's "genirq: Sanitize spurious interrupt detection
>> >> >> of
>> >> >> threaded irqs" patch.
>> > >
>> > > I upgraded to 3.14.3-rt4, and the problem still persists.
>> > >
>> > > I turned on event tracing and tracked it down further.  I'm able to
>> > > lock it up by scping a new kernel debian package to /tmp/ on the
>> > > machine.  scp is locking the inode, and then scheduling
>> > > xfs_bmapi_allocate_worker in the work queue.  The work then never gets
>> > > run.  The kworkers then lock up waiting for the inode lock.
>> > >
>> > > Here are the relevant events from the trace.  ffff8803e9f10288
>> > > (blk_delay_work) gets run later on in the trace, but ffff8803b4c158d0
>> > > (xfs_bmapi_allocate_worker) never does.  The kernel then warns about
>> > > blocked tasks 120 seconds later.
>
> Austin and Richard,
>
> I'm not 100% sure that the patch below will fix your problem, but we
> saw something that sounds pretty familiar to your issue involving the
> nvidia driver and the preempt-rt patch.  The nvidia driver uses the
> completion support to create their own driver's notion of an internally
> used semaphore.
>
> Some tasks were failing to ever wakeup from wait_for_completion() calls
> due to a race in the underlying do_wait_for_common() routine.

Hi John,

Thanks for the suggestion and patch.  The issue is that the work never
gets run, not that the work finishes but the waiter never gets woken.
I applied it anyways to see if it helps, but I still get the lockup.

Thanks,
    Austin
