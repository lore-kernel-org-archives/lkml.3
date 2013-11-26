Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3KZK1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:27:31 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35802 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3KZK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:27:28 -0500
Message-ID: <52947783.2040700@hitachi.com>
Date: Tue, 26 Nov 2013 19:27:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com> <5294409F.70508@hitachi.com> <CAGdX0WGVDX9FzBL2tJUTx3oHBPopK74OOrFzThR_7m3GxQUs3Q@mail.gmail.com> <52946261.8020408@hitachi.com>
In-Reply-To: <52946261.8020408@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/26 17:57), Masami Hiramatsu wrote:
> (2013/11/26 16:20), Jovi Zhangwei wrote:
>> I'm not sure this relate with ftrace:function event, from the
>> crash log, it seems more like caused by lock events.
>>
>> Now I only enable lock events (lockdep compiled in my box), below
>> two commands both can crash system.
> 
> That is not the lockdep, but the lockstat. :)
> 
>>
>> #echo 1 > /sys/kernel/debug/tracing/events/lock/lock_acquire/enable
>> or.
>> #echo 1 > /sys/kernel/debug/tracing/events/lock/lock_release/enable
>>
>> According to the log, it seems like a recursion tracing bug.
>>
>> register lock event -> jump_label_update -> text_poke_bp ->
>> on_each_cpu -> local_apic_timer_interrupt -> ktime_get_update_offsets
>> -> lock_release
> 
> OK, the problem is in the lock_acquire/release events.

Hm, it seems that the bug is caused because lock->name is NULL in
ftrace_raw_event_lock(_acquire). To allocate a buffer on ring_buffer,
ftrace_raw_event_##call tries to measure the length of lock->name
but it causes a memory access violation in ftrace_get_offsets_##call
because lock->name is NULL. :(

I could fix this by checking lock->name in include/trace/events/lock.h

e.g.
        TP_STRUCT__entry(
                __field(unsigned int, flags)
                __string(name, lock->name ?: "NULL")
                __field(void *, lockdep_addr)
        ),

        TP_fast_assign(
                __entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
                __assign_str(name, lock->name ?: "NULL");
                __entry->lockdep_addr = lock;
        ),

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


