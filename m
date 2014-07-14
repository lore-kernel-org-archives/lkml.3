Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaGNISk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:18:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36699 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaGNISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:18:31 -0400
Message-ID: <53C39250.20200@hitachi.com>
Date: Mon, 14 Jul 2014 17:18:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
References: <20140703200750.648550267@goodmis.org> <20140710213620.GA19858@treble.redhat.com> <alpine.LNX.2.00.1407102342050.8779@pobox.suse.cz> <53BF4B5A.3000302@hitachi.com> <alpine.LNX.2.00.1407111523270.8779@pobox.suse.cz> <20140711142928.GA13037@treble.redhat.com> <53C333D9.4030907@hitachi.com> <87ion02yx3.fsf@sejong.aot.lge.com>
In-Reply-To: <87ion02yx3.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/14 16:16), Namhyung Kim wrote:
> Hi Masami,
> 
> On Mon, 14 Jul 2014 10:35:21 +0900, Masami Hiramatsu wrote:
>> (2014/07/11 23:29), Josh Poimboeuf wrote:
>> [...]
>>>
>>> >From 951d2aec17885a62905df6b910dc705d99c63993 Mon Sep 17 00:00:00 2001
>>> From: Josh Poimboeuf <jpoimboe@redhat.com>
>>> Date: Fri, 11 Jul 2014 08:58:33 -0500
>>> Subject: [PATCH] x86/dumpstack: fix stack traces for generated code
>>>
>>> If a function in the stack trace is dynamically generated, for example an
>>> ftrace dynamically generated trampoline, print_context_stack() gets confused
>>> and ends up showing all the following addresses as unreliable:
>>>
>>>   [  934.546013]  [<ffffffff81700312>] dump_stack+0x45/0x56
>>>   [  934.546020]  [<ffffffff8125f5b0>] ? meminfo_proc_open+0x30/0x30
>>>   [  934.546027]  [<ffffffffa080a494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
>>>   [  934.546058]  [<ffffffff812143ae>] ? seq_read+0x2de/0x3b0
>>>   [  934.546062]  [<ffffffff812143ae>] ? seq_read+0x2de/0x3b0
>>>   [  934.546067]  [<ffffffff8125f5b5>] ? meminfo_proc_show+0x5/0x5e0
>>>   [  934.546071]  [<ffffffff8125f5b5>] ? meminfo_proc_show+0x5/0x5e0
>>>   [  934.546075]  [<ffffffff8121423a>] ? seq_read+0x16a/0x3b0
>>>   [  934.546081]  [<ffffffff8125768d>] ? proc_reg_read+0x3d/0x80
>>>   [  934.546088]  [<ffffffff811f0668>] ? vfs_read+0x98/0x170
>>>   [  934.546093]  [<ffffffff811f1345>] ? SyS_read+0x55/0xd0
>>>   [  934.546099]  [<ffffffff81707969>] ? system_call_fastpath+0x16/0x1b
>>>
>>> Once it encounters an address which is not in the kernel's text area, it gets
>>> confused and stops updating the frame pointer.
>>
>> Right, this uses a module_alloc to get a memory for trampline, but
>> it just allocates a page in executable vmalloc area. We need a hack
>> in __kernel_text_address if we really want to use that.
>>
>>> The __kernel_text_address() check isn't needed when determining whether an
>>> address is reliable.  It's only needed when deciding whether to print an
>>> unreliable address.
>>
>> Yeah, I guess that is for the case that the frame pointer is broken.
>>
>>>
>>> Here's the same stack trace with this patch:
>>>
>>>   [ 1314.612287]  [<ffffffff81700312>] dump_stack+0x45/0x56
>>>   [ 1314.612290]  [<ffffffff8125f5b0>] ? meminfo_proc_open+0x30/0x30
>>>   [ 1314.612293]  [<ffffffffa080a494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
>>>   [ 1314.612306]  [<ffffffffa00160c4>] 0xffffffffa00160c3
>>
>> Here, this still has a wrong entry. Maybe the trampline doesn't setup
>> frame pointer (bp) correctly.
> 
> Hmm.. are you saying about the hex address above?  I guess it's a valid
> entry in the (dynamic) trampoline, but has no symbol..

Ah, indeed. (BTW, why is it one less than the address ...? printk's spec?)

>>>   [ 1314.612309]  [<ffffffff812143ae>] ? seq_read+0x2de/0x3b0
>>>   [ 1314.612311]  [<ffffffff812143ae>] ? seq_read+0x2de/0x3b0
>>>   [ 1314.612312]  [<ffffffff8125f5b5>] ? meminfo_proc_show+0x5/0x5e0
>>>   [ 1314.612314]  [<ffffffff8125f5b5>] ? meminfo_proc_show+0x5/0x5e0
>>>   [ 1314.612315]  [<ffffffff8121423a>] ? seq_read+0x16a/0x3b0
> 
> But these seem to be wrong - there're duplicate entries and they should
> show some of these functions (at least) correctly IMHO.  I guess it's
> because the trampoline didn't save rbp to the stack right below the
> return address as dumpstack requires.

Right, the last seq_read should be reliable. Thank you for pointing out.

Thanks!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


