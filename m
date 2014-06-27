Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaF0OTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:19:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:47320 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754003AbaF0OTN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:19:13 -0400
Date: Fri, 27 Jun 2014 10:19:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 2/5 v2] tracing: Create seq_buf layer in trace_seq
Message-ID: <20140627101907.3b2ebe5d@gandalf.local.home>
In-Reply-To: <20140627134538.GB23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220129.620409461@goodmis.org>
	<20140627134538.GB23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 15:45:38 +0200
Petr Mládek <pmladek@suse.cz> wrote:

> On Thu 2014-06-26 17:49:03, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> > be limited to page size. This will allow other usages of seq_buf
> > instead of a hard set PAGE_SIZE one that trace_seq has.
> >
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/seq_buf.h              |  58 ++++++
> >  include/linux/trace_seq.h            |  10 +-
> >  kernel/trace/Makefile                |   1 +
> >  kernel/trace/seq_buf.c               | 348 +++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace.c                 |  39 ++--
> >  kernel/trace/trace_events.c          |   6 +-
> >  kernel/trace/trace_functions_graph.c |   6 +-
> >  kernel/trace/trace_seq.c             | 184 +++++++++---------
> >  8 files changed, 527 insertions(+), 125 deletions(-)
> >  create mode 100644 include/linux/seq_buf.h
> >  create mode 100644 kernel/trace/seq_buf.c
> 
> There is a lot of similar code in the two layers. Do you have any
> plans to transform the trace stuff to seq_buf and get rid of the
> trace_seq layer in long term?
> 
> If I get it correctly, the two layers are needed because:
> 
>    1. seq_buf works with any buffer but
>       trace_seq with static buffer
> 
>    2. seq_buf writes even part of the message until the buffer is full but
>       trace_buf writes only full messages or nothing
> 
>    3. seq_buf returns the number of written characters but
>       trace_seq returns 1 on success and 0 on failure
> 
>    4. seq_buf sets "overflow" flag when an operation failed but
>       trace_seq sets "full" when this happens
> 
> 
> I wounder if we could get a compromise and use only one layer.
> 
> ad 1st:
> 
>    I have checked many locations and it seems that trace_seq_init() is
>    called before the other functions as used. There is the WARN_ON()
>    in the generic seq_buf() functions, so they would not crash. If
>    there is some init missing, we could fix it later.
> 
>    But I haven't really tested it yet.

Actually, there's a few hidden places that initialize a struct with
kzalloc that contains a trace_seq. I started fixing them but there were
more and more to find that I decided to give up and just add the check
to see if it needed to be initialized at each call.

Not that pretty, but not that critical to be worth crashing something
we missed. Maybe in the future this can change, but not now.


> 
> 
> ad 2nd and 3rd:
> 
>    These are connected.
> 
>    On solution is to disable writing part of the text even in the
>    generic seq_buf functions. I think that it is perfectly fine.
>    If we do not print the entire line, we are in troubles anyway.
>    Note that we could not allocate another buffer in NMI, so
>    we will lose part of the message anyway.

This patch uses seq_buf for the NMI code so it will fill to the end of
the buffer and just truncate what can't fit.

trace_pipe depends on the trace_seq behavior.

> 
>    Another solution would be to live with incomplete lines in tracing.
>    I wonder if any of the functions tries to write the line again when the
>    write failed.

This may break trace_pipe. Although there looks to be redundant
behavior in that the pipe code also resets the seq.len on partial line,
so maybe it's not an issue.

> 
>    IMHO, the most important thing is that both functions return 0 on
>    failure.

Note, I'm not sure how tightly these two need to be. I'm actually
trying to get trace_seq to be specific to tracing and nothing more.
Have seq_buf be used for all other instances.



> 
> 
> ad 4th:
> 
>    Both "full" and "overflow" flags seems to have the same meaning.
>    For example, trace_seq_printf() sets "full" on failure even
>    when s->seq.len != s->size.

The difference is that the overflow flag is just used for info letting
the user know that it did not fit. The full flag in trace_seq lets you
know that you can not add anything else, even though the new stuff may
fit.

-- Steve
