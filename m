Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbaLEKdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:33:19 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:40309 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaLEKdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:33:16 -0500
Message-ID: <548189D4.3010907@huawei.com>
Date: Fri, 5 Dec 2014 18:32:52 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>		 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>	 <1417710073.2239.10.camel@linaro.org> <5481289E.4060504@huawei.com> <1417774227.2232.1.camel@linaro.org>
In-Reply-To: <1417774227.2232.1.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.548189E7.0063,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 727e8f0719b8bfb005329f5f19f37f59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/5 18:10, Jon Medhurst (Tixy) wrote:
> On Fri, 2014-12-05 at 11:38 +0800, Wang Nan wrote:
>> On 2014/12/5 0:21, Jon Medhurst (Tixy) wrote:
>>> On Thu, 2014-12-04 at 13:36 +0800, Wang Nan wrote:
>>>
>>
>> [trim some text]
>>
>>>
>>> I have retested this patch and on one of the arm test cases I get an
>>> undefined instruction exception in kprobe_arm_test_cases. When this
>>> happens PC points to the second nop below. 
>>>
>>>
>>> 80028a38:	e320f000 	nop	{0}
>>> 80028a3c:	e11000b2 	ldrh	r0, [r0, -r2]
>>> 80028a40:	e320f000 	nop	{0}
>>>
>>> As all three instructions will have probes on them during testing, and
>>> un-optimised probes are implemented by using an undefined instruction to
>>> act as a breakpoint, my first thought was that we have a race condition
>>> somewhere with adding, removing or optimizing probes. Though a reboot a
>>> retest failed in the same way on the same instruction, so I'm not 100%
>>> convinced about strictly timing related bugs.
>>>  
>>
>> Does the problem appear in your platform in each time?
> 
> Three times out of three tries yes. Though the third try was built
> differently and the problem occurred on a different test case.
> 
> 
>>  Currently I have only
>> QEMU machine for testing and haven't seen problem like this before.
> 
> I don't know much about QEMU and have never used it, but I'm assuming
> QEMU doesn't make any attempt to simulate caches like the data cache,
> instruction cache, TLBs, branch predictor? Does it even emulate multiple
> CPUs with multiple host CPU threads? Basically, I very much doubt QEMU
> is a very good test of kernel code in general, and especially code that
> modifies code and has multiple cpus running in parallel.
> 
> Do you not have access to any kind of ARM board to try some testing on?
> 
> 
>>  Could
>> you please provide a detail steps for me to reproduce it? Or do you just
>> enable kprobe test code when booting and this exception simply appear twice?
> 
> I applied the patches on top of Linux 3.18-rc5 and set VERBOSE in
> arm/probes/kprobes/test-core.h to 1. Then built a kernel configured
> using vexpress_defconfig and enabled
> 
> CONFIG_KPROBES=y
> CONFIG_ARM_KPROBES_TEST=y
> CONFIG_DEBUG_INFO=y
> 
> then booted on a Versatile Express board with a TC2 CoreTile (A15/A7
> big.LITTLE CPU).
> 
> The Oops I described happened on two consecutive boots of the board. I
> then tried again setting VERBOSE to 0 and I got a similar OOPs but on a
> different test case.
> 


Before your reply I also did my testing on real hardware platform. I tried 3
times and hit one similar failure. dmesg is pasted at the end of this mail.
After the Oops arises, I wrap the failed testcase with a loop and run it
100 times, they all passed.

I use your test code for testing, with following modification:

--- ../temp/arch/arm/probes/kprobes/test-core.c	2014-12-05 15:42:28.000000000 +0800
+++ ./arch/arm/probes/kprobes/test-core.c	2014-12-05 16:06:18.000000000 +0800
@@ -311,6 +311,7 @@
 	pre_handler_called = test_func_instance;
 	if (regs->ARM_r0 == FUNC_ARG1 && regs->ARM_r1 == FUNC_ARG2)
 		test_regs_ok = true;
+	post_handler_called = test_func_instance + 1;
 	return 0;
 }

@@ -325,7 +326,7 @@
 static struct kprobe the_kprobe = {
 	.addr		= 0,
 	.pre_handler	= pre_handler,
-	.post_handler	= post_handler
+	.post_handler	= NULL
 };

 static int test_kprobe(long (*func)(long, long))
@@ -346,6 +347,7 @@

 	if (!ret)
 		return -EINVAL;
+#if 0
 	if (pre_handler_called != test_func_instance) {
 		pr_err("FAIL: kprobe pre_handler not called\n");
 		return -EINVAL;
@@ -361,7 +363,7 @@
 		pr_err("FAIL: probe called after unregistering\n");
 		return -EINVAL;
 	}
-
+#endif
 	return 0;
 }

and with the kernel config options you mentioned before selected.

The hardware platform I use doesn't have stable BSP for 3.18, so
I have to backport all kprobe related code to 3.10.61.

Both your and mine failure are related to ldrd/h instruction. What
about your second failed testcase?


> I'm worried because this whole optimised kprobes has some rather
> complicated interactions, e.g. can the background thread that changes
> breakpoints to jumps (or back again?) could occur at the same time
> another CPU is processing a kprobe that's been hit, or is in the process
> of removing a probe.
> 

I think x86 should also has to deal with these problems, so if the fault
is caused by these race, they may not ARM specific.

Thank you!

------------ dmesg --------------
...
[ 1398.496592] .long ((0xe089c0df) & 0xFFFFFFFF)
[ 1398.496592] 		@ ldrd r12, [r9], pc
[ 1398.504338] strd	r0, [r1, #-8]	@ e14100f8
[ 1400.241108] strvsd	r8, [r13, #8]	@ 61cd80f8
[ 1402.031108] strd	r4, [r2, #16]!	@ e1e241f0
[ 1403.821107] strvcd	r12, [r11, #-16]!	@ 716bc1f0
[ 1405.641104] strd	r2, [r4], #48	@ e0c423f0
[ 1407.441108] strd	r10, [r9], #-48	@ e049a3f0
[ 1409.261105] strd	r6, [r13, #-64]!	@ e16d64f0
[ 1411.051105] strd r6, [r13, #-64-8]!	@ e16d64f8
[ 1411.101114] strd	r4, [r12, #-64-8]!	@ e16c44f8
[ 1412.871105] .long ((0xe1efc3f0) & 0xFFFFFFFF)
[ 1412.871105] 		@ strd r12, [pc, #48]!
[ 1412.921113] ldrd	r0, [r0, #-8]	@ e14000d8
[ 1413.031116] Internal error: Oops - undefined instruction: 0 [#1] SMP ARM
[ 1413.037809] Modules linked in:
[ 1413.040876] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.53-HULK2+ #31
[ 1413.047569] task: ef238000 ti: ef226000 task.ti: ef226000
[ 1413.052971] PC is at kprobe_arm_test_cases+0xa1ec/0xfeec
[ 1413.058276] LR is at 0x21522f52
[ 1413.061416] pc : [<c00286d4>]    lr : [<21522f52>]    psr: 18010113
[ 1413.061416] sp : ef227dd8  ip : 21522d52  fp : 21522a52
[ 1413.072876] r10: 21522b52  r9 : 21522852  r8 : 21522952
[ 1413.078095] r7 : 21522652  r6 : 21522752  r5 : 21522452  r4 : 21522552
[ 1413.084613] r3 : 21522252  r2 : 21522352  r1 : 45678eab  r0 : 45678dab
[ 1413.091132] Flags: nzcV  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[ 1413.098430] Control: 18c53c7d  Table: 8000404a  DAC: 00000015
[ 1413.104167] Process swapper/0 (pid: 1, stack limit = 0xef226238)
[ 1413.110166] Stack: (0xef227dd8 to 0xef228000)
[ 1413.114518] 7dc0:                                                       456789ab 45678aab
[ 1413.122686] 7de0: 45678bab 45678cab 45678dab 45678eab 45678fab 456790ab 456791ab 456792ab
[ 1413.130855] 7e00: 456793ab 456794ab 456795ab ef227e50 456797ab 456798ab 456799ab 45679aab
[ 1413.139022] 7e20: 45679bab 45679cab 45679dab 45679eab 45679fab 4567a0ab 4567a1ab 4567a2ab
[ 1413.147191] 7e40: 4567a3ab 4567a4ab 4567a5ab 4567a6ab 4567a7ab 4567a8ab 4567a9ab 4567aaab
[ 1413.155360] 7e60: 4567abab 4567acab 4567adab 4567aeab 4567afab 4567b0ab 4567b1ab 4567b2ab
[ 1413.163527] 7e80: 4567b3ab 4567b4ab 4567b5ab 4567b6ab 4567b7ab 4567b8ab 4567b9ab 4567baab
[ 1413.171694] 7ea0: 4567bbab 4567bcab 4567bdab 4567beab 4567bfab 4567c0ab 4567c1ab 4567c2ab
[ 1413.179863] 7ec0: 4567c3ab 4567c4ab 4567c5ab 4567c6ab 4567c7ab 4567c8ab c03bd920 c03bdf5e
[ 1413.188031] 7ee0: c02f7708 00000000 c001dd58 00000000 c046526c 00000000 0000000c 00000000
[ 1413.196199] 7f00: c04c1a4c c04427f0 00000001 c02f7708 00000000 00000000 c04c1440 00000007
[ 1413.204367] 7f20: c0465264 c0476520 c04c1440 c044266c c046526c c000868c ef227f64 c0418fac
[ 1413.212534] 7f40: c0418a2c 00000058 00000007 00000007 00000001 00000007 c0465264 c0476520
[ 1413.220702] 7f60: c04c1440 00000058 c043a478 c046526c 00000000 c043ac50 00000007 00000007
[ 1413.228869] 7f80: c043a478 ef226000 c04c1440 c02d8e9c 00000000 00000000 00000000 00000000
[ 1413.237036] 7fa0: 00000000 c02d8ea8 00000000 c000e138 00000000 00000000 00000000 00000000
[ 1413.245203] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1413.253371] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[ 1413.261545] [<c00286d4>] (kprobe_arm_test_cases+0xa1ec/0xfeec) from [<45678cab>] (0x45678cab)
[ 1413.270060] Code: 00002000 000c000c e7f001f8 e14000d8 (eabf69b9)
[ 1413.276164] ---[ end trace 81706e7e45d860af ]---
[ 1413.280776] Kernel panic - not syncing: Fatal exception
[ 1413.285996] CPU1: stopping
[ 1413.288704] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D      3.10.53-HULK2+ #31
[ 1413.296372] [<c0014b84>] (unwind_backtrace+0x0/0x120) from [<c00118a8>] (show_stack+0x10/0x14)
[ 1413.304977] [<c00118a8>] (show_stack+0x10/0x14) from [<c00137b4>] (handle_IPI+0xc0/0x124)
[ 1413.313148] [<c00137b4>] (handle_IPI+0xc0/0x124) from [<c0008530>] (gic_handle_irq+0x58/0x60)
[ 1413.321675] [<c0008530>] (gic_handle_irq+0x58/0x60) from [<c02e6900>] (__irq_svc+0x40/0x50)
[ 1413.330013] Exception stack(0xef259fa0 to 0xef259fe8)



