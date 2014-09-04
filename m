Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaIDJKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:10:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39988 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaIDJKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:10:09 -0400
Message-ID: <54082C68.8030400@linux.vnet.ibm.com>
Date: Thu, 04 Sep 2014 14:40:00 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com> <53296AD0.5090908@linux.vnet.ibm.com>	<19131121.D211TBerqb@vostro.rjw.lan> <CAKohpom0+bbyffZML2tJjXQDc+2q4PM8sVkL5pDA5WX=rmvtKA@mail.gmail.com>
In-Reply-To: <CAKohpom0+bbyffZML2tJjXQDc+2q4PM8sVkL5pDA5WX=rmvtKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090409-0320-0000-0000-00000064A410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I went through the cpufreq code and the previous discussion in the
context of this patch and I propose the below patch. Please let me know
if it misses something that you all had discussed.

On 09/04/2014 11:38 AM, Viresh Kumar wrote:
> On 19 March 2014 19:49, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
>> That said, for the intel_pstate case ->stop() as proposed by Dirk is demonstrably
>> sufficient and there are no other ->setpolicy drivers in sight wanting or needing
>> anything else.
>>
>> So to me, (1) the new ->stop() should *only* be called for ->setpolicy drivers,
>> because the purpose of it should be to "allow ->setpolicy drivers to do what the
>> GOV_STOP will do for regular drivers" as you put it above, and (2) some code in
>> the original intel_pstate's ->exit() may/should stay in there (instead of being
>> moved to the new ->stop()), which is the only possibly remaining issue here.
>>
>> The whole discussion about possibly re-using ->stop() for ->target drivers goes
>> in a totally wrong direction, because *if* ->target drivers need a new callback
>> to be executed around where ->stop() is called for ->setpolicy drivers, *then*
>> that has to be a *different* callback.
>>
>> And by the way, ->get() in fact has a different meaning for ->setpolicy drivers,
>> so it would be good to consider logical separation of ->setpolicy and ->target
>> drivers so that each kind has its own separate set of callbacks with no overlaps.
>> That would make it easier to avoid breakage resulting from changes made with
>> ->setpolicy drivers that also affect ->target drivers in unpredictable ways and
>> the other way around.
> 
> Okay, I have picked up a very old thread but it looks more sensible to start
> replying here..
> 
> Preeti (Cc'd) wants to do something similar, i.e. reduce freq of a
> core before it
> goes down. And the driver is probably: drivers/cpufreq/powernv-cpufreq.c, which
> is ->target() type.
> 
> Now should we reuse the same callback ->stop_cpu() or implement a new one?
> I don't know if adding a new callback would be a good idea here..
> 
> --
> viresh
> 

cpufreq: Allow stop CPU callback to be used by all cpufreq drivers
    
Commit 367dc4aa introduced the stop CPU callback for intel_pstate
drivers. During the CPU_DOWN_PREPARE stage, this callback is invoked
so that drivers can take some action on the pstate of the cpu
before it is taken offline. This callback was assumed to be useful
only for those drivers which have implemented the set_policy CPU
callback because they have no other way to take action about the
cpufreq of a CPU which is being hotplugged out except in the exit
callback which is called very late in the offline process.
    
The drivers which implement the target/target_index callbacks were
expected to take care of requirements like the ones that commit
367dc4aa addresses in the GOV_STOP notification event. But there
are disadvantages to restricting the usage of stop CPU callback
to cpufreq drivers that implement the set_policy callbacks and who
want to take explicit action on the setting the cpufreq during a
hotplug operation.
   
1.GOV_STOP gets called for every CPU offline and drivers would usually
  want to take action when the last cpu in the policy->cpus mask
  is taken offline. As long as there is more than one cpu in the
  policy->cpus mask, cpufreq core itself makes sure that the freq
  for the other cpus in this mask is set according to the maximum load.
  This is sensible and drivers which implement the target_index callback
  would mostly not want to modify that. However the cpufreq core leaves a
  loose end when the cpu in the policy->cpus mask is the last one to go offline;
  it does nothing explicit to the frequency of the core. Drivers may need
  a way to take some action here and stop CPU callback mechanism is the
  best way to do it today.
    
2.We cannot implement driver specific actions in the GOV_STOP mechanism.
  So we will need another driver callback which is invoked from here which is
  unnecessary.
    
  Therefore this patch extends the usage of stop CPU callback to be used
  by all cpufreq drivers as long as they have this callback implemented
  and irrespective of whether they are set_policy/target_index drivers.
  The assumption is if the drivers find the GOV_STOP path to be a suitable
  way of implementing what they want to do with the freq of the cpu
  going offine,they will not implement the stop CPU callback at all.
    
  Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d9fdedd..6463f35 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1380,7 +1380,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
                if (!cpufreq_suspended)
                        pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
                                 __func__, new_cpu, cpu);
-       } else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
+       } else if (cpufreq_driver->stop_cpu) {
                cpufreq_driver->stop_cpu(policy);
        }


