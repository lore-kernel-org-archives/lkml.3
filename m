Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaICKSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:18:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59242 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523AbaICKSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:18:13 -0400
Message-ID: <5406EADC.8080009@hitachi.com>
Date: Wed, 03 Sep 2014 19:18:04 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, Russell King <linux@arm.linux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will.deacon@arm.com>, Pei Feiyue <peifeiyue@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kprobes: arm: enable OPTPROBES for ARM 32
References: <1409144552-12751-1-git-send-email-wangnan0@huawei.com>  <1409144552-12751-4-git-send-email-wangnan0@huawei.com> <1409665784.2873.49.camel@linaro1.home>
In-Reply-To: <1409665784.2873.49.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/09/02 22:49), Jon Medhurst (Tixy) wrote:
> I gave the patches a quick test and in doing so found a bug which stops
> any probes actually being optimised, and the same bug should affect X86,
> see comment below...
> 
> On Wed, 2014-08-27 at 21:02 +0800, Wang Nan wrote:
> [...]
>> +int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
>> +{
>> +	u8 *buf;
>> +	unsigned long rel_chk;
>> +	unsigned long val;
>> +
>> +	if (!can_optimize(op))
>> +		return -EILSEQ;
>> +
>> +	op->optinsn.insn = get_optinsn_slot();
>> +	if (!op->optinsn.insn)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * Verify if the address gap is in 32MiB range, because this uses
>> +	 * a relative jump.
>> +	 *
>> +	 * kprobe opt use a 'b' instruction to branch to optinsn.insn.
>> +	 * According to ARM manual, branch instruction is:
>> +	 *
>> +	 *   31  28 27           24 23             0
>> +	 *  +------+---+---+---+---+----------------+
>> +	 *  | cond | 1 | 0 | 1 | 0 |      imm24     |
>> +	 *  +------+---+---+---+---+----------------+
>> +	 *
>> +	 * imm24 is a signed 24 bits integer. The real branch offset is computed
>> +	 * by: imm32 = SignExtend(imm24:'00', 32);
>> +	 *
>> +	 * So the maximum forward branch should be:
>> +	 *   (0x007fffff << 2) = 0x01fffffc =  0x1fffffc
>> +	 * The maximum backword branch should be:
>> +	 *   (0xff800000 << 2) = 0xfe000000 = -0x2000000
>> +	 *
>> +	 * We can simply check (rel & 0xfe000003):
>> +	 *  if rel is positive, (rel & 0xfe000000) shoule be 0
>> +	 *  if rel is negitive, (rel & 0xfe000000) should be 0xfe000000
>> +	 *  the last '3' is used for alignment checking.
>> +	 */
>> +	rel_chk = (unsigned long)((long)op->optinsn.insn -
>> +			(long)op->kp.addr + 8) & 0xfe000003;
> 
> This check always fails because op->kp.addr is zero. Debugging this I
> found that this function is called from alloc_aggr_kprobe() and that
> copies the real kprobe into op->kp using copy_kprobe(), which doesn't
> actually copy the 'addr' value...

Right, I've already pointed that :)

https://lkml.org/lkml/2014/8/28/114

> 
>         static inline void copy_kprobe(struct kprobe *ap, struct kprobe *p)
>         {
>         	memcpy(&p->opcode, &ap->opcode, sizeof(kprobe_opcode_t));
>         	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
>         }
> 
> Thing is, the new ARM code is a close copy of the existing X86 version
> so that would also suffer the same problem of kp.addr always being zero.
> So either I've miss understood something or this is fundamental bug no
> one has noticed before.
> 
> Throwing in 'p->addr = ap->addr' into the copy_kprobe function fixed the
> behaviour arch_prepare_optimized_kprobe.
> 
> I was testing this by running the kprobes tests
> (CONFIG_ARM_KPROBES_TEST=y) and putting a few printk's in strategic
> places in kprobes-opt.c to check to see what code paths got executed,
> which is how I discovered the problem.
> 
> Two things to note when running kprobes tests...
> 
> 1. On SMP systems it's very slow because of kprobe's use of stop_machine
> for applying and removing probes, this forces the system to idle and
> wait for the next scheduler tick for each probe change.

Hmm, agreed. It seems that arm32 limitation of self-modifying code on SMP.
I'm not sure how we can handle it, but I guess;
 - for some processors which have better coherent cache for SMP, we can
   atomically replace the breakpoint code with original code.
 - Even if we get an "undefined instruction" exception, its handler can
   ask kprobes if the address is under modifying or not. And if it is,
   we can just return from the exception to retry the execution.

Thank you,

> 2. It's a good idea to enable VERBOSE in kprobes-test.h to get output
> for each test case instruction, this reassures you things are
> progressing and if things explode lets you know what instruction type
> triggered it.
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


