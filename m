Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbbA0Ee1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:34:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42632 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbA0EeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:34:25 -0500
Date: Tue, 27 Jan 2015 04:34:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127043421.GV29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
 <20150126154259.5e650d32@gandalf.local.home>
 <20150126214658.GQ29656@ZenIV.linux.org.uk>
 <20150126184314.24f2583c@gandalf.local.home>
 <20150126184916.70d88963@gandalf.local.home>
 <20150126193909.19967bd0@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126193909.19967bd0@grimm.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 07:39:09PM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 18:49:16 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 26 Jan 2015 18:43:14 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> > > That is, we can not hold i_mutex and take trace_types_lock.
> > > 
> > > trace_types_lock needs to be held with the creation or destruction
> > > of events, which is what mkdir an rmdir do.
> > 
> > Although, I can not remember how this happened, but lockdep blew up on
> > me with this. I'll look again.
> 
> OK, found it. When events are created (module is loaded), the
> trace_types_lock is taken, and the event directories are created (these
> are in /sys/kernel/debug/tracing/events). We need to grab the i_mutex
> in order to create these files.
> 
> This means that we can not take the trace_types_lock within the mkdir
> or rmdir calls.
> 
> The directories are not static even outside the mkdir and rmdir calls.
> As events can be created from several sources, which will create new
> files and directories.

Frankly, the first impression is that you have trace_types_lock way too
high in the hierarchy - you are taking it well outside of the level where
you start walking through ftrace_trace_arrays...

What else is it used for?  You seem to use it protect trace_array refcounts,
but you use them in a very odd way...  What happens if lookup for a file
in that tree loses CPU just as it enters trace_array_get() (e.g. on the
same trace_types_lock), at which point rm .../instances/<whatever> comes,
sees that tr->ref is still zero, kicks the sucker out of the list and
frees it, immediately followed by mkdir creating a new instace?  If the
allocation of the new trace_array happens to reuse the just-freed one,
your trace_array_get() will actually succeed, won't it?

It's not fatal (after all, everything will work as if you opened the similar
file in new instance in the first place), but it looks rather bogus...
