Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3HXJic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 05:38:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58789 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848Ab3HXJia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 05:38:30 -0400
Date: Sat, 24 Aug 2013 11:38:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/12] perf, persistent: Add persistent events
Message-ID: <20130824093826.GB28383@pd.tnic>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yep,

this text is very nicely written and should be in a README somewhere.
:-)

On Thu, Aug 22, 2013 at 04:13:15PM +0200, Robert Richter wrote:
> This patch set implements the necessary kernel changes for persistent
> events.
> 
> Persistent events run standalone in the system without the need of a
> controlling process that holds an event's file descriptor. The events
> are always enabled and collect data samples in a ring buffer.
> Processes may connect to existing persistent events using the
> perf_event_open() syscall. For this the syscall must be configured
> using the new PERF_TYPE_PERSISTENT event type and a unique event
> identifier specified in attr.config. The id is propagated in sysfs or
> using ioctl (see below).
> 
> Persistent event buffers may be accessed with mmap() in the same way
> as for any other event. Since the buffers may be used by multiple
> processes at the same time, there is only read-only access to them.
> Currently there is only support for per-cpu events, thus root access
> is needed too.
> 
> Persistent events are visible in sysfs. They are added or removed
> dynamically. With the information in sysfs userland knows about how to
> setup the perf_event attribute of a persistent event. Since a
> persistent event always has the persistent flag set, a way is needed
> to express this in sysfs. A new syntax is used for this. With
> 'attr<num>:<mask>' any bit in the attribute structure may be set in a
> similar way as using 'config<num>', but <num> is an index that points
> to the u64 value to change within the attribute.
> 
> For persistent events the persistent flag (bit 23 of flag field in
> struct perf_event_attr) needs to be set which is expressed in sysfs
> with "attr5:23". E.g. the mce_record event is described in sysfs as
> follows:
> 
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:23
> 
> Note that perf tools need to support the 'attr<num>' syntax that is
> added in a separate patch set. With it we are able to run perf tool
> commands to read persistent events, e.g.:
> 
>  # perf record -e persistent/mce_record/ sleep 10
>  # perf top -e persistent/mce_record/
> 
> In general the new syntax is flexible to describe with sysfs any event
> to be setup by perf tools.
> 
> There are ioctl functions to control persistent events that can be
> used to detach or attach an event to or from a process. The
> PERF_EVENT_IOC_DETACH ioctl call makes an event persistent.

Yeah, we probably want to abstract this a step further by allowing
to attach/detach fds to/from events. Then "persistent" is only one
incarnation of us always detaching from the event during its lifetime.

If we close an event while it is attached, it gets destroyed - i.e.,
current functionality, etc. See the other thread.

But we probably need more input on this from people. Ingo, Peter?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
