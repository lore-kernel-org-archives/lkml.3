Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225AbaEGNi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbaEGNi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:38:57 -0400
Message-ID: <536A3747.5040506@redhat.com>
Date: Wed, 07 May 2014 15:38:15 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] nohz: Fix iowait overcounting if iowait task migrates
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com> <1398365158-12568-4-git-send-email-dvlasenk@redhat.com> <20140429144727.GB6129@localhost.localdomain> <5367D30E.9020901@redhat.com>
In-Reply-To: <5367D30E.9020901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 08:06 PM, Denys Vlasenko wrote:
> On 04/29/2014 04:47 PM, Frederic Weisbecker wrote:
>> On Thu, Apr 24, 2014 at 08:45:58PM +0200, Denys Vlasenko wrote:
>>> +void tick_nohz_iowait_to_idle(int cpu)
>>> +{
>>> +	struct tick_sched *ts = tick_get_tick_sched(cpu);
>>> +	ktime_t now = ktime_get();
>>> +
>>> +	write_seqcount_begin(&ts->idle_sleeptime_seq);
>>> +	ts->iowait_exittime = now;
>>> +	write_seqcount_end(&ts->idle_sleeptime_seq);
>>
>> So now you have two concurrent updaters using the seqcount, which is
>> very dangerous as the counters aren't updated atomically.
>>
>> seqcount is only suitable when there is a single sequential updater.
>> Once you deal with concurrent updaters you need seqlock.
>>
>> And once you add seqlock in the hot scheduler path, you're hitting
>> a big scalability issue.
> 
> What I need here is merely an atomic store.
> The complication is, of course, that, ktime_t is not atomic[64]_t.
> 
> How do you think I can do an atomic store?

Ok, I think a have a version which uses atomic64_t
and is not looking ugly. Sending new patchset now...

