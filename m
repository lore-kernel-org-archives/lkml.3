Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202AbaHEKxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:53:45 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:59545 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaHEKxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:53:42 -0400
MIME-Version: 1.0
In-Reply-To: <53E0B657.4070007@redhat.com>
References: <1406634362-811-1-git-send-email-prarit@redhat.com>
	<2066166.pXm4lKLOID@vostro.rjw.lan>
	<53DA8389.80804@redhat.com>
	<1917362.abr2Y4p7vh@vostro.rjw.lan>
	<53DA8A41.2030601@redhat.com>
	<53DAA60B.6040802@codeaurora.org>
	<53DAA749.5080506@redhat.com>
	<53DAA95B.2040505@codeaurora.org>
	<53DAB038.3050007@redhat.com>
	<53DABFA6.6090503@codeaurora.org>
	<53DACA26.1000908@redhat.com>
	<53DAE592.2030909@codeaurora.org>
	<53DB6B81.6050400@redhat.com>
	<53DBCBE8.6010809@codeaurora.org>
	<53DBE764.8050109@redhat.com>
	<53DBEC27.7050803@codeaurora.org>
	<CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com>
	<53E0B657.4070007@redhat.com>
Date: Tue, 5 Aug 2014 16:23:41 +0530
Message-ID: <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to
 be held for duration of changing governors [v2]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 August 2014 16:17, Prarit Bhargava <prarit@redhat.com> wrote:
> Nope, not a stupid question.  After reproducing (finally!) yesterday I've been
> wondering the same thing.

Good to know that :)

> I've been looking into *exactly* this.  On any platform where
> cpu_weight(affected_cpus) == 1 for a particular cpu this lockdep trace should
> happen.

> That's what I'm wondering too.  I'm going to instrument the code to find out
> this morning.  I'm wondering if this comes down to a lockdep class issue
> (perhaps lockdep puts globally defined locks like cpufreq_global_kobject in a
> different class?).

Maybe, I tried this Hack to make this somewhat similar to the other case
on my platform with just two CPUs:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6f02485..6b4abac 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -98,7 +98,7 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);

 bool have_governor_per_policy(void)
 {
-       return !!(cpufreq_driver->flags & CPUFREQ_HAVE_GOVERNOR_PER_POLICY);
+       return !(cpufreq_driver->flags & CPUFREQ_HAVE_GOVERNOR_PER_POLICY);
 }
 EXPORT_SYMBOL_GPL(have_governor_per_policy);


This should result in something similar to setting that per-policy-governor
flag (Actually I could have done that too :)), and I couldn't see that crash :(

That needs more investigation now, probably we can get some champ of
sysfs stuff like Tejun/Greg into discussion now..

--
viresh
