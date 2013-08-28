Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3H1QXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab3H1QXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:23:32 -0400
Date: Wed, 28 Aug 2013 12:23:21 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828162321.GA14689@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130828034627.GA30596@redhat.com>
 <20130828103101.3f5679bc@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828103101.3f5679bc@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 10:31:01AM -0400, Steven Rostedt wrote:
 > Dave,
 > 
 > BTW, is there a way to run trinity on a subset of syscalls. Basically,
 > I would like to run it on just the perf code, and nothing else. I have
 > a feeling that the bug you see is not caused by other operations
 > happening (although it could be), but from just out of order perf
 > calls. If I can reproduce it, I'll have a much better way of debugging
 > this.
 
indeed. -c perf_open_event for eg. (You can also specify multiple -c's
if you want to thow in some others)

There's a few other options in there for narrowing things down.
Say you think it's an interaction between perf and and unknown other syscall
for eg, you can do -c perf_open_event -r5. This will pick 5 random
syscalls, and fuzz those plus perf. See scripts/find.sh for an example of
how I've used this in the past.

 > Perhaps another thing you may think of adding to trinity (if it doesn't
 > already exist), is a log of what it is doing. That is, to log somewhere
 > the commands it writes, and that way, if something goes wrong, you have
 > a clue to how it got there. Because this is one of those bugs that
 > triggered before the code crashes, and the crash is just the symptom of
 > what went wrong and does not give you much clue to how it happened.
 
It does have logging already, though for a bug that takes hours, or days to
hit, they can grow to unmanagable sizes, and there's a problem if we have
a situation like..

syscall A
<24 hours of boring syscalls>
syscall B
oops as a result of B's interaction with A.

Quite often just rerunning that last syscall that caused the oops/warn
isn't sufficient to trigger an issue. (Though it may be for this specific
bug that may not be the case..)

Vince has a variant of trinity focussed just on perf which also has some
neat replay/bisecting capabilities to narrow down test cases.
I think I might need to add something like that at some point.

	Dave

