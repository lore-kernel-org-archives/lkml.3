Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaHBWKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:10:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49526 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaHBWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:10:00 -0400
Date: Sat, 02 Aug 2014 15:09:56 -0700 (PDT)
Message-Id: <20140802.150956.747835720193799195.davem@davemloft.net>
To: ast@plumgrid.com
Cc: dborkman@redhat.com, willemb@google.com, pablo@netfilter.org,
        keescook@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/5] net: filter: split sk_filter into
 socket and bpf, cleanup names
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406777656-27755-1-git-send-email-ast@plumgrid.com>
References: <1406777656-27755-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 15:09:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 30 Jul 2014 20:34:11 -0700

> The main goal of the series is to split 'struct sk_filter' into socket and
> bpf parts and cleanup names in the following way:
> - everything that deals with sockets keeps 'sk_*' prefix
> - everything that is pure BPF is changed to 'bpf_*' prefix
> 
> split 'struct sk_filter' into
> struct sk_filter {
> 	atomic_t        refcnt;
> 	struct rcu_head rcu;
> 	struct bpf_prog *prog;
> };
> and
> struct bpf_prog {
>         u32                     jited:1,
>                                 len:31;
>         struct sock_fprog_kern  *orig_prog;
>         unsigned int            (*bpf_func)(const struct sk_buff *skb,
>                                             const struct bpf_insn *filter);
>         union {
>                 struct sock_filter      insns[0];
>                 struct bpf_insn         insnsi[0];
>                 struct work_struct      work;
>         };
> };
> so that 'struct bpf_prog' can be used independent of sockets and cleans up
> 'unattached' bpf use cases:
> isdn, ppp, team, seccomp, ptp, xt_bpf, cls_bpf, test_bpf
> which don't need refcnt/rcu fields.
> 
> It's a follow up to the rcu cleanup started by Pablo in
> commit 34c5bd66e5 ("net: filter: don't release unattached filter through call_rcu()")
> 
> Patch 1 - cleans up socket memory charging and makes it possible for functions
>   sk(bpf)_migrate_filter(), sk(bpf)_prepare_filter() to be socket independent
> Patches 2-4 - trivial renames
> Patch 5 - sk_filter split and renames of related sk_*() functions

Series applied, thanks Alexei.
