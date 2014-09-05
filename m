Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaIEQTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:19:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50111 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIEQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:19:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1409051157440.5269@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1409051157440.5269@file01.intranet.prod.int.rdu2.redhat.com>
Date: Fri, 5 Sep 2014 09:19:17 -0700
Message-ID: <CAMEtUuwx12Df79KV6kG+5eGJ=zH4XQ8+rpnst9WKT1oueYZTkQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix a false positive kmemcheck warning
From: Alexei Starovoitov <ast@plumgrid.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 9:01 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> This patch fixes false positive kmemcheck warning in bpf.
>
> When we try to write the variable len, the compiler generates a code that
> reads the 32-bit word, modifies the bits belonging to "len" and writes the
> 32-bit word back. The reading of the word results in kmemcheck warning due
> to reading uninitialized memory. This patch fixes it by avoiding using bit
> fields when kmemcheck is enabled.

It will conflict with pending Hannes's patch.
Once it's in, I can rebase and actually make it unconditional.
These bit savings probably not worth it, since bpf_prog is
dominated by program anyway.

JITs would need to be updated as well, since they're now do
->jited = 1;
I can fix this all up.
Do you mind sharing the kmemcheck warning you see?

> Index: linux-2.6/include/linux/filter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/filter.h       2014-09-04 23:04:26.000000000 +0200
> +++ linux-2.6/include/linux/filter.h    2014-09-04 23:43:05.000000000 +0200

why diff says 2.6 ? Kinda odd.

> @@ -325,8 +325,13 @@ struct sock;
>  struct seccomp_data;
>
>  struct bpf_prog {
> +#ifdef CONFIG_KMEMCHECK
> +       bool                    jited;
> +       u32                     len;
> +#else
>         u32                     jited:1,        /* Is our filter JIT'ed? */
>                                 len:31;         /* Number of filter blocks */
> +#endif
>         struct sock_fprog_kern  *orig_prog;     /* Original BPF program */
>         unsigned int            (*bpf_func)(const struct sk_buff *skb,
>                                             const struct bpf_insn *filter);
