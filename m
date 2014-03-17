Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaCQTbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:31:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43709 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQTbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:31:37 -0400
Message-ID: <53274D93.8030105@oracle.com>
Date: Mon, 17 Mar 2014 15:31:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] improve_stack: make stack dump output useful again
References: <1394994799-2221-1-git-send-email-sasha.levin@oracle.com> <CA+55aFx-4XM3qzbEf1kgSDsuUm22sWCYHVaqK2D+juvHY3WEeg@mail.gmail.com>
In-Reply-To: <CA+55aFx-4XM3qzbEf1kgSDsuUm22sWCYHVaqK2D+juvHY3WEeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2014 02:55 PM, Linus Torvalds wrote:
> On Sun, Mar 16, 2014 at 11:33 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> The only useful thing above is the function name. Due to the amount of
>> different kernel code versions and various configurations being used, the
>> kernel address and the offset into the function are not really helpful in
>> determining where the problem actually occured.
>
> Actually, the offset into the function is very useful both for a local
> kernel (when it tells you exactly where it is) and for external
> bug-reports (where it's more of a hint about where things are).
>
> So I think the "not really helpful" description about the offset in
> particular is misleading and actively incorrect.
>
> The size part is not generally so useful, although for external
> bug-reports it's an important part of making sense of the offset
> (because, as you say, config options can have such huge impact on code
> generation).
>
> HOWEVER. I agree that *if* you have debug info, and can look up file
> and line number, then both offset and size end up being less than
> interesting. So I wonder if your script should remove offset/size iff
> the debug info can be found. IOW, for your example:
>
>    [  324.019502]  dump_stack+0x52/0x7f (lib/dump_stack.c:52)
>    [  324.020206]  warn_slowpath_common+0x8c/0xc0 (kernel/panic.c:418)
>    [  324.020289]  ? noop_count+0x10/0x10 (kernel/locking/lockdep.c:1315)
>    [  324.020289]  warn_slowpath_null+0x1a/0x20 (kernel/panic.c:453)
>    [  324.020289]  __bfs+0x113/0x240 (kernel/locking/lockdep.c:962
> kernel/locking/lockdep.c:1027)
>    [  324.020289]  find_usage_backwards+0x80/0x90 (kernel/locking/lockdep.c:1365)
>    [  324.020289]  check_usage_backwards+0xb7/0x100
> (kernel/locking/lockdep.c:2379)
>
>
> maybe you could simplify this to just
>
>    [  324.019502]  dump_stack (lib/dump_stack.c:52)
>    [  324.020206]  warn_slowpath_common (kernel/panic.c:418)
>    [  324.020289]  ? noop_count (kernel/locking/lockdep.c:1315)
>    [  324.020289]  warn_slowpath_null (kernel/panic.c:453)
>    [  324.020289]  __bfs (kernel/locking/lockdep.c:962
> kernel/locking/lockdep.c:1027)
>    [  324.020289]  find_usage_backwards (kernel/locking/lockdep.c:1365)
>    [  324.020289]  check_usage_backwards (kernel/locking/lockdep.c:2379)
>
> but only do that when addr2line actually works. Right now you don't
> seem to handle the "addr2line fails" case (it seems to return 0
> regardless, and just output "??:?" when it can't find line number
> information).
>
> Other than that nit, the concept certainly looks fine to me.

What about duplicate symbol names? Without the full hex address we lose
the ability to correctly translate from symbol name to file/line.

Take a look at 'kthread' for example, if we rely on just the symbol name
we'll have two possible options:

	$ nm vmlinux | grep -e ' kthread$'
	ffffffff8116b190 t kthread
	ffffffff83116850 t kthread

Both of which are valid addresses for kthread, pointing at their respective
owners:

	$ nm vmlinux | grep -e ' kthread$' | awk {'print $1'} | xargs addr2line -i -e vmlinux
	/home/sasha/linux-next/kernel/kthread.c:185
	/home/sasha/linux-next/drivers/block/aoe/aoecmd.c:1289

So when going through a stack trace, without looking at the full address both
of the above are valid options.


Thanks,
Sasha
