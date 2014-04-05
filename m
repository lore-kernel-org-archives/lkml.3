Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaDEO5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 10:57:17 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43433 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaDEO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 10:57:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140405100813.GA16696@localhost.localdomain>
References: <5338CC86.9080602@jp.fujitsu.com> <5338CE0B.1050100@jp.fujitsu.com>
 <CAK1hOcMmmq=5EVLBrAd44HC+EHrnztABU48gd9BgK+LUNBJSOQ@mail.gmail.com>
 <20140404160328.GA10042@localhost.localdomain> <CAK1hOcMZPDhUzvJk0Q0rkkBh1tS=O+HU9ufEmX7VwnjhsSgQeA@mail.gmail.com>
 <20140405100813.GA16696@localhost.localdomain>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 5 Apr 2014 16:56:54 +0200
Message-ID: <CAK1hOcO2X7juCSkKrd85q8_i8Xv4vhZg2YKtzybwmWukoCEyow@mail.gmail.com>
Subject: Re: [PATCH 1/2] nohz: use seqlock to avoid race on idle time stats v2
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2014 at 12:08 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > Iowait makes sense but not per cpu. Eventually it's a global
>> > stat. Or per task.
>>
>> There a lot of situations where admins want to know
>> how much, on average, their CPUs are idle because
>> they wait for IO.
>>
>> If you are running, say, a Web cache,
>> you need to know that stat in order to be able to
>> conjecture "looks like I'm IO bound, perhaps caching
>> some data in RAM will speed it up".
>
> But then accounting iowait time waited until completion on the CPU
> that the task wakes up should work for that.
>
> Doesn't it?

It can easily make iowait count higher than idle count,
or even higher than idle+sys+user+nice count.

IOW, it can show that the system is way more
than 100% IO bound, which doesn't make sense.


> So we save, per task, the time when the task went to sleep. And when it wakes up
> we just flush the pending time since that sleep time to the waking CPU:
> iowait[$CPU] += NOW() - tsk->sleeptime;
>
>> Is such counter meaningful for the admin?
>
> Well, you get the iowait time accounting.

Admin wants to know "how often do I have CPU idled
because they have nothing to do until IO is complete?"

Merely knowing how much tasks waited for IO
doesn't answer that question.
