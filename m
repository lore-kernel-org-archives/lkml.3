Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaCLTWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:22:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40371 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaCLTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:22:18 -0400
Date: Wed, 12 Mar 2014 15:22:15 -0400 (EDT)
Message-Id: <20140312.152215.347361365901821816.davem@davemloft.net>
To: ast@plumgrid.com
Cc: dborkman@redhat.com, mingo@kernel.org, wad@chromium.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        hagen@jauu.net, jesse@nicira.com, tglx@linutronix.de,
        edumazet@google.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, fweisbec@gmail.com, acme@infradead.org,
        penberg@iki.fi, arjan@infradead.org, hch@infradead.org,
        xemul@parallels.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v9 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394512892-5448-2-git-send-email-ast@plumgrid.com>
References: <1394512892-5448-1-git-send-email-ast@plumgrid.com>
	<1394512892-5448-2-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:22:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 10 Mar 2014 21:41:30 -0700

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 1a869488b8ae..2c13d000389c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3054,6 +3054,7 @@ extern int		netdev_max_backlog;
>  extern int		netdev_tstamp_prequeue;
>  extern int		weight_p;
>  extern int		bpf_jit_enable;
> +extern int		bpf_ext_enable;

I don't like seeing config ifdefs in C code, so please adjust the
bpf_jit_enable declaration with something like:

#ifdef CONFIG_BPF_JIT
extern int		bpf_jit_enable;
#else
#define bpf_jit_enable	0
#endif

Then you can kill the ifdefs here:

> +#ifdef CONFIG_BPF_JIT
> +	if (bpf_ext_enable && !bpf_jit_enable)
> +#else
> +	if (bpf_ext_enable)
> +#endif

And here:

> +#ifdef CONFIG_BPF_JIT
> +	if (bpf_ext_enable && !bpf_jit_enable) {
> +#else
> +	if (bpf_ext_enable) {
> +#endif

Next:

> +#ifdef CONFIG_64BIT
> +		DL(BPF_STX, BPF_XADD, BPF_DW)
> +#endif
 ...
> +#ifdef CONFIG_64BIT
> +BPF_STX_BPF_XADD_BPF_DW: /* lock xadd *(u64 *)(A + insn->off) += X */
> +	atomic64_add((u64)X, (atomic64_t *)(ulong)(A + insn->off));
> +	CONT;
> +#endif

I'm not too happy about instructions which are only available on
certain architectures.

I'd rather see best effort emulation than wholesale lack of support.

We have an implementation of 64-bit atomics for 32-bit systems or
those without true atomic compare-and-saw etc. ops in lib/atomic64.c
so the routines are always available.

64-bit stores and loads are trivial.
