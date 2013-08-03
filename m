Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab3HCHiB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 03:38:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52964 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3HCHiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 03:38:00 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable reprogramming in remove_hrtimer
From: ethan <ethan.kernel@gmail.com>
In-Reply-To: <20130730115905.GS3008@twins.programming.kicks-ass.net>
Date: Sat, 3 Aug 2013 15:37:46 +0800
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <145EA9B5-A40F-417E-93A9-DFABA54EA638@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com> <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de> <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com> <20130730093519.GP3008@twins.programming.kicks-ass.net> <CABawtvNVeHbe06tbuH6Khgp_5gYmRYtk=sz9U7oE8f_x+6yg1g@mail.gmail.com> <20130730115905.GS3008@twins.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter and tglx,
  Some other tough hacking and testing with result FYI,
With the default kernel 2.6.32-279.19.1.el6.x86_64 in CentOS 6.3 running on my ASUS 4 core Intel i5 server, almost got the best performance of 
tool http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c

[root@localhost ~]# time ./pipe-test-1m

real	0m7.704s
user	0m0.047s
sys	0m4.815s
[root@localhost ~]# time ./pipe-test-1m

real	0m8.000s
user	0m0.071s
sys	0m5.035s
[root@localhost ~]# time ./pipe-test-1m

real	0m7.386s
user	0m0.086s
sys	0m4.591s
[root@localhost ~]# time ./pipe-test-1m

real	0m7.919s
user	0m0.064s
sys	0m4.912s
[root@localhost ~]# time ./pipe-test-1m

real	0m7.949s
user	0m0.083s
sys	0m4.917s

[root@localhost ~]# time ./pipe-test-1m
rrr
real	0m7.913s
user	0m0.070s
sys	0m4.903s
[root@localhost ~]# time ./pipe-test-1m

real	0m7.953s
user	0m0.092s
sys	0m4.881s
[root@localhost ~]# time ./pipe-test-1m

real	0m8.059s
user	0m0.108s
sys	0m5.037s
[root@localhost ~]# 

Then compiled and boot stable 3.11.0-rc3 with default configuration, redid the same test. got very bad performance:
root@localhost ~]# uname -a
Linux localhost 3.11.0-rc3 #4 SMP Wed Jul 31 16:10:56 EDT 2013 x86_64 x86_64 x86_64 GNU/Linux


real	0m10.730s
user	0m0.245s
sys	0m6.596s
[root@localhost ~]# time ./pipe-test-1m

real	0m10.661s
user	0m0.218s
sys	0m6.520s
[root@localhost ~]# time ./pipe-test-1m

real	0m10.699s
user	0m0.233s
sys	0m6.534s
[root@localhost ~]# time ./pipe-test-1m

real	0m10.616s
user	0m0.191s
sys	0m6.505s
[root@localhost ~]# time ./pipe-test-1m

real	0m10.546s
user	0m0.214s
sys	0m6.441s

[root@localhost ~]# time ./pipe-test-1m

real	0m10.631s
user	0m0.204s
sys	0m6.509s

First 'tough' hacking is disable the reprogramming in _remove_hrtimer() within 3.11-rc3 code and redo the test.
much better.

root@localhost ~]# time ./pipe-test-1m

real	0m9.447s
user	0m0.227s
sys	0m5.900s
[root@localhost ~]# time ./pipe-test-1m

real	0m9.507s
user	0m0.226s
sys	0m5.922s
[root@localhost ~]# time ./pipe-test-1m

real	0m9.495s
user	0m0.228s
sys	0m5.916s
[root@localhost ~]# time ./pipe-test-1m

real	0m9.470s
user	0m0.229s
sys	0m5.938s
[root@localhost ~]# time ./pipe-test-1m

real	0m9.484s
user	0m0.269s
sys	0m5.875s
[root@localhost ~]# time ./pipe-test-1m

real	0m9.328s
user	0m0.242s
sys	0m5.767s

While I monitor the wake-up with powertop, got
Top causes for wakeups:
  98.5% (  inf)      <kernel IPI> : Rescheduling interrupts
   0.5% (  inf)         swapper/3 : hrtimer_start_range_ns (tick_sched_timer)
   0.3% (  inf)         swapper/2 : hrtimer_start_range_ns (tick_sched_timer)
   0.2% (  inf)         swapper/1 : hrtimer_start_range_ns (tick_sched_timer)
   0.2% (  inf)         swapper/0 : hrtimer_start_range_ns (tick_sched_timer)

So I did the second tough hacking, commented out the rescheduling IPI sending in following function and re-did the test.

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4137890..c27f04f 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -137,7 +137,7 @@ static inline void play_dead(void)
 
 static inline void smp_send_reschedule(int cpu)
 {
-       smp_ops.smp_send_reschedule(cpu);
+       /* smp_ops.smp_send_reschedule(cpu); */
 }

Got the performance as best as 2.6.32 kernel and the scheduling seems also OK.

root@localhost ~]# time ./pipe-test-1m

real    0m7.661s
user    0m0.179s
sys     0m4.880s
[root@localhost ~]# time ./pipe-test-1m

real    0m7.473s
user    0m0.189s
sys     0m4.782s
[root@localhost ~]# time ./pipe-test-1m

real    0m7.658s
user    0m0.195s
sys     0m4.899s
[root@localhost ~]# time ./pipe-test-1m

real    0m7.644s
user    0m0.194s
sys     0m4.941s
[root@localhost ~]# time ./pipe-test-1m

real    0m7.694s
user    0m0.189s
sys     0m4.925s
[root@localhost ~]# time ./pipe-test-1m

real    0m7.694s
user    0m0.197s
sys     0m4.915s
[root@localhost ~]# time ./pipe-test-1m

real    0m7.597s
user    0m0.190s
sys     0m4.886s

The the two processes of pipe-test-1m and its child seem could be balanced from cpu0 to cpu3 well,
#top   
f  J
14888 root      20   0   68    0 R 73.2  0.0   0:03.22 2 pip1m
14887 root      20   0  284  224 S 63.4  0.0   0:03.23 0 pip1m

And so the above tough hacking and test basicly show the No.1 expensive thing is the rescheduling IPI, and
the No.2 expensive thing is the extra hrtimer reprogramming/tick in Linux 3.11-rc3 code.
We need manage to do as less as possible rescheduling IPI and reprogramming to get better performance.
Does it(the tough hacking and the test) make sense ? and the result rational ?


Thanks,
Ethan



ÔÚ 2013-7-30£¬ÏÂÎç7:59£¬Peter Zijlstra <peterz@infradead.org> Ð´µÀ£º

> On Tue, Jul 30, 2013 at 07:44:03PM +0800, Ethan Zhao wrote:
>> Got it.
>> what tglx and you mean
>> 
>> 
>> So the expensive thing maybe not inside the schedule(), but could
>> outside the scheduler(), the more bigger forever loop.
>> 
>> This is one part of what I am facing.
> 
> Right, so it would be good if you could further diagnose the problem so
> we can come up with a solution that cures the problem while retaining
> the current 'desired' properties.
> 
> The patch you pinpointed caused a regression in that it would wake from
> NOHZ mode far too often. Could it be that the now longer idle sections
> cause your CPU to go into deeper idle modes and you're suffering from
> idle-exit latencies?

