Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaIOVau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:30:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46812 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756302AbaIOVas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:30:48 -0400
Date: Mon, 15 Sep 2014 22:30:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH arm64-next v3] net: bpf: arm64: address randomize and
 write protect JIT code
Message-ID: <20140915213004.GA31150@arm.com>
References: <1410812423-11818-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410812423-11818-1-git-send-email-dborkman@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

One small comment than I forgot to mention before (see below).

On Mon, Sep 15, 2014 at 09:20:23PM +0100, Daniel Borkmann wrote:
> This is the ARM64 variant for 314beb9bcab ("x86: bpf_jit_comp: secure bpf
> jit against spraying attacks").
> 
> Thanks to commit 11d91a770f1f ("arm64: Add CONFIG_DEBUG_SET_MODULE_RONX
> support") which added necessary infrastructure, we can now implement
> RO marking of eBPF generated JIT image pages and randomize start offset
> for the JIT code, so that it does not reside directly on a page boundary
> anymore. Likewise, the holes are filled with illegal instructions: here
> we use BRK #0x100 (opcode 0xd4202000) to trigger a fault in the kernel
> (unallocated BRKs would trigger a fault through do_debug_exception). This
> seems more reliable as we don't have a guaranteed undefined instruction
> space on ARM64.
> 
> This is basically the ARM64 variant of what we already have in ARM via
> commit 55309dd3d4cd ("net: bpf: arm: address randomize and write protect
> JIT code"). Moreover, this commit also presents a merge resolution due to
> conflicts with commit 60a3b2253c41 ("net: bpf: make eBPF interpreter images
> read-only") as we don't use kfree() in bpf_jit_free() anymore to release
> the locked bpf_prog structure, but instead bpf_prog_unlock_free() through
> a different allocator.
> 
> JIT tested on aarch64 with BPF test suite.
> 
> Reference: http://mainisusuallyafunction.blogspot.com/2012/11/attacking-hardened-linux-systems-with.html
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Zi Shen Lim <zlim.lnx@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alexei Starovoitov <ast@plumgrid.com>
> ---
>  v2->v3:
>   - Use cpu_to_le32() as suggested by Zi/Will
>  v1->v2:
>   - Use brk insn as suggested by Catalin
>  Note:
>   - This patch depends on net-next being merged to mainline due
>     to the mentioned merge conflict.
> 
>  arch/arm64/net/bpf_jit_comp.c | 38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 7ae3354..4b71779 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -19,7 +19,6 @@
>  #define pr_fmt(fmt) "bpf_jit: " fmt
>  
>  #include <linux/filter.h>
> -#include <linux/moduleloader.h>
>  #include <linux/printk.h>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
> @@ -119,6 +118,15 @@ static inline int bpf2a64_offset(int bpf_to, int bpf_from,
>  	return to - from;
>  }
>  
> +static void jit_fill_hole(void *area, unsigned int size)
> +{
> +	/* We use brk #0x100 to trigger a fault. */
> +	u32 *ptr;
> +	/* We are guaranteed to have aligned memory. */
> +	for (ptr = area; size >= sizeof(u32); size -= sizeof(u32))
> +		*ptr++ = cpu_to_le32(0xd4202000);
> +}

Please can you use the existing macros in debug-monitors.h for constructing
this value? We have AARCH64_BREAK_MON to get the BRK encoding, then you can
add an immediate to that file to reserve something for bpf. That way, we
make sure that other parts of the kernel don't accidentally repurpose your
fault code.

Cheers,

Will
