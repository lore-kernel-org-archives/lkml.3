Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3C1BtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:49:25 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:47273 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3C1BtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:49:23 -0400
Date: Wed, 27 Mar 2013 21:49:13 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@Parags-iMac.carolina.rr.com
To: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: intel_pstate_timer_func divide by zero oops
Message-ID: <alpine.LFD.2.03.1303272103380.8412@gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this same oops occassionally - the machine freezes and there doesn't 
seem to be any record of the oops on disk.

I captured it on camera - 
https://lh3.googleusercontent.com/-K0lNbJrZBMQ/UVOU1vv1vvI/AAAAAAAANqI/pY92mWm3caE/s800/20130327_205245.jpg

If I am reading this right, it dies on this instruction -

   0xffffffff8145792d <+349>:   divq   0x18(%rcx)

>From the lst file that *seems* to be this inline function -

static inline void intel_pstate_calc_busy(struct cpudata *cpu,
                                        struct sample *sample)
{
        u64 core_pct;
        sample->pstate_pct_busy = 100 - div64_u64(
ffffffff8145791d:       48 8b 41 20             mov    0x20(%rcx),%rax
ffffffff81457921:       48 8d 04 80             lea    (%rax,%rax,4),%rax
ffffffff81457925:       48 8d 04 80             lea    (%rax,%rax,4),%rax
ffffffff81457929:       48 c1 e0 02             shl    $0x2,%rax
ffffffff8145792d:       48 f7 71 18             divq   0x18(%rcx)


That  is -
	sample->pstate_pct_busy = 100 - div64_u64(
					sample->idletime_us * 100,
					sample->duration_us);

So looks like sample->duration_us is 0? If so, that implies that 
ktime_us_delta(now, cpu->prev_sample) is zero. I am not entirely sure how 
to handle this case - return if sampling too early, or if there is some 
other bug making the delta calculation go poof.


Thanks,

Parag
