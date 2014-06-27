Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaF0PSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:18:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaF0PSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:18:07 -0400
Date: Fri, 27 Jun 2014 17:18:04 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20140627151741.GI23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220129.620409461@goodmis.org>
 <20140627134538.GB23205@pathway.suse.cz>
 <20140627101907.3b2ebe5d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627101907.3b2ebe5d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-27 10:19:07, Steven Rostedt wrote:
> On Fri, 27 Jun 2014 15:45:38 +0200
> Petr Mládek <pmladek@suse.cz> wrote:
> 
> > On Thu 2014-06-26 17:49:03, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> > > be limited to page size. This will allow other usages of seq_buf
> > > instead of a hard set PAGE_SIZE one that trace_seq has.
> > >
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  include/linux/seq_buf.h              |  58 ++++++
> > >  include/linux/trace_seq.h            |  10 +-
> > >  kernel/trace/Makefile                |   1 +
> > >  kernel/trace/seq_buf.c               | 348 +++++++++++++++++++++++++++++++++++
> > >  kernel/trace/trace.c                 |  39 ++--
> > >  kernel/trace/trace_events.c          |   6 +-
> > >  kernel/trace/trace_functions_graph.c |   6 +-
> > >  kernel/trace/trace_seq.c             | 184 +++++++++---------
> > >  8 files changed, 527 insertions(+), 125 deletions(-)
> > >  create mode 100644 include/linux/seq_buf.h
> > >  create mode 100644 kernel/trace/seq_buf.c
> > 
> > There is a lot of similar code in the two layers. Do you have any
> > plans to transform the trace stuff to seq_buf and get rid of the
> > trace_seq layer in long term?
> > 
> > If I get it correctly, the two layers are needed because:
> > 
> >    1. seq_buf works with any buffer but
> >       trace_seq with static buffer
> > 
> >    2. seq_buf writes even part of the message until the buffer is full but
> >       trace_buf writes only full messages or nothing
> > 
> >    3. seq_buf returns the number of written characters but
> >       trace_seq returns 1 on success and 0 on failure
> > 
> >    4. seq_buf sets "overflow" flag when an operation failed but
> >       trace_seq sets "full" when this happens
> > 
> > 
> > I wounder if we could get a compromise and use only one layer.
> > 
> > ad 1st:
> > 
> >    I have checked many locations and it seems that trace_seq_init() is
> >    called before the other functions as used. There is the WARN_ON()
> >    in the generic seq_buf() functions, so they would not crash. If
> >    there is some init missing, we could fix it later.
> > 
> >    But I haven't really tested it yet.
> 
> Actually, there's a few hidden places that initialize a struct with
> kzalloc that contains a trace_seq. I started fixing them but there were
> more and more to find that I decided to give up and just add the check
> to see if it needed to be initialized at each call.
> 
> Not that pretty, but not that critical to be worth crashing something
> we missed. Maybe in the future this can change, but not now.

I see.
 
> > 
> > ad 2nd and 3rd:
> > 
> >    These are connected.
> > 
> >    On solution is to disable writing part of the text even in the
> >    generic seq_buf functions. I think that it is perfectly fine.
> >    If we do not print the entire line, we are in troubles anyway.
> >    Note that we could not allocate another buffer in NMI, so
> >    we will lose part of the message anyway.
> 
> This patch uses seq_buf for the NMI code so it will fill to the end of
> the buffer and just truncate what can't fit.

I think that NMI code could live with the trace_seq behavior. The
lines are short. If we miss few characters it is not that big difference.

> trace_pipe depends on the trace_seq behavior.
> 
> > 
> >    Another solution would be to live with incomplete lines in tracing.
> >    I wonder if any of the functions tries to write the line again when the
> >    write failed.
> 
> This may break trace_pipe. Although there looks to be redundant
> behavior in that the pipe code also resets the seq.len on partial line,
> so maybe it's not an issue.
> 
> > 
> >    IMHO, the most important thing is that both functions return 0 on
> >    failure.
> 
> Note, I'm not sure how tightly these two need to be. I'm actually
> trying to get trace_seq to be specific to tracing and nothing more.
> Have seq_buf be used for all other instances.

If the two layers make your life easier then they might make sense. I
just saw many similarities and wanted to help. IMHO, if anyone breaks
seq_buf, it will break trace_seq anyway. So, they are not really separated.

> 
> > ad 4th:
> > 
> >    Both "full" and "overflow" flags seems to have the same meaning.
> >    For example, trace_seq_printf() sets "full" on failure even
> >    when s->seq.len != s->size.
> 
> The difference is that the overflow flag is just used for info letting
> the user know that it did not fit. The full flag in trace_seq lets you
> know that you can not add anything else, even though the new stuff may
> fit.

I see. They have another meaning but they are set at the same time:

	if (s->seq.overflow) {
		...
		s->full = 1;
		return 0;
	}

In fact, both names are slightly misleading. seq.overflow is set
when the buffer is full even when all characters were written.
s->full is set even when there is still some space :-)

I suggest to rename "overflow" to "full" and have it only in the
struct "seq_buf". Then it has the right meaning in "seq_buf" and is still
backward compatible with "trace_seq".


Best Regards,
Petr
