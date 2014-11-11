Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaKKNH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:07:28 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44235 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaKKNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:07:25 -0500
MIME-Version: 1.0
In-Reply-To: <5461FDE1.2080302@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
	<1415199239-19019-3-git-send-email-prarit@redhat.com>
	<CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com>
	<5460AF02.9010907@redhat.com>
	<CAKohpomeRivb3TwkeWALL_xsf4gOBPYOnfCNdz2oVvZSAGBP4g@mail.gmail.com>
	<5461FDE1.2080302@redhat.com>
Date: Tue, 11 Nov 2014 18:37:24 +0530
Message-ID: <CAKohponGMGzYnDEjto2tP1_kXNRQOgxqDW__s3kNOJWhFas8sw@mail.gmail.com>
Subject: Re: [PATCH 2/5] cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT calls
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Robert_Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 17:45, Prarit Bhargava <prarit@redhat.com> wrote:
> the deadlock in commit 955ef4833574636819cd269cfbae12f79cbde63a
>
> [   75.471265]        CPU0                    CPU1
> [   75.476327]        ----                    ----
> [   75.481385]   lock(&policy->rwsem);
> [   75.485307]                                lock(s_active#219);
> [   75.491857]                                lock(&policy->rwsem);
> [   75.498592]   lock(s_active#219);
> [   75.502331]
> [   75.502331]  *** DEADLOCK ***

I wanted to understand how this deadlock is prevented by a simple change
to trylock..

>> And also your changelog talks about accessing invalid pointers
>> without the trylock change, how can that be possible? After the read
>> lock is taken,
>> all the pointers should be valid.
>
> consider the following very simple case:
>
> the governor is ondemand.  cpu 0 reads cpuinfo_cur_freq. cpu0 expects to get the
> current cpu freq for the ondemand governor.

Name it A.

>
> simultaneously, cpu1 changes the governor from ondemand to userspace.

Name it B.

>
> the two threads will race for the policy->mutex
>
> suppose cpu0 gets it first.  then there is no problem.  the userspace program
> for cpu0 gets exactly the data it is expecting.
>
> Now suppose cpu1 gets the lock and starts to write ... cpu0 is blocked.
>
> cpu1 completes the governor change, and cpu0 gets the mutex ... and returns
> bogus data at this point.

What do you mean by bogus here? That userspace wouldn't be able to know if
the value is for which governor?

If that's the case than it can still happen. Issue both above commands at almost
the same time. You will never be able to differentiate if the sequence is:

- A followed by B
- B followed by A
- A waited for B and so returned -EBUSY (Only this will be clear)

And the value read can still be bogus. So, we haven't solved the problem at all.
