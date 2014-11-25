Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaKYKak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:30:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38706 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaKYKae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:30:34 -0500
Date: Tue, 25 Nov 2014 10:30:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141125103034.GC30251@arm.com>
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
 <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org>
 <20141118140425.GM18842@arm.com>
 <546C58DB.5080204@linaro.org>
 <20141119190601.GM15985@arm.com>
 <546D7860.2010300@linaro.org>
 <20141120191738.GV19126@arm.com>
 <547432D2.7000909@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547432D2.7000909@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 07:42:10AM +0000, AKASHI Takahiro wrote:
> On 11/21/2014 04:17 AM, Will Deacon wrote:
> > On Thu, Nov 20, 2014 at 05:13:04AM +0000, AKASHI Takahiro wrote:
> >> On 11/20/2014 04:06 AM, Will Deacon wrote:
> >>> On Wed, Nov 19, 2014 at 08:46:19AM +0000, AKASHI Takahiro wrote:
> >>>> Syscall(-1) will return -ENOSYS whether or not a syscallno is explicitly
> >>>> replaced with -1 by a tracer, and, in this sense, it is *skipped*.
> >>>
> >>> Ok, but now userspace sees -ENOSYS for a skipped system call in that case,
> >>> whereas it would usually see whatever the trace put in x0, right?
> >>
> >> If you don't really like this behavior, how about this patch instead of my [2/6] patch?
> >>
> >> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> >> index 726b910..1ef57d0 100644
> >> --- a/arch/arm64/kernel/entry.S
> >> +++ b/arch/arm64/kernel/entry.S
> >> @@ -668,8 +668,15 @@ ENDPROC(el0_svc)
> >>            * switches, and waiting for our parent to respond.
> >>            */
> >>    __sys_trace:
> >> +       cmp     w8, #-1                         // default errno for invalid
> >> +       b.ne    1f                              // system call
> >> +       mov     x0, #-ENOSYS
> >> +       str     x0, [sp, #S_X0]
> >> +1:
> >>           mov     x0, sp
> >>           bl      syscall_trace_enter
> >> +       cmp     w0, #-1                         // skip the syscall?
> >> +       b.eq    __sys_trace_return_skipped
> >>           adr     lr, __sys_trace_return          // return address
> >>           uxtw    scno, w0                        // syscall number (possibly new)
> >>           mov     x1, sp                          // pointer to regs
> >> @@ -684,6 +691,7 @@ __sys_trace:
> >>
> >>    __sys_trace_return:
> >>           str     x0, [sp]                        // save returned x0
> >> +__sys_trace_return_skipped:
> >>           mov     x0, sp
> >>           bl      syscall_trace_exit
> >>           b       ret_to_user
> >>
> >> With this change, I believe, syscall(-1) returns -ENOSYS by default whether traced
> >> or not, and still you can change a return value when tracing.
> >> (But a drawback here is that a tracer will see -ENOSYS in x0 even at syscall entry
> >> for syscall(-1).)
> >
> > But it's exactly these drawbacks that I'm objected to. syscall(-1) shouldn't
> > be treated any differently to syscall(42) with respect to restarting,
> > exactly like x86.
> 
> Can you elaborate a bit more as to "restarting?"

Sorry, I meant skipping. There was another thread about syscall restarting
at the same time I wrote that, so my mind was elsewhere!

> We can't make any assumption about the number of arguments taken by *invalid* syscall(-1)
> and so changing a value in x0 (or any other registers) doesn't make any difference.
> ()

Ok, that's a fair point.

Will
