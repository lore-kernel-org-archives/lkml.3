Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaLCGiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:38:09 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64732 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCGiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:38:06 -0500
MIME-Version: 1.0
In-Reply-To: <1417301173-23691-1-git-send-email-ast@plumgrid.com>
References: <1417301173-23691-1-git-send-email-ast@plumgrid.com>
Date: Tue, 2 Dec 2014 22:38:04 -0800
Message-ID: <CABg9mcso+YeS-sgAQmAu6MvsfNnzrKYuUG8m+WYJmxdaxbGmPA@mail.gmail.com>
Subject: Re: [PATCH v2 net] bpf: x86: fix epilogue generation for eBPF programs
From: Z Lim <zlim.lnx@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexei,

On Sat, Nov 29, 2014 at 2:46 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
> classic BPF has a restriction that last insn is always BPF_RET.
> eBPF doesn't have BPF_RET instruction and this restriction.
> It has BPF_EXIT insn which can appear anywhere in the program
> one or more times and it doesn't have to be last insn.

Just to confirm, in valid eBPF, BPF_EXIT *must* be present at least
once, correct?
Does an eBPF JIT implementation need to check for it?

> Fix eBPF JIT to emit epilogue when first BPF_EXIT is seen
> and all other BPF_EXIT instructions will be emitted as jump.
>
> Since jump offset to epilogue is computed as:
> jmp_offset = ctx->cleanup_addr - addrs[i]
> we need to change type of cleanup_addr to signed to compute the offset as:
> (long long) ((int)20 - (int)30)
> instead of:
> (long long) ((unsigned int)20 - (int)30)
>
> Fixes: 622582786c9e ("net: filter: x86: internal BPF JIT")
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> Note, this bug is applicable only to native eBPF programs
> which first were introduced in 3.18, so no need for stable.
>
> arm64 JIT has the same problem, but the fix is not as trivial,
> so will be done as separate patch.

I'll cook up a patch for arm64 if you haven't already done so.
Any related test case I should run through?
