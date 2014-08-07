Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaHGOZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:25:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58302 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932086AbaHGOZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:25:46 -0400
Message-Id: <20140807142310.143659661@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 07 Aug 2014 10:23:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] ring-buffer: Fix bad reads from 'trace' file
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This contains a fix for two long standing bugs. Both of which are
rarely ever hit, and requires the user to do something that users rarely
do. It took a few special test cases to even trigger this bug,
and one of them was just one test in the process of finishing up as another
one started.

Both bugs have to do with the ring buffer iterator rb_iter_peek(), but one
is more indirect than the other.

The fist bug fix is simply an increase in the safety net loop counter.
The counter makes sure that the rb_iter_peek() only iterates the number
of times we expect it can, and no more. Well, there was one way it could
iterate one more than we expected, and that caused the ring buffer
to shutdown with a nasty warning. The fix was simply to up that counter by
one.

The other bug has to do with rb_iter_reset() (called by rb_iter_peek()).
This happens when a user reads both the trace_pipe and trace files.
The trace_pipe is a consuming read and does not use the ring buffer
iterator, but the trace file is not a consuming read and does use the
ring buffer iterator. When the trace file is being read, if it detects
that a consuming read occurred, it resets the iterator and starts over.
But the reset code that does this (rb_iter_reset()), checks if the
reader_page is linked to the ring buffer or not, and will look into
the ring buffer itself if it is not. This is wrong, as it should always
try to read the reader page first. Not to mention, the code that looked
into the ring buffer did it wrong, and used the header_page "read" offset
to start reading on that page. That offset is bogus for pages in the
writable ring buffer, and was corrupting the iterator, and it would start
returning bogus events.

Please pull the latest trace-fixes-3.16 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-3.16

Tag SHA1: e90e7aae9b49c7d55f1ac4275f1a425d0bfc0bb2
Head SHA1: 651e22f2701b4113989237c3048d17337dd2185c


Steven Rostedt (Red Hat) (2):
      ring-buffer: Up rb_iter_peek() loop count to 3
      ring-buffer: Always reset iterator to reader page

----
 kernel/trace/ring_buffer.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)
