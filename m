Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaFXITg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:19:36 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:47951 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaFXITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:19:33 -0400
Message-ID: <1403597961.4418.39.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Date: Tue, 24 Jun 2014 10:19:21 +0200
In-Reply-To: <20140623140413.3cebe156@gandalf.local.home>
References: <20140619213329.478113470@goodmis.org>
	 <20140619213952.058255809@goodmis.org>
	 <20140619220607.c6da2540.akpm@linux-foundation.org>
	 <20140620125823.5acb12dd@gandalf.local.home>
	 <1403422685.4418.4.camel@jlt4.sipsolutions.net>
	 <20140623120805.1624e1db@gandalf.local.home>
	 <1403545094.4418.32.camel@jlt4.sipsolutions.net>
	 <20140623140413.3cebe156@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 14:04 -0400, Steven Rostedt wrote:

> Ah! I see what you are saying. You are saying that once you are full
> you need to flush. Honestly, the trace_puts() should check the return.
> Perhaps it wants to try again with a shorter string?

Perhaps, but perhaps not? I don't remember exactly the issue that I saw
without the full flag, and it may very well be a purely theoretical
thing too. I don't think I mind either way.

> The full flag means that once we hit full, we are done, no more can be
> written till the buffer is flushed.

Right. Arguably, it was already full or overflowed, but as it now stands
we make sure the data is consistent with the input (or rejected if the
input didn't fit.)

> Is that what we would want from this utility? Or do we want to allow
> the user to try again with a smaller string?

That's a good question - right now of course the first attempt would
make it full, and then any further attempt would fail.

> I was thinking of reversing the error code and have the trace_seq_*()
> return 0 as success and the remaining buffer size on error.

That would make some sense if we wanted to make it post-determined (you
fail, and then you can use the remaining buffer). Maybe it would make
sense to pre-determine that, e.g. by having a function that can reserve
a range, say

 void trace_seq_put_buf(..., int min_len, int max_len,
                        int *out_avail, void *out_data_ptr)

(of course that prototype needs to be adjusted appropriately)

If less than min_len is available, we could still have the "full"
semantics.

Either way, I don't really know or even care. I'm only using this
indirectly through the tracing, where I don't think it makes a lot of
sense without the full semantics since afaik the buffers need to be in
the right order in the page(s), and where you likely don't want to cut a
string short since you couldn't continue it on the next page, but you're
clearly the expert on this and I'm probably wrong anyway :)

johannes

