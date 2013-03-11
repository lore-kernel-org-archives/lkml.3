Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3CKOq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:46:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:55052 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CKOq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:46:26 -0400
Message-ID: <513DEE39.2040204@windriver.com>
Date: Mon, 11 Mar 2013 09:46:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 07/13] tracing/kdb: remove redundant checking
References: <513D8437.8060400@huawei.com> <1363010968.12608.6.camel@gandalf.local.home>
In-Reply-To: <1363010968.12608.6.camel@gandalf.local.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 09:09 AM, Steven Rostedt wrote:
> This is Jason's code.
>
> Jason, please give an Ack or Nack.
>
> Thanks,
>
> -- Steve
>
>
> On Mon, 2013-03-11 at 15:13 +0800, zhangwei(Jovi) wrote:
>> trace_empty is checking in while-loop, so the previous checking
>> is totally redundant, and more worse, the first trace entry is losted.
>>
>> so remove it.
>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>> ---
>>  kernel/trace/trace_kdb.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
>> index 3c5c5df..6489b2e 100644
>> --- a/kernel/trace/trace_kdb.c
>> +++ b/kernel/trace/trace_kdb.c
>> @@ -57,8 +57,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>>  		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
>>  		tracing_iter_reset(&iter, cpu_file);
>>  	}
>> -	if (!trace_empty(&iter))
>> -		trace_find_next_entry_inc(&iter);
>> +
>>  	while (!trace_empty(&iter)) {
>>  		if (!cnt)
>>  			kdb_printf("---------------------------------\n");
>


This was just a copy of part of the logic used for printing the information in a similar manner to what you get when you cat the trace buffer to obtain the human readable version.

May I ask how you tested it though?

As far as I know the patch I sent Stephen quite a while ago got lost and the mainline version of the "ftdump" doesn't actually work.

Example:
[0]kdb> ftdump
Dumping ftrace buffer:
3BUG: sleeping function called from invalid context at /space/jw/git/kgdb/linux-2.6-kgdb/mm/slub.c:925
3in_atomic(): 1, irqs_disabled(): 1, pid: 81, name: sh
Pid: 81, comm: sh Not tainted 3.9.0-rc1-WR4.3.0.0_standard+ #568
Call Trace:
 <#DB>  [<ffffffff81069ffe>] __might_sleep+0xde/0x100
 [<ffffffff8112611b>] kmem_cache_alloc_trace+0xdb/0x170
 [<ffffffff810c01bd>] ring_buffer_read_prepare+0x4d/0x70
 [<ffffffff810d4d28>] kdb_ftdump+0x1e8/0x410
 [<ffffffff810a9a89>] kdb_parse+0x209/0x690
 [<ffffffff810aad0c>] kdb_main_loop+0x67c/0x8c0
 [<ffffffff810ad4b3>] kdb_stub+0x1d3/0x420
 [<ffffffff8104ccfd>] ? __send_signal+0x1ad/0x3e0
 [<ffffffff810a33be>] kgdb_cpu_enter+0x27e/0x590
 [<ffffffff810a3981>] kgdb_handle_exception+0x161/0x1c0
 [<ffffffff81027cf1>] __kgdb_notify+0x31/0xe0
 [<ffffffff81027e10>] kgdb_ll_trap+0x40/0x50
 [<ffffffff81002e12>] do_int3+0x52/0x130
 [<ffffffff81674345>] int3+0x25/0x40
 [<ffffffff810a2be2>] ? sysrq_handle_dbg+0x32/0x60
 <<EOE>>  [<ffffffff813e1e69>] __handle_sysrq+0x129/0x190


I think we need to actually empirically prove the code change is right or wrong before merging it, as well as cleaning up the change log slightly.

I'll go hunt down the patch the fixes the oops first.

Cheers,
Jason.
