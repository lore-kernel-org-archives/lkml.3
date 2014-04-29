Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbaD2IEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:04:37 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46088 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971AbaD2IEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <535F565B.6020405@linux.vnet.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
	<20140428185507.28755.6483.stgit@srivatsabhat.in.ibm.com>
	<CAKohpomaJ0ubnzzQ7AwAd6z+Zm085i+UwB7XMa=si7qthZdgZg@mail.gmail.com>
	<CAKohpokiy2Fvry=uTVnOCymH7Co1ka+JCFT3ndtPQBSD94Mnew@mail.gmail.com>
	<535F43B2.2000309@linux.vnet.ibm.com>
	<CAKohpokiRMnZ6ga3_y2Tqgo95LzExb5nNgoKBNBXvsMyO__ZYA@mail.gmail.com>
	<535F565B.6020405@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 13:34:31 +0530
Message-ID: <CAKohpom93-q9zN9PgpTs-7E7Bi7N2cdyi4DaitPN8YFCAG1UMw@mail.gmail.com>
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

On 29 April 2014 13:05, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 04/29/2014 12:19 PM, Viresh Kumar wrote:
>> +       WARN_ON(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
>>                              && (current == policy->transition_task));
>>
>> which you already mentioned.
>
> Yeah, I think we should just go with this. I thought we needed lots of
> if-conditions to do exclude these drivers (which would have made it ugly),
> but as you pointed above, just this one would suffice.

Okay, I think we can do one more modification here:

>> +       WARN_ON(unlikely(!(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION)
>>                              && (current == policy->transition_task)));


> Besides, the cpufreq core doesn't automatically invoke _begin() and
> _end() for ASYNC_NOTIFICATION drivers. So that means the probability
> that such drivers will hit this problem is extremely low, since the
> driver alone is responsible for invoking _begin/_end and hence there
> shouldn't be much of a conflict. So I think we should really just
> skip ASYNC_NOTIFICATION drivers in this debug infrastructure.

The only way it can happen (I don't hope somebody would be so
stupid to call begin twice from target() :)), is via transition notifiers,
which in some case starting a new transition..
