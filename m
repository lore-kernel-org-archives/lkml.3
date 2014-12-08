Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaLHGfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:35:09 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:55046 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaLHGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:35:07 -0500
Message-ID: <5485467F.6060005@huawei.com>
Date: Mon, 8 Dec 2014 14:34:39 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>	 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>	 <1417710073.2239.10.camel@linaro.org> <5481289E.4060504@huawei.com>	 <1417774227.2232.1.camel@linaro.org> <1417791592.2232.5.camel@linaro.org>
In-Reply-To: <1417791592.2232.5.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54854697.03B6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 727e8f0719b8bfb005329f5f19f37f59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/5 22:59, Jon Medhurst (Tixy) wrote:
> On Fri, 2014-12-05 at 10:10 +0000, Jon Medhurst (Tixy) wrote:
> [...]
>> I'm worried because this whole optimised kprobes has some rather
>> complicated interactions, e.g. can the background thread that changes
>> breakpoints to jumps (or back again?) could occur at the same time
>> another CPU is processing a kprobe that's been hit, or is in the process
>> of removing a probe.
> 
> I think that is a plausible theory. We can have this situation...
> 
> 1. CPU A executes a probe's 'breakpoint' instruction and the undefined
> instruction exception handler is triggered.
> 
> 2. CPU B is executing the kprobes optimisation thread and replaces the
> 'breakpoint' with a branch instruction.
> 
> 3. CPU A reads the invalid instruction from memory and because this is
> now the branch instruction it doesn't match
> KPROBE_ARM_BREAKPOINT_INSTRUCTION which kprobes registered to handle.
> This means the undefined instruction exception is treated as just that,
> execution of an undefined instruction.
> 

I confirmed your theory by printing the buggy instruction:

...
[  474.824206] subls	r9,  r9, r14, lsr r7	@ 9049973e
[  476.954206] subge	r10, r11, r14, asr r7	@ a04ba75e
[  479.014206] sublt	r11, r11, r14, asr r7	@ b04bb75e
[  479.194212] undefined instruction: pc=bf001bbc, instruction=ea01187f
[  479.290190] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[  479.370533] Modules linked in: test_kprobes(+)
[  479.423990] CPU: 10 PID: 1410 Comm: insmod Not tainted 3.10.53-HULK2+ #31
[  479.505377] task: c42b72c0 ti: ed4f8000 task.ti: ed4f8000
[  479.570189] PC is at kprobe_arm_test_cases+0x122c/0xfeed [test_kprobes]
...

ea01187f is a branch instruction.

Please help me to review my v14 patch series:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/309236.html

In which I fix it by wrapping __arch_optimize_kprobes() using stop_machine().


> The above scenario is the exact reason why arch_disarm_kprobe is
> implemented to always use stop_machine to modify the code and we need to
> ensure the same happens with arch_optimize_kprobes.
> 


