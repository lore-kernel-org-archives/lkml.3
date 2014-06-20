Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaFTDOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:14:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60432 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaFTDOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:14:37 -0400
Message-ID: <53A3A715.80805@hitachi.com>
Date: Fri, 20 Jun 2014 12:14:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "systemtap@sources.redhat.com" <systemtap@sources.redhat.com>
Subject: Re: [PATCH -tip v2 0/3] ftrace, kprobes: Introduce IPMODIFY flag
 for ftrace_ops to detect conflicts
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal> <20140619020831.GA21146@treble.redhat.com> <53A26F23.1050702@hitachi.com> <20140619141857.GA17328@treble.hsd1.ky.comcast.net>
In-Reply-To: <20140619141857.GA17328@treble.hsd1.ky.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/19 23:18), Josh Poimboeuf wrote:
> On Thu, Jun 19, 2014 at 02:03:31PM +0900, Masami Hiramatsu wrote:
>> (2014/06/19 11:08), Josh Poimboeuf wrote:
>>> On Tue, Jun 17, 2014 at 11:04:36AM +0000, Masami Hiramatsu wrote:
>>>> Hi,
>>>>
>>>> Here is the version 2 of the series of patches which introduces
>>>> IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
>>>> who can modify regs->ip in their handler.
>>>> In this version, I fixed some bugs in previous version and
>>>> added a patch which made kprobe itself free from IPMODIFY
>>>> except for jprobe.
>>>
>>> Hi Masami,
>>>
>>> This seems better, but I still saw a few issues.  I'm not sure if the
>>> issues are specific to stap or kprobes.  For the following issues I used
>>> this command to set a kprobe:
>>>
>>>   stap -v -e 'probe kernel.function("meminfo_proc_show") {printf("meminfo_proc_show called\n");}'
>>>
>>> With patches 1-2, when I used stap to kprobe the function after it was
>>> already kpatched, stap didn't return an error and instead acted like it
>>> succeeded (though the probe didn't work):
>>>
>>>   $ sudo stap -v -e 'probe kernel.function("meminfo_proc_show") {printf("meminfo_proc_show called\n");}'
>>>   Pass 1: parsed user script and 112 library script(s) using 221516virt/41612res/6028shr/36228data kb, in 130usr/0sys/132real ms.
>>>   Pass 2: analyzed script: 1 probe(s), 0 function(s), 0 embed(s), 0 global(s) using 255840virt/77132res/7132shr/70552data kb, in 510usr/20sys/577real ms.
>>>   Pass 3: translated to C into "/tmp/stap3Qunba/stap_2690192fea570fb7bba78c7ed7fa1e0d_898_src.c" using 255840virt/77392res/7392shr/70552data kb, in 10usr/0sys/4real ms.
>>>   Pass 4: compiled C into "stap_2690192fea570fb7bba78c7ed7fa1e0d_898.ko" in 5020usr/640sys/7105real ms.
>>>   Pass 5: starting run.
>>>   (no error)
>>
>> Yeah, I guess you can see some warning messages in dmesg (by
>> arm_kprobe) at this point.
> 
> Ah, you're right:
> 
>   Jun 19 08:03:10 treble kernel: ------------[ cut here ]------------
>   Jun 19 08:03:10 treble kernel: WARNING: CPU: 1 PID: 17991 at kernel/kprobes.c:953 arm_kprobe+0xa7/0xe0()
>   Jun 19 08:03:10 treble kernel: Failed to init kprobe-ftrace (-16)
>   Jun 19 08:03:10 treble kernel: Modules linked in: stap_1faf9cc0ccf85c0d203c74ab6f604b_17991(OE) ...defra
>   Jun 19 08:03:10 treble kernel:  videobuf2_vmalloc serio_raw microcode sdhci_pci bluetooth videobuf2_m...
>   Jun 19 08:03:10 treble kernel: CPU: 1 PID: 17991 Comm: stapio Tainted: G     U  W  OE 3.15.0+ #1
>   Jun 19 08:03:10 treble kernel: Hardware name: LENOVO 2356BH8/2356BH8, BIOS G7ET63WW (2.05 ) 11/12/2012
>   Jun 19 08:03:10 treble kernel:  0000000000000000 000000009023f19e ffff8803dcce7d80 ffffffff816f31fd
>   Jun 19 08:03:10 treble kernel:  ffff8803dcce7dc8 ffff8803dcce7db8 ffffffff8108914d ffffffffa08248e0
>   Jun 19 08:03:10 treble kernel:  ffffffffa08248f0 0000000000000000 0000000000000000 0000000000000000
>   Jun 19 08:03:10 treble kernel: Call Trace:
>   Jun 19 08:03:10 treble kernel:  [<ffffffff816f31fd>] dump_stack+0x45/0x56
>   Jun 19 08:03:10 treble kernel:  [<ffffffff8108914d>] warn_slowpath_common+0x7d/0xa0
>   Jun 19 08:03:10 treble kernel:  [<ffffffff810891cc>] warn_slowpath_fmt+0x5c/0x80
>   Jun 19 08:03:10 treble kernel:  [<ffffffff816ff9d7>] arm_kprobe+0xa7/0xe0
>   Jun 19 08:03:10 treble kernel:  [<ffffffff817007f7>] register_kprobe+0x557/0x5d0
>   Jun 19 08:03:10 treble kernel:  [<ffffffff81254db0>] ? meminfo_proc_open+0x30/0x30
>   Jun 19 08:03:10 treble kernel:  [<ffffffffa081fc95>] _stp_ctl_write_cmd+0x8d5/0x930 [stap_1faf9c...7991]
>   Jun 19 08:03:10 treble kernel:  [<ffffffff811e5dba>] vfs_write+0xba/0x1e0
>   Jun 19 08:03:10 treble kernel:  [<ffffffff811e6975>] SyS_write+0x55/0xd0
>   Jun 19 08:03:10 treble kernel:  [<ffffffff81703179>] system_call_fastpath+0x16/0x1b
>   Jun 19 08:03:10 treble kernel: ---[ end trace 19615ed55413a30d ]---
> 
> Why not change arm_kprobe() to return an error?

Actually, arm_kprobe() is widely used at deeper point.
And the 3rd patch will solve the problem. So I decided just adding
IPMODIFY flag at the 2nd patch.

>>> With all 3 patches, I expected kprobes and kpatch to be able to ftrace
>>> the same function.  But when I tried to kpatch the function after it was
>>> kprobed, I got the following oops in stap:
>>>
>>>   [  455.842797] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>>>   [  455.843388] IP: [<ffffffffa0833d1e>] _stp_module_notifier+0x1e/0x320 [stap_2690192fea570fb7bba78c7ed7fa1e_20189]
>>
>> Hmm, since this happens in _stp_module_notifier() which is a code in systemtap,
>> I guess it's a systemtap problem.
>>
>> Could you test it with kprobe-tracer as below?
>>
>> # (do something kpatch related activation)
>> # echo p meminfo_proc_show > /sys/kernel/debug/tracing/kprobe_events
>> # echo 1 > /sys/kernel/debug/tracing/events/kprobe/enable
> 
> That worked, thanks.

Moreover, I couldn't reproduced the stap case on my fedora20.
Perhaps, Maybe a different version of systemtap I used.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


