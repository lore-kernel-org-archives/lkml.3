Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaDDRDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:03:06 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52455 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaDDRDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:03:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140404160328.GA10042@localhost.localdomain>
References: <5338CC86.9080602@jp.fujitsu.com> <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com> <20140404160328.GA10042@localhost.localdomain>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 4 Apr 2014 19:02:43 +0200
Message-ID: <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 6:03 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> However, if we would put ourselves into admin's seat, iowait
>> immediately starts to make sense: for admin, the system state
>> where a lot of CPU time is genuinely idle is qualitatively different
>> form the state where a lot of CPU time is "idle" because
>> we are I/O bound.
>>
>> Admins probably wouldn't insist that iowait accounting must be
>> very accurate. I would hazard to guess that admins would settle
>> for the following rules:
>
> Iowait makes sense but not per cpu. Eventually it's a global
> stat. Or per task.

There a lot of situations where admins want to know
how much, on average, their CPUs are idle because
they wait for IO.

If you are running, say, a Web cache,
you need to know that stat in order to be able to
conjecture "looks like I'm IO bound, perhaps caching
some data in RAM will speed it up".

Global stat will give such data to admin. Per-task won't -
there can be an efficient Web cache design which uses
many parallel tasks to hide IO latency. Thus, such
Web cache can be nearly optimal despite its tasks,
individually, having significant iowait counts each.

> I've sratched my head a lot on this. And I think we can't continue
> with the current semantics. If we had to keep the current semantics
> and enforce correctness at the same time, we are going to run into
> big scalability and performance issues. This can't be done without
> locking updates to nr_iowait() with seqlock:
>
> * when a task blocks on IO and goes idle, lock some per cpu iowait_seq,
> increase nr_iowait, save curr CPU number, save time.
>
> * when a task io completes and it gets enqueued on another CPU: retrieve
> old CPU, lock its iowait_seq, decrease nr_iowait, flush delta iowait .
>
> And all that just to maintain stats which semantics are wrong, this
> would be pure madness.
>
> OTOH we must stay compatible with user ABI in /proc/stat (the one in /proc/timers_list
> matters less).  But if we make it a per task stat, we are free to account it
> on the CPU we want.
>
> So what we can do for example is to account it per task and update stats
> on the CPU where the blocking task wakes up. This way we guarantee
> that we only account locally, which is good for scalability.

When IO-bound task wakes on some CPU,
how exactly do you propose to update counters -
add total waited time of this task to this CPU's counter?

Is such counter meaningful for the admin?

> This is going to be an ABI change on a /proc/stat field semantic.
> We usually can not do that as it can break userspace. But I think
> we have a reasonable exception here:
>
> 1) On a performance POV we don't have the choice.
>
> 2) It has always been a buggy stat on SMP. Given the possible fast iowait update
> rate, I doubt it has ever dumped correct stats. So I guess that few user apps
> have ever correctly relied on it.

In busybox project, the following tools use iowait counter:

top,mpstat: in order to show "%iowait"

nmeter: to show "waiting for disk" part of CPU bar.
Example:
$ nmeter '%t %70c'
18:57:33 SUU...................................................................
18:57:34 SUUUUUUUUUUI..........................................................
18:57:35 SUUUII................................................................
18:57:36 SUUU..................................................................
18:57:37 SSUDDD................................................................
  (^^^^^^ IO-intensive task starts)
18:57:38 SSSSSSUDDDDDDDDDDDDIi.................................................
18:57:39 SSSSSSSSUDDDDDDDDDi...................................................
18:57:40 SSSSSUUDDDDDDDDDDDDi..................................................
18:57:41 SSSSSUUUUUDDDDDDDDDDDDi...............................................
18:57:42 SSSSSUDDDDDDDDDDDDDIi.................................................
18:57:43 SSSUUDDDDDDDi.........................................................
  (^^^^^^ IO-intensive task ends)
18:57:44 SUUUI.................................................................
18:57:45 SUUU..................................................................
18:57:46 UU....................................................................
18:57:47 U.....................................................................

This doesn't look bogus to me.
It does give me information I need to know.

> Also it decouples iowait from idle time. Running time is also accounted
> as iowait.

The time when CPUs are busy while there is IO-wait
are usually not a sign of badly tuned software/system.

Only when CPUs are idle and there is IO-wait is.

That's how it looks from userspace.
