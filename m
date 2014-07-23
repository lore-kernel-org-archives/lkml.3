Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaGWTUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:20:42 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43236 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaGWTUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ93-vto9voMENc4jX5itcd_Rm5AZjeChF57fpMYnWocA@mail.gmail.com>
References: <cover.1405992946.git.luto@amacapital.net> <CAGXu5jJ93-vto9voMENc4jX5itcd_Rm5AZjeChF57fpMYnWocA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Jul 2014 12:20:18 -0700
Message-ID: <CALCETrVwqDeRbFOw=k_OhQZ4V6Pn5v3t8ODw75UuE7HKPFz=Sw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] Two-phase seccomp and x86 tracing changes
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Will Drewry <wad@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:37 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jul 21, 2014 at 6:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> [applies on jmorris's security-next tree]
>>
>> This is both a cleanup and a speedup.  It reduces overhead due to
>> installing a trivial seccomp filter by 87%.  The speedup comes from
>> avoiding the full syscall tracing mechanism for filters that don't
>> return SECCOMP_RET_TRACE.
>>
>> This series works by splitting the seccomp hooks into two phases.
>> The first phase evaluates the filter; it can skip syscalls, allow
>> them, kill the calling task, or pass a u32 to the second phase.  The
>> second phase requires a full tracing context, and it sends ptrace
>> events if necessary.
>>
>> Once this is done, I implemented a similar split for the x86 syscall
>> entry work.  The C callback is invoked in two phases: the first has
>> only a partial frame, and it can request phase 2 processing with a
>> full frame.
>>
>> Finally, I switch the 64-bit system_call code to use the new split
>> entry work.  This is a net deletion of assembly code: it replaces
>> all of the audit entry muck.
>>
>> In the process, I fixed some bugs.
>>
>> If this is acceptable, someone can do the same tweak for the
>> ia32entry and entry_32 code.
>>
>> This passes all seccomp tests that I know of.  Now that it's properly
>> rebased, even the previously expected failures are gone.
>>
>> Kees, if you like this version, can you create a branch with patches
>> 1-4?  I think that the rest should go into tip/x86 once everyone's happy
>> with it.
>>
>> Changes from v2:
>>  - Fixed 32-bit x86 build (and the tests pass).
>>  - Put the doc patch where it belongs.
>
> Thanks! This looks good to me. I'll add it to my tree.
>
> Peter, how do you feel about this series? Do the x86 changes look good to you?
>

It looks like patches 1-4 have landed here:

https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath

hpa, what's the route forward for the x86 part?

--Andy
