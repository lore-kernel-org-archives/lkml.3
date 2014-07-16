Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaGPUMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:12:40 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49779 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaGPUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <4f153feea35430104d6d1a7c83805fccbffdf089.1405452484.git.luto@amacapital.net>
References: <cover.1405452484.git.luto@amacapital.net>
	<4f153feea35430104d6d1a7c83805fccbffdf089.1405452484.git.luto@amacapital.net>
Date: Wed, 16 Jul 2014 13:12:32 -0700
X-Google-Sender-Auth: Aq3U3qzSYSqXVB6-nq_Til3cAX0
Message-ID: <CAGXu5jK0v=dtPNY4Y2m7D01peeNoBSDq8zowgLu_rjZe41=eUg@mail.gmail.com>
Subject: Re: [PATCH 2/7] seccomp: Refactor the filter callback and the API
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> The reason I did this is to add a seccomp API that will be usable
> for an x86 fast path.  The x86 entry code needs to use a rather
> expensive slow path for a syscall that might be visible to things
> like ptrace.  By splitting seccomp into two phases, we can check
> whether we need the slow path and then use the fast path in if the
> filter allows the syscall or just returns some errno.
>
> As a side effect, I think the new code is much easier to understand
> than the old code.

I'd agree. The #idefs got a little weirder, but the actual code flow
was much easier to read. I wonder if "phase1" and "phase2" should be
renamed "pretrace" and "tracing" or something more meaningful? Or
"fast" and "slow"?

> This has one user-visible effect: the audit record written for
> SECCOMP_RET_TRACE is now a simple indication that SECCOMP_RET_TRACE
> happened.  It used to depend in a complicated way on what the tracer
> did.  I couldn't make much sense of it.

I think this change is okay. The only way to get the audit record to
report SIGSYS before was to have an additional signal come in and kill
it while the tracer was working on it. Which is confusing too. I like
this way better.

-Kees

-- 
Kees Cook
Chrome OS Security
