Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaHLSEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:04:36 -0400
Received: from natalenko.name ([78.47.77.148]:58310 "EHLO natalenko.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbaHLSEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:04:34 -0400
DMARC-Filter: OpenDMARC Filter v1.2.0 natalenko.name 0B3E8AB64
Authentication-Results: mail.natalenko.name; dmarc=none header.from=natalenko.name
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
Date: Tue, 12 Aug 2014 21:04:30 +0300
Message-ID: <1449757.YVvGmvgCpE@spock>
User-Agent: KMail/4.13.3 (Linux/3.15.0-pf5; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAOh2x=nJTuKKKyM72MUFSkrsH1eh1YgRUbfLcTCpfZzO85q80w@mail.gmail.com>
References: <4708675.eITUXPv8Ih@spock> <97078cc7-f961-4575-ab72-ec88e6f30b9e@email.android.com> <CAOh2x=nJTuKKKyM72MUFSkrsH1eh1YgRUbfLcTCpfZzO85q80w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I've added the following code to cpufreq_register_notifier() 
(drivers/cpufreq/cpufreq.c) to CPUFREQ_TRANSITION_NOTIFIER case:

===
pr_info("Registered transition notifier: %p, (%p)\n", nb->notifier_call, &nb-
>notifier_call);
===

And got the following in my dmesg (only 1 line):

===
$ cat /var/log/kern.log | grep "Registered transition notifier"
Aug 12 17:23:45 defiant kernel: [    3.084977] cpufreq: Registered transition 
notifier: ffffffff81590378, (ffffffff81cb0ba0)
===

System.map tells me, that ffffffff81590378 corresponds to 
cpufreq_stat_notifier_trans() (in drivers/cpufreq/cpufreq_stats.c).

Also I've added

===
pr_info("%s\n", __func__);
===

to all callbacks (hello, LXR :)), and got the following occurrences in dmesg:

===
$ cat /var/log/kern.log | egrep -e '(acpi_|cpufreq|notifier)' | awk 
'{print($7)}' | sort -u
acpi_processor_ppc_notifier
acpi_thermal_cpufreq_notifier
cpufreq_stat_notifier_policy
===

No extra notifiers are involved so far, but also I haven't caught new hang yet 
as it occurs randomly. Still waiting for it, but I hope my little 
investigation could help somehow.

On Tuesday 12 August 2014 13:16:25 Viresh Kumar wrote:
> On Tue, Aug 12, 2014 at 12:56 PM, Oleksandr Natalenko
> 
> <oleksandr@natalenko.name> wrote:
> > Got that and will try to investigate ASAP.
> > 
> > Just to note: I tried to use powersave governor and got the same result. I
> > believe notifiers are used with powersave governor as well. Am I wrong?
> Notifiers are used from the cpufreq core when frequency is changed.
> And the powersave governor should have changed the frequency only
> ONCE, i.e. to go to lowest frequency.
> 
> So, it probably happened at the first & only change at that time as well..
> But it shouldn't happen any later. So, see what the log looks like on
> that crash.
-- 
Oleksandr post-factum Natalenko, MSc
pf-kernel community
https://natalenko.name/
