Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3H0Lyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:54:31 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49960 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3H0Ly3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:54:29 -0400
Date: Tue, 27 Aug 2013 13:54:22 +0200
From: Robert Richter <rric@kernel.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/12] [RFC] perf, persistent: ioctl functions to
 control persistency
Message-ID: <20130827115422.GD15884@rric.localhost>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
 <1377180807-12758-13-git-send-email-rric@kernel.org>
 <alpine.DEB.2.02.1308221404090.26486@pianoman.cluster.toy>
 <20130823091128.GA19548@nazgul.tnic>
 <20130823094556.GB10223@rric.localhost>
 <20130823104441.GD10223@rric.localhost>
 <20130823113400.GA20310@nazgul.tnic>
 <alpine.DEB.2.02.1308231255330.7482@pianoman.cluster.toy>
 <20130823193934.GB15521@pd.tnic>
 <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1308231704450.24113@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.13 17:08:11, Vince Weaver wrote:
> On Fri, 23 Aug 2013, Borislav Petkov wrote:
> 
> > Maybe this makes it more understandable for you but this is beside the
> > point.
> 
> Understandability doesn't matter?

I agree with Vince on this, the naming should be intuitive. Esp. since
'attach' is used in tracing in different context, we should avoid
using the term here for less confusion.

I got another idea for this, what about UNCLAIM and CLAIM? It is
exactly, what it is. A process unclaims an event telling it doesn't
care anymore.  Another process comes and claims the event, meaning the
process wants the event no longer to be shared with others and being
released after closing.

> > But I have to say the reversed thing above does sound confusing, now
> > that I'm looking at the code. Actually, at the time we discussed this,
> > my idea was to do it like this:
> > 
> > 1. we open a perf event and get its file descriptor
> > 2. ioctl ATTACH to it so that it is attached to the process.
> > 
> > ... do some tracing and collecting and fiddling...

You don't need to attach to a persistent event, you can just use the
event with perf_event_open, mmap, close.

> > 3. ioctl DETACH from it so that it is "forked in the background" so to
> > speak, very similar to a background job in the shell.

With 'detach' we move the event into the 'background' so that it is
still available after opening.

> Would it make sense to actually fork a kernel thread that "owns" the 
> event?  

There is no need for a kernel thread, there is nothing to do. We just
increase the refcount so that the event is not destroyed.

> The way it is now events can "get loose" if either the user
> forgets about them or the tool that opened them crashes, and it's
> impossible to kill these events with normal tools.  You possibly
> wouldn't even know one was running (except you'd have one fewer
> counter to work with) unless you poked around under /sys.

As boris said, there could be some sort of 'kill' tool for events.
That's what we need sysfs for, it tells which events are running.

> > 4. The rest of the code continues and deallocates the event *BUT* (and
> > this is the key thing!) the counter/tracepoint remains operational in
> > the kernel, running all the time.

The event remains operational esp. after closing it or killing/
terminating the process owning it.

> > 5. Now, after a certain point, you come back and ioctl ATTACH to this
> > already opened event and read/collect its buffers again.

-Robert
