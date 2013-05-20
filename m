Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3ETOQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:16:50 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:57770 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3ETOQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:16:48 -0400
Message-ID: <519A304B.1040805@intel.com>
Date: Mon, 20 May 2013 07:16:43 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tommy Apel <tommyapeldk@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: kernel 3.10-rc1 p-state/cpuidle panic
References: <1368962741.30275.17.camel@workstation-home> <20130520050837.GA12848@pd.tnic> <CAGA4a+FExrde7ceDZRMWCxe7YgQ5EmYBJ1gmapuYOF2CrJHuRw@mail.gmail.com> <20130520121356.GE12690@pd.tnic> <CAGA4a+HJ3EUoWYCtqvQ3p46zTFH+i97ucPGU82Uz+N=qqdEt8g@mail.gmail.com>
In-Reply-To: <CAGA4a+HJ3EUoWYCtqvQ3p46zTFH+i97ucPGU82Uz+N=qqdEt8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 06:55 AM, Tommy Apel wrote:
> Well it beats me why it breaks on a dual but not a single cpu system,
> or maybe I just havn't hit something yet.
>
> 2013/5/20 Borislav Petkov <bp@alien8.de>:
>> On Mon, May 20, 2013 at 12:02:53PM +0200, Tommy Apel wrote:
>>> I think it's worth mentioning that this happens on a dual cpu system,
>>> I'm running the exact same kernel on a Xeon E3
>>> and has not had this problem.
>>>
>>> I also changed back to the regular dyntick and after that the dual cpu
>>> system has been stabil.
>>
>> True story - NO_HZ_FULL=y. Although I can't see the connection between
>> the issue and NO_HZ_FULL.
>>
>> Adding Frederic and leaving in the rest for reference.
>>
>>> On May 20, 2013 7:08 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>>>>
>>>> Hmm,
>>>>
>>>> divide by 0, it seems.
>>>>
>>>> + Dirk Brandewie.
>>>>
>>>> On Sun, May 19, 2013 at 01:25:41PM +0200, Tommy Apel Hansen wrote:
>>>>> Hello guys, I'm getting this with the current 3.10-rc1, I've enabled the new full-NOHZ
>>>>> I'm not sure though if that has something to do with this or if something is changed in the
>>>>> p-state code

The following patch removes the offending division since it was not needed
anway. This is queued for rc-2.

commit ca7bb07c8fa8d982971d4775bef48d0bc3c6e1cf
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Fri May 17 07:19:58 2013 -0700

     cpufreq/intel_pstate: remove idle time and duration from sample and 
calculations

     Idle time is taken into account in the APERF/MPERF ratio calculation
     there is no reason for the driver to track it seperately.  This
     reduces the work in the driver and makes the code more readable.

     Removal of the tracking of sample duration removes the possibility of
     the divide by zero exception when the duration is sub 1us

     https://bugzilla.kernel.org/show_bug.cgi?id=56691

     Reported-by: Mike Lothian <mike@fireburn.co.uk>
     Cc: stable@vger.kernel.org
     Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
  drivers/cpufreq/intel_pstate.c |   45 +++++++--------------------------------
  1 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index cc3a8e6..c6e10d0 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -48,12 +48,7 @@ static inline int32_t div_fp(int32_t x, int32_t y)
  }

  struct sample {
-	ktime_t start_time;
-	ktime_t end_time;
  	int core_pct_busy;
-	int pstate_pct_busy;
-	u64 duration_us;
-	u64 idletime_us;
  	u64 aperf;
  	u64 mperf;
  	int freq;
@@ -91,8 +86,6 @@ struct cpudata {
  	int min_pstate_count;
  	int idle_mode;

-	ktime_t prev_sample;
-	u64	prev_idle_time_us;
  	u64	prev_aperf;
  	u64	prev_mperf;
  	int	sample_ptr;
@@ -450,48 +443,26 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
  					struct sample *sample)
  {
  	u64 core_pct;
-	sample->pstate_pct_busy = 100 - div64_u64(
-					sample->idletime_us * 100,
-					sample->duration_us);
  	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
  	sample->freq = cpu->pstate.max_pstate * core_pct * 1000;

-	sample->core_pct_busy = div_s64((sample->pstate_pct_busy * core_pct),
-					100);
+	sample->core_pct_busy = core_pct;
  }

  static inline void intel_pstate_sample(struct cpudata *cpu)
  {
-	ktime_t now;
-	u64 idle_time_us;
  	u64 aperf, mperf;

-	now = ktime_get();
-	idle_time_us = get_cpu_idle_time_us(cpu->cpu, NULL);
-
  	rdmsrl(MSR_IA32_APERF, aperf);
  	rdmsrl(MSR_IA32_MPERF, mperf);
-	/* for the first sample, don't actually record a sample, just
-	 * set the baseline */
-	if (cpu->prev_idle_time_us > 0) {
-		cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
-		cpu->samples[cpu->sample_ptr].start_time = cpu->prev_sample;
-		cpu->samples[cpu->sample_ptr].end_time = now;
-		cpu->samples[cpu->sample_ptr].duration_us =
-			ktime_us_delta(now, cpu->prev_sample);
-		cpu->samples[cpu->sample_ptr].idletime_us =
-			idle_time_us - cpu->prev_idle_time_us;
-
-		cpu->samples[cpu->sample_ptr].aperf = aperf;
-		cpu->samples[cpu->sample_ptr].mperf = mperf;
-		cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
-		cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
-
-		intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
-	}
+	cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
+	cpu->samples[cpu->sample_ptr].aperf = aperf;
+	cpu->samples[cpu->sample_ptr].mperf = mperf;
+	cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
+	cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
+
+	intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);

-	cpu->prev_sample = now;
-	cpu->prev_idle_time_us = idle_time_us;
  	cpu->prev_aperf = aperf;
  	cpu->prev_mperf = mperf;
  }



