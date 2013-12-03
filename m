Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3LCRCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:02:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45291 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3LCRCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:02:15 -0500
Message-ID: <529E0E69.90009@zytor.com>
Date: Tue, 03 Dec 2013 09:01:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 3/5] Extended BPF (64-bit BPF) design document
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <1386044930-15149-4-git-send-email-ast@plumgrid.com>
In-Reply-To: <1386044930-15149-4-git-send-email-ast@plumgrid.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 08:28 PM, Alexei Starovoitov wrote:
> +
> +All BPF registers are 64-bit without subregs, which makes JITed x86 code
> +less optimal, but matches sparc/mips architectures.
> +Adding 32-bit subregs was considered, since JIT can map them to x86 and aarch64
> +nicely, but read-modify-write overhead for sparc/mips is not worth the gains.
> +

I find this tradeoff to be more than somewhat puzzling, given that x86
and ARM are by far the dominant tradeoffs, and it would make
implementation on 32-bit CPUs cheaper if a lot of the operations are 32 bit.

Instead it seems like the niche architectures (which, realistically,
SPARC and MIPS have become) ought to take the performance hit.

Perhaps you are simply misunderstanding the notion of subregisters.
Neither x86 nor ARM64 leave the top 32 bits intact, so I don't see why
SPARC/MIPS would do RMW either.

> +Q: Why extended BPF is 64-bit? Cannot we live with 32-bit?
> +A: On 64-bit architectures, pointers are 64-bit and we want to pass 64-bit
> +values in/out kernel functions, so 32-bit BPF registers would require to define
> +register-pair ABI, there won't be a direct BPF register to HW register
> +mapping and JIT would need to do combine/split/move operations for every
> +register in and out of the function, which is complex, bug prone and slow.
> +Another reason is counters. To use 64-bit counter BPF program would need to do
> +a complex math. Again bug prone and not atomic.

Having EBPF code manipulating pointers - or kernel memory - directly
seems like a nonstarter.  However, per your subsequent paragraph it
sounds like pointers are a special type at which point it shouldn't
matter at the EBPF level how many bytes it takes to represent it?

	-hpa

