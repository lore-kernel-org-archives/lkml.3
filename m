Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab3LIPCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:02:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52476 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933548Ab3LIPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:02:51 -0500
Date: Mon, 9 Dec 2013 10:02:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: binary blob no more! Was: [RFC PATCH tip 0/5] tracing filters
 with BPF
Message-ID: <20131209100248.74db0fb3@gandalf.local.home>
In-Reply-To: <CAMEtUuwGyDfYT-twem4z_sAaG1DeUp7ams69dQKyxkdBfSsC7Q@mail.gmail.com>
References: <CAMEtUuwGyDfYT-twem4z_sAaG1DeUp7ams69dQKyxkdBfSsC7Q@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Dec 2013 19:36:18 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

 
> Actually I think there are few ways to include the source equivalent
> in bpf image.
> 
> Approach #1
> include original C source code into bpf image:
>   bpf_image = bpf_insns + original_C
> this will imply that C code can have #include's of linux kernel headers only
> and it can only be C source.
> this way the user can do 'cat /sys/kernel/debug/bpf/filter', kernel
> will print original_C and these restrictions will guarantee that it
> will compile into similar bpf code whether gcc or llvm compiler is
> used.
> 
> Approach #2
> include original llvm bitcode:
>   bpf_image = bpf_insns + llvm_bc
> The user can do 'cat .../filter' and use llvm-dis to see human readable bitcode.
> It takes practice to read it, but it's high level enough to understand
> what filter is doing. llvm-llc can be used to generate bpf_insns
> again, or generate C from bitcode.
> Pro vs 1: bitcode is very compact
> Con: only llvm compiler can used to generate bpf instructions
> 
> Enforcement can be done by having a user space daemon that
> walks over all loaded filters and recompiles them from C or from bitcode.
> 
> Please let me know which approach you prefer.

I don't like either. And different compilers may produce different
results, so that daemon may not be able to verify what is in the C code
is really what's in the bitcode.

> 
> I still think that bpf_image = bpf_insns + license_string is just as good,
> since bpf code can only call tiny set of functions, so no matter what
> the code does its scope is very limited and license enforcement
> guarantees that original source has to be available,
> but I'm ok whichever way.

I like that approach much better. That is, all binary code must state
that it is under the GPL. That way, if you give a binary to someone,
you must also supply the source under the GPL license.

Having a disassembler in the kernel to see what code is loaded, adds
the added benefit that you can see what is there. We can have a
userspace tool to make even more sense out of the disassembled code.

I don't think the kernel should have anything more than a disassembler
though. Maybe that's even too much, but at least a human can inspect it
a little without needing extra tools.

> 
> Also please indicate whether gcc or llvm backend is preferred to
> be hosted in tools.

If we end up placing a compiler in tools, than that compiler should
also be able to be used to compile the entire kernel.

Maybe we will finally get our kcc ;-)

-- Steve
