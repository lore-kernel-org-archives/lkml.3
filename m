Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaHFPIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:08:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57740 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbaHFPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:08:33 -0400
Date: Wed, 6 Aug 2014 08:08:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
Message-ID: <20140806150831.GB32301@codeaurora.org>
References: <53DB6B81.6050400@redhat.com>
 <53DBCBE8.6010809@codeaurora.org>
 <53DBE764.8050109@redhat.com>
 <53DBEC27.7050803@codeaurora.org>
 <CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com>
 <53E0B657.4070007@redhat.com>
 <CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com>
 <53E1556B.5070304@codeaurora.org>
 <CAKohpoky1-hj7cwnKc58svh8Z1Yas1=q4uJEK8mWcb56uqAcng@mail.gmail.com>
 <53E1FEE5.80305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E1FEE5.80305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06, Prarit Bhargava wrote:
> 
> 
> On 08/06/2014 04:10 AM, Viresh Kumar wrote:
> > On 6 August 2014 03:36, Saravana Kannan <skannan@codeaurora.org> wrote:
> >> Stephen and I looked into this. This is not a sysfs framework difference.
> >> The reason we don't have this issue when we use global tunables is because
> >> we add the attribute group to the cpufreq_global_kobject and that kobject
> >> doesn't have a kobj_type ops similar to the per policy kobject. So,
> >> read/write to those attributes do NOT go through the generic show/store ops
> >> that wrap every other cpufreq framework attribute read/writes.
> >>
> >> So, none of those read/write do any kind of locking. They don't race with
> >> POLICY_EXIT (because we remove the sysfs group first thing in POLICY_EXIT)
> >> but might still race with START/STOPs (not sure, haven't looked closely
> >> yet).
> >>
> >> For example, writing to sampling_rate of ondemand governor might cause a
> >> race in update_sampling_rate(). It could race and happen between a STOP and
> >> POLICY_EXIT (triggered by hotplug, gov change, etc).
> > 
> > This sounds good but I couldn't prove it. Doing this on my dual core exynos
> > doesn't give me that crash report and it should?
> 
> Are you sure you're not seeing another lockdep warning?  That was my problem --
> there was an xfs related lockdep warning which then resulted in lockdep being
> disabled from that point on.
> 

Are we talking about the lockdep splat or the crash that started
this thread or something else? For the lockdep splat you need the
corrected patch in this thread and the per policy governor flag.
I'm not sure how to recreate the crash that started this thread.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
