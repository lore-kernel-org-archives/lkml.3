Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3IJPMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:12:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3IJPMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:12:22 -0400
Date: Tue, 10 Sep 2013 17:12:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
In-Reply-To: <CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1309101656150.16010@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
 <CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:I5q2h3pwboqeey/Pp/C+QSAWcg55/tDhpXZOeDekP1H
 /dYBcZzA6JVIvFJFmwbE9qrXRtqoZ2lGPmX5/xQbGfvytqifdh
 jb8YfswR6jzDmpQ2Lc+JVu9wRTLeqJctuEGjnzycOElMY+53l8
 1LPiPnBIqz2FMsdzNnNmgv8OqXswGNI3W29bP1UXOhrC2tXRBZ
 P4vcaRXht9vth3JME5f9sGYynCMyZeHDQbgQMNZJcKisCZ9O1s
 2pxRkWN61lGsUpng+EcsQTX0c6cdaBj69BNh9gFuN4dYPRWuPg
 EcYZES/fP8tLPgRjyEAKl8RAoSNM2+N9q1oWtFx3BLiTu1PCQF
 /rLSJ/l0V4J3H0Ia3HOZZIYC/R83KQQa6DKx7v37dc1yu212nw
 /Na3PO1E3zZDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Viresh Kumar wrote:

> On 9 September 2013 20:41, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > Sorry guys, I'm trying my best to stop this patch from propagating to
> > stable and to get it fixed asap, so, the CC list might be a bit excessive.
> > Also trying to fix the originally spare cc list, which makes it impossible
> > for me to reply to the original thread, instead have to start a new one.
> >
> > Commit
> >
> > commit dceff5ce18801dddc220d6238628619c93bc3cb6
> > Author: Viresh Kumar <viresh.kumar@linaro.org>
> > Date:   Sun Sep 1 22:19:37 2013 +0530
> >
> >     cpufreq: fix serialization issues with freq change notifiers
> >
> > breaks .transition_ongoing counting. This leads to cpufreq-cpu0 not
> > working any more. In particular switching the governor from performance to
> > powersave directly after boot doesn't result in a frequency switch any
> > more. Reverting this patch fixes the problem again. Tested with today's
> > -next.
> 
> I have tested it again on my exynos and intel machines and couldn't see
> a single problem with this patch..

Ok, here's what I've just done.

1. checkout -next tag next-20130909

commit 98926a8004b453089368fda456b8c869240e9953
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Sep 9 16:05:53 2013 +1000

    Add linux-next specific files for 20130909

2. built and booted a kernel for kzm9g (.config available on request)

3. cpufreq failed to initialise:

cpufreq_cpu0: failed to find cpu0 node
cpufreq-cpu0: probe of cpufreq-cpu0 failed with error -2

due to commit f837a9b5ab05c52a07108c6f09ca66f2e0aee757 - as reported in 
another thread.

4. reverted that commit, resolving a trivial conflict. Added a debug 
output in __cpufreq_driver_target() of

 
 	if (cpufreq_disabled())
 		return -ENODEV;
+	pr_info("%s() %d\n", __func__, policy->transition_ongoing);
 	if (policy->transition_ongoing)
 		return -EBUSY;
 

Built and booted, got

cpufreq: __cpufreq_driver_target(): 1

printed out 4 times from the beginning.

5. tried

echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

the above output appeared 2 more times - no frequency change resulted.

6. reverted commit dceff5ce18801dddc220d6238628619c93bc3cb6, built booted 
- cpufreq works again.

> I am afraid you need to give us some more information on how it broke
> your stuff.. :)

Hope the above is enough.

Thanks
Guennadi

> And I am also not sure cpufreq-cpu0 is different then any other driver..
> 
> --
> viresh

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
