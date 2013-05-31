Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3EaFD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:03:27 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45745 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3EaFDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:03:20 -0400
Date: Fri, 31 May 2013 14:03:16 +0900
From: Tejun Heo <tj@kernel.org>
To: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: race condition in schedule_on_each_cpu()
Message-ID: <20130531050316.GC7720@mtj.dyndns.org>
References: <51A7FFE8.6060204@kylinos.com.cn>
 <20130531023246.GD30479@mtj.dyndns.org>
 <51A821F3.1000605@kylinos.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A821F3.1000605@kylinos.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 12:07:15PM +0800, weiqi@kylinos.com.cn wrote:
> 
> >the only way for them to get stuck is if there aren't enough execution
> >resources (ie. if a new thread can't be created) but OOM killers would
> >have been activated if that were the case.
> 
> The following is a detailed description of our scenerio:
> 
> 1.  after turnning off the the disk array, the ps results is shown
> in *ps*, which indicates the kworker/1:0 kworker/1:2 are stuck
> 
> 2.  the call stack for the kworkers are shown in *stack_xxx.txt*
> 
> 3.  the workqueue operations during that period is shown in
> *out.txt*, use ftrace
> (we added a new trace point /workqueue_queue_work_insert/,
> immediately before insert_wq_barrier, in the function
> start_flush_work. its implementation is shown in
> *trace_insert_wq_barrier.txt*)
>        from the results int *grep_kwork1:0_from_out.txt*, we can see:
>               kworker/1:0 is stuck after start work
> /fc_starget_delete/ at time 360.801271,  and  catch the
> insert_wq_barrier trace_info behind this
> 
> 
> 4.  from out.txt , we can see, there are altogether three
> /fc_starget_delete/ work enqueued.
>       atfer the point of deadlock, kworker/1:1 and kworker/1:3 is
> executing ...
> 
> 
> 5.  if we let the scsi_transport_fc uses only one worker thread,
> i.e.,  change scsi_transport_fc.c : fc_host_setup()
>               alloc_workqueue(fc_host->work_q_name, 0, 0) to
>                      alloc_workqueue(fc_host->work_q_name, WQ_UNBOUND, 1)
> 
>               alloc_workqueue(fc_host->devloss_work_q_name, 0, 0) to
> alloc_workqueue(fc_host->devloss_work_q_name, WQ_UNBOUND, 1)
> 
>      the deadlock won't occur.
> >Can you please test a recent kernel?  How easily can you reproduce the
> >issue?
> >
> it's occured every time when hot remove disk array.
> 
> I'll test recent kernel after a while , but  this problem in 3.0.30
> really confused me

Yeah, it definitely sounds like concurrency depletion.  There have
been some fixes and substantial changes in the area, so I really wanna
find out whether the problem is reproducible in recent vanilla kernel
- say, v3.9 or, even better, v3.10-rc2.  Can you please try to
reproduce the problem with a newer kernel?

> by the way, I'm wondering about  what's the race condition before
> which  doesn't exist now

Before the commit you originally quoted, the calling thread could be
preempted and migrated to another CPU before get_online_cpus() thus
ending up executing the function twice on the new cpu but skipping the
old one.

Thanks.

-- 
tejun
