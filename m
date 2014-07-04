Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaGDG45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 02:56:57 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36114 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGDG4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 02:56:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140703091450.GB12958@arm.com>
References: <1404278424-31176-1-git-send-email-zlim.lnx@gmail.com>
	<20140703091450.GB12958@arm.com>
Date: Thu, 3 Jul 2014 23:56:54 -0700
Message-ID: <CABg9mcuCQHXacgq-C7A=G5GH_p7b0TxCYB8A9qXvGJSoSbjs5A@mail.gmail.com>
Subject: Re: [PATCH RFC] arm64: eBPF JIT compiler
From: Z Lim <zlim.lnx@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Thu, Jul 3, 2014 at 2:14 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hello,
>
> On Wed, Jul 02, 2014 at 06:20:24AM +0100, Zi Shen Lim wrote:
[...]
>
> First off, this is really cool. Thanks for putting in the effort to get this
> supported on arm64! I'm happy to run tests on some real hardware if you tell
> me how to run them :)

Thanks for offering to test on real hardware :)
I'm running test_bpf per Documentations/networking/filter.txt, also
described by Daniel in his response to you.

>
> One general observation relates to your instruction encoding logic, e.g:
>
>> +/* 5-bit Register Operand */
>> +#define A64_R(x)       x               /* R0-R30: General purpose */
>> +#define A64_FP         A64_R(29)       /* Frame pointer */
>> +#define A64_LR         A64_R(30)       /* Link register */
>> +#define A64_ZR         31              /* As source register operand */
>> +#define A64_SP         31              /* As load/store base register */
>> +
>> +#define BITSMASK(bits) ((1 << (bits)) - 1)
>> +
>> +/* Compare & branch (immediate) */
>> +static inline u32 A64_COMP_BRANCH_IMM(int sf, int op, int imm19, int Rt)
>> +{
>> +       sf &= BITSMASK(1);
>> +       op &= BITSMASK(1);
>> +       imm19 &= BITSMASK(19);
>> +       Rt &= BITSMASK(5);
>> +       return 0x34000000 | sf << 31 | op << 24 | imm19 << 5 | Rt;
>> +}
>> +#define A64_CBZ(sf, Rt, imm19)  A64_COMP_BRANCH_IMM(sf, 0, imm19, Rt)
>> +#define A64_CBNZ(sf, Rt, imm19) A64_COMP_BRANCH_IMM(sf, 1, imm19, Rt)
>
> We already have some some basic instruction manipulation code in
> arch/arm64/kernel/insn.c and arch/arm64/include/asm/insn.h. Would you be
> able to move some of this there please (but only the bits that aren't tied
> to BPF?

Ah, thanks for pointing that out to me.

>
> The reason I ask, is because we're inevitebly going to need this stuff
> for other subsystems (e.g. kprobes, dynamic code patching ("alternatives"))
> and I'd like to avoid a proliferation of magic numbers across the codebase.

Yes, I agree in principle, consolidating this stuff in one place sounds good.

>
> Does this sound remotely feasible?

So I looked at insn.c and the only overlap at this point is B/BL codegen.
A whole lot more, e.g. arithmetic, logical, and memory ops, will need
to be shuffled in.

Let me address Alexei's review comments and send out a v2.
After that, I can take a stab at consolidating bpf_jit.h into
insn.{c,h}. Sounds good to you?

Thanks,
z

>
> Cheers,
>
> Will
