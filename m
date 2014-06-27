Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaF0PjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:39:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:25419 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753607AbaF0PjM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:39:12 -0400
Date: Fri, 27 Jun 2014 11:39:09 -0400
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
Message-ID: <20140627113909.4ea41040@gandalf.local.home>
In-Reply-To: <20140627151741.GI23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220129.620409461@goodmis.org>
	<20140627134538.GB23205@pathway.suse.cz>
	<20140627101907.3b2ebe5d@gandalf.local.home>
	<20140627151741.GI23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 17:18:04 +0200
Petr Mládek <pmladek@suse.cz> wrote:


> > This patch uses seq_buf for the NMI code so it will fill to the end of
> > the buffer and just truncate what can't fit.
> 
> I think that NMI code could live with the trace_seq behavior. The
> lines are short. If we miss few characters it is not that big difference.

True, but I'm trying to keep trace_seq more tracing specific.

> 
> > trace_pipe depends on the trace_seq behavior.
> > 
> > > 
> > >    Another solution would be to live with incomplete lines in tracing.
> > >    I wonder if any of the functions tries to write the line again when the
> > >    write failed.
> > 
> > This may break trace_pipe. Although there looks to be redundant
> > behavior in that the pipe code also resets the seq.len on partial line,
> > so maybe it's not an issue.
> > 
> > > 
> > >    IMHO, the most important thing is that both functions return 0 on
> > >    failure.
> > 
> > Note, I'm not sure how tightly these two need to be. I'm actually
> > trying to get trace_seq to be specific to tracing and nothing more.
> > Have seq_buf be used for all other instances.
> 
> If the two layers make your life easier then they might make sense. I
> just saw many similarities and wanted to help. IMHO, if anyone breaks
> seq_buf, it will break trace_seq anyway. So, they are not really separated.

There's actually things I want to do with the seq_buf behavior that I
can't do with the trace_seq behavior. That's more about having a
dynamic way to create seq_buf buffers and resize them if need be.
Although, perhaps an all or nothing approach will help in that.


> 
> > 
> > > ad 4th:
> > > 
> > >    Both "full" and "overflow" flags seems to have the same meaning.
> > >    For example, trace_seq_printf() sets "full" on failure even
> > >    when s->seq.len != s->size.
> > 
> > The difference is that the overflow flag is just used for info letting
> > the user know that it did not fit. The full flag in trace_seq lets you
> > know that you can not add anything else, even though the new stuff may
> > fit.
> 
> I see. They have another meaning but they are set at the same time:
> 
> 	if (s->seq.overflow) {
> 		...
> 		s->full = 1;
> 		return 0;
> 	}
> 
> In fact, both names are slightly misleading. seq.overflow is set
> when the buffer is full even when all characters were written.
> s->full is set even when there is still some space :-)

I actually disagree. overflow means that you wrote more than what was
there. In this case, it was cropped.

Full suggests that you can't add anymore because it wont allow you.

The difference is that you are looking at a implementation point of
view. I'm looking at a usage point of view. With trace_seq, there is no
space left, you can't add any more. seq_buf, you can add more but it
wont be saved because it was overflowed.

What I should do is change overflow from being a flag to the number of
characters that it overflowed by. That would be useful information, and
would make more sense. It lets the user know what wasn't written.

-- Steve



> 
> I suggest to rename "overflow" to "full" and have it only in the
> struct "seq_buf". Then it has the right meaning in "seq_buf" and is still
> backward compatible with "trace_seq".
> 
> 
> Best Regards,
> Petr

