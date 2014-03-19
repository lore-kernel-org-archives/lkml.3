Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbaCSKJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:09:20 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:52016 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078AbaCSKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:09:17 -0400
X-Greylist: delayed 16521 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 06:09:17 EDT
MIME-Version: 1.0
In-Reply-To: <53296870.5010505@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
	<CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
	<53296870.5010505@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 15:39:16 +0530
Message-ID: <CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
Subject: Re: [RFC V2] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 15:20, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> No, its not about burden. Its about the elegance of the design. We should
> not be overly "smart" in the cpufreq core. Hiding the synchronization inside
> the cpufreq core only encourages people to write buggy code in their drivers.

What kind of buggy code can be there? They are supposed to call notifiers
in the order mentioned and so it shouldn't be a problem at all.. Don't know..

> Why don't we go with what Rafael suggested? We can have dedicated
> begin_transition() and end_transition() calls to demarcate the frequency
> transitions. That way, it makes it very clear how the synchronization is
> done. Of course, these functions would be provided (exported) by the cpufreq
> core, by implementing them using locks/counters/whatever.
>
> Basically what I'm arguing against, is the idea of having the cpufreq
> core figure out what the driver _intended_ to do, from inside the
> cpufreq_notify_transition() call.
>
> What I would prefer instead is to have the cpufreq driver do something
> like this:
>
> cpufreq_freq_transition_begin();
>
> cpufreq_notify_transition(CPUFREQ_PRECHANGE);

Why do we need two routines then? What about doing notification from
inside cpufreq_freq_transition_begin()?

This is a burden for driver writers, who don't normally understand the
relevance of these calls in detail and may think, only the first one is
enough or the second one is..

Its better if they simply let the core that they are starting to do transitions,
i.e. cpufreq_freq_transition_begin() and then the core should send
notifications.

> //perform the frequency change
>
> cpufreq_notify_transition(CPUFREQ_POSTCHANGE);
>
> cpufreq_freq_transition_end();
>
> [ASYNC_NOTIFICATION drivers will invoke the last two functions in a
> separate context/thread.]

Same for the last two routines and yes they would be called from
separate thread for ASYNC_NOTIFICATION drivers..
