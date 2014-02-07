Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaBGEJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:09:39 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:57603 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaBGEJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:09:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140205221052.19080.77507.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	<20140205221052.19080.77507.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 7 Feb 2014 09:39:36 +0530
Message-ID: <CAKohpok4XOS19XVfpth+8AYnL3D_35=VMMqefSnQLFy1DRDDrQ@mail.gmail.com>
Subject: Re: [PATCH 35/51] acpi-cpufreq: Fix CPU hotplug callback registration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, oleg@redhat.com, rusty@rustcorp.com.au,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        walken@google.com, ego@linux.vnet.ibm.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2014 03:40, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
>
>         get_online_cpus();
>
>         for_each_online_cpu(cpu)
>                 init_cpu(cpu);
>
>         register_cpu_notifier(&foobar_cpu_notifier);
>
>         put_online_cpus();
>
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
>
> Instead, the correct and race-free way of performing the callback
> registration is:
>
>         cpu_maps_update_begin();
>
>         for_each_online_cpu(cpu)
>                 init_cpu(cpu);
>
>         /* Note the use of the double underscored version of the API */
>         __register_cpu_notifier(&foobar_cpu_notifier);
>
>         cpu_maps_update_done();
>
>
> Fix the acpi-cpufreq code by using this latter form of callback registration.
>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
