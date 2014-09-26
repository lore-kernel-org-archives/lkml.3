Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaIZQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:29:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaIZQ3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:29:03 -0400
Date: Fri, 26 Sep 2014 18:28:58 +0200
From: Petr Mladek <pmladek@suse.cz>
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
Message-ID: <20140926162858.GA23430@dhcp128.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220129.620409461@goodmis.org>
 <20140627134538.GB23205@pathway.suse.cz>
 <20140627101907.3b2ebe5d@gandalf.local.home>
 <20140627151741.GI23205@pathway.suse.cz>
 <20140627113909.4ea41040@gandalf.local.home>
 <20140627165204.GJ23205@pathway.suse.cz>
 <20140926110043.39eb1c1a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140926110043.39eb1c1a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 26-09-14 11:00:43, Steven Rostedt wrote:
> As people are asking for this patch series to be added, I'm going back
> through your comments. I never replied to this email (at least my email
> client says I did not).

It is great that you are on it again. I am looking forward to have the
proposed solution of the backtrace printing under NMI.


> On Fri, 27 Jun 2014 18:52:04 +0200
> Petr Mládek <pmladek@suse.cz> wrote:
> 
> > On Fri 2014-06-27 11:39:09, Steven Rostedt wrote:
> > > On Fri, 27 Jun 2014 17:18:04 +0200
> > > Petr Mládek <pmladek@suse.cz> wrote:
> > > 
> > > 
> > > > > This patch uses seq_buf for the NMI code so it will fill to the end of
> > > > > the buffer and just truncate what can't fit.
> > > > 
> > > > I think that NMI code could live with the trace_seq behavior. The
> > > > lines are short. If we miss few characters it is not that big difference.
> > > 
> > > True, but I'm trying to keep trace_seq more tracing specific.
> > 
> > It is true that most writing functions write as much as possible. On
> > the other hand, I do not think that refusing to write, if there is not
> > enough space, is specific to tracing. It might be useful also for others.
> 
> Looking at what seq_file does, for example seq_printf(), it fills the
> buffer to the max size. If the printf is truncated, it sets the count
> to the size of the buffer. Then in traverse(), it detects that an
> overflow happened and stops reading, frees the buffer, increases the
> size of the buffer (by power of two), and then tries again with the
> bigger buffer.
> 
> Really, it doesn't matter if seq_printf() didn't write anything or if
> it truncated, the result would be the same. Perhaps then I can keep
> seq_buf doing a all or nothing approach like trace_seq does. I think it
> was Andrew (akpm) that criticized this behavior.

I guess that you mean https://lkml.org/lkml/2014/6/20/26 and the part:

--- cut ---
> +
> +	/* If we can't write it all, don't bother writing anything */

This is somewhat unusual behavior for a write()-style thing.  Comment
should explain "why", not "what".
--- cut ---

> 
> > 
> > 
> > > > 
> > > > > 
> > > > > > ad 4th:
> > > > > > 
> > > > > >    Both "full" and "overflow" flags seems to have the same meaning.
> > > > > >    For example, trace_seq_printf() sets "full" on failure even
> > > > > >    when s->seq.len != s->size.
> > > > > 
> > > > > The difference is that the overflow flag is just used for info letting
> > > > > the user know that it did not fit. The full flag in trace_seq lets you
> > > > > know that you can not add anything else, even though the new stuff may
> > > > > fit.
> > > > 
> > > > I see. They have another meaning but they are set at the same time:
> > > > 
> > > > 	if (s->seq.overflow) {
> > > > 		...
> > > > 		s->full = 1;
> > > > 		return 0;
> > > > 	}
> 
> Well, if it is overflowed, it can't write anymore ;-)
> 
> But notice that the seq.len is still the same. Hmm, I need to zero that
> as well. As tools are allowed to print s->buffer with it. We don't want
> added data to it.

Your patch actually do

    back s->seq.len = save_len;

which is reasonable. I probably simplified it by the dots (...) too much. :-)

> > > > 
> > > > In fact, both names are slightly misleading. seq.overflow is set
> > > > when the buffer is full even when all characters were written.
> > > > s->full is set even when there is still some space :-)
> > > 
> > > I actually disagree. overflow means that you wrote more than what was
> > > there. In this case, it was cropped.
> > 
> > The problem is that we do not know that it was cropped.
> > 
> > The "overflow" flag is set when (s->len > (s->size - 1)). In most
> > cases it will be set when (s->len == s->size).
> > 
> > For example, seq_buf_printf() calls vsnprintf(). It will never write
> > over the buffer. We do not know if the message was cropped or if we
> > were lucky and the message was exactly as long as the free space.
> > 
> 
> Again, I was doing this because of what was suggested before. I'll try
> to find the email. I may work to have seq_buf() be used for seq_file
> first, and then make trace_seq() use it. That might make even more
> sense.

OK, let's see what is going out of the integration with seq_file.

Also I am going to think about another solution. In fact, I think that
both names "overflow" and "full" are slightly misleading. As explained
above, "overflow" might be set event when there was no real overflow and
"full" is set even when there seems to be a space. I understand
how it is designed but I wonder if we might find a more clear
solution, maybe just a better name(s).

> > In each case, I do not want to block this patch. The generic "seq_buf"
> > API looks reasonable. The tracing code is your area and it is your
> > decision. You know much more about it than me and the extra complexity
> > might be needed.
> 
> Yeah, we can always change it later. It's not an interface into
> userspace, thus it's not set in stone. But I still want something that
> is reasonable before pushing further. I'll go find those comments from
> Andrew and see where things can be figured out. Perhaps writing a patch
> that makes seq_file() use seq_buf might show what is needed better.

I see. It makes sense.


Best Regards,
Petr
