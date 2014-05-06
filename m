Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaEFMjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:39:15 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34175 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaEFMjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:39:12 -0400
Date: Tue, 6 May 2014 14:39:07 +0200
From: Robert Richter <rric@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
Message-ID: <20140506123907.GV32718@rric.localhost>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Robert Richter <rric@kernel.org>:
> This patch set implements the necessary kernel changes for persistent
> events.

I was reviewing the code again after a while. It demonstrates how
persistent events can be used esp. for kernel enabled tracing. It also
allows people to play with it. The initial use case for this was
memory/hardware error detection. But for general-purpose uses of
persistent events I think the design must be improved. I want to start
a discussion on this. Sorry for the long text, but I hope my
description is detailed enough to show you the challenge.

The implementation of persistent events (see description in original
mail below about this) in the kernel is the right direction, basically
increase the refcount to not free events and its buffers when a
process terminates. Then, have a mechanism to reopen the event with
the syscall which can be done by the same or any other
process. Buffers can also be shared and have multiple users.

Now, the interesting question is how userland should all handle
this. There are ioctls implemented to control persistency of
events. But there are some open questions we need to discuss and
address since once the API is defined it can not be changed easily
later. Esp. the identification of events and its grouping of the same
kind of events running on all cpus (I don't mean group events).

We need to cover the following use cases for persistent events:

 * create,
 * reopen,
 * delete,
 * list and name them in the system.

The last is the most tricky.

I want to explain the current implementation with pros and cons and
possible alternatives.

Creation of events basically does (function arguments are a bit pseudo
code):

	attr.type   = pmu_type;
	attr.config = event_config;
	event = perf_event_open(attr, cpu, ...);
	id = ioctl(event, PERF_EVENT_IOC_UNCLAIM, 0);
	close(event);

To reopen it again:

	attr.type   = PERF_TYPE_PERSISTENT;
	attr.config = id;
	event = perf_event_open(attr, cpu, ...);
	do_something(event);	/* access buffers etc.: */
	close(event);

Id must be known from sysfs or stored somewhere.

Events could also be shared transparently. This means, if there is
already an event running with the same attr, it could be reused. Not
sure if this makes sense much and is also feasible. Most events are
opened with writable buffers and thus can not be shared anyway.

Removing it:

	... /* same as reopen */
	id = ioctl(event, PERF_EVENT_IOC_CLAIM, 0);
	close(event);

I rather would change the ioctl to

 id = ioctl(PERF_EVENT_IOC_SET_PERSIST, arg);

 arg != 0:	create persistent event (unclaim)
 arg == 0:	delete persistent event (claim)

This has the advantage that the naming is better and arg can be used
as parameter (e.g. event id to share a namespace).

The unclaim ioctl *creates* a buffer with 512kB default size. The
reopening process must mmap with the same buffer size. This is a
problem as in this implementation the buffer size is fix and can not
be adjusted. We could let create the process the buffers and make the
event persistent including the current buffers.

Variable buffer size is a must, so the reopening process also must be
able to detect buffer size. Mmap buffer size could be detected by
mmap'ing only the header page, reading the buffer size from the header
and then remapping the buffer with adjusted size.

It would be good to have a perf tool option -P that puts events in
persistent state instead of starting a command:

 # perf record -e ... -a -P <namespace>		# create pers. events
 # perf record -e persistent/<namespace>/ -a	# read existing buffers
 # perf record -e persistent/<namespace>/ -a -k	# read and kill existing events

Note that no args for a command are given.

Persistent events are listed in sysfs, e.g.:

 /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
 /sys/bus/event_source/devices/persistent/format/persistent:attr5:24

Thus perf tool is able to setup events that connect to persistent
events. The list is dynamically updated.

The persistent flag is actually ignored and thus not needed for
setup. It is used internally to mark the event as persistent. (We
modify event attr, is this ok?) It is planned to use the persistent
flag to instantly make the event persistent during its creation, which
is not yet implemented (-EOPNOTSUPP). It is unclear if this is
possible if the buffers must be created by the process. It might be
better to drop the persistent flag then. In this case we need an
alternative flag to be used internally. The following sysfs entries
should be enough and attrX support is obsolete and no longer
necessary, though it is still useful in my point of view:

 /sys/bus/event_source/devices/persistent/events/mce_record:config=<id>

This is nice but raises some questions about the handling of names and
ids. First, the 'mce_record' string is chosen by the kernel function
that created the events (perf_add_persistent_tp()). In user space we
can't choose a name, the string is created from the unique persistent
id (see pevent_alloc()). Hmm, this (a number) is not parsable by the
perf tool as event name which must be name_minus (see parse-events.l:
[a-zA-Z_*?][a-zA-Z0-9\-_*?]*). A name could be provided with an
ioctl():

	err = ioctl(event, PERF_EVENT_IOC_SET_NAME, name);

Do we need to check the name's syntax, or can we expect userspace
doing it right?

If there is a namespace, other events must be able to be added to it.
Events could be created like this:

	u64 id = ~0;
	for_each_cpu(cpu, mask) {
		event = perf_event_open(attr, cpu, ...)
		err = ioctl(event, PERF_EVENT_IOC_SET_NAME, name);
		...
		/*
		 * if id == ~0 create own name, otherwise use id's
		 * name space, id is updated by the ioctl
		 */
		err = ioctl(event, PERF_EVENT_IOC_SET_PERSIST, &id)
		...
	}

We might require to set a name before issuing SET_PERSIST. Another
problem is that the name must not yet exist and is created new the
first time. Otherwise there might be namespace collisions.

Second, persistent events run in system wide mode. Thus, multiple
events (one per cpu) are involved. Should there one id for all or
separate ids for every single event? In this case we could use
(u64)event->id. There is already a syscall to read the id. In sysfs
all events on all cpus would be listed (each id). This is too much and
also not useful since sysfs event entries (.../devices/persistent/
events/*) do not handle cpu numbers. So, it would be better to combine
the events on all cpus then, at least for the sysfs entries. But if
the id is shared, we need a solution for the case where an event is
not running on all cpus. Cpu hotplug must also be considered.

Suppose there is one single name for a collection of events that are
persistent, this is how all events could be reopened (similar to
getdents()):

	/* not actual an event: */
	fd = perf_event_open(type = PERF_TYPE_PERSISTENT, config = ~0, ...)
	err = ioctl(fd, PERF_EVENT_IOC_SET_NAME, name);

	/* maintain an internal iteration state bound to fd */
	while(1) {
		err = ioctl(fd, PERF_EVENT_IOC_GET_PERSIST, &id);
		if (!id)
			break;
		event = perf_event_open(PERF_TYPE_PERSISTENT, config = id);
		...
	}
	close(fd)

A problem is the cpu number here, needs to be solved somehow.

Events could be listed and controlled with the perf ctl command:

 $ perf ctl -l
 <event name1>
 <event name2>
 ...
 $ perf ctl -d <event name>

The first lists all events in the system, the -d option removes an
event from it. This raises the question from above, whether events on
all cpus should be listed or not.

I hope this shows a bit what the current kernel/user interaction
misses and starts a discussion about how this could be solved. There
is no final solution yet. Not all questions mentioned need to be
answered, but we need to be aware that we do not break API with later
changes.

Please ask me questions, I might not have explained it good
enough. Any ideas are appreciated.

Thanks,

-Robert

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
> For persistent events the persistent flag (bit 24 of flag field in
> struct perf_event_attr) needs to be set which is expressed in sysfs
> with "attr5:24". E.g. the mce_record event is described in sysfs as
> follows:
> 
>  /sys/bus/event_source/devices/persistent/events/mce_record:persistent,config=106
>  /sys/bus/event_source/devices/persistent/format/persistent:attr5:24
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
> PERF_EVENT_IOC_UNCLAIM ioctl call makes an event persistent. The
> perf_event_open() syscall can be used to re-open the event by any
> process. The PERF_EVENT_IOC_CLAIM ioctl attaches the event again so
> that it is removed after closing the event's fd.
