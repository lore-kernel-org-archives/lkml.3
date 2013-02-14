Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741Ab3BNQ0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:26:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021Ab3BNQ0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:26:54 -0500
Message-ID: <511D104A.1040204@redhat.com>
Date: Thu, 14 Feb 2013 17:26:50 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if 64-bit
 process entered kernel with int 80
References: <511CE3D0.8000308@redhat.com> <20130214150046.GA30543@redhat.com>
In-Reply-To: <20130214150046.GA30543@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 04:00 PM, Oleg Nesterov wrote:
> On 02/14, Denys Vlasenko wrote:
>> This patch makes it so that in syscall-entry-stop caused by
>> "int 80" instruction, PTRACE_GETREGSET returns 32-bit regset.
> 
> Not sure...
> 
> First of all, this is incompatible change. And to me, it doesn't look
> correct anyway. Say, why the debugger can't modify r15 if a 64bit tracee
> does int80?

On x86_64, PTRACE_GET/SETREGS can be used for this: they always operate
on 64-bit registers.

> Or think about PTRACE_EVENT_FORK which can be reported with
> TS_COMPAT set.

I don't see a problem. Yes, PTRACE_GETREGSET will return
32-bit regset in this ptrace-stop, which is a problem... why?

> Probably is_ia32_task() should be reported "explicitely" as we already
> discussed, and afaik you have other ideas.


Yes, there are a few ideas. Say, new ptrace op:
can be introduced to return a vector of longs.
To make it easily parsable, how about (type,len,data...)
records? This also may allow tracer to indicate which records
it wants: for example, not everyone wants to read syscall params.
Maybe something like

ptrace(PTRACE_GETSYSCALL, pid, list_of_elements_I_want, &iov)

where list_of_elements_I_want is long[], 0-terminated,
iov points to a buffer, and on return iov.len is updated
(a-la GETREGSET).

What problems can be solved here?

(1) syscall entry/exit discrimination etc. Say, a record
can contain bit flags, such as "it's a syscall entry",
"it's a syscall exit", "it's a group-stop" etc.
Currently, it is impossible for tracer to distinguish
syscall entry from syscall exit.

(2) a record can supply arch-specific data, such as the x86-specific
problem I tried to address: "was it a int 80 syscall?". Variable-length
record format makes it easy to adapt to different archs' needs.
Alternatively, we can set aside a few bits in "bit flags record"
as arch dependent bits. Most arches need just a few bits.

(3) on syscall entry, a record can contain (up to) 7 words: syscall_no
and 0-6 params, making tracer's code less architecture dependent.
Today in strace, *every* architecture needs to have arch-dependent
regs-to-params conversion code. I would like to be able
to code it in C with the same code for most arches.

(4) We can read structs/data pointed by syscall params, such as
struct stat returned by fstat, without needing additional
round-trip to kernel, *and* with kernel-supplied information
on structure's size. Currently, strace has to know the size correctly.
There were, and will be, bugs in strace where we mishandle
structures because we mis-detect process' bitness, and use wrong
struct stat layouts. If kernel would be able to tell us:
"I returned 78 byte structure in memory pointed to by arg1",
it would help a lot. Even if it wouldn't return the result
structure itself (I imagine it's a lot of work in kernel
to access it in other process vm), knowing its size
will still be a big help.

(5) We can read several regsets: gps, SSE regs, etc.
Maybe someone would find it useful? (strace doesn't need this).


How does this look?

I propose to start small, by implementing just 1; 2 in a form of arch bits
as part of 1; and 3. It will satisfy the needs I tried to address
in my patch.

-- 
vda

