Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaKKMPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:15:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418AbaKKMPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:15:44 -0500
Message-ID: <5461FDE1.2080302@redhat.com>
Date: Tue, 11 Nov 2014 07:15:29 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 2/5] cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT
 calls
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1415199239-19019-3-git-send-email-prarit@redhat.com> <CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com> <5460AF02.9010907@redhat.com> <CAKohpomeRivb3TwkeWALL_xsf4gOBPYOnfCNdz2oVvZSAGBP4g@mail.gmail.com>
In-Reply-To: <CAKohpomeRivb3TwkeWALL_xsf4gOBPYOnfCNdz2oVvZSAGBP4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/10/2014 10:37 PM, Viresh Kumar wrote:
> On 10 November 2014 17:56, Prarit Bhargava <prarit@redhat.com> wrote:
> 
>>> I still fail to understand why ? What will the _trylock() change ?
>>
>> viresh, afaict read_trylock will return 0 when busy with write:
> 
> Yes..
> 
>> static inline int queue_read_trylock(struct qrwlock *lock)
>> {
>>         u32 cnts;
>>
>>         cnts = atomic_read(&lock->cnts);
>>         if (likely(!(cnts & _QW_WMASK))) {
>>
>> so the deadlock will not occur.  the show() is opened, write lock is taken, and
>> if the thread is rescheduled and takes read lock the trylock will return 0, and
>> the thread will return -EBUSY to userspace avoiding the deadlock.
> 
> Which deadlock? 

the deadlock in commit 955ef4833574636819cd269cfbae12f79cbde63a

[   75.471265]        CPU0                    CPU1
[   75.476327]        ----                    ----
[   75.481385]   lock(&policy->rwsem);
[   75.485307]                                lock(s_active#219);
[   75.491857]                                lock(&policy->rwsem);
[   75.498592]   lock(s_active#219);
[   75.502331]
[   75.502331]  *** DEADLOCK ***

And also your changelog talks about accessing invalid pointers
> without the trylock change, how can that be possible? After the read
> lock is taken,
> all the pointers should be valid.

consider the following very simple case:

the governor is ondemand.  cpu 0 reads cpuinfo_cur_freq. cpu0 expects to get the
current cpu freq for the ondemand governor.

simultaneously, cpu1 changes the governor from ondemand to userspace.

the two threads will race for the policy->mutex

suppose cpu0 gets it first.  then there is no problem.  the userspace program
for cpu0 gets exactly the data it is expecting.

Now suppose cpu1 gets the lock and starts to write ... cpu0 is blocked.

cpu1 completes the governor change, and cpu0 gets the mutex ... and returns
bogus data at this point.

P.
> 
