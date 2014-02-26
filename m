Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaBZGCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 01:02:22 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61897 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaBZGCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 01:02:19 -0500
MIME-Version: 1.0
In-Reply-To: <530D47F4.2010204@codeaurora.org>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
	<15001517.xLHO8lGdWr@vostro.rjw.lan>
	<530D06FF.201@codeaurora.org>
	<1789244.B5CzWbcp6h@vostro.rjw.lan>
	<530D47F4.2010204@codeaurora.org>
Date: Wed, 26 Feb 2014 11:32:19 +0530
Message-ID: <CAKohpo==WVKytPCaMk=O5rGfPNFDAF7ffYo7OE0d3uAPyJfwwA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2014 07:18, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 02/25/2014 02:41 PM, Rafael J. Wysocki wrote:

>> And is "fully initialized" actually well defined?
>
> The point in add dev/hot plug path after which we will no longer change
> policy fields without sending further CPUFREQ_UPDATE_POLICY_CPU /
> CPUFRE_NOTIFY notifiers.

Okay..

> Pretty much the end of __cpufreq_add_dev() so that it's after:
> - cpufreq_init_policy()
> - And the update of userpolicy fields that after thie init call

No. In that case it can be considered initialized before cpufreq_init_policy().
As we do send CPUFREQ_NOTIFY after that from cpufreq_init_policy()->
cpufreq_set_policy().

There are two types of fields within policy, some are very basic: cpu/min/max/
affected_cpus/related_cpus

some are advanced: sysfs/governors/..

And as a rule you have to get policy->rwsem lock before accessing policy
members. We might not have followed it very well for small things like cpu.

And so if you are doing anything over that, please use a lock and that is
already present in cpufreq_update_policy().

With my latest patchset that I sent yesterday, locking is improved and now
a policy will be usable only after the rwsem is released. And that should be
fine. And so making it available in the per-cpu variable after all the necessary
fields are filled looks fine to me. And so I don't think we need to move it
after call to cpufreq_init_policy(maybe a better name to this function is
required)..

> Ok, here's some pseudo code to explain it better:
>
> Something like, replace all calls to cpufreq_driver->get with
> __cpufreq_driver_get() with the fn being something like:
>
> unsigned int __cpufreq_driver_get(cpufreq_policy *policy)
> {
>   if (policy->clk)
>      return clk_get_rate(policy->clk) / 1000;
>   else
>      return cpufreq_driver->get(policy->cpu);

This part may still use cpufreq_cpu_get().

> }

Drivers are free to have their implementation of ->get() even
if they have a valid policy->clk field..
