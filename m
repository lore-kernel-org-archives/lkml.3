Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaILRLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:11:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49039 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbaILRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:10:59 -0400
Date: Fri, 12 Sep 2014 18:10:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "zlim.lnx@gmail.com" <zlim.lnx@gmail.com>,
        "ast@plumgrid.com" <ast@plumgrid.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH arm64-next] net: bpf: arm64: address randomize and write
 protect JIT code
Message-ID: <20140912171014.GG12108@arm.com>
References: <1410505897-20122-1-git-send-email-dborkman@redhat.com>
 <20140912160345.GF5532@arm.com>
 <54131D87.9060008@redhat.com>
 <20140912164656.GH5532@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912164656.GH5532@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 05:46:57PM +0100, Catalin Marinas wrote:
> On Fri, Sep 12, 2014 at 05:21:27PM +0100, Daniel Borkmann wrote:
> > On 09/12/2014 06:03 PM, Catalin Marinas wrote:
> > > On Fri, Sep 12, 2014 at 08:11:37AM +0100, Daniel Borkmann wrote:
> > >>   Will, Catalin, Dave, this is more or less a heads-up: when net-next and
> > >>   arm64-next tree will get both merged into Linus' tree, we will run into
> > >>   a 'silent' merge conflict until someone actually runs eBPF JIT on ARM64
> > >>   and might notice (I presume) an oops when JIT is freeing bpf_prog. I'd
> > >>   assume nobody actually _runs_ linux-next, but not sure about that though.
> > >
> > > Some people do.
> > >
> > >>   How do we handle this? Would I need to resend this patch when the time
> > >>   comes or would you ARM64 guys take care of it automagically? ;)
> > >
> > > I think we could disable BPF for arm64 until -rc1 and re-enable it
> > > together with this patch.
> > 
> > Ok, yes, that would mitigate it a bit. Sounds fine to me.
> > 
> > > One comment below:
> > >
> > >> --- a/arch/arm64/net/bpf_jit_comp.c
> > >> +++ b/arch/arm64/net/bpf_jit_comp.c
> > > [...]
> > >> +static void jit_fill_hole(void *area, unsigned int size)
> > >> +{
> > >> +	/* Insert illegal UND instructions. */
> > >> +	u32 *ptr, fill_ins = 0xe7ffffff;
> > >
> > > On arm64 we don't have a guaranteed undefined instruction space (and
> > > Will tells me that on Thumb-2 for the 32-bit arm port it actually is a
> > > valid instruction, it seems that you used the same value).
> > 
> > Hm, ok, the boards we've tried out and where Zi tested it too, it worked.
> 
> So, if I try this:
> 
> $ echo 0xffffffe7 | xxd -r > test.bin
> $ arm-linux-gnueabihf-objdump -m arm -D -b binary test.bin
> ...
>    0:   e7ffffff        udf     #65535  ; 0xffff


...and for Thumb, it ends up as:

0:	ffff e7ff	vqshl.u64	q15, <illegal reg q15.5>, #63

which does happen to be undefined, but it feels fragile to rely on that
particular instruction form always having UNDEF behaviour.

> Do you use the same constant on arm32?
> 
> > > I think the only guaranteed way is to use the BRK #imm instruction but
> > > it requires some changes to the handling code as it is currently used
> > > for kgdb (unless you can use two instructions for filling in which could
> > > generate a NULL pointer access).
> > 
> > The trade-off would be that if we align on 8, it would certainly increase
> > the probability to jump to the right offset. Note, on x86_64 we have no
> > alignment requirements, hence 1, and on s390x only alignment of 2.
> > 
> > So, on that few (?) boards where UND would be a valid instruction [ as
> > opposed to crash the kernel ], would it translate into a NOP and just
> > 'walk' from there into the JIT image?
> 
> On current ARMv8 CPU implementations, the above constant is unallocated
> in the A64 instruction space. But you never know, it may be allocated in
> the future.
> 
> I think it's easier if you just use something like BRK #0x100 (opcode
> 0xd4202000) which would trigger a fault in the kernel (kgdb uses #imm
> 0x400 and 0x401).
> 
> An unallocated BRK would trigger a fault via do_debug_exception ->
> brk_handler and panic the kernel.

Sounds sensible.

Will
