Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaHNNeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:34:21 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:56942 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaHNNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <53EC176D.6080201@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com>
	<20140812191218.GA15210@redhat.com>
	<53EA94DD.5040900@redhat.com>
	<20140813172230.GA6296@redhat.com>
	<20140813133526.1eb5526f@cuia.bos.redhat.com>
	<20140813180807.GA8098@redhat.com>
	<53EBADB1.2020403@redhat.com>
	<20140813184511.GA9663@redhat.com>
	<20140813170324.544aaf2d@cuia.bos.redhat.com>
	<20140814004318.GA2582@lerouge>
	<53EC176D.6080201@redhat.com>
Date: Thu, 14 Aug 2014 15:34:18 +0200
Message-ID: <CAFTL4hwfNyQPMfpca-=Ou7WoPjB6sE_7BVAcQrVDkBjjPVmPRw@mail.gmail.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with seqlock
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-14 3:57 GMT+02:00 Rik van Riel <riel@redhat.com>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 08/13/2014 08:43 PM, Frederic Weisbecker wrote:
>> On Wed, Aug 13, 2014 at 05:03:24PM -0400, Rik van Riel wrote:
>>> --- a/kernel/time/posix-cpu-timers.c +++
>>> b/kernel/time/posix-cpu-timers.c @@ -272,22 +272,8 @@ static int
>>> posix_cpu_clock_get_task(struct task_struct *tsk, if
>>> (same_thread_group(tsk, current)) err =
>>> cpu_clock_sample(which_clock, tsk, &rtn); } else { -         unsigned
>>> long flags; -                struct sighand_struct *sighand; - -             /* -             *
>>> while_each_thread() is not yet entirely RCU safe, -           * keep
>>> locking the group while sampling process -            * clock for now. -
>>> */ -         sighand = lock_task_sighand(tsk, &flags); -             if (!sighand)
>>> -                    return err; - if (tsk == current ||
>>> thread_group_leader(tsk)) err =
>>> cpu_clock_sample_group(which_clock, tsk, &rtn); - -
>>> unlock_task_sighand(tsk, &flags); }
>>
>> I'm worried about such lockless solution based on RCU or read
>> seqcount because we lose the guarantee that an update is
>> immediately visible by all subsequent readers.
>>
>> Say CPU 0 updates the thread time and both CPU 1 and CPU 2 right
>> after that call clock_gettime(), with the spinlock we were
>> guaranteed to see the new update. Now with a pure seqlock read
>> approach, we guarantee a read sequence coherency but we don't
>> guarantee the freshest update result.
>>
>> So that looks like a source of non monotonic results.
>
> Which update are you worried about, specifically?
>
> The seq_write_lock to update the usage stat in p->signal will lock out
> the seqlock read side used to check those results.
>
> Is there another kind of thing read by cpu_clock_sample_group that you
> believe is not excluded by the seq_lock?

I mean the read side doesn't use a lock with seqlocks. It's only made
of barriers and sequence numbers to ensure the reader doesn't read
some half-complete update. But other than that it can as well see the
update n - 1 since barriers don't enforce latest results.
