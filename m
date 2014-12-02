Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaLBCTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 21:19:16 -0500
Received: from imap.thunk.org ([74.207.234.97]:33380 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbaLBCTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 21:19:15 -0500
Date: Mon, 1 Dec 2014 21:19:12 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Checking to see if a bit is _not_ set in a ftrace event filter
Message-ID: <20141202021912.GA29096@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to do something like this:

filter="events/writeback/writeback_mark_inode_dirty/filter"
echo "(flags & 2048) && ((state & 2048) == 0)" > $filter

... but that doesn't work.

This works:

echo "flags & 2048" > $filter

But the problem is this:

echo "(state & 2048) == 0" > $filter

The simplest patch to add this would be add a new filter_ops so we
could do this:

echo "(state !& 2048)" > $filter

... but that's pretty ugly.  But adding more general expression
parsing in the ftrace event filter code would be non-trivial, and if
we start trying to make things like "!(state & 2048)" or "(state &
2048) == 0", then at some point some crazy person might request
supporting something like this: "(state ^ flags) == 2048".  :-)

So I guess the main question I want to ask is your opinion about
whether a patch that adds support for the operator "!&" is too ugly to
live?

Thanks,

					- Ted
