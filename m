Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab3BSKaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:30:00 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:38911 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab3BSK36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hxxWBfi5Ad+X27ouFDFBM-LttRJiEn3f83T1Q2z=v1k7g@mail.gmail.com>
References: <1359455940-1710-1-git-send-email-vincent.guittot@linaro.org>
	<1359455940-1710-2-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hzboD8Mv_-pRDHc+39QwXGWiT3MGtL8gJ=_ajnHdDCBcA@mail.gmail.com>
	<CAKfTPtD2jRke2CUXiJdmaYYki_Voi4eTqJKgsyTnRpna7p8mJg@mail.gmail.com>
	<CAFTL4hzriJm1mK1A_9U5kX9Z0RCMGpxy8M3gKuzFtt9Bky5htQ@mail.gmail.com>
	<CAKfTPtCWudftS2XSM1OC2sR050mYvcAU6Fkt0vjV=C2V+w84Ew@mail.gmail.com>
	<CAFTL4hzu-7uAXLqP+J48DaqLUYQWTESMNwPMYiiwrU2ZoOsgqw@mail.gmail.com>
	<CAFTL4hyR=_ftCxycyvCBR0xwj6aOix9op40ps7htogpkkqVz+A@mail.gmail.com>
	<CAKfTPtC3c50yo8AcQ7K9m73gP95dEsetjbhNXDN4RiR-nZ8UqA@mail.gmail.com>
	<CAFTL4hxxWBfi5Ad+X27ouFDFBM-LttRJiEn3f83T1Q2z=v1k7g@mail.gmail.com>
Date: Tue, 19 Feb 2013 11:29:56 +0100
Message-ID: <CAKfTPtCCS2ACCco-eQUtKO4ZF4ybBMCEmOzFKMThZTE=Cw19Ng@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, Mike Galbraith <efault@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2013 16:40, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/2/18 Vincent Guittot <vincent.guittot@linaro.org>:
>> On 18 February 2013 15:38, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> I pasted the original at: http://pastebin.com/DMm5U8J8
>>
>> We can clear the idle flag only in the nohz_kick_needed which will not
>> be called if the sched_domain is NULL so the sequence will be
>>
>> = CPU 0 =                                            = CPU 1=
>>
>> detach_and_destroy_domain {
>>             rcu_assign_pointer(cpu1_dom, NULL);
>> }
>>
>> dom = new_domain(...) {
>>              nr_cpus_busy = 0;
>>              set_idle(CPU 1);
>> }
>>                                                     dom =
>> rcu_dereference(cpu1_dom)
>>                                                     //dom == NULL, return
>>
>> rcu_assign_pointer(cpu1_dom, dom);
>>
>>                                                     dom =
>> rcu_dereference(cpu1_dom)
>>                                                     //dom != NULL,
>>                                                     nohz_kick_needed {
>>
>> set_idle(CPU 1)
>>                                                                    dom
>> = rcu_dereference(cpu1_dom)
>>
>> //dec nr_cpus_busy,
>>                                                     }
>>
>> Vincent
>
> Ok but CPU 0 can assign NULL to the domain of cpu1 while CPU 1 is
> already in the middle of nohz_kick_needed().

Yes nothing prevents the sequence below to occur

= CPU 0 =                                            = CPU 1=
                                                    dom =
rcu_dereference(cpu1_dom)
                                                    //dom != NULL
detach_and_destroy_domain {
            rcu_assign_pointer(cpu1_dom, NULL);
}

dom = new_domain(...) {
             nr_cpus_busy = 0;
             //nr_cpus_busy in the new_dom
             set_idle(CPU 1);
}
                                                    nohz_kick_needed {
                                                             clear_idle(CPU 1)
                                                             dom =
rcu_dereference(cpu1_dom)

//cpu1_dom == old_dom
                                                             inc nr_cpus_busy,

//nr_cpus_busy in the old_dom
                                                    }

rcu_assign_pointer(cpu1_dom, dom);
//cpu1_dom == new_dom

I'm not sure that this can happen in practice because CPU1 is in
interrupt handler but we don't have any mechanism to prevent the
sequence.

The NULL sched_domain can be used to detect this situation and the
set_cpu_sd_state_busy function can be modified like below

inline void set_cpu_sd_state_busy
 {
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
+	int clear = 0;

 	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
 		return;
-	clear_bit(NOHZ_IDLE, nohz_flags(cpu));

 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+		clear = 1;
 	}
 	rcu_read_unlock();
+
+	if (likely(clear))
+		clear_bit(NOHZ_IDLE, nohz_flags(cpu));
 }

The NOHZ_IDLE flag will not be clear if we have a NULL sched_domain
attached to the CPU.
With this implementation, we still don't need to get the sched_domain
for testing the NOHZ_IDLE flag which occurs each time CPU becomes idle

The patch 2 become useless

Vincent
