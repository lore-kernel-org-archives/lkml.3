Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3FYR5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:57:35 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:42284 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3FYR5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:57:34 -0400
Date: Tue, 25 Jun 2013 19:57:29 +0200
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130625175729.GI21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624194510.GC4065@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.13 21:45:11, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Oh and what Boris and Ingo said; persistent events should 'persist' and
> > not be tied to particular processes.

Fine with me too. But we need an answer how to create/release
persistent events.

It's easy to add them as in-kernel events in the kernel. But, how
could persistent events be created from userspace without inventing
too much new? As for standard events this could be done with the perf
syscall too. The event is created by a process and buffers are also
setup using the event's file descriptor. After the setup we detach the
event from the process. The event is persistent now. We could release
an event the same way by attaching it to a process an then closing it.

Detaching an event from a process basically means the event is not
released after the process is closing the event or is killed itself.
Sharing an event between processes is very important for this. Sharing
requires the event buffer to be accessed readonly and the event's ref
count needs to keep track of all attached processes. As long as a
process is using the event it is not released.

But what options there are to detach the event from all processes and
make it persistent?  We could just put the creating process to sleep
as long as the event should be persistent. This seems not to be an
option for you. There could be other ways to just increase the
refcount. We could use a ftrace-like approach and modify the refcount
by:

Detach:

 # echo opened_event > /sys/bus/event_source/devices/persistent/detached

Release:

 # echo '!opened_event' > /sys/bus/event_source/devices/persistent/detached

And Ingo's proposal using eventfs somehow:

 /sys/fs/events/user/PID/

And/or cgroups?

Are there other suggestions?

> > I'm not sure about the entire
> > eventfs thing; but the proposed sysfs thing should definitely work for
> > now.
> 
> I'm fine with a sysfs approach as well, as long as it's correct and 
> obvious enough to use.

Glad to hear this. :)

Thanks,

-Robert
