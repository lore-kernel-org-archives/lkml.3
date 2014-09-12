Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaILQDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:03:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50969 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaILQDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:03:50 -0400
Date: Fri, 12 Sep 2014 17:03:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "zlim.lnx@gmail.com" <zlim.lnx@gmail.com>,
        "ast@plumgrid.com" <ast@plumgrid.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH arm64-next] net: bpf: arm64: address randomize and write
 protect JIT code
Message-ID: <20140912160345.GF5532@arm.com>
References: <1410505897-20122-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1410505897-20122-1-git-send-email-dborkman@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Sep 2014 16:03:46.0718 (UTC) FILETIME=[22482BE0:01CFCEA3]
X-MC-Unique: 114091217034801501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Fri, Sep 12, 2014 at 08:11:37AM +0100, Daniel Borkmann wrote:
>  Will, Catalin, Dave, this is more or less a heads-up: when net-next and
>  arm64-next tree will get both merged into Linus' tree, we will run into
>  a 'silent' merge conflict until someone actually runs eBPF JIT on ARM64
>  and might notice (I presume) an oops when JIT is freeing bpf_prog. I'd
>  assume nobody actually _runs_ linux-next, but not sure about that though.

Some people do.

>  How do we handle this? Would I need to resend this patch when the time
>  comes or would you ARM64 guys take care of it automagically? ;)

I think we could disable BPF for arm64 until -rc1 and re-enable it
together with this patch.

One comment below:

> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
[...]
> +static void jit_fill_hole(void *area, unsigned int size)
> +{
> +	/* Insert illegal UND instructions. */
> +	u32 *ptr, fill_ins = 0xe7ffffff;

On arm64 we don't have a guaranteed undefined instruction space (and
Will tells me that on Thumb-2 for the 32-bit arm port it actually is a
valid instruction, it seems that you used the same value).

I think the only guaranteed way is to use the BRK #imm instruction but
it requires some changes to the handling code as it is currently used
for kgdb (unless you can use two instructions for filling in which could
generate a NULL pointer access).

-- 
Catalin

