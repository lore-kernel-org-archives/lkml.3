Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3CAKya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:54:30 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36778 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3CAKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:54:27 -0500
Message-ID: <513088E0.4090704@hitachi.com>
Date: Fri, 01 Mar 2013 19:54:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Timo Juhani Lindfors <timo.lindfors@iki.fi>
Cc: ananth@in.ibm.com, linux-kernel@vger.kernel.org,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: kprobing "hash_64.constprop.26" crashes the system, recursion
 through get_kprobe?
References: <84ehg2jdny.fsf@sauna.l.org> <20130301053123.GA30500@in.ibm.com> <513041D0.4010209@hitachi.com> <84sj4fik71.fsf@sauna.l.org>
In-Reply-To: <84sj4fik71.fsf@sauna.l.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/01 17:43), Timo Juhani Lindfors wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>>> I am unable to recreate this problem on a fedora system; hash_64 is
>>> inlined AFAICS.
> 
> Thanks testing. How does the disassembly of get_kprobes look for you?

Actually, there is no "call" instruction in get_kprobe.

>> I also tried and couldn't recreate hash_64 problem on my ubuntu 12.10.
>> Could you tell us your kconfig?
> 
> Sure, see
> 
> http://lindi.iki.fi/lindi/config-3.7-trunk-amd64_3.7.3-1~experimental.1

Thanks! I'll check that.

> 
> Note that I am doing the tests under xen. Should I redo the tests under
> kvm?

No, I think the issue should be reproduced again even on kvm.

>>> This is a clear case of recursion. Either of the two options should fix
>>> the problem.
>>
>> I think __kprobes is better if it works, because it causes kprobes
>> issue (no problem in other parts).
>> (Again, since I can't reproduce this hash_64.constprop,
>> I'm not sure that __kprobes can fix that clearly.)

OK, I've ensured that __kprobes on an inline function (I used kzalloc
for test) moves all constprop instances into .kprobes.text section.
So I think it can fix your case too.

> Ok. My worry is that hash_64 is not the only function that is called
> from a __kprobes marked function. For example kprobes_module_callback
> calls mutex_lock. Should we also mark mutex_lock with __kprobes?

No, you don't need to do it, because kprobes_module_callback
is never called from the probe handler (unless user doesn't do)

This recursive call issue happens when the probe point(function)
is executed inside the kprobe int3 handler. In your case,
it happened on the kprobe_exceptions_notify(inlined kprobe_handler code)
which is called from do_int3 via notify_die.

> 
> Based on the disassembly of code between __kprobes_text_start and
> __kprobes_text_end I made a function call graph that shows functions
> that get called from this region:
> 
> http://lindi.iki.fi/lindi/kprobes/function-call-graph1.png
> 
> The __kprobes functions are marked with red color. I had to omit
> mutex_lock, mutex_unlock and printk from the graph to make it readable
> (I also omited functions that don't call other functions). As you can
> see, this is quite a minefield :)

Actually, __kprobes is used much more than we need, because that
is safer (and also, that is used just for marking functions
related to kprobes).

Only what functions we need to mark __kprobes is the functions
called from do_int3, and optimized_callback, until processing
recursive call (which is done by kprobe_running() and
reenter_kprobe()).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


