Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaJKDMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 23:12:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38010 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaJKDMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 23:12:43 -0400
Message-ID: <1412997161.9362.34.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] x86: bpf_jit: fix two bugs in eBPF JIT compiler
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 10 Oct 2014 20:12:41 -0700
In-Reply-To: <1412995493-16100-1-git-send-email-ast@plumgrid.com>
References: <1412995493-16100-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 19:44 -0700, Alexei Starovoitov wrote:

> 2.
> while staring at the code realized that 64-byte buffer may not be enough
> when 1st insn is large, so increase it to 128 to avoid buffer overflow
> (theoretical maximum size of prologue+div is 109) and add runtime check.
> 


> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index d56cd1f..8266896 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -187,7 +187,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
>  {
>  	struct bpf_insn *insn = bpf_prog->insnsi;
>  	int insn_cnt = bpf_prog->len;
> -	u8 temp[64];
> +	bool seen_ld_abs = ctx->seen_ld_abs | (oldproglen == 0);
> +	u8 temp[128];

Hmmm. I would use some guard like :

#define BPF_MAX_INSN_SIZE 128
#define BPF_INSN_SAFETY   64

	u8 temp[MAX_INSN_SIZE + BPF_INSN_SAFETY];
 

> +		if (ilen >= sizeof(temp)) {

	if (ilen > BPF_MAX_INSN_SIZE) {
...

> +			pr_err("bpf_jit_compile fatal insn size error\n");
> +			return -EFAULT;
> +		}
> +

Otherwise, we might have corrupted stack and panic anyway.


