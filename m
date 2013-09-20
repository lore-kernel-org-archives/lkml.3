Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3ITItU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 04:49:20 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:62183 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3ITItT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com>
	<45987104.t6r4hvPgQn@vostro.rjw.lan>
	<523AF22F.1010909@linux.vnet.ibm.com>
	<CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com>
	<CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com>
	<CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com>
	<CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com>
Date: Fri, 20 Sep 2013 14:19:18 +0530
Message-ID: <CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com>
Subject: Re: Regression on cpufreq in v3.12-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2013 14:11, Linus Walleij <linus.walleij@linaro.org> wrote:
> Any other idea why this patch is causing the issue?

I went into looking that patch in more detail
after my first reply, not as if I ran away from answering that :)

Probably yes.. I know what's causing it:

 unsigned int cpufreq_get(unsigned int cpu)
 {
        unsigned int ret_freq = 0;
-       struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);

-       if (!policy)
-               goto out;
+       if (!down_read_trylock(&cpufreq_rwsem))
+               return 0;

        if (unlikely(lock_policy_rwsem_read(cpu)))
                goto out_policy;
@@ -1438,8 +1413,8 @@ unsigned int cpufreq_get(unsigned int cpu)
        unlock_policy_rwsem_read(cpu);

 out_policy:
-       cpufreq_cpu_put(policy);
-out:
+       up_read(&cpufreq_rwsem);
+
        return ret_freq;
 }

---------x---------------x--------------

We used to return early in case policy isn't found, but now we went
and took the lock..

Hmm... Remember I told you last time that I have another way of fixing
it up, probably we need that now..

I wanted to add another variable to reflect if a cpufreq_driver is registered
or not, and if not then return early from these routines..

I will get that in now, please see if you can give it a try..

But I am still surprised how are we reaching this place before your cpufreq
driver gets registered..
