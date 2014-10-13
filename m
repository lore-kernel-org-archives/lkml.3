Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaJMOtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:49:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51295 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753286AbaJMOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:49:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
Subject: Re: Locking issues with cpufreq and sysfs
Date: Mon, 13 Oct 2014 17:09:43 +0200
Message-ID: <2412719.9lgtmSkvbC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543BD229.4020207@redhat.com>
References: <543BCF9A.1060603@redhat.com> <543BD229.4020207@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 13, 2014 09:22:49 AM Prarit Bhargava wrote:
> 
> On 10/13/2014 09:11 AM, Prarit Bhargava wrote:
> > There are several issues with the current locking design of cpufreq.  Most
> > notably is the panic reported here:
> > 
> > http://marc.info/?l=linux-kernel&m=140622451625236&w=2
> > 
> > which was introduced by commit 955ef4833574636819cd269cfbae12f79cbde63a,
> > cpufreq: Drop rwsem lock around CPUFREQ_GOV_POLICY_EXIT, which introduces
> > a race in the changing of the cpufreq policy.  This change was introduced
> > because of a lockdep deadlock warning that can be reproduced (on x86 with
> > the acpi_cpufreq driver) via the following debug patch:
> > 
> > iff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> > index b0c18ed..366cfb7 100644
> > --- a/drivers/cpufreq/acpi-cpufreq.c
> > +++ b/drivers/cpufreq/acpi-cpufreq.c
> > @@ -885,6 +885,7 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
> > 
> >  static struct cpufreq_driver acpi_cpufreq_driver = {
> >         .verify         = cpufreq_generic_frequency_table_verify,
> > +       .flags          = CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
> >         .target_index   = acpi_cpufreq_target,
> >         .bios_limit     = acpi_processor_get_bios_limit,
> >         .init           = acpi_cpufreq_cpu_init,
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 61190f6..4cb488a 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -2195,9 +2195,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
> >         /* end old governor */
> >         if (old_gov) {
> >                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> > -               up_write(&policy->rwsem);
> >                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> > -               down_write(&policy->rwsem);
> >         }
> > 
> >         /* start new governor */
> > @@ -2206,9 +2204,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *polic
> >                 if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
> >                         goto out;
> > 
> > -               up_write(&policy->rwsem);
> >                 __cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> > -               down_write(&policy->rwsem);
> >         }
> > 
> >         /* new governor failed, so re-start old one */
> > 
> > (which causes the acpi-cpufreq driver to emulate the behaviour of the arm
> > cpufreq driver), and by doing
> > 
> > echo ondemand > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
> > cat /sys/devices/system/cpu/cpu5/cpufreq/ondemand/*
> > echo conservative > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
> > exit 0
> > 
> > [Question: was the original reported deadlock "real"?  Did it really happen or
> > did lockdep only report it (I may have asked this question previously and
> > forgot the answer)?  The reason I ask is that this situation is very similar to
> > USB's device removal in which the sysfs attributes are removed for a device but
> > not the device it was called for.  I actually think that's part of the problem
> > here.]
> > 
> > The above, obviously, is a complete hack of the code but in a sense does
> > mimic a proper locking fix.  However, even with this fix we are still left
> > with a race in accessing the sysfs files.  Consider the following example,
> > 
> > CPU 1: accesses scaling_setspeed to set cpu speed
> > 
> > simultaneously,
> > 
> > CPU 2: accesses scaling_governor to set governor to ondemand
> > 
> > CPU 1 & 2 race ... and this can result in different critical situations.
> > The first is that CPU 1 holds the scalling_setspeed open while CPU attempts
> > to change the governor.  This results in a syfs warning about creating a
> > file with an existing file name which in some cases can lead to additional
> > corruption and a panic.  The second case is that CPU 1's setting of the speed
> > is now done on the new governor -- which may or may not be correct.  In any
> > case an argument could be made that the userspace program doing this type
> > of action should be "smart" enough to confirm simultaneous changes... but
> > in any case the kernel should not panic or corrupt data.
> > 
> > The locking is insufficient here, Viresh.  I no longer believe that fixes
> > to this locking scheme are the right way to move forward here.  I'm wondering
> > if we can look at other alternatives such as maintaining a refcount or
> > perhaps using a queuing mechanism for governor and policy related changes.
> > 
> 
> Uh ... I meant this as "I'm willing to modify the code to do this but I'd like
> to know what everyone else thinks before I do anything" ;)

OK, that's constructive. :-)

Can we discuss the target design first, please?  You certainly have something
in mind, so can you describe it?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
