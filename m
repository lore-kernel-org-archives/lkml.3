Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaJNRNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:13:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42840 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaJNRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:13:43 -0400
Date: Tue, 14 Oct 2014 13:13:38 -0400 (EDT)
Message-Id: <20141014.131338.1924789014148410781.davem@davemloft.net>
To: ast@plumgrid.com
Cc: darrick.wong@oracle.com, edumazet@google.com, dborkman@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, mingo@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] x86: bpf_jit: fix two bugs in eBPF JIT compiler
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412998223-3805-1-git-send-email-ast@plumgrid.com>
References: <1412998223-3805-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 10:13:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Fri, 10 Oct 2014 20:30:23 -0700

> 1.
> JIT compiler using multi-pass approach to converge to final image size,
> since x86 instructions are variable length. It starts with large
> gaps between instructions (so some jumps may use imm32 instead of imm8)
> and iterates until total program size is the same as in previous pass.
> This algorithm works only if program size is strictly decreasing.
> Programs that use LD_ABS insn need additional code in prologue, but it
> was not emitted during 1st pass, so there was a chance that 2nd pass would
> adjust imm32->imm8 jump offsets to the same number of bytes as increase in
> prologue, which may cause algorithm to erroneously decide that size converged.
> Fix it by always emitting largest prologue in the first pass which
> is detected by oldproglen==0 check.
> Also change error check condition 'proglen != oldproglen' to fail gracefully.
> 
> 2.
> while staring at the code realized that 64-byte buffer may not be enough
> when 1st insn is large, so increase it to 128 to avoid buffer overflow
> (theoretical maximum size of prologue+div is 109) and add runtime check.
> 
> Fixes: 622582786c9e ("net: filter: x86: internal BPF JIT")
> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> v1->v2: reduce chances of stack corruption in case of future bugs (suggested by Eric)
> 
> note in classic BPF programs 1st insn is always short move, but native eBPF
> programs may trigger buffer overflow. I couldn't force the crash with overflow,
> since there are no further calls while this part of stack is used.
> Both are ugly bugs regardless.
> When net-next opens I will add narrowed down testcase from 'nmap' to testsuite.

Applied, thanks Alexei.
