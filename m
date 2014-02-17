Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaBQVsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:48:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62716 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751100AbaBQVsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:48:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Pierre Ossman <pierre-list@ossman.eu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, powernow-k8: Initialize per-cpu data-structures properly
Date: Mon, 17 Feb 2014 23:02:50 +0100
Message-ID: <1851033.kRQPL2X90T@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpo=nYQpZFh5=2g=REDyf-LKaMqJvnZ=pSncawLFpr1K_+Q@mail.gmail.com>
References: <20140217104821.21147.71463.stgit@srivatsabhat.in.ibm.com> <CAKohpo=nYQpZFh5=2g=REDyf-LKaMqJvnZ=pSncawLFpr1K_+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 04:35:08 PM Viresh Kumar wrote:
> On 17 February 2014 16:18, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > The powernow-k8 driver maintains a per-cpu data-structure called powernow_data
> > that is used to perform the frequency transitions. It initializes this data-
> > structure only for the policy->cpu. So, accesses to this data-structure by
> > other CPUs results in various problems because they would have been
> > uninitialized.
> >
> > Specifically, if a cpu (!= policy->cpu) invokes the drivers' ->get() function,
> > it returns 0 as the KHz value, since its per-cpu memory doesn't point to
> > anything valid. This causes problems during suspend/resume since
> > cpufreq_update_policy() tries to enforce this (0 KHz) as the current frequency
> > of the CPU, and this madness gets propagated to adjust_jiffies() as well.
> > Eventually, lots of things start breaking down, including the r8169 ethernet
> > card, in one particularly interesting case reported by Pierre Ossman.
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=70311
> >
> > Fix this by initializing the per-cpu data-structures of _all_ the CPUs
> > in the policy appropriately.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Pierre Ossman <pierre@ossman.eu>
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > ---
> >
> >  drivers/cpufreq/powernow-k8.c |   10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> > index e10b646..6684e03 100644
> > --- a/drivers/cpufreq/powernow-k8.c
> > +++ b/drivers/cpufreq/powernow-k8.c
> > @@ -1076,7 +1076,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
> >  {
> >         struct powernow_k8_data *data;
> >         struct init_on_cpu init_on_cpu;
> > -       int rc;
> > +       int rc, cpu;
> >
> >         smp_call_function_single(pol->cpu, check_supported_cpu, &rc, 1);
> >         if (rc)
> > @@ -1140,7 +1140,9 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
> >         pr_debug("cpu_init done, current fid 0x%x, vid 0x%x\n",
> >                  data->currfid, data->currvid);
> >
> > -       per_cpu(powernow_data, pol->cpu) = data;
> > +       /* Point all the CPUs in this policy to the same data */
> > +       for_each_cpu(cpu, pol->cpus)
> > +               per_cpu(powernow_data, cpu) = data;
> >
> >         return 0;
> >
> > @@ -1155,6 +1157,7 @@ err_out:
> >  static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
> >  {
> >         struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
> > +       int cpu;
> >
> >         if (!data)
> >                 return -EINVAL;
> > @@ -1165,7 +1168,8 @@ static int powernowk8_cpu_exit(struct cpufreq_policy *pol)
> >
> >         kfree(data->powernow_table);
> >         kfree(data);
> > -       per_cpu(powernow_data, pol->cpu) = NULL;
> > +       for_each_cpu(cpu, pol->cpus)
> > +               per_cpu(powernow_data, cpu) = NULL;
> >
> >         return 0;
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up as a fix for 3.14, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
