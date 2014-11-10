Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaKJM06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:26:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaKJM05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:26:57 -0500
Message-ID: <5460AF02.9010907@redhat.com>
Date: Mon, 10 Nov 2014 07:26:42 -0500
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
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1415199239-19019-3-git-send-email-prarit@redhat.com> <CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com>
In-Reply-To: <CAKohpomZNwZWjmi8hkZ6QXUeDTaXTwzx_fPz1_byh3xmmkPNrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/10/2014 05:44 AM, Viresh Kumar wrote:
> On 5 November 2014 20:23, Prarit Bhargava <prarit@redhat.com> wrote:
>> commit 955ef4833574636819cd269cfbae12f79cbde63a (" cpufreq: Drop rwsem
>> lock around CPUFREQ_GOV_POLICY_EXIT") opens up a hole in the locking
>> scheme for cpufreq.
>>
>> Simple tests such as rapidly switching the governor between ondemand and
>> performance or attempting to read policy values while a governor switch occurs
>> now fail with very NULL pointer warnings, sysfs namespace collisions, and
>> system hangs.  In short, the locking that policy->rwsem is supposed to provide
>> is currently broken.
>>
>> The identified commit attempts to resolve a lockdep warning by removing
>> a lock around a section of code which does a shutdown of the
>> existing policy.  The problem is that this is part of the _critical_ section of
>> code that switches the governors and must be protected by the lock; without
>> locking readers may access now NULL or stale data, and writes may collide with
>> each other.
>>
>> With the previous patch, which now returns -EBUSY during times of
>> contention the deadlock reported in
>> 955ef4833574636819cd269cfbae12f79cbde63a (" cpufreq: Drop rwsem lock
>> around CPUFREQ_GOV_POLICY_EXIT") cannot occur, so adding the locks back
>> into this section of code is possible.
> 
> I still fail to understand why ? What will the _trylock() change ?

viresh, afaict read_trylock will return 0 when busy with write:

static inline int queue_read_trylock(struct qrwlock *lock)
{
        u32 cnts;

        cnts = atomic_read(&lock->cnts);
        if (likely(!(cnts & _QW_WMASK))) {

so the deadlock will not occur.  the show() is opened, write lock is taken, and
if the thread is rescheduled and takes read lock the trylock will return 0, and
the thread will return -EBUSY to userspace avoiding the deadlock.

P.
> 
