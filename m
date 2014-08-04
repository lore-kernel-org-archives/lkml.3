Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaHDMZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbaHDMZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:25:50 -0400
Message-ID: <53DF7BC4.9070500@redhat.com>
Date: Mon, 04 Aug 2014 08:25:40 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com> <53DAA95B.2040505@codeaurora.org> <53DAB038.3050007@redhat.com> <53DABFA6.6090503@codeaurora.org> <53DACA26.1000908@redhat.com> <53DAE592.2030909@codeaurora.org> <53DB6B81.6050400@redhat.com> <53DBCBE8.6010809@codeaurora.org> <CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com>
In-Reply-To: <CAKohpom0KycrB8qJDM7yEOHOn76J1sEe90CG+JXERJMcxKnOJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/04/2014 06:36 AM, Viresh Kumar wrote:
> Sorry for the delay guys, was away :(
> 
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&policy->rwsem);
>>                                 lock(s_active#9);
>>                                 lock(&policy->rwsem);
>>    lock(s_active#9);
>>
> 
> Thanks for coming to my rescue Stephen :), I was quite sure I got this
> with ondemand
> as well..

Yeah, I'm confused by it a bit because I wasn't able to reproduce it.  But I've
got some pretty clear instructions on how to do it.

> 
> I will be looking very closely at the code now to see what's going wrong.
> And btw, does anybody here has the exact understanding of why this
> lockdep does happen? I mean what was the real problem for which we

The issue is the collision between the setup & teardown of the policy's governor
sysfs files.

On creation the kernel does:

down_write(&policy->rwsem)
mutex_lock(kernfs_mutex) <- note this is similar to the "old" sysfs_mutex.

The opposite happens on a governor switch, specifically the existing governor's
exit, and then we get a lockdep warning.

I tried to reproduce with the instructions but was unable to ... ut that was on
Friday ;) and I'm going to try again this morning.  I've also ping'd some of the
engineers here in the office who are working on ARM to get access to a system to
do further analysis and testing.

I'll ping back later in the day with some results.

Sorry I don't have a better answer or solution yet, Viresh.

P.
