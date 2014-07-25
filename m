Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbaGYLcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:32:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbaGYLcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:32:05 -0400
Message-ID: <53D24030.1010302@redhat.com>
Date: Fri, 25 Jul 2014 07:32:00 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors
References: <1406224491-3599-1-git-send-email-prarit@redhat.com> <CAKohpomHj17A4e6Sh8JSz1HPbq9r8gXUJeZ20PQ=Mhu59Vt7ZQ@mail.gmail.com>
In-Reply-To: <CAKohpomHj17A4e6Sh8JSz1HPbq9r8gXUJeZ20PQ=Mhu59Vt7ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/25/2014 12:27 AM, Viresh Kumar wrote:
> On 24 July 2014 23:24, Prarit Bhargava <prarit@redhat.com> wrote:
>> The closer I looked at commit 955ef483, the more questions I have.  The first
>> thing is that it appears that the stacktrace includes function calls that
>> are not, and never have been, part of the linux.git tree, ie) the call trace
>> shows
>>
>>             [<c0055a79>] lock_acquire+0x61/0xbc
>>             [<c00fabf1>] sysfs_addrm_finish+0xc1/0x128
>>             [<c00f9819>] sysfs_hash_and_remove+0x35/0x64
>>             [<c00fbe6f>] remove_files.isra.0+0x1b/0x24
>>             [<c00fbea5>] sysfs_remove_group+0x2d/0xa8
>>             [<c02f9a0b>] cpufreq_governor_interactive+0x13b/0x35c
>>             [<c02f61df>] __cpufreq_governor+0x2b/0x8c
>>             [<c02f6579>] __cpufreq_set_policy+0xa9/0xf8
>>             [<c02f6b75>] store_scaling_governor+0x61/0x100
>>             [<c02f6f4d>] store+0x39/0x60
>>             [<c00f9b81>] sysfs_write_file+0xed/0x114
>>             [<c00b3fd1>] vfs_write+0x65/0xd8
>>             [<c00b424b>] sys_write+0x2f/0x50
>>             [<c000cdc1>] ret_fast_syscall+0x1/0x52
>>
>> and the top part of the stack from cpufreq_governor_interactive() appear to
>> be for a driver that is not in the linux.git tree.  Google search does show
>> that it exists in various android trees, however, my concern is that the "core"
>> scaling governors are now broken because of an out tree driver.
> 
> Actually the problem did occur with ondemand/conservative as well. And
> the problem was, we accessed something from cpufreq sysfs and then were
> trying to remove that only and so some recursive locking stuff..
> 

Do you recall if there was a reproducer for it?  FWIW, I was able to run ~50K
events without an issue (I eventually stopped the test when I applied my patch.
 I compiled two kernels, one with LOCKDEP on and one with LOCKDEP off and
neither showed a problem.

> And so nothing interactive governor specific.
> 
> The problem looks similar to what's reported here:
> http://comments.gmane.org/gmane.linux.power-management.general/47397
> 
> And that's how I replied to it:
> 
> I have pushed a fix earlier for similar issues:
> 19c7630 cpufreq: serialize calls to __cpufreq_governor()

This is very similar to what I did by adding in a new mutex and serializing the
"governor switch" portion of the code, but that still won't work (see below).
> 
> but was later reverted by Srivatsa:
> 56d07db cpufreq: Remove temporary fix for race between CPU hotplug and
> sysfs-writes
> 
> because we didn't thought about this usecase.
> 
> I propose we get that back. I have tested a revert of 56d07db on
> my setup and didn't see any crash..

I'm not convinced that keeping the dropping of the rwsem is the right thing to
do.  As I said in my original email, the whole purpose behind that semaphore is
to single thread writing and the code in question clearly breaks that purpose.

What if the following happens

thread 1: changes max_scaling_freq
thread 2: changes cpufreq governor

when we drop the rwsem?  Who knows what we end up with?  If we're going to start
to serialize operations, then why not serialize the entirety of the
cpufreq_set_policy function.  Maybe then we can drop the rwsem in its entirety.

A different approach is necessary here to fix the locking (that is, if we want
to keep the locking in it's current form).  The locking is clearly broken at
this point.

I'll try to dig in further to see if I can reproduce the above lock inversion.

P.
