Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaHLPNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:13:07 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60779 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaHLPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:13:03 -0400
Message-ID: <53EA2EF7.9060209@hitachi.com>
Date: Wed, 13 Aug 2014 00:12:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Nan <wangnan0@huawei.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peifeiyue@huawei.com, lizefan@huawei.com
Subject: Re: [PATCH v4] kprobes: arm: enable OPTPROBES for ARM 32
References: <1407819388-52145-1-git-send-email-wangnan0@huawei.com> <53EA1086.4010606@huawei.com>
In-Reply-To: <53EA1086.4010606@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/12 22:03), Wang Nan wrote:
> Hi Masami and everyone,
> 
> When checking my code I found a problem: if we replace a stack operatinon instruction,
> it is possible that the emulate execution of such instruction destroy the stack used
> by kprobeopt:
> 
>> +
>> +asm (
>> +			".global optprobe_template_entry\n"
>> +			"optprobe_template_entry:\n"
>> +			"	sub	sp, sp, #80\n"
>> +			"	stmia	sp, {r0 - r14} \n"
> 
> Here, trampoline code sub sp with 80 (0x50, I choose this number without much thinking), and then
> use stmia to push r0 - r14 (registers except pc) onto the stack. Assume the original sp is
> 0xd0000050, the stack becomes:
> 
> 0xd0000000: r0
> 0xd0000004: r1
> 0xd0000008: r2
> ...
> 0xd0000038: r14
> 0xd000003c: r15 (place holder)
> 0xd0000040: cpsr (place holder)
> 0xd0000044: ?
> 0xd0000048: ?
> 0xd000004c: ?
> 0xd0000050: original stack
> 
> If the replaced code operates stack, for example, push {r0 - r10}, it will overwrite our register.
> For that reason, sub sp, #80 is not enough, we need at least 64 bytes stack space, so the first instruction
> here should be sub sp, #128.
> 
> However, it increase stack requirement. Moreover, although rare, there may be sp relative addressing,
> such as: str r1, [sp, #-132].

Hmm, I see the increasing stack is clearly hard to emulate, but
why is it hard to emulate sp relative instruction? It should
access the memory under the stack pointer.

> To make every situations safe, do you think we need to alloc a pre-cpu optprobe private stack?

Of course, that is one possible idea, but the simplest way is just not
optimizing such instructions. Why not can_optimize() check that? ;)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


