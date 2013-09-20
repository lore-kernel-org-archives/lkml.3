Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3ITIdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:33:25 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:65491 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3ITIdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
Date: Fri, 20 Sep 2013 10:33:22 +0200
Message-ID: <CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 2:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Sep 19, 2013 at 2:46 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>
>> So I think we should first identify (bisect?) and understand what caused that
>> particular change and then we will be in a position to evaluate whether the
>> patch you proposed would be the right fix or not.
>
> I'll see if I can get a bisect going, the problem is that I upload the
> kernel over the serial port so this isn't a very quick procedure :-(

Well I did a bisect anyway, it seems the problem appears due
at this commit:

commit 6eed9404ab3c4baea54ce4c7e862e69df1d39f38
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Aug 6 22:53:11 2013 +0530

    cpufreq: Use rwsem for protecting critical sections

    Critical sections of the cpufreq core are protected with the help of
    the driver module owner's refcount, which isn't the correct approach,
    because it causes rmmod to return an error when some routine has
    updated that refcount.

    Let's use rwsem for this purpose instead.  Only
    cpufreq_unregister_driver() will use write sem
    and everybody else will use read sem.

    [rjw: Subject & changelog]
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I suspect this hunk from the patch may be the cause:

+       if (cpufreq_driver) {
+               /* get the CPU */
+               policy = per_cpu(cpufreq_cpu_data, cpu);
+               if (policy)
+                       kobject_get(&policy->kobj);
+       }

-       /* get the CPU */
-       policy = per_cpu(cpufreq_cpu_data, cpu);

As you see we *always* set a policy pointer before this patch,
but after this patch we only do it if we have a cpufreq driver
registered!

It's not trivial to fix this for me though, it seems there are some
other suggestions in this thread...

Yours,
Linus Walleij
