Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaAUW3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:29:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44989 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaAUW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:29:34 -0500
Message-ID: <52DEF495.2020304@oracle.com>
Date: Tue, 21 Jan 2014 17:28:37 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
References: <20131212140835.729222186@infradead.org> <20131212141655.362219382@infradead.org>
In-Reply-To: <20131212141655.362219382@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 09:08 AM, Peter Zijlstra wrote:
> In order to avoid the runtime condition and variable load turn
> sched_clock_stable into a static_key.
>
> Also provide a shorter implementation of local_clock() and
> cpu_clock(int) when sched_clock_stable==1.
>
>                          MAINLINE   PRE       POST
>
>      sched_clock_stable: 1          1         1
>      (cold) sched_clock: 329841     221876    215295
>      (cold) local_clock: 301773     234692    220773
>      (warm) sched_clock: 38375      25602     25659
>      (warm) local_clock: 100371     33265     27242
>      (warm) rdtsc:       27340      24214     24208
>      sched_clock_stable: 0          0         0
>      (cold) sched_clock: 382634     235941    237019
>      (cold) local_clock: 396890     297017    294819
>      (warm) sched_clock: 38194      25233     25609
>      (warm) local_clock: 143452     71234     71232
>      (warm) rdtsc:       27345      24245     24243
>
> Signed-off-by: Peter Zijlstra<peterz@infradead.org>

Hi Peter,

This patch seems to be causing an issue with booting a KVM guest. It seems that it
causes the time to go random during early boot process:

	[    0.000000] Initmem setup node 30 [mem 0x12ee000000-0x138dffffff]
	[    0.000000]   NODE_DATA [mem 0xcfa42000-0xcfa72fff]
	[    0.000000]     NODE_DATA(30) on node 1
	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
	[    0.000000]     NODE_DATA(31) on node 1
	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
	[133538.294040] Zone ranges:
	[133538.294338]   DMA      [mem 0x00001000-0x00ffffff]
	[133538.294804]   DMA32    [mem 0x01000000-0xffffffff]
	[133538.295223]   Normal   [mem 0x100000000-0x142fffffff]
	[133538.295670] Movable zone start for each node

Looking at the code, initially I though that the problem is with:

	+void set_sched_clock_stable(void)
	+{
	+       if (!sched_clock_stable())
	+               static_key_slow_dec(&__sched_clock_stable);
	+}
	+
	+void clear_sched_clock_stable(void)
	+{
	+       /* XXX worry about clock continuity */
	+       if (sched_clock_stable())
	+               static_key_slow_inc(&__sched_clock_stable);
	+}

I think the jump label inc/dec is reversed here. We would want to inc it when enabling
and dec when disabling, no?
However, trying to reverse the two didn't help. I was still seeing the same odd behaviour.

I tried doing a simple conversion to using a simple var like before, which looks like this:

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 6bd6a67..a035932 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -76,26 +76,21 @@ EXPORT_SYMBOL_GPL(sched_clock);
  __read_mostly int sched_clock_running;

  #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
+static int __sched_clock_stable;

  int sched_clock_stable(void)
  {
-       if (static_key_false(&__sched_clock_stable))
-               return false;
-       return true;
+       return __sched_clock_stable;
  }

  void set_sched_clock_stable(void)
  {
-       if (!sched_clock_stable())
-               static_key_slow_dec(&__sched_clock_stable);
+       __sched_clock_stable = 1;
  }

  static void __clear_sched_clock_stable(struct work_struct *work)
  {
-       /* XXX worry about clock continuity */
-       if (sched_clock_stable())
-               static_key_slow_inc(&__sched_clock_stable);
+       __sched_clock_stable = 0;
  }

  static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
@@ -340,7 +335,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
   */
  u64 cpu_clock(int cpu)
  {
-       if (static_key_false(&__sched_clock_stable))
+       if (!sched_clock_stable())
                 return sched_clock_cpu(cpu);

         return sched_clock();
@@ -355,7 +350,7 @@ u64 cpu_clock(int cpu)
   */
  u64 local_clock(void)
  {
-       if (static_key_false(&__sched_clock_stable))
+       if (!sched_clock_stable())
                 return sched_clock_cpu(raw_smp_processor_id());

         return sched_clock();


This has corrected the issue:

	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
	[    0.000000]     NODE_DATA(31) on node 1
	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
	[    0.000000] Zone ranges:
	[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
	[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
	[    0.000000]   Normal   [mem 0x100000000-0x142fffffff]
	[    0.000000] Movable zone start for each node
	[    0.000000] Early memory node ranges
		[ timing is correct for the rest of the boot]

At this point, I thought that there's something up with jump labels being used this early (?) and
tried compiling with CONFIG_JUMP_LABELS=n, this didn't solve the issue.

This makes me thing there's something different related to jumplabels we're missing, as the
no-jumplabel config should be very similar to the patch I did above, I just can't figure
out what it is.


Thanks,
Sasha
