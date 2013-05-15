Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3EODPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:15:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61609 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3EODPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:15:49 -0400
Message-ID: <5192FDE2.1020305@lwfinger.net>
Date: Tue, 14 May 2013 22:15:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: V3.10-rc1 memory leak
References: <51912567.6090507@lwfinger.net>  <1368558586.6828.53.camel@gandalf.local.home>  <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net>  <1368566427.6828.58.camel@gandalf.local.home> <1368579423.6828.63.camel@gandalf.local.home>
In-Reply-To: <1368579423.6828.63.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 07:57 PM, Steven Rostedt wrote:
> On Tue, 2013-05-14 at 17:20 -0400, Steven Rostedt wrote:
>> On Tue, 2013-05-14 at 16:10 -0500, Larry Finger wrote:
>>> On 05/14/2013 03:30 PM, Catalin Marinas wrote:
>>>>
>>>> I just got a patch today:
>>>>
>>>> https://lkml.org/lkml/2013/5/10/607
>>>>
>>>> which could be related. If Rusty doesn't push it I'll do. But please let
>>>> me know if it does not solve the problem.
>>>
>>> This patch fixes my problem. Now I can see the next new problem reported by
>>> kmemleak. :)
>>>
>>> Thanks to you and Jianpeng Ma,
>>>
>>> Larry
>>>
>>
>> It goes away on my testing too. So you can add:
>>
>> Tested-by: Steven Rostedt <rostedt@goodmis.org>
>>
>
> But we are not out of the woods yet. I'm also getting these:
>
> unreferenced object 0xffff88007800efc0 (size 32):
>    comm "modprobe", pid 1309, jiffies 4294697214 (age 188.356s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 a8 d0 3e a0 ff ff ff ff  ..........>.....
>      30 d1 3e a0 ff ff ff ff 00 00 00 00 00 00 00 00  0.>.............
>    backtrace:
>      [<ffffffff814b535f>] kmemleak_alloc+0x73/0x98
>      [<ffffffff8112003c>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
>      [<ffffffff81120dfe>] kmem_cache_alloc_trace+0xc0/0x10b
>      [<ffffffff810e5478>] jump_label_module_notify+0xce/0x1d5
>      [<ffffffff814d221d>] notifier_call_chain+0x37/0x63
>      [<ffffffff8105c29c>] __blocking_notifier_call_chain+0x4b/0x60
>      [<ffffffff8105c2c5>] blocking_notifier_call_chain+0x14/0x16
>      [<ffffffff8108fe83>] load_module+0x1d7f/0x20d3
>      [<ffffffff810902b0>] SyS_init_module+0xd9/0xdb
>      [<ffffffff814d5754>] tracesys+0xdd/0xe2
>      [<ffffffffffffffff>] 0xffffffffffffffff
>
> Where it points to the allocation in jump_label_add_module() where it
> allocates the jlm. And this does get freed in jump_label_del_module(). I
> put in printks in add_module():
>
> 	printk("alloc %p (%s)\n", jlm, mod->name);
>
> and in del_module:
>
> 	printk("free %p (%s)\n", jlm, mod->name);
>
> And got this:
>
> [   29.917577] alloc ffff88007800efc0 (kvm_intel)
>
>
> And removing kvm_intel, I got:
>
> [  364.965916] free ffff88007800efc0 (kvm_intel)
>
>
> Thus it seems to be yet another false positive :-(

I do not see that particular one; however, I see 4 instances of

unreferenced object 0xffff8800b7979750 (size 8):
   comm "swapper/0", pid 1, jiffies 4294892402 (age 21888.316s)
   hex dump (first 8 bytes):
     31 38 00 b7 00 88 ff ff                          18......
   backtrace:
     [<ffffffff81432ea1>] kmemleak_alloc+0x21/0x50
     [<ffffffff81145d50>] __kmalloc_track_caller+0x140/0x2b0
     [<ffffffff81119fb5>] kstrdup+0x35/0x70
     [<ffffffff8125febc>] acpi_set_pnp_ids+0xd0/0x304
     [<ffffffff81260c47>] acpi_scan_init_hotplug+0x47/0xa1
     [<ffffffff81261223>] acpi_bus_check_add+0x66/0xd7
     [<ffffffff8127877a>] acpi_ns_walk_namespace+0xb9/0x173
     [<ffffffff81278bf3>] acpi_walk_namespace+0x93/0xc6
     [<ffffffff812612dc>] acpi_bus_scan+0x48/0x9a
     [<ffffffff818c983d>] acpi_scan_init+0x57/0x14b
     [<ffffffff818c966a>] acpi_init+0x244/0x286
     [<ffffffff810002fa>] do_one_initcall+0x10a/0x160
     [<ffffffff8189cef0>] kernel_init_freeable+0x103/0x192
     [<ffffffff814313a9>] kernel_init+0x9/0xf0
     [<ffffffff8144992c>] ret_from_fork+0x7c/0xb0
     [<ffffffffffffffff>] 0xffffffffffffffff

All four were allocated early in the bootup, and are the only leaks reported in 
my system. I have not yet tested to see if they are false.

Larry


