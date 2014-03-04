Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbaCDSY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:24:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbaCDSYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:24:25 -0500
Message-ID: <53161A14.3060405@redhat.com>
Date: Tue, 04 Mar 2014 19:23:16 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: [PATCH v4 net-next 1/3] Extended BPF interpreter and converter
References: <1393910304-4004-1-git-send-email-ast@plumgrid.com> <1393910304-4004-2-git-send-email-ast@plumgrid.com> <5315A40E.6010209@redhat.com> <CAMEtUuwzo9JdcHdUvSOecmK5QD=5vcRLEE3DsLth=mxXnPOocw@mail.gmail.com>
In-Reply-To: <CAMEtUuwzo9JdcHdUvSOecmK5QD=5vcRLEE3DsLth=mxXnPOocw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 06:09 PM, Alexei Starovoitov wrote:
> On Tue, Mar 4, 2014 at 1:59 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
...
>> Hmm, so the case statement is about BPF_RET | BPF_A and BPF_RET | BPF_K
>> but BPF_RET | BPF_X is not mentioned. However, in BPF_SRC(fp->code)
>> selection you fall back to BPF_X if it doesn't equal BPF_K? Is that
>> correct? And, you probably also need to handle BPF_RET | BPF_X ?
>
> :) that design choice of original BPF always puzzled me.
> BPF_A macro only used in one insn: BPF_RET + BPF_A
> and all other insns use BPF_K and BPF_X
> and though comment in uapi/filter.h says "ret - BPF_K and BPF_X also apply"
> this is not true, since sk_chk_filter() only allows ret+a and ret+k
> libpcap is equally confused. It never generates ret+x, but has few
> places in the code
> that can recognize it. I guess that's an artifact of distant past.

Good point, ret+a and ret+k are main users anyway, though we could fix
that limitation actually. ;)

> epbf has only one RET insn that takes register R0 and returns it.
> That is similar to real CPU 'ret' insn and done to make epbf easier
> to generate from gcc/llvm point of view.
> ebpf jit converts 'ret' into 'leave; ret' on x86_64.
>
> so original bpf+k and bpf+a are converted into 'mov r0, [a or k]; ret r0'
>
> btw, if there is interest I can put ebpf testsuite into tools/net/

Yes, please. Would be great if you can place the test suite under:

   tools/testing/selftests/net/bpf/

I believe some stuff there could get its own folder e.g. "packet"
for PF_PACKET test cases etc, so that we can easily arrange them.
