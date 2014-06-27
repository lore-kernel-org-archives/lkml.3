Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaF0QwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:52:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaF0QwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:52:08 -0400
Date: Fri, 27 Jun 2014 18:52:04 +0200
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
Message-ID: <20140627165204.GJ23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220129.620409461@goodmis.org>
 <20140627134538.GB23205@pathway.suse.cz>
 <20140627101907.3b2ebe5d@gandalf.local.home>
 <20140627151741.GI23205@pathway.suse.cz>
 <20140627113909.4ea41040@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627113909.4ea41040@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-27 11:39:09, Steven Rostedt wrote:
> On Fri, 27 Jun 2014 17:18:04 +0200
> Petr Mládek <pmladek@suse.cz> wrote:
> 
> 
> > > This patch uses seq_buf for the NMI code so it will fill to the end of
> > > the buffer and just truncate what can't fit.
> > 
> > I think that NMI code could live with the trace_seq behavior. The
> > lines are short. If we miss few characters it is not that big difference.
> 
> True, but I'm trying to keep trace_seq more tracing specific.

It is true that most writing functions write as much as possible. On
the other hand, I do not think that refusing to write, if there is not
enough space, is specific to tracing. It might be useful also for others.

In the worst case, we could add a flag into the "struct seq_buf" that
might define the behavior. Well, I am not sure if we want to add this
complexity when there are no users. As I said, the backtraces might
live with trace_seq behavior.

>> 
> > > trace_pipe depends on the trace_seq behavior.
> > > 
> > > > 
> > > >    Another solution would be to live with incomplete lines in tracing.
> > > >    I wonder if any of the functions tries to write the line again when the
> > > >    write failed.
> > > 
> > > This may break trace_pipe. Although there looks to be redundant
> > > behavior in that the pipe code also resets the seq.len on partial line,
> > > so maybe it's not an issue.
> > > 
> > > > 
> > > >    IMHO, the most important thing is that both functions return 0 on
> > > >    failure.
> > > 
> > > Note, I'm not sure how tightly these two need to be. I'm actually
> > > trying to get trace_seq to be specific to tracing and nothing more.
> > > Have seq_buf be used for all other instances.
> > 
> > If the two layers make your life easier then they might make sense. I
> > just saw many similarities and wanted to help. IMHO, if anyone breaks
> > seq_buf, it will break trace_seq anyway. So, they are not really separated.
> 
> There's actually things I want to do with the seq_buf behavior that I
> can't do with the trace_seq behavior. That's more about having a
> dynamic way to create seq_buf buffers and resize them if need be.
> Although, perhaps an all or nothing approach will help in that.

Note that we should not allocate in NMI context, especially when there
is a softlock. So, we might need to define the behavior anyway.


> > 
> > > 
> > > > ad 4th:
> > > > 
> > > >    Both "full" and "overflow" flags seems to have the same meaning.
> > > >    For example, trace_seq_printf() sets "full" on failure even
> > > >    when s->seq.len != s->size.
> > > 
> > > The difference is that the overflow flag is just used for info letting
> > > the user know that it did not fit. The full flag in trace_seq lets you
> > > know that you can not add anything else, even though the new stuff may
> > > fit.
> > 
> > I see. They have another meaning but they are set at the same time:
> > 
> > 	if (s->seq.overflow) {
> > 		...
> > 		s->full = 1;
> > 		return 0;
> > 	}
> > 
> > In fact, both names are slightly misleading. seq.overflow is set
> > when the buffer is full even when all characters were written.
> > s->full is set even when there is still some space :-)
> 
> I actually disagree. overflow means that you wrote more than what was
> there. In this case, it was cropped.

The problem is that we do not know that it was cropped.

The "overflow" flag is set when (s->len > (s->size - 1)). In most
cases it will be set when (s->len == s->size).

For example, seq_buf_printf() calls vsnprintf(). It will never write
over the buffer. We do not know if the message was cropped or if we
were lucky and the message was exactly as long as the free space.


> Full suggests that you can't add anymore because it wont allow you.
> 
> The difference is that you are looking at a implementation point of
> view. I'm looking at a usage point of view. With trace_seq, there is no
> space left, you can't add any more. seq_buf, you can add more but it
> wont be saved because it was overflowed.

I know that there is some difference but I am not sure if users are
really interested into such details. In both cases, they are unable
to write more data. From they point of view, the buffer is simply full.
Honestly, I think that the two flags and the two point of view cause
more confusion than win.

Note that I do not want to change the meaning for trace_buf. I want to
change the meaning for "seq_buf" that has no users yet.


> What I should do is change overflow from being a flag to the number of
> characters that it overflowed by. That would be useful information, and
> would make more sense. It lets the user know what wasn't written.

I am afraid that we do not have this information. See above for the
example with vsnprintf().

In each case, I do not want to block this patch. The generic "seq_buf"
API looks reasonable. The tracing code is your area and it is your
decision. You know much more about it than me and the extra complexity
might be needed.


Best Regards,
Petr
