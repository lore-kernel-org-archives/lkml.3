Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295Ab3DPVFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:05:23 -0400
Received: from www.sr71.net ([198.145.64.142]:35276 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965213Ab3DPVFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:05:22 -0400
Message-ID: <516DBD12.4030006@sr71.net>
Date: Tue, 16 Apr 2013 14:05:22 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: sched/cputime: sig->prev_stime underflow
References: <515DBB00.20208@sr71.net> <CAFTL4hxnNyWbn47PxPZDibzgOcqtw8v+t3EEzn+AM_pzFM=YeQ@mail.gmail.com> <5162E8DC.4080204@sr71.net> <20130411074529.GA1629@redhat.com> <51670549.70205@sr71.net> <20130416110651.GB620@redhat.com>
In-Reply-To: <20130416110651.GB620@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 04:06 AM, Stanislaw Gruszka wrote:
> On Thu, Apr 11, 2013 at 11:47:37AM -0700, Dave Hansen wrote:
>> On 04/11/2013 12:45 AM, Stanislaw Gruszka wrote:
>>> On Mon, Apr 08, 2013 at 08:57:16AM -0700, Dave Hansen wrote:
>>>> On 04/04/2013 04:41 PM, Frederic Weisbecker wrote:
>>>>> Does this patch fix the issue for you?
>>>>> https://lkml.org/lkml/2013/4/4/112
>>>>
>>>> Nope, that doesn't seem to make a difference.  I'm still seeing the
>>>> underflow.  I'm pretty sure it's already gone to hell by the time it
>>>> gets in to the loop that's patched there.
>>>
>>> Perhaps this is glich introduced by commit 
>>> 62188451f0d63add7ad0cd2a1ae269d600c1663d "cputime: Avoid multiplication
>>> overflow on utime scaling" . Could you try to revert it and see if that
>>> helps. If it does not, can you check if problem happen on 3.8 ?
>>
>> I'll run a bit longer, but reverting
>> 62188451f0d63add7ad0cd2a1ae269d600c1663d _does_ seem to make it happier.
> 
> Hmm, I supposed glitch in this commit because it something that was
> changed recently and previously we did not have such bug reports. But
> I do not see mistake there. Basically prev->stime should never be
> bigger than rtime, since at any moment stime <= rtime and previous
> rtime <= current rtime. So this looks like rtime decrease and for
> some reason before 62188451f0d it does not manifest as a bug.
> 
> It can be fixed by comparing prev->stime < rtime or by something
> like first attached patch. Not sure what will be better.

The first patch does appear to fix the issue for me.

> But since this (most likely) is rtime monotonicity problem it
> is bug by itself and probably that should be fixed. Can you 
> check second patch attached and see if it trigger the warning.

Yup, it triggers lots of warnings.  Here's one.

> [  460.789710] ------------[ cut here ]------------
> [  460.789730] WARNING: at /home/davehans/linux.git/kernel/sched/cputime.c:563 cputime_adjust+0xe6/0xf0()
> [  460.789736] Hardware name: PRIMEQUEST 1800E2
> [  460.789739] Modules linked in:
> [  460.789745] Pid: 4245, comm: top Tainted: G        W    3.9.0-rc7-00004-gbb33db7-dirty #19
> [  460.789748] Call Trace:
> [  460.789777]  [<ffffffff810c6dc7>] warn_slowpath_common+0xb7/0x120
> [  460.789783]  [<ffffffff810c6e5a>] warn_slowpath_null+0x2a/0x40
> [  460.789789]  [<ffffffff8111a8d6>] cputime_adjust+0xe6/0xf0
> [  460.789795]  [<ffffffff8111b755>] ? thread_group_cputime+0x5/0x140
> [  460.789800]  [<ffffffff8111bbb9>] thread_group_cputime_adjusted+0x59/0x70
> [  460.789810]  [<ffffffff813179b5>] do_task_stat+0xc35/0xef0
> [  460.789821]  [<ffffffff8114306f>] ? __lock_acquire+0x3ff/0x1010
> [  460.789827]  [<ffffffff8114048d>] ? lock_release_holdtime+0x4d/0x270
> [  460.789832]  [<ffffffff81318a0c>] proc_tgid_stat+0x1c/0x30
> [  460.789841]  [<ffffffff813117db>] proc_single_show+0x7b/0xf0
> [  460.789848]  [<ffffffff812ace19>] seq_read+0x139/0x620
> [  460.789857]  [<ffffffff812894ae>] ? final_putname+0x2e/0x80
> [  460.789866]  [<ffffffff81278e4b>] vfs_read+0xdb/0x230
> [  460.789871]  [<ffffffff81279221>] sys_read+0x81/0xf0
> [  460.789881]  [<ffffffff819b3542>] system_call_fastpath+0x16/0x1b
> [  460.789883] ---[ end trace fbba451b40d2c6c7 ]---

