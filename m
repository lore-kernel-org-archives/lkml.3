Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbbA0BBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:01:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:2126 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751623AbbA0BBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:01:48 -0500
Date: Mon, 26 Jan 2015 20:02:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126200218.6ecfc931@grimm.local.home>
In-Reply-To: <20150127003742.GU29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
	<20150126214658.GQ29656@ZenIV.linux.org.uk>
	<20150126184314.24f2583c@gandalf.local.home>
	<20150127003742.GU29656@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 00:37:42 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Jan 26, 2015 at 06:43:14PM -0500, Steven Rostedt wrote:
> 
> > I originally had this, but the issue isn't with i_mutex only. The
> > instance_mkdir and instance_rmdir need to grab trace_types_lock.
> > This is also held when calling into tracefs.
> > 
> > That is, we can not hold i_mutex and take trace_types_lock.
> > 
> > trace_types_lock needs to be held with the creation or destruction
> > of events, which is what mkdir an rmdir do.
> 
> Yecchhh...
> 
> Looks like something that fell out of BKL removal - AFAICS, you are
> using it to protect all kinds of things ;-/

It's only used to protect slow paths. Yes, it grew more than what it
should protect. I had patches to add a few more mutexes, to narrow
things down. But that still did not solve this issue. The broken out
mutex still needed to be held when events are created.

The main issue is that mkdir() and rmdir() will create events that
require holding a mutex to make sure access to the events are
serialized.

But creating events requires grabbing the i_mutex. We can create events
either with mkdir() or when a module is loaded that has its own events.

Same goes with the mutex that protects adding and removing of
trace_arrays. When a module is loaded, we need to add events to each
trace array that exists (requiring that we grab the mutex that protects
that list). And hold it while we add our events.

Now you see why I found just dropping the parent mutex easier.

-- Steve
