Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbaKRO4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:56:50 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:60314 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaKRO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:56:47 -0500
Date: Tue, 18 Nov 2014 14:56:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: David Long <dave.long@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] arm64: Kprobes with single stepping support
Message-ID: <20141118145643.GO18842@arm.com>
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
 <1416292375-29560-2-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416292375-29560-2-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 18, 2014 at 06:32:51AM +0000, David Long wrote:
> From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
> 
> Add support for basic kernel probes(kprobes) and jump probes
> (jprobes) for ARM64.
> 
> Kprobes will utilize software breakpoint and single step debug
> exceptions supported on ARM v8.
> 
> software breakpoint is placed at the probe address to trap the
> kernel execution into kprobe handler.
> 
> ARM v8 support single stepping to be enabled while exception return
> (ERET) with next PC in exception return address (ELR_EL1).
> kprobe handler prepares a executable memory slot for out-of-line
> execution with the copy of the original instruction under probe, and
> enable single stepping from the instruction slot. With this scheme,
> the instruction is executed with the exact same register context
> 'except PC' that points to instruction slot.
> 
> Debug mask(PSTATE.D) is enabled only when single stepping a recursive
> kprobes i.e. during kprobes reenter so that probes instruction can be
> single stepped within the kprobe handler -exception- context.
> The recursion depth of kprobe is always 2, i.e. upon probe re-entry,
> any further re-entry is prevented by not calling handlers and the case
> counted as missed kprobe)
> 
> Single stepping from slot has drawback on PC-relative accesses
> like branching and symbolic literals access as offset from new PC
> (slot address) may not be ensured to fit in immediate value of
> opcode, Such instructions needs simulation, so reject
> probing such instructions.
> 
> Instructions generating exceptions or cpu mode change are rejected,
> and not allowed to insert probe for these instructions.
> 
> Instructions using Exclusive Monitor are rejected right too.
> 
> System instructions are mostly enabled for stepping, except MSR
> immediate that update "daif" flags in PSTATE, which are not safe
> for probing -rejected.

One thing I noticed looking through this patch is that we're effectively
reinventing a bunch of the instruction decoding logic that we already have
in the kernel (introduced since Sandeepa last sent his patch).

Could you take a look at include/asm/insn.h and kernel/insn.c please, and
see if you can at least consolidate some of this? Some of it should be easy
(i.e. reusing masks, using existing #defines to construct BRK encodings),
but I appreciate there may be places where kprobes needs to add extra bits,
in which case I'd really like to keep this all together if at all possible.

We're currently in a position where the module loader, BPF jit, ftrace and
the proposed alternative patching scheme are all using the same instruction
manipulation functions, so we should try to continue that trend if we can.

Thanks,

Will
