Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCIOti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 10:49:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60489 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaCIOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 10:49:36 -0400
Message-ID: <1394376574.20149.99.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v7 net-next 1/3] filter: add Extended BPF interpreter
 and converter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Will Drewry <wad@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Hagen Paul Pfeifer <hagen@jauu.net>,
        Jesse Gross <jesse@nicira.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Pekka Enberg <penberg@iki.fi>, Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Sun, 09 Mar 2014 07:49:34 -0700
In-Reply-To: <1394320530-3508-2-git-send-email-ast@plumgrid.com>
References: <1394320530-3508-1-git-send-email-ast@plumgrid.com>
	 <1394320530-3508-2-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 15:15 -0800, Alexei Starovoitov wrote:

> +			if (BPF_SRC(fp->code) == BPF_K &&
> +			    (int)fp->k < 0) {
> +				/* extended BPF immediates are signed,
> +				 * zero extend immediate into tmp register
> +				 * and use it in compare insn
> +				 */
> +				insn->code = BPF_ALU | BPF_MOV | BPF_K;
> +				insn->a_reg = 2;
> +				insn->imm = fp->k;
> +				insn++;
> +
> +				insn->a_reg = 6;
> +				insn->x_reg = 2;
> +				bpf_src = BPF_X;
> +			} else {
> +				insn->a_reg = 6;
> +				insn->x_reg = 7;
> +				insn->imm = fp->k;
> +				bpf_src = BPF_SRC(fp->code);
> +			}
> +			/* common case where 'jump_false' is next insn */
> +			if (fp->jf == 0) {
> +				insn->code = BPF_JMP | BPF_OP(fp->code) |
> +					bpf_src;
> +				tgt = i + fp->jt + 1;
> +				EMIT_JMP;
> +				break;
> +			}
> +			/* convert JEQ into JNE when 'jump_true' is next insn */
> +			if (fp->jt == 0 && BPF_OP(fp->code) == BPF_JEQ) {
> +				insn->code = BPF_JMP | BPF_JNE | bpf_src;
> +				tgt = i + fp->jf + 1;
> +				EMIT_JMP;
> +				break;
> +			}
> +			/* other jumps are mapped into two insns: Jxx and JA */
> +			tgt = i + fp->jt + 1;
> +			insn->code = BPF_JMP | BPF_OP(fp->code) | bpf_src;
> +			EMIT_JMP;
> +
> +			insn++;
> +			insn->code = BPF_JMP | BPF_JA;
> +			tgt = i + fp->jf + 1;
> +			EMIT_JMP;
> +			break;
> +
> +		/* ldxb 4*([14]&0xf) is remaped into 3 insns */
> +		case BPF_LDX | BPF_MSH | BPF_B:
> +			insn->code = BPF_LD | BPF_ABS | BPF_B;
> +			insn->a_reg = 7;
> +			insn->imm = fp->k;
> +
> +			insn++;
> +			insn->code = BPF_ALU | BPF_AND | BPF_K;
> +			insn->a_reg = 7;
> +			insn->imm = 0xf;
> +
> +			insn++;
> +			insn->code = BPF_ALU | BPF_LSH | BPF_K;
> +			insn->a_reg = 7;
> +			insn->imm = 2;
> +			break;
> +
> +		/* RET_K, RET_A are remaped into 2 insns */
> +		case BPF_RET | BPF_A:
> +		case BPF_RET | BPF_K:
> +			insn->code = BPF_ALU | BPF_MOV |
> +				(BPF_RVAL(fp->code) == BPF_K ? BPF_K : BPF_X);
> +			insn->a_reg = 0;
> +			insn->x_reg = 6;
> +			insn->imm = fp->k;
> +
> +			insn++;
> +			insn->code = BPF_RET | BPF_K;
> +			break;


What the hell is this ?

All this magical values, like 2, 6, 7, 10.

I am afraid nobody will be able to read this but you.



