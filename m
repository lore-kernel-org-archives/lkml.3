Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbaD2Hgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:36:52 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46023 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaD2Hgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:36:49 -0400
Message-ID: <535F565B.6020405@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 13:05:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com> <20140428185507.28755.6483.stgit@srivatsabhat.in.ibm.com> <CAKohpomaJ0ubnzzQ7AwAd6z+Zm085i+UwB7XMa=si7qthZdgZg@mail.gmail.com> <CAKohpokiy2Fvry=uTVnOCymH7Co1ka+JCFT3ndtPQBSD94Mnew@mail.gmail.com> <535F43B2.2000309@linux.vnet.ibm.com> <CAKohpokiRMnZ6ga3_y2Tqgo95LzExb5nNgoKBNBXvsMyO__ZYA@mail.gmail.com>
In-Reply-To: <CAKohpokiRMnZ6ga3_y2Tqgo95LzExb5nNgoKBNBXvsMyO__ZYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042907-2000-0000-0000-000011091766
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 12:19 PM, Viresh Kumar wrote:
> On 29 April 2014 11:46, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Yes, I'm aware that this corner case doesn't work well with my debug
> 
> Don't know if its a corner case, it may be the most obvious case for
> some :)
>

Yeah, it could be.
 
>> patch. I tried to avoid this but couldn't think of any solution.
> 
> The problem is not that it wouldn't work for these systems, but we will
> get WARN_ON() when they shouldn't have come :)
> 

Yes, I thought about this, and I agree that this is not acceptable.

>> (One big-hammer way to avoid this is to exclude this infrastructure
>> for all ASYNC_NOTIFICATION drivers, but I didn't want to go with that
>> approach, since it makes it look ugly). Do you have any better ideas
>> to deal with this scenario?
> 
> Can't think of anything better than this:
> 
> +       WARN_ON(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
>                              && (current == policy->transition_task));
> 
> which you already mentioned.

Yeah, I think we should just go with this. I thought we needed lots of
if-conditions to do exclude these drivers (which would have made it ugly),
but as you pointed above, just this one would suffice.

Besides, the cpufreq core doesn't automatically invoke _begin() and 
_end() for ASYNC_NOTIFICATION drivers. So that means the probability
that such drivers will hit this problem is extremely low, since the
driver alone is responsible for invoking _begin/_end and hence there
shouldn't be much of a conflict. So I think we should really just
skip ASYNC_NOTIFICATION drivers in this debug infrastructure.

> 
>> Also, do we really have cases in mind where a single thread does
>> multiple frequency transitions in one go? That too in such quick
>> successions? Echo's to sysfs, changing of governors from userspace etc
>> all do one frequency transition at a time per-task...
> 
> Its not really about if we can think of a real use case or not. The point
> is, governor is free to call transition calls one after the other (will always
> happen from a single thread) and it isn't supposed to wait for drivers
> to finish earlier transitions as ->target() has already returned.
> 

Yes, I agree now. Making bold assumptions in the cpufreq core about
how many frequency transitions a single task will do etc is potentially
*very* dangerous. Let's not do it that way.

I'll send a v2 excluding the ASYNC_NOTIFICATION drivers.
Thanks a lot for your inputs!

Regards,
Srivatsa S. Bhat

