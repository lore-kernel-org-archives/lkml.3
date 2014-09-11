Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaIKKpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:45:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50162 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbaIKKpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:45:45 -0400
Date: Thu, 11 Sep 2014 11:45:13 +0100
From: Will Deacon <will.deacon@arm.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH arm64-next] net: bpf: arm64: fix module memory leak when
 JIT image build fails
Message-ID: <20140911104513.GC6158@arm.com>
References: <1410428208-2446-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410428208-2446-1-git-send-email-dborkman@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:36:48AM +0100, Daniel Borkmann wrote:
> On ARM64, when the BPF JIT compiler fills the JIT image body with
> opcodes during translation of eBPF into ARM64 opcodes, we may fail
> for several reasons during that phase: one being that we jump to
> the notyet label for not yet supported eBPF instructions such as
> BPF_ST. In that case we only free offsets, but not the actual
> allocated target image where opcodes are being stored. Fix it by
> calling module_free() on dismantle time in case of errors.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Zi Shen Lim <zlim.lnx@gmail.com>
> Cc: Alexei Starovoitov <ast@plumgrid.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  [ Compile-tested only. ]
> 
>  arch/arm64/net/bpf_jit_comp.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 38c4296..7ae3354 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -651,8 +651,10 @@ void bpf_int_jit_compile(struct bpf_prog *prog)
>  	build_prologue(&ctx);
>  
>  	ctx.body_offset = ctx.idx;
> -	if (build_body(&ctx))
> +	if (build_body(&ctx)) {
> +		module_free(NULL, ctx.image);
>  		goto out;
> +	}
>  

Looks good to me:

  Acked-by: Will Deacon <will.deacon@arm.com>

Catalin, can you apply this on the for-next/core branch, please?

Will
