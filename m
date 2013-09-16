Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab3IPSXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:23:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39080 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3IPSXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:23:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cpufreq: unlock correct rwsem while updating policy->cpu
Date: Mon, 16 Sep 2013 20:34:46 +0200
Message-ID: <7384008.XcFgntkLDk@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpomEQsS-WHQpa=_07NQ1FXDB711inrmMgUguD529BA7g1A@mail.gmail.com>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org> <1379348823.3422.42.camel@linaro1.home> <CAKohpomEQsS-WHQpa=_07NQ1FXDB711inrmMgUguD529BA7g1A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 16, 2013 10:38:05 PM Viresh Kumar wrote:
> On 16 September 2013 21:57, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> > If I take mainline code and just change the line above to:
> 
> You meant this line by above line?
> 
>          unlock_policy_rwsem_write(cpu);
> 
> >    up_write(&per_cpu(cpu_policy_rwsem, (per_cpu(cpufreq_cpu_data,
> > cpu))->last_cpu));
> > then the big_little cpufreq driver works for me.
> 
> That would be same as: up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));
> 
> >> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >> index 43c24aa..c18bf7b 100644
> >> --- a/drivers/cpufreq/cpufreq.c
> >> +++ b/drivers/cpufreq/cpufreq.c
> >> @@ -952,9 +952,16 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> >>       if (cpu == policy->cpu)
> >>               return;
> >>
> >> +     /* take direct locks as lock_policy_rwsem_write wouldn't work here */
> >> +     down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> >> +     down_write(&per_cpu(cpu_policy_rwsem, cpu));
> >> +
> >>       policy->last_cpu = policy->cpu;
> >>       policy->cpu = cpu;
> >>
> >> +     up_write(&per_cpu(cpu_policy_rwsem, cpu));
> >> +     up_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> >
> > You've just overwritten policy->cpu with cpu.
> 
> Stupid enough :)
> 
> > I tried using
> > policy->last_cpu to fix that, but it still doesn't work for me (giving
> > the lockdep warning I mentioned.) If I change the code to just lock the
> > original policy->cpu lock only, then all is fine.
> 
> Fixed my patch now.. find attached..

Care to resend with a subject indicating that that's a patch update?

Like [PATCH v2] etc. or similar?

Rafael

