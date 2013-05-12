Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3ELCLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 22:11:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3ELCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 22:11:31 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MHtc-6IHmuYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=nVE_FSFTGkgA:10 a=bGLrUZ2y8D87rGjWdkwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368324689.6828.13.camel@gandalf.local.home>
Subject: Re: [PATCH 00/18] tracing/kprobes: Update kprobes with new ftrace
 changes
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Sat, 11 May 2013 22:11:29 -0400
In-Reply-To: <CA+55aFyftw6uxJ=pO4DgN7ZrKxE5X-cbQahMjKKu6Rb++EGhqQ@mail.gmail.com>
References: <20130511001206.477862307@goodmis.org>
	 <CA+55aFyftw6uxJ=pO4DgN7ZrKxE5X-cbQahMjKKu6Rb++EGhqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-11 at 18:16 -0700, Linus Torvalds wrote:
> On Fri, May 10, 2013 at 5:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Linus,
> >
> > The majority of these changes are from Masami Hiramatsu bringing
> > kprobes up to par with the latest changes to ftrace (multi buffering
> > and the new function probes).
> 
> So I pulled this just before doing -rc1, and I'm a bit worried about
> "make allmodconfig" resulting in these new warnings:
> 
>    WARNING: "ring_buffer_event_data" [*/*/*.ko] has no CRC!

I have no idea what that means. I found that line gets printed by
scripts/mod/modpost.c, but why it would print that for this is beyond
me. Note, the changes you pulled had nothing directly to do with that
function.

Here's the function in question:

void *ring_buffer_event_data(struct ring_buffer_event *event)
{
	return rb_event_data(event);
}
EXPORT_SYMBOL_GPL(ring_buffer_event_data);


> 
> but the kernel I actually install and boot doesn't show that, so I
> don't know if this then actually causes problems. And since I wasn't
> going to do a kernel release tomorrow, I shipped -rc1 as-is.

Yeah, I built, booted and tested an allmodconfig (as one of the ktests I
run), before sending you a pull request, so I didn't think it would be
an issue.

Although, I have to admit, I didn't look for new warnings on
allmodconfig. I do that check on other tests. I guess I should add a new
warning check for that test too. Although, as this is a warning from a
post compile program and not a gcc warning, my test will probably not
catch it.

> 
> Please do check it out and send me a fix, though.

I'm running an allmodconfig test now.

I see that function called near some of the changes in trace_kprobes.c:

        if (!event)
                return;
 
        entry = ring_buffer_event_data(event);
-       entry->ip = (unsigned long)kp->addr;
+       entry->ip = (unsigned long)tp->rp.kp.addr;
        store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
That's the only place I see it referenced in that last pull request. Not
sure why that would cause any issue.

I'll take a look when my allmodconfig test finishes.

-- Steve


