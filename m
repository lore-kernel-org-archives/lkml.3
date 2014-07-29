Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaG2TXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaG2TX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:23:28 -0400
Date: Tue, 29 Jul 2014 21:20:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 0/5] x86: two-phase syscall tracing and seccomp
	fastpath
Message-ID: <20140729192056.GA6308@redhat.com>
References: <cover.1406604806.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1406604806.git.luto@amacapital.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy, to avoid the confusion: I am not trying to review this changes.
As you probably know my understanding of asm code in entry.S is very
limited.

Just a couple of questions to ensure I understand this correctly.

On 07/28, Andy Lutomirski wrote:
>
> This is both a cleanup and a speedup.  It reduces overhead due to
> installing a trivial seccomp filter by 87%.  The speedup comes from
> avoiding the full syscall tracing mechanism for filters that don't
> return SECCOMP_RET_TRACE.

And only after I look at 5/5 I _seem_ to actually understand where
this speedup comes from.

So. Currently tracesys: path always lead to "iret" after syscall, with
this change we can avoid it if phase_1() returns zero, correct?

And, this also removes the special TIF_SYSCALL_AUDIT-only case in entry.S,
cool.

I am wondering if we can do something similar with do_notify_resume() ?


Stupid question. To simplify, lets forget that syscall_trace_enter()
already returns the value. Can't we simplify the asm code if we do
not export 2 functions, but make syscall_trace_enter() return
"bool slow_path_is_needed". So that "tracesys:" could do

	// pseudo code

tracesys:
	SAVE_REST
	FIXUP_TOP_OF_STACK

	call syscall_trace_enter

	if (!slow_path_is_needed) {
		addq REST_SKIP, %rsp
		jmp system_call_fastpath
	}
	
	...

?

Once again, I am just curious, it is not that I actually suggest to consider
this option.

Oleg.

