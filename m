Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaIZPAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:00:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:40336 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754944AbaIZPAr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:00:47 -0400
Date: Fri, 26 Sep 2014 11:00:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?ISO-8859-1?B?TWzhZGVr?= <pmladek@suse.cz>
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
Message-ID: <20140926110043.39eb1c1a@gandalf.local.home>
In-Reply-To: <20140627165204.GJ23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220129.620409461@goodmis.org>
	<20140627134538.GB23205@pathway.suse.cz>
	<20140627101907.3b2ebe5d@gandalf.local.home>
	<20140627151741.GI23205@pathway.suse.cz>
	<20140627113909.4ea41040@gandalf.local.home>
	<20140627165204.GJ23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As people are asking for this patch series to be added, I'm going back
through your comments. I never replied to this email (at least my email
client says I did not).

On Fri, 27 Jun 2014 18:52:04 +0200
Petr Mládek <pmladek@suse.cz> wrote:

> On Fri 2014-06-27 11:39:09, Steven Rostedt wrote:
> > On Fri, 27 Jun 2014 17:18:04 +0200
> > Petr Mládek <pmladek@suse.cz> wrote:
> > 
> > 
> > > > This patch uses seq_buf for the NMI code so it will fill to the end of
> > > > the buffer and just truncate what can't fit.
> > > 
> > > I think that NMI code could live with the trace_seq behavior. The
> > > lines are short. If we miss few characters it is not that big difference.
> > 
> > True, but I'm trying to keep trace_seq more tracing specific.
> 
> It is true that most writing functions write as much as possible. On
> the other hand, I do not think that refusing to write, if there is not
> enough space, is specific to tracing. It might be useful also for others.

Looking at what seq_file does, for example seq_printf(), it fills the
buffer to the max size. If the printf is truncated, it sets the count
to the size of the buffer. Then in traverse(), it detects that an
overflow happened and stops reading, frees the buffer, increases the
size of the buffer (by power of two), and then tries again with the
bigger buffer.

Really, it doesn't matter if seq_printf() didn't write anything or if
it truncated, the result would be the same. Perhaps then I can keep
seq_buf doing a all or nothing approach like trace_seq does. I think it
was Andrew (akpm) that criticized this behavior.


> 
> In the worst case, we could add a flag into the "struct seq_buf" that
> might define the behavior. Well, I am not sure if we want to add this
> complexity when there are no users. As I said, the backtraces might
> live with trace_seq behavior.
> 

Yeah, I don't want to add more complexity to this. No flags :-)


> >> 
> > > > trace_pipe depends on the trace_seq behavior.
> > > > 
> > > > > 
> > > > >    Another solution would be to live with incomplete lines in tracing.
> > > > >    I wonder if any of the functions tries to write the line again when the
> > > > >    write failed.
> > > > 
> > > > This may break trace_pipe. Although there looks to be redundant
> > > > behavior in that the pipe code also resets the seq.len on partial line,
> > > > so maybe it's not an issue.
> > > > 
> > > > > 
> > > > >    IMHO, the most important thing is that both functions return 0 on
> > > > >    failure.
> > > > 
> > > > Note, I'm not sure how tightly these two need to be. I'm actually
> > > > trying to get trace_seq to be specific to tracing and nothing more.
> > > > Have seq_buf be used for all other instances.
> > > 
> > > If the two layers make your life easier then they might make sense. I
> > > just saw many similarities and wanted to help. IMHO, if anyone breaks
> > > seq_buf, it will break trace_seq anyway. So, they are not really separated.
> > 
> > There's actually things I want to do with the seq_buf behavior that I
> > can't do with the trace_seq behavior. That's more about having a
> > dynamic way to create seq_buf buffers and resize them if need be.
> > Although, perhaps an all or nothing approach will help in that.
> 
> Note that we should not allocate in NMI context, especially when there
> is a softlock. So, we might need to define the behavior anyway.

No, I wouldn't mean that seq_buf would automatically allocate, but a
wrapper to seq_buf could. Like what seq_file does. In fact, perhaps, we
can have seq_buf be part of seq_file and consolidate the behavior?

> 
> 
> > > 
> > > > 
> > > > > ad 4th:
> > > > > 
> > > > >    Both "full" and "overflow" flags seems to have the same meaning.
> > > > >    For example, trace_seq_printf() sets "full" on failure even
> > > > >    when s->seq.len != s->size.
> > > > 
> > > > The difference is that the overflow flag is just used for info letting
> > > > the user know that it did not fit. The full flag in trace_seq lets you
> > > > know that you can not add anything else, even though the new stuff may
> > > > fit.
> > > 
> > > I see. They have another meaning but they are set at the same time:
> > > 
> > > 	if (s->seq.overflow) {
> > > 		...
> > > 		s->full = 1;
> > > 		return 0;
> > > 	}

Well, if it is overflowed, it can't write anymore ;-)

But notice that the seq.len is still the same. Hmm, I need to zero that
as well. As tools are allowed to print s->buffer with it. We don't want
added data to it.


> > > 
> > > In fact, both names are slightly misleading. seq.overflow is set
> > > when the buffer is full even when all characters were written.
> > > s->full is set even when there is still some space :-)
> > 
> > I actually disagree. overflow means that you wrote more than what was
> > there. In this case, it was cropped.
> 
> The problem is that we do not know that it was cropped.
> 
> The "overflow" flag is set when (s->len > (s->size - 1)). In most
> cases it will be set when (s->len == s->size).
> 
> For example, seq_buf_printf() calls vsnprintf(). It will never write
> over the buffer. We do not know if the message was cropped or if we
> were lucky and the message was exactly as long as the free space.
> 

Again, I was doing this because of what was suggested before. I'll try
to find the email. I may work to have seq_buf() be used for seq_file
first, and then make trace_seq() use it. That might make even more
sense.

> 
> > Full suggests that you can't add anymore because it wont allow you.
> > 
> > The difference is that you are looking at a implementation point of
> > view. I'm looking at a usage point of view. With trace_seq, there is no
> > space left, you can't add any more. seq_buf, you can add more but it
> > wont be saved because it was overflowed.
> 
> I know that there is some difference but I am not sure if users are
> really interested into such details. In both cases, they are unable
> to write more data. From they point of view, the buffer is simply full.
> Honestly, I think that the two flags and the two point of view cause
> more confusion than win.

Lets see what happens if I make seq_file use seq_buf. This may be
interesting.

> 
> Note that I do not want to change the meaning for trace_buf. I want to
> change the meaning for "seq_buf" that has no users yet.

Understood. But others have suggested ideas that contradict yours. We
do need to straighten this out.

> 
> 
> > What I should do is change overflow from being a flag to the number of
> > characters that it overflowed by. That would be useful information, and
> > would make more sense. It lets the user know what wasn't written.
> 
> I am afraid that we do not have this information. See above for the
> example with vsnprintf().
> 
> In each case, I do not want to block this patch. The generic "seq_buf"
> API looks reasonable. The tracing code is your area and it is your
> decision. You know much more about it than me and the extra complexity
> might be needed.

Yeah, we can always change it later. It's not an interface into
userspace, thus it's not set in stone. But I still want something that
is reasonable before pushing further. I'll go find those comments from
Andrew and see where things can be figured out. Perhaps writing a patch
that makes seq_file() use seq_buf might show what is needed better.

Thanks,

-- Steve
