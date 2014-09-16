Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaIPQ0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:26:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440AbaIPQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:26:10 -0400
Date: Tue, 16 Sep 2014 17:25:31 +0100
From: Will Deacon <will.deacon@arm.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH arm64-next v4] net: bpf: arm64: address randomize and
 write protect JIT code
Message-ID: <20140916162531.GC32073@arm.com>
References: <1410853730-16470-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410853730-16470-1-git-send-email-dborkman@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:48:50AM +0100, Daniel Borkmann wrote:
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
>  v3->v4:
>   - Inclusion into debug-monitors.h as suggested by Will
>  v2->v3:
>   - Use cpu_to_le32() as suggested by Zi/Will
>  v1->v2:
>   - Use brk insn as suggested by Catalin
>  Note:
>   - This patch depends on net-next being merged to mainline due
>     to the mentioned merge conflict.
> 
>  arch/arm64/include/asm/debug-monitors.h |  8 +++++++
>  arch/arm64/net/bpf_jit_comp.c           | 39 +++++++++++++++++++++++++--------
>  2 files changed, 38 insertions(+), 9 deletions(-)

Thanks, Daniel, this looks great:

  Acked-by: Will Deacon <will.deacon@arm.com>

We can merge this at -rc1.

Will
