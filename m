Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3KZHUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:20:32 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41499 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3KZHUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:20:30 -0500
MIME-Version: 1.0
In-Reply-To: <5294409F.70508@hitachi.com>
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
	<5294409F.70508@hitachi.com>
Date: Tue, 26 Nov 2013 15:20:29 +0800
Message-ID: <CAGdX0WGVDX9FzBL2tJUTx3oHBPopK74OOrFzThR_7m3GxQUs3Q@mail.gmail.com>
Subject: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 2:33 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/11/26 13:38), Jovi Zhangwei wrote:
>> Hi,
>>
>> I'm not sure this issue already be fixed or not, it can be reproduced
>> permanently.
>>
>> (I didn't use git-bisect yet, you guys might can understand it quickly)
>>
>> #echo 1 > /sys/kernel/debug/tracing/events/enable
>
> Thanks for reporting. I could reproduce it.
>
> To narrow this down, I tried to run the below command
>
> [tracing]# for i in events/*/*/enable ; do echo $i; echo 1 > $i; done
>
> And it ran through the end without any problem.
> Hm, next I checked the difference of available_events and set_event.
>
> [tracing]# diff available_events set_event
> 283d282
> < ftrace:function
>
> So, I guess it was caused by enabling ftrace:function, and
> it is unable to do that via set_event, nor events/ftrace/enable
> I'm not sure how, but it seems that ftrace:function can be
> enabled by the events/enable.
>
I'm not sure this relate with ftrace:function event, from the
crash log, it seems more like caused by lock events.

Now I only enable lock events (lockdep compiled in my box), below
two commands both can crash system.

#echo 1 > /sys/kernel/debug/tracing/events/lock/lock_acquire/enable
or.
#echo 1 > /sys/kernel/debug/tracing/events/lock/lock_release/enable

According to the log, it seems like a recursion tracing bug.

register lock event -> jump_label_update -> text_poke_bp ->
on_each_cpu -> local_apic_timer_interrupt -> ktime_get_update_offsets
-> lock_release

(Perhaps the crash you reproduced is another crash? similar crash log?)

Jovi
