Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3D0Nka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 09:40:30 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53032 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3D0Nk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 09:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <1367056747.6391.15.camel@ThinkPad-T5421.cn.ibm.com>
References: <1367056747.6391.15.camel@ThinkPad-T5421.cn.ibm.com>
Date: Sat, 27 Apr 2013 15:40:28 +0200
Message-ID: <CAFTL4hwVXS9s7n=0Ji4+5cbOQSROk53OxMAWY3U=bzRPRijr9w@mail.gmail.com>
Subject: Re: [RFC PATCH]nohz: Use raw_smp_processor_id() in tick_nohz_task_switch()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/27 Li Zhong <zhong@linux.vnet.ibm.com>:
> I saw following error when testing the latest nohz code on Power:
>
> [   85.295384] BUG: using smp_processor_id() in preemptible [00000000] code: rsyslogd/3493
> [   85.295396] caller is .tick_nohz_task_switch+0x1c/0xb8
> [   85.295402] Call Trace:
> [   85.295408] [c0000001fababab0] [c000000000012dc4] .show_stack+0x110/0x25c (unreliable)
> [   85.295420] [c0000001fababba0] [c0000000007c4b54] .dump_stack+0x20/0x30
> [   85.295430] [c0000001fababc10] [c00000000044eb74] .debug_smp_processor_id+0xf4/0x124
> [   85.295438] [c0000001fababca0] [c0000000000d7594] .tick_nohz_task_switch+0x1c/0xb8
> [   85.295447] [c0000001fababd20] [c0000000000b9748] .finish_task_switch+0x13c/0x160
> [   85.295455] [c0000001fababdb0] [c0000000000bbe50] .schedule_tail+0x50/0x124
> [   85.295463] [c0000001fababe30] [c000000000009dc8] .ret_from_fork+0x4/0x54
>
> It seems to me that we could just use raw_smp_processor_id() here. Even
> if the tick_nohz_full_cpu() check is done on a !nohz_full cpu, then the
> task is moved to another nohz_full cpu, it seems the context switching
> because of the task moving would call tick_nohz_task_switch() again to
> evaluate the need for tick.
>
> I don't know whether I missed something here.

You're right it looks safe to do so. But I suggest we rather move the
test inside local_irq_save()/restore section to avoid confusion on
reviewers minds.

Thanks!
