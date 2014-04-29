Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaD2Gtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:49:42 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59602 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaD2Gtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <535F43B2.2000309@linux.vnet.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
	<20140428185507.28755.6483.stgit@srivatsabhat.in.ibm.com>
	<CAKohpomaJ0ubnzzQ7AwAd6z+Zm085i+UwB7XMa=si7qthZdgZg@mail.gmail.com>
	<CAKohpokiy2Fvry=uTVnOCymH7Co1ka+JCFT3ndtPQBSD94Mnew@mail.gmail.com>
	<535F43B2.2000309@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 12:19:39 +0530
Message-ID: <CAKohpokiRMnZ6ga3_y2Tqgo95LzExb5nNgoKBNBXvsMyO__ZYA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 April 2014 11:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Yes, I'm aware that this corner case doesn't work well with my debug

Don't know if its a corner case, it may be the most obvious case for
some :)

> patch. I tried to avoid this but couldn't think of any solution.

The problem is not that it wouldn't work for these systems, but we will
get WARN_ON() when they shouldn't have come :)

> (One big-hammer way to avoid this is to exclude this infrastructure
> for all ASYNC_NOTIFICATION drivers, but I didn't want to go with that
> approach, since it makes it look ugly). Do you have any better ideas
> to deal with this scenario?

Can't think of anything better than this:

+       WARN_ON(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
                             && (current == policy->transition_task));

which you already mentioned.

> Also, do we really have cases in mind where a single thread does
> multiple frequency transitions in one go? That too in such quick
> successions? Echo's to sysfs, changing of governors from userspace etc
> all do one frequency transition at a time per-task...

Its not really about if we can think of a real use case or not. The point
is, governor is free to call transition calls one after the other (will always
happen from a single thread) and it isn't supposed to wait for drivers
to finish earlier transitions as ->target() has already returned.

--
viresh
